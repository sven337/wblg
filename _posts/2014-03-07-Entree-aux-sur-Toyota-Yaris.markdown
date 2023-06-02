---
layout: post
title:  "DIY - Rajouter une entrée AUX sur Yaris 2007"
date:   2014-03-07 21:16:55
categories: francais
img_rel: /~sven337/data/w58824
disqus_comment_thread: YarisAuxFR
comments: YarisAuxFR
redirect_from:
    - /YarisAuxFR
---

# Objectif

Rajouter une **entrée auxiliaire** sur une **Yaris** de **2007** achetée en France. Le véhicule utilise un autoradio **W58824** fabriqué par Panasonic
sous la référence **CQ-TS0570LC** (exclusif à Toyota).

J'ai écrit un article en anglais à ce sujet, avant de réaliser que les personnes concernées seraient probablement plutôt francophones.

Cet article en est un résumé.

# Mes essais n'ont pas fonctionné

J'ai réalisé trois tentatives différentes qui n'ont pas fonctionné. Les Yaris américaines disposent, sur le connecteur à l'arrière de l'autoradio, d'une entrée auxiliaire. Celle-ci n'est bien souvent pas câblée dans le véhicule, mais elle existe néanmoins, et il suffit d'y connecter 3 fils pour pouvoir s'en servir. C'est ce que réalisent des objets tels que celui-ci: ![Cable aux](cable_aux.jpg) (ou, si cela vous chante, la référence Toyota officielle qui vous coûtera de l'ordre de 50 euros). Ensuite, un simple appui sur le bouton AUX (ou DISP, ou CD, ... selon le modèle exact qui n'est _pas_ W58824) et l'entrée fonctionne.

Nous avons moins de chance en France, car si le même connecteur est bien présent au dos de l'autoradio, il est utilisé à des fins différentes. Sur ma voiture, seules 3 des 20 pattes de ce connecteur sont utilisées, et c'est pour la commande au volant.
![Connecteur D74 utilisé pour commandes au volant](conn_SW.jpg)

# Quelles sont les options restantes ?

Il y a **trois possibilités** pour rajouter une entrée auxiliaire :

1. **émuler un changeur de CD**
1. **injecter l'entrée auxiliaire sur la sortie du lecteur CD**
1. **injecter l'entrée auxiliaire sur l'entrée de l'amplificateur**

Émuler un changeur de CD est plus compliqué qu'il n'y paraît. En effet, les données voyagent sous forme analogique compatible directement avec le câble jack 3.5mm que nous souhaitons ajouter, mais l'autoradio est basé sur **AVC-LAN**, un protocole réseau made in Toyota dont le principal but semble être de compliquer les manipulations telles que celle que nous tentons ici.

Il faut donc de l'électronique spécifique pour parler à l'autoradio en AVC-LAN, afin de lui faire croire qu'un changeur de CD est présent, cela pour qu''il accepte de lire les données analogiques qui lui sont envoyées sur la prise changeur CD. Voir <http://www.softservice.com.pl/corolla/avc/avclan.php>, en anglais, pour plus d'informations.

Certains appareils se trouvent sur AliExpress ou eBay, qui permettent d'émuler un changeur de CD. Ils sont relativement onéreux (compter plus de 50 euros) car ils sont intrinsèquement complexes. On verra à la fin de cet article que, la mort dans l'âme, je suis contraint de recommander cette solution (quoique ne l'ayant pas testée moi même).

Les options **2** et **3** imposent de démonter l'appareil.

# Démonter l'appareil

Démonter l'appareil est compliqué, notamment parce que Panasonic a choisi d'utiliser des clips en plastique dur, du genre de ceux qui se cassent si vous les regardez de travers. J'espère que UFC-Que choisir se décidera à faire un énorme procès à l'inventeur de ces clips.

![Vue de face](front.jpg)
![Vue de dos avec connecteurs](back_connected.jpg)
![conn_main1-thumb.jpg](conn_main1.jpg)
![conn_main1p-thumb.jpg](conn_main1p.jpg)
![conn_main2-thumb.jpg](conn_main2.jpg)
![back-thumb.jpg](back.jpg)
![Retrait des clips tout pourris](front-noplastic.jpg)
![side-thumb.jpg](side.jpg)
![side2-thumb.jpg](side2.jpg)
![Carte lecteur CD](cdreader_board.jpg)
![Carte mère](mainboard.jpg)

## Carte électronique

La plupart des puces utilisées semblent être à usage interne Panasonic, et je n'ai pu trouver aucune _datasheet_ sur Internet !

Un manuel de réparation d'un modèle proche m'a cependant aidé un petit peu.

## Sortie du lecteur CD

La sortie du lecteur CD dispose de 14 pins, donc trois nous intéressent - **Left**, **AGND**, **Right**. Se brancher dessus est difficile car les pistes sur le PCB sont minuscules, et celui-ci est copieusement verni ce qui complique d'autant la soudure.

Ceci ne fonctionne pas : en effet j'ai observé que lorsque je branchais mon lecteur MP3 à travers la prise jack, pour injecter le signal sur ces trois pins, le son se coupait complètement, comme si le signal du CD était "écrasé". Par contre, ce n'est pas pour autant que j'ai entendu le son de mon lecteur MP3...

## Entrée de l'amplificateur

Si vous ne parvenez pas à identifier l'amplificateur sur la carte en 15 secondes, merci de tout remonter et vous faire un peu la main sur de l'électronique avant de jouer à modifier un autoradio. Les erreurs coûtent cher sur ce type d'appareil. En se branchant sur l'entrée de l'amplificateur (5 pins au milieu du chip, **F**ront**L**eft/**F**ront**R**ight/**R**ear**L**eft/**Re**ar**R**ight et **GND**), on peut tenter d'injecter du son, indépendamment du mode CD ou radio de l'appareil.

Une fois de plus, si j'ai bien réussi avec mon câble à "tuer" le son qui sortait, je n'ai pas réussi à entendre celui de mon lecteur.

J'ai réalisé après coup que l'appareil utilise un pré-amplificateur - il est donc probable que le niveau du signal n'était pas bon.

# Travail à venir

Les connexions sont dures à réaliser de manière fiable et solide, et un connecteur AUX ne vaut pas les neuf heures de travail que j'ai consacré à ce projet. Un essai d'injection sur le pré-amplificateur me semble être la meilleure piste, mais la réalisation d'un émulateur de changeur CD (lien plus haut), ou l'achat d'un tel appareil - qui fournit souvent par ailleurs des fonctionnalités utiles comme un port USB - est probablement le choix le plus simple. Le coût n'est bien sûr pas nul.

Si vous êtes intéressé pour continuer les expérimentations, je serais très intéressé de connaître vos résultats ! Contactez-moi et je les mettrai en ligne.

<script>
    $(document).ready(function() {
		$("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>

