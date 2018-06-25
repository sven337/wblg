---
layout: post
title: "Ingénierie inverse de l'autoradio eMyWay (RT6) Citroën"
date: 2014-03-05 23:00:00
tags: electronics auto
category: francais
comments: true
img_rel: "/~sven337/data/rt6"
---

Je reprends ici un article que j'ai rédigé il y a plus d'un an concernant l'autoradio eMyWay disponible sur les Citroën C4. Cette version est plus complète et a l'intérêt d'être en un seul morceau.

Notez que je ne possède plus ni de C4 ni de RT6, je ne suis donc plus actif sur ce projet.

# Table des matières
{:.no_toc}

1. contents placeholder
{:toc}

# 1. Travaux précédents

Le RT6, développé par Magneti Marelli, semble à première vue être assez similaire au RT3, pour lequel un effort de documentation a déjà été fait. On
est en présence d'une plateforme **VxWorks 5.5.1** avec Tornado 2.2.1. La carte mère est probablement similaire à une WindRiver d'architecture PowerPC
(exemples de produits : [http://www.windriver.com/products/bsp_web/bsp_architecture.html?architecture=PowerPC](http://www.windriver.com/products/bsp_web/bsp_architecture.html?architecture=PowerPC)) La carte est-elle la même que le RT3 ? Je pensais que le RT3 était en MIPS mais [http://fr.viadeo.com/fr/profile/cyrille.lohier](http://fr.viadeo.com/fr/profile/cyrille.lohier) laisse penser le contraire. Les binaires semblent être produits avec GCC: `(GNU) gcc-2.96 (2.96+ MW/LM) AltiVec VxWorks 5.5`.

Le RT4 a une architecture très similaire et a été l'objet d'efforts d'ingénierie inverse menés par différentes personnes dont plusieurs ont posté en français sur [Planete Citroen](http://www.planete-citroen.com). On notera qu'il existe une version RT6 des "mira scripts", en cours de développement ([http://mira308sw.altervista.org/en/index.htm](http://mira308sw.altervista.org/en/index.htm)). Mira connaît très bien l'appareil.

# 2. Étude du CD d'upgrade firmware 2.20

On trouve sur le CD:

  * des fichiers ".inf" 
  * des fichiers ".CMD" et ".ini" 
  * des fichiers ".out" 
  * des fichiers ".gz" 
  * ... 

## 2.1. Fichiers .inf

Ce sont des fichiers décrivant un binaire, le binaire semble porter le même nom que le fichier mais sans le ".inf" (a.bin.inf décrit le fichier a.bin).
Exemple :
```
    c1d5be54
    VER:295
    TYPE:DATA
    COMPRESSED:NO
    SIZE:1356848
    ENTRY:NO
```    

Pour obtenir la liste exhaustive des champs utilisés par le firmware :

    
``` bash  
    find . -name '*.inf' | xargs tail -q -n +2 | cut -f1 -d: | sort | uniq
```    

On trouve :

    
    
    COMPRESSED
    ENTRY
    ID
    SIZE
    SUBVER
    TYPE
    USIZE
    VER
    

  * 1ère ligne : 2 valeurs hexa sur 16 bits chacune (4 caractères). La première valeur est un **CRC** (polynôme spécifique, voir plus bas) du fichier INF lui même. On l'obtient en calculant le CRC sur ce fichier à partir de l'octet n°5 inclus (seek de 4). La deuxième valeur est un CRC du fichier binaire correspondant au INF, calculé sur l'intégralité du binaire (compressé s'il est compressé). 
  * VER : version du fichier 
  * TYPE : soit "DATA" (données ?) soit "RELOCABLE" (code exécutable) 
  * COMPRESSED : indique si le fichier binaire correspondant est compressé ou non. Le format de compression est DEFLATE tel qu'implémenté par zlib (outil zpipe), avec une petite subtilité au niveau du format 
  * SIZE : taille du fichier tel que stocké (compressé ou non) 
  * USIZE : **u**ncompressed **size**, taille du fichier après décompression (présent uniquement sur les COMPRESSED) 
  * ENTRY: YES ou NO... (aucun idée de ce que c'est, à vérifier) 
  * SUBVER : "sous version" ?? 
  * ID: "sous sous version" ?? 
<br />
 
## 2.2. Fichiers .CMD et .ini

On dirait que c'est une habitude chez MM d'utiliser des extensions pour des types de fichiers qui ne correspondent pas du tout. Les .CMD et .ini sont...
du **code C** ! En réalité ce code est interprété par une bibliothèque dénommée [EiC](http://www.linuxbox.com/tiki/node/149), qui permet d'écrire des scripts avec une syntaxe très similaire au C.

## 2.3. Fichiers .out

Il s'agit d'exécutables.

```./Application/Boot/ssm_boot.out: ELF 32-bit MSB relocatable, PowerPC or cisco 4500, version 1 (SYSV), not stripped

Architecture **PowerPC**, BigEndian, 32 bit. Désassemblable avec les binutils GNU compilés pour PowerPC... ils ont même laissé les symboles de debug (= les noms des fonctions) ! Merci MM !

## 2.4. Fichiers .gz

Ce sont des exécutables comme les .out, mais compressés. Voir plus bas.

## 2.5. Bootrom

Il semble y avoir un fichier spécial, qui est un exécutable non compressé qui n'est pas ELF. C'est probablement le _BIOS_ de la carte. C'est le fichier `Application/Boot/RNEG2010_EUR_2_20/DG4/BOOTROM.DAT`. Ce fichier contient un certain nombre de chaînes de caractères intéressantes. Sa version est `BSP_PPC-SECT83+BSP_PPC_6.86k1:project:SECT39+1`. C'est probablement du code binaire sans structure particulière, il faudra essayer de le désassembler comme si c'était du code machine brut.

## 2.6. BootRom.sym

Attention ce fichier n'est pas le même que dans la section précédente. C'est un exécutable PowerPC statique dont les symboles n'ont pas été supprimés : on peut le désassembler pour l'étudier. C'est lui qui semble fournir la majorité des fonctions utilisées dans le firmware, par exemple **CheckCRCFile**.

## 2.7. Hash des fichiers

Les fichiers .inf ont au début une valeur qui correspond à un hash **CRC**. J'ai essayé plusieurs possibilités - CRC32 avec divers polynômes connus, Adler32, sans succès. La formule de calcul du hash n'est donc pas évidente - mais en lisant le code on se rend compte que c'est un hash sur 16 bits et non 32 bits. Si on regarde dans le code de BootRom.sym on se rend compte que *CheckCRCFile* appelle *CheckCRCInf* qui lui même fait deux appels :

  * l'un à `ReadINFCRC__FPCcR9Crc16Type` (Le nom bizarre correspond au "mangling" des fonctions C++ fait par GCC. Cela correspond à la signature : `ReadINFCRC(char const *, Crc16Type &)`) 
  * l'autre à `ComputeCRCFile`

J'ai manuellement recréé le code de calcul du hash à partir du code machine. Il opère par tranche de 8 bits, avec deux tables de lookup, et des échanges... ce n'est pas un Adler16. Il peut s'agir d'un algo "maison", dans ce cas le code ci-dessous associé au contenu des tables permettra de recréer les hash si on veut faire des modifs. J'ai écrit un programme en C pour [calculer les hashs](/~sven337/data/rt6/crc_rt6.c).

Exemple sur `/Application/BTL/File_Search.gz.inf` - le hash en début de fichier est **0c622f64**. **0c62** est le hash du **.inf**, **2f64** est le hash du **binaire**, comme on peut le voir :
 
~~~ 
    $ ./crc_rt6 /mnt/hd/Application/BTL/File_Search.gz.inf 4
    Computed CRC16 0x0c 0x62
    $ ./crc_rt6 /mnt/hd/Application/BTL/File_Search.gz 0
    Computed CRC16 0x2f 0x64
~~~


## 2.8. Compression des binaires

La plupart des exécutables sont des fichiers .gz compressés. Un peu d'étude du code nous amène à la fonction **inflate** qui est utilisée pour décompresser ces binaires. Malheureusement cette fonction ne semble pas avoir le comportement standard de la zlib. Un peu de Google nous mène à [cette page](http://read.pudn.com/downloads58/sourcecode/embed/205887/src/util/inflateLib.c__.htm). Tout en bas du fichier, la fonction `inflate` semble correspondre au code source de celle du RT6. Il reste à vérifier en quoi cette fonction diffère de ce que fait la zlib nativement et nous pourrons décompresser (et je l'espère recompresser) les binaires du RT6. Avec décompression + CRC, on pourra commencer à s'amuser à tout casser.

VxWorks ajoute en fait un octet de _bourrage_ au début de chaque fichier compressé (qui sert pour calculer un checksum, mais uniquement si la variable **inflateCksum** est définie - adresse `0xff4cf04` dans **BootRom.sym** qui est l'exécutable principal, et elle ne l'est pas pour l'instant). Cet octet fait que le format n'est pas reconnu par l'outil zpipe inclus dans zlib. Il faut donc faire une petite modification sur **zpipe** dans `main()`:

~~~ c
    /* do decompression if -d specified */
    else if (argc >= 2 && strcmp(argv[1], "-d") == 0) {
    if (argc == 3) {
    int sz = atoi(argv[2]);
    char buf[sz];
    fread(buf, sz, 1, stdin);
    }
    ret = inf(stdin, stdout);
    if (ret != Z_OK)
    zerr(ret);
    return ret;
    }
~~~
    

Cela permet de passer un _seek_ en argument. La valeur de _seek_ à utiliser est 1. On peut ensuite décompresser n'importe quel binaire du RT6 de la manière suivante :

        
    zpipe -d 1 < file.gz > file.bin
    

J'ai fait cela sur tous les binaires compressés du firmware. Pas de surprise, ce sont bien des binaires PowerPC, avec les symboles de debug.

## 2.9 Le processus de mise à jour

On a ``/F`` qui est la partition de boot. Probablement du flash, probablement soudé sur la carte mère, peut-être une carte SD, à voir. (XXX mettre à jour selon les résultats des expérimentations qui ont eu lieu depuis) On a ``/SDC`` qui est la partition d'application. SDC comme **SD C**ard, je suppose.

### 2.9.1 Initialisation

Lors de l'insertion d'un CD d'upgrade du firmware, le système réagit à la présence du fichier ``CD.inf`` et exécute ``FlasherROMStart("/path/to/cd")`` dans ``/UPG/Flasher/FLASHER.ROM`` (indication de Mira non vérifiée). Celui-ci détecte la version de l'appareil et si c'est bien un RNEG il exécute le fichier ``/UPG/Flasher/FLASHER.ROM.RNEG``. Cela prouve que le RT6 est globalement similaire aux RT3/RT4 qui l'ont précédé.
Dans ``FLASHER.ROM.RNEG`` on trouve la fonction ``FlasherRomRNEGStart(char *sourcedrive)`` qui appelle ``GetHardwareConfiguration("CFG_HW_FAMILY")`` pour vérifier (à nouveau ?!) si c'est bien un RNEG, et écrit la réponse (= 1 sur RNEG) dans deux variables: 
- C_SETUP_HW::m_is_rneg_family
- C_SETUP_HW::m_is_sd_present. 

Ensuite, ``C_SETUP_HW::m_is_preampli_present`` et ``m_is_mtb_present`` sont renseignés. Apparemment "mtb" signifie motherboard (carte mère). J'espère bien, que la carte mère est présente... Il y a une également une variable ``mtb_tuner_type``... qui prend les valeurs 0 1 2 3).

Un affichage pour le _debug_ semble être réalisé par ``Splash_PrintL1__FPCc``.

Le stockage flash est sur``/F``. La partition subit les appels suivants, dans l'ordre : 

~~~ 
KernelUnprotectFlash
UnMountPartition
MountAndCheckTffs
BootRomFormatTffs
KernelProtectBoot
~~~

**TFFS** semble donc être le format du FS. <http://en.wikipedia.org/wiki/Flash_file_system#TrueFFS> sous entend que c'est un FS utilisé par VxWorks, donc c'est une possibilité très nette que ce soit bien notre FS.

### 2.9.2 Vérification du CD
Une fois le FS formaté, c'est la fonction ``LaunchSoftUpgrade`` qui prend le relais. Le RT6 utilise la bibliothèque **EiC** (<http://www.linuxbox.com/tiki/node/149>, merci à Mira) pour fournir des scripts dont la syntaxe est celle du langage C. EiC va définir un ensemble de fonctions C qui seront appelables depuis les scripts .CMD. Je disposais de la liste exhaustive de ces fonctions mais suite à une erreur de manipulation je ne les ai plus.
Ces fonctions sont exportées à travers EiC en appelant ``EiC_AddBuiltinFunc(const char *, void *(*func)(void))``. (Par exemple, ``EiC_AddBuiltinFunc("MaFunctionAMoi", &MaFunctionAMoi)``). On doit pouvoir en rajouter assez facilement de cette manière, mais Mira a utilisé une autre technique à mon avis plus compliquée.

Une fois **EiC** initialisée, le programme cherche le fichier ``[source]/UPG/Command/CHECK_CD.CMD`` ([source] correspond à l'adresse du "device" contenant la mise à jour, je ne sais pas encore quels sont les points de montage). Ce script est très explicite, écrit par un certain Philippe Chapelet <http://fr.linkedin.com/pub/philippe-chapelet/45/834/bb7>.

``EiC_ExeFile(argc, argv)``, **CHECK_CMD** est appelé avec ``argv[2]="BOOTROM"`` (TODO vérifier s'il y a un appel avec "NORMAL" ou une autre valeur, il existe aussi "RECOVERY", voir comment c'est utilisé), les 2 autres arguments sont l'adresse source et le path du script lui même (ce qui est confirmé par le contenu du script).

### 2.9.3 Mise à jour

Le script de vérification retourne 0 si tout est OK. Dans ce cas, la mise à jour va avoir lieu. Le programme cherche le script d'upgrade, ``[source]/UPG/Command/FLASHER.ROM.RNEG.CMD``. Ce script est appelé avec les mêmes arguments qu'au-dessus.
C'est lui qui fait l'essentiel du travail.

### 2.9.4 Après la mise à jour

Une fonction vérifie le flag ``g_Flasher_ROMERROR``. **0** = pas d'erreur, **3** = message d'**erreur** + SetDBBootFlagError(), 1 2 4 message d'erreur, en cas d'erreur "emergency reboot".

## 2.10 Questions restantes

À faire : détails du fonctionnement de l'upgrade firmware. Questions: est-ce qu'on peut ne mettre à jour qu'un seul fichier ? Est-ce qu'on peut faire des changements et revenir en arrière sur une version officielle du firmware ?

Le système reconnaît que le média est une mise à jour du firmware à travers la présence d'un fichier CD.inf, et il exécute le binaire `/upg/flasher/flasher.rom`.


# 3. Fonctionnalités Bluetooth

Bluetooth définit plusieurs **profils**, qui correspondent à un ensemble de fonctionnalités rendues par un appareil à un autre. Pour la musique, il existe **AD2P** qui est le profil permettant de transférer le son par radio, et **AVRCP** qui permet le contrôle de l'appareil lecteur par un autre (play, pause, next, previous, ...). Je souhaite savoir quelle version du profil Bluetooth AVRCP mon véhicule supporte. Cette information n'est disponible nulle part mais l'étude du module Bluetooth pourra répondre à la question. On trouve dans `Application/BCM/t2bf/bcm_t2bf.bin` (note: je nomme **.bin** les fichiers obtenus par décompression du **.gz**) les chaînes suivantes :


```
AVRCP version 1.0 supported
AVRCP version 1.3 supported
AVRCP unknown version
```

Donc le RT6 supporterait la version 1.3 d'AVRCP. Il y a une version 1.4 qui ajoute une fonction recherche et la possibilité de gérer plusieurs _players_ (par exemple deux téléphones simultanément pour streamer de la musique). <http://en.wikipedia.org/wiki/Bluetooth_profile#Audio.2FVideo_Remote_Control_Profile_.28AVRCP.29>

**sdptool** sous Linux liste les profils supportés par un appareil Bluetooth... mais **BT_CAR_SYSTEM** (le RT6) ne répond pas aux requêtes. En tout cas cela m'a permis de détecter la version d'AVRCP sur mon Blackberry et mon YP-P2 - ces deux appareils sont en 1.0, donc la voiture ne pourra pas afficher les méta données ni m'indiquer la liste des pistes. Conclusion il vaut mieux brancher ces appareils en **USB** (sauf que le Blackberry n'est pas accepté par le RT6 en USB, "média illisible", probablement à cause de la table des partitions - en effet le BB expose une table des partitions avec une seule partition, alors que la plupart des clés n'ont pas de table des partitions, à vérifier si c'est effectivement le souci, dans ce cas on serait en présence d'une erreur/oubli de la part de MM). 

# 4. Architecture matérielle

## 4.1 Stockage
Le RT6 est équipé d'une carte SD de 8Go qui sert de stockage système au format TFFS, ainsi que d'une EEPROM qui stocke des paramètres de configuration persistants. La carte SD permet de réaliser certaines manipulations sans risque (car on peut facilement la sauvegarder). L'EEPROM peut donner lieu à des retours en garantie qui se sont avérés coûteux. Il convient d'être particulièrement prudent avec le _MiraScript_ **CONFIGFLAG**.
Il n'y a pas de disque dur, et pas de stockage volumineux qui permet de s'en servir en Jukebox : obligation d'utiliser le port USB si on veut avoir un stockage important.

## 4.2 Démontage
Voici des photographies prises par quelqu'un qui a démonté son RT6. Je les étudie plus bas.

![1](01.jpg)
![2](02.jpg)
![3](03.jpg)
![4](04.jpg)
![5](05.jpg)
![6](06.jpg)
![7](07.jpg)
![9](09.jpg)
![10 - puce GPS](10.jpg)
![11](11.jpg)
![12 - microcontrôleur](12.jpg)
![13 - audio & radio](13.jpg)
![14 - microcontrôleur](14.jpg)
![15 - audio & radio](15.jpg)
![16](16.jpg)
![18 - Minus & Cortex](18.jpg)
![19](19.jpg)


### GPS

La puce **GPS** dans le RT6 est soit une **Atmel**, soit une **SIRF**, d'après le code. La photo n°10 nous montre un chip **SIRF GSC2Xi**, ce qui semble correspondre au produit **SIRFStarII**. Bien sûr, cette entreprise supprime de son site les anciennes références, et je n'ai pas pu trouver de datasheet. J'aurai l'occasion un jour de décrire tout le bien que je pense que ces pratiques.

### Microcontrôleur

Sur les photos n°12 et 14 on trouve un microcontrôleur : <http://www.datasheetarchive.com/M30290FCTHP-datasheet.html>.
Si on savait à quoi est relié le connecteur noir, on saurait à quoi il sert.

### Circuit audio

Photo n°13 et 15, la "carte son" **SAF7741** <http://www.nxp.com/documents/leaflet/75016755.pdf> associée aux deux tuners **TEF 7000** (en petit au dessus). Il faut que je trouve la datasheet du SAF7741, mais j'ai l'impression qu'il n'a que des sorties analogiques vers les HP (donc **pas de SPDIF**).

### Cortex

Photo n°18, un FPGA **Altera Cyclone 3** <http://www.altera.com/literature/hb/cyc3/cyclone3_handbook.pdf>, modèle **EP3C25** package **F324** vitesse **A7**. Ce FPGA sert très probablement de carte graphique pour piloter l'écran. La technologie utilisée semble être <http://www.altera.com/support/examples/nios2/exm-tes-demo.html>.
Un chip **flash 16Mo** Spansion <http://www.spansion.com/Support/Related%20Product%20Info/S29GL128N_overview.pdf> **GL128N90FFAR2** voila peut-être notre **/F**?
3 chips **Micron** marqués ``2DF42 D9GPD``, probablement de la **RAM** (en haut pour le FPGA, en bas pour le CPU ?), à vérifier
Un **CPU Freescale MPC5200B** <http://cache.freescale.com/files/32bit/doc/data_sheet/MPC5200.pdf>, modèle exact difficile à connaître, probablement **SPC5200CVR400** - PowerPC 32 bits 400MHz avec FPU, 16k cache, CAN, USB, Ethernet (??), ... 


# 5. Upgrade POI

Détails du fonctionnement. Questions : pourquoi est-ce que ça boucle à l'infini chez certaines personnes sans plus d'infos ? Est-ce qu'on peut y faire quelque chose ? RE du format peut-être déjà fait car il existe des POI non-officiels issues de SCDB pour le RT6 (vu sur gpsunderground). 
Le système reconnaît que le média est une mise à jour des points d'intérêt à travers la présence d'un fichier **POI_VER.POI**, et il exécute le script `upg/poi_upgrade.cmd`.

# 6. Upgrade Carto

Détails du fonctionnement. Questions : Est-ce que le format est compréhensible ? Est-ce qu'on peut envisager de mettre à jour les cartes à partir d'Openstreetmap ? Que signifie exactement "mise à jour pas compatible avec les véhicules après août 2011" ?
Le système reconnaît que le média est une mise à jour des points d'intérêt à travers la présence d'un fichier **CD_VER.NAV**, et il exécute le script NAV_UPGRADE.CMD.

# 7. Modifier le code firmware

Il faut bien garder à l'esprit qu'il est assez facile de **comprendre comment les choses fonctionnent** (en tout cas pour quelqu'un du métier), car le firmware est livré avec ses symboles de debug. Il suffit d'un désassembleur et de temps pour lire ce que le programme fait. Faire des modifications est un autre débat, malheureusement. À moins de se procurer un kit de développement VxWorks (payant), il faudra faire les modifications directement en assembleur PowerPC, et les injecter dans le firmware existant. J'avais commencé à travailler avec **objdump** pour supprimer une fonction quelconque du firmware, et la remplacer par une écrite à la main, ce qui est un montage plus "propre" que le bidouillage de Mira pour les *generic function calls*. Toutefois la manipulation n'avait pas abouti.

# 9. Changer l'image d'accueil

Le BMP d'accueil est stocké sur le RT6 dans le chemin suivant : **/F/Application/Boot/BootScreen.bmp**. Il est, comme tous les fichiers du RT6, soumis à une vérification du CRC selon la procédure décrite plus haut. Ce fichier ne semble pas présent sur le média d'install du firmware 2.20. 
C'est la fonction **BootRomSplash** qui le charge (je crois). Elle est appelée avec une valeur entre 0 et 5 qui décrit le type de splash - "please insert upgrade CD", "error detected", etc.

Je n'ai jamais procédé à un changement d'image d'accueil, mais c'est une opération que Mira sait réaliser.

# 10. Pour rigoler/avis sur l'appareil

Le code du firmware fait apparaître que **Maserati** est également utilisateur du RT6. Moi, si j'achète une Maserati, j'attends nettement mieux que le RT6... :)
Je suis plutôt déçu de cet appareil qui est lent dans la plupart de ses opérations (saisie d'une adresse GPS, démarrage, lecture d'une clé USB), qui contient certains bugs particulièrement gênants (déconnexions intempestives Bluetooth AD2P, refus de lire certaines clés USB), et dont le système de navigation est assez mauvais tant dans ses algorithmes (il ne démord pas du chemin qu'il a choisi, par une espèce d'hystérèse, si vous vous en écartez) que dans sa cartographie (qui n'est pas vraiment à jour même dans ses éditions récentes, le tout pour un prix prohibitif).
Il est vrai que travaillant dans un secteur plus dynamique et plus rapide à innover que l'automobile, j'ai des exigences très importantes de la part de l'informatique embarquée que j'utilise au quotidien. Le RT6 fait ce pour quoi il a été conçu, mais le prix de l'option ne me semble pas être réaliste en regard des défauts qu'il présente.

# 11. <s>Besoin d'aide</s>

N'étant plus actif sur ce projet je n'ai pas besoin d'aide - mais si vous avez des informations à me transmettre je les mettrai en ligne (contact en bas de la page).


<script>
    $(document).ready(function() {
		$("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>
