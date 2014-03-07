---
layout: post
title: "Ingénierie inverse de l'autoradio eMyWay (RT6) Citroën"
date: 2014-03-05 23:00:00
#encoding: iso-8859-15
categories: francais electronics auto
---

Je reprends ici un article que j'ai rédigé il y a plus d'un an concernant
l'autoradio eMyWay disponible sur les Citroën C4.

Méthode: **Étude du CD d'upgrade firmware 2.20**

# 1. Travaux précédents

Le RT6, développé par Magneti Marelli, semble à première vue être assez
similaire au RT3, pour lequel un effort de documentation a déjà été fait. On
est en présence d'une plateforme **VxWorks 5.5.1** avec Tornado 2.2.1. La
carte mère est probablement similaire à une WindRiver d'architecture PowerPC
(exemples de produits : [http://www.windriver.com/products/bsp_web/bsp_architecture.html?architecture=PowerPC](http://www.windriver.com/products/bsp_web/bsp_architecture.html?architecture=PowerPC)) La carte est-elle la même que le RT3
? Je pensais que le RT3 était en MIPS mais [http://fr.viadeo.com/fr/profile/cyrille.lohier](http://fr.viadeo.com/fr/profile/cyrille.lohier) laisse penser le
contraire. Les binaires semblent être produits avec GCC: `(GNU) gcc-2.96
(2.96+ MW/LM) AltiVec VxWorks 5.5`.

Le RT4 a une architecture très similaire et a été l'objet d'efforts
d'ingénierie inverse menés par différentes personnes dont plusieurs ont posté
sur ce forum. On notera qu'il existe une version RT6 des "mira scripts", en
cours de développement ([http://mira308sw.altervista.org/en/index.htm](http://
mira308sw.altervista.org/en/index.htm)). Mira connaît très bien l'appareil.

# 2. Arborescence

On trouve sur le CD:

  * des fichiers ".inf" 
  * des fichiers ".CMD" et ".ini" 
  * des fichiers ".out" 
  * des fichiers ".gz" 
  * ... 

## 2.1. Fichiers .inf

Ce sont des fichiers décrivant un binaire, le binaire semble porter le même
nom que le fichier mais sans le ".inf" (a.bin.inf décrit le fichier a.bin).
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

    
```bash  
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

## 2.2. Fichiers .CMD et .ini

On dirait que c'est une habitude chez MM d'utiliser des extensions pour des
types de fichiers qui ne correspondent pas du tout. Les .CMD et .ini sont...
du **code C** ! En réalité ce code est interprété par une bibliothèque
dénommée [EiC](http://www.linuxbox.com/tiki/node/149), qui permet d'écrire des
scripts avec une syntaxe très similaire au C.

## 2.3. Fichiers .out

Il s'agit d'exécutables.

```./Application/Boot/ssm_boot.out: ELF 32-bit MSB relocatable, PowerPC or
cisco 4500, version 1 (SYSV), not stripped

Architecture **PowerPC**, BigEndian, 32 bit. Désassemblable avec les binutils
GNU compilés pour PowerPC... ils ont même laissé les symboles de debug (= les
noms des fonctions) ! Merci MM !

## 2.4. Fichiers .gz

Ce sont des exécutables comme les .out, mais compressés. Voir plus bas.

## 2.5. Bootrom

Il semble y avoir un fichier spécial, qui est un exécutable non compressé qui
n'est pas ELF. C'est probablement le _BIOS_ de la carte. C'est le fichier
`Application/Boot/RNEG2010_EUR_2_20/DG4/BOOTROM.DAT`. Ce fichier contient un
certain nombre de chaînes de caractères intéressantes. Sa version est
`BSP_PPC-SECT83+BSP_PPC_6.86k1:project:SECT39+1`. C'est probablement du code
binaire sans structure particulière, il faudra essayer de le désassembler
comme si c'était du code machine brut.

## 2.6. BootRom.sym

Attention ce fichier n'est pas le même que dans la section précédente. C'est
un exécutable PowerPC statique dont les symboles n'ont pas été supprimés : on
peut le désassembler pour l'étudier. C'est lui qui semble fournir la majorité
des fonctions utilisées dans le firmware, par exemple **CheckCRCFile**.

## 2.7. Hash des fichiers

Les fichiers .inf ont au début une valeur qui correspond à un hash **CRC**.
J'ai essayé plusieurs possibilités - CRC32 avec divers polynômes connus,
Adler32, sans succès. La formule de calcul du hash n'est donc pas évidente -
mais en lisant le code on se rend compte que c'est un hash sur 16 bits et non
32 bits. Si on regarde dans le code de BootRom.sym on se rend compte que
*CheckCRCFile* appelle *CheckCRCInf* qui lui même fait deux appels :

  * l'un à `ReadINFCRC__FPCcR9Crc16Type` (Le nom bizarre correspond au "mangling" des fonctions C++ fait par GCC. Cela correspond à la signature : `ReadINFCRC(char const *, Crc16Type &)`) 
  * l'autre à `ComputeCRCFile`

J'ai manuellement recréé le code de calcul du hash à partir du code machine.
Il opère par tranche de 8 bits, avec deux tables de lookup, et des échanges...
ce n'est pas un Adler16. Il peut s'agir d'un algo "maison", dans ce cas le
code ci-dessous associé au contenu des tables permettra de recréer les hash si
on veut faire des modifs. J'ai écrit un programme en C pour [calculer les
hashs](crc_rt6.c).

Exemple sur `/Application/BTL/File_Search.gz.inf` - le hash en début de
fichier est **0c622f64**. **0c62** est le hash du **.inf**, **2f64** est le
hash du **binaire**, comme on peut le voir :

    
    
    $ ./crc_rt6 /mnt/hd/Application/BTL/File_Search.gz.inf 4
    Computed CRC16 0x0c 0x62
    $ ./crc_rt6 /mnt/hd/Application/BTL/File_Search.gz 0
    Computed CRC16 0x2f 0x64
    

## 2.8. Compression des binaires

La plupart des exécutables sont des fichiers .gz compressés. Un peu d'étude du
code nous amène à la fonction **inflate** qui est utilisée pour décompresser
ces binaires. Malheureusement cette fonction ne semble pas avoir le
comportement standard de la zlib. Un peu de Google nous mène à [http://read.pu
dn.com/downloads58/sourcecode/embed/205887/src/util/inflateLib.c__.htm](http:/
/read.pudn.com/downloads58/sourcecode/embed/205887/src/util/inflateLib.c__.htm
). Tout en bas du fichier, la fonction `inflate` semble correspondre au code
source de celle du RT6. Il reste à vérifier en quoi cette fonction diffère de
ce que fait la zlib nativement et nous pourrons décompresser (et je l'espère
recompresser) les binaires du RT6. Avec décompression + CRC, on pourra
commencer à s'amuser à tout casser.

VxWorks ajoute en fait un octet de _bourrage_ au début de chaque fichier
compressé (qui sert pour calculer un checksum, mais uniquement si la variable
**inflateCksum** est définie - adresse `0xff4cf04` dans **BootRom.sym** qui
est l'exécutable principal, et elle ne l'est pas pour l'instant). Cet octet
fait que le format n'est pas reconnu par l'outil zpipe inclus dans zlib. Il
faut donc faire une petite modification sur **zpipe** dans `main()`:

    
    
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
    

Cela permet de passer un _seek_ en argument. La valeur de _seek_ à utiliser
est 1. On peut ensuite décompresser n'importe quel binaire du RT6 de la
manière suivante :

    
    
    zpipe -d 1 < file.gz > file.bin
    

J'ai fait cela sur tous les binaires compressés du firmware. Pas de surprise,
ce sont bien des binaires PowerPC, avec les symboles de debug.

# 3. Question Bluetooth

Bluetooth définit plusieurs **profils**, qui correspondent à un ensemble de
fonctionnalités rendues par un appareil à un autre. Pour la musique, il existe
**AD2P** qui est le profil permettant de transférer le son par radio, et
**AVRCP** qui permet le contrôle de l'appareil lecteur par un autre (play,
pause, next, previous, ...). Je souhaite savoir quelle version du profil
Bluetooth AVRCP mon véhicule supporte. Cette information n'est disponible
nulle part mais l'étude du module Bluetooth pourra répondre à la question. On
trouve dans `Application/BCM/t2bf/bcm_t2bf.bin` (note: je nomme **.bin** les
fichiers obtenus par décompression du **.gz**) les chaînes suivantes :

    
    
    AVRCP version 1.0 supported
    AVRCP version 1.3 supported
    AVRCP unknown version
    

Donc le RT6 supporterait la version 1.3 d'AVRCP. Il y a une version 1.4 qui
ajoute une fonction recherche et la possibilité de gérer plusieurs _players_
(par exemple deux téléphones simultanément pour streamer de la musique). [http
://en.wikipedia.org/wiki/Bluetooth_profile+Audio.2FVideo_Remote_Control_Profil
e_.28AVRCP.29](http://en.wikipedia.org/wiki/Bluetooth_profile+Audio.2FVideo_Re
mote_Control_Profile_.28AVRCP.29)

**sdptool** sous Linux liste les profils supportés par un appareil Bluetooth... mais **BT_CAR_SYSTEM** (le RT6) ne répond pas aux requêtes. En tout cas cela m'a permis de détecter la version d'AVRCP sur mon Blackberry et mon YP-P2 - ces deux appareils sont en 1.0, donc la voiture ne pourra pas afficher les méta données ni m'indiquer la liste des pistes. Conclusion il vaut mieux brancher ces appareils en **USB** (sauf que le Blackberry n'est pas accepté par le RT6 en USB, "média illisible", probablement à cause de la table des partitions - en effet le BB expose une table des partitions avec une seule partition, alors que la plupart des clés n'ont pas de table des partitions, à vérifier si c'est effectivement le souci, dans ce cas on serait en présence d'une erreur/oubli de la part de MM). 

# 4. Upgrade firmware

À faire : détails du fonctionnement de l'upgrade firmware. Questions: est-ce
qu'on peut ne mettre à jour qu'un seul fichier ? Est-ce qu'on peut faire des
changements et revenir en arrière sur une version officielle du firmware ?

Le système reconnaît que le média est une mise à jour du firmware à travers la
présence d'un fichier CD.inf, et il exécute le binaire
`/upg/flasher/flasher.rom`.

# 5. Upgrade POI

Détails du fonctionnement. Questions : pourquoi est-ce que ça boucle à
l'infini chez certaines personnes sans plus d'infos ? Est-ce qu'on peut y
faire quelque chose ? RE du format peut-être déjà fait car il existe des POI
non-officiels issues de SCDB pour le RT6 (vu sur gpsunderground).

Le système reconnaît que le média est une mise à jour des points d'intérêt à
travers la présence d'un fichier **POI_VER.POI**, et il exécute le script
`upg/poi_upgrade.cmd`.

# 6. Upgrade Carto

Détails du fonctionnement. Questions : Est-ce que le format est compréhensible
? Est-ce qu'on peut envisager de mettre à jour les cartes à partir
d'Openstreetmap ? Que signifie exactement "mise à jour pas compatible avec les
véhicules après août 2011" ?

Le système reconnaît que le média est une mise à jour des points d'intérêt à
travers la présence d'un fichier **CD_VER.NAV**, et il exécute le script
NAV_UPGRADE.CMD.

# 7. Besoin d'aide

Si vous voulez aider cet effort, et que vous n'êtes pas informaticien, voici
quelques idées de choses à faire :

  * photographies détaillées de l'extérieur et intérieur du RT6, avec repérage de tous les composants (afin de connaître les caractéristiques du matériel) 
  * plus spécifiquement, déterminer quel médium de stockage est dans le RT6 (disque dur, si oui marque et modèle, flash, si oui amovible ou pas, si oui marque et modèle, ...) 
  * prêt d'un RT6 pour test (non, je veux pas la voiture avec) 
  * prise de contact avec MM pour solliciter le code source ou la documentation (très peu de chances d'aboutir et c'est à double tranchant, réservé à des gens très diplomates) 
  * récupérer d'autres versions du firmware/POI/carto (attention aux aspects légaux) pour me les envoyer 
  * tester pour moi certaines fonctionnalités ("cheat codes" que j'indiquerai, etc.), voire plus selon votre courage 
