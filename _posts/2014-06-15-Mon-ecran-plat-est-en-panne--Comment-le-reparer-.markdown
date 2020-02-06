---
layout: post
title: Mon écran plat est en panne ! Comment le réparer ?
date: 2014-06-15 17:40:10
tags: electronics
category: francais
comments: pannecran
img_rel: "/~sven337/data/lcdfix"
---

Dans cet article je vais expliquer comment réparer un écran plat (télévision, écran d'ordinateur) en panne.
Je l'écris car s'il existe de nombreuses ressources sur Internet (souvent en anglais), je n'ai pas trouvé d'article de synthèse accessible à des débutants ou des personnes de niveau intermédiaire.

Dans un premier temps nous regarderons ensemble l'anatomie d'un écran plat, afin d'identifier les grandes briques fonctionnelles. Dans un deuxième temps nous verrons, pour les briques couramment responsables de la panne, comment les diagnostiquer, identifier le composant défectueux, et procéder au remplacement.

# Anatomie d'un écran plat

Un écran plat est constitué des composants suivants :

* la dalle, élément responsable de l'affichage
* les lampes, en général des tubes fluorescents (comme les "néons" dans les bureaux), qui assurent le rétroéclairage
* l'électronique de contrôle, qui assure l'envoi des données à l'écran, réagit à la pression sur les boutons, ...
* l'électronique de puissance, c'est-à-dire l'alimentation

95% des pannes proviennent de l'alimentation. Ironiquement, c'est cette brique fonctionnelle qui est la moins "high tech", étant basée sur des technologies connues depuis des années, sans rien d'innovant dedans. L'essentiel de l'innovation est situé dans la dalle (nouvelles matrices avec meilleur contraste, meilleur angle de vision, réaction plus rapide...), et l'électronique de contrôle.

## La dalle

Cet élément est celui qui est réellement responsable de l'affichage. C'est une grande plaque, noire, rarement accessible facilement. Elle est protégée devant l'écran par un matériau transparent qui encaisse l'essentiel des coups et rayures. La dalle est en général l'élément qui flanche dans le cas d'une casse : lors d'une chute, par exemple d'un ordinateur portable, la dalle est susceptible de casser.

La dalle n'est jamais réparable. Une fois cassée, seul un remplacement complet permet de réparer l'écran. Un tel remplacement n'est en général économiquement pas rentable : à neuf, il est impossible, et en occasion c'est rare de pouvoir trouver une dalle à un prix acceptable... mais dans le cas d'un ordinateur portable où l'écran n'est pas remplaçable, il n'y a guère le choix. N'achetez pas d'ordinateur portable.

## Les lampes

De nouvelles technologies apparaissent mais à l'heure où j'écris ces lignes la plus courante, en particulier sur les écrans de plus de 4 ans qui sont les plus susceptibles d'être concernés par cet article, est le tube fluorescent. C'est la même technologie que vous avez dans les lampes à économie d'énergie et dans les "néons" présents dans les immeubles collectifs.

Un gaz est placé dans une ampoule scellée, et excité par un **courant alternatif** de fréquence assez élevée, d'intensité assez faible, sous une tension d'environ **700V** (parfois plus). Lorsque ce gaz est excité il émet de la lumière, qui n'est pas forcément blanche, mais interceptée par un revêtement de surface sur l'ampoule qui la transforme en lumière (plus ou moins) blanche.

Les pannes arrivent parfois, toutefois je n'en ai jamais observé personnellement. J'imagine qu'il existe deux modes de panne : soit la panne "circuit ouvert, pas de lumière", qui correspondra à une lampe grillée (dans ce cas vous ne verrez pas une partie de l'image à moins de vous approcher très, très près), soit la panne "court-circuit", qui vous garantit au minimum la mise en protection de l'alimentation (donc pas de lumière sur aucune des lampes), quand ce n'est pas le décès "luminothermique" de ladite alimentation (rien à voir avec l'oxydation de l'aluminium).

## L'électronique de contrôle

Celle-ci est parfois répartie sur plusieurs cartes électroniques au dos de l'écran, selon la conception. Cette carte est assez facile à identifier : c'est la plus complexe, qui abrite des puces électroniques de taille assez importante, parfois équipées d'un radiateur. Le PCB (*printed circuit board*, c'est-à-dire le circuit imprimé) est en général vert ou bleu, double face, multicouches et recouvert de composants miniaturisés.
Cette électronique est responsable, de manière non exhaustive, de :

- décoder le signal radio (TV TNT = DVB-T, FM, ...) le cas échéant
- décoder le signal HDMI, VGA, ... le cas échéant
- envoyer les données à la dalle 
- répondre aux appuis sur les boutons et la télécommande
- changer de chaîne, augmenter le volume sonore, ...

Il est assez rare que toutes ces fonctionnalités soient intégrées sur une seule puce. L'amplificateur audio, le tuner radio, le contrôleur de dalle... sont en général chacun sur leur propre puce, cela pour des raisons industrielles. Lorsque vous concevez une télévision, celle-ci ne va probablement pas innover dans le domaine de l'amplification audio, et il est moins coûteux de prendre une puce d'amplification existante, que d'intégrer une logique d'amplification au sein du circuit que vous concevez pour cette nouvelle télévision. 

On trouve bien sûr de la mémoire vive (RAM) et souvent de la mémoire de masse (flash) sur la ou les cartes de l'électronique de contrôle.

Les pannes sont rares au niveau de cette électronique, ce qui est paradoxal considérant que c'est la partie de l'écran qui a coûté le plus cher à concevoir (après la dalle, mais ce n'est pas vraiment de l'électronique donc je l'ignore). Cela est très heureux car les réparations seraient pratiquement impossibles, d'une part car les composants susceptibles de tomber en panne (les puces) sont introuvables, d'autre part car même si vous pouviez les trouver vous ne pourriez pas les remplacer sans matériel professionnel et qualifications spécifiques (changer une puce en BGA, c'est un métier).

## L'alimentation

Nous allons, si vous ne l'aviez pas deviné, nous attarder longuement sur l'alimentation. En effet celle-ci est responsable de la majorité des pannes d'écrans plats, ce que je trouve par ailleurs scandaleux car les pannes sont stéréotypées, et évitables à condition de concevoir correctement la thermique (ce qui semble n'être jamais fait, mais c'est le problème n°1 des alimentations électroniques grand public en 2014).

Je vais rentrer de plus en plus dans les détails, et je vous invite à sauter des paragraphes si les détails dépassent votre niveau en électronique. Vous n'aurez pas besoin de ces connaissances théoriques pour dépanner votre écran (plus bas).

L'alimentation est responsable de deux choses :

* alimenter l'électronique de contrôle (en général **5V DC**)
* alimenter les lampes (en général **700V AC**)

Ces deux responsabilités semblent très différentes, mais en réalité la deuxième est construite en rajoutant une brique par dessus la première. L'alimentation est systématiquement structurée sous la forme d'une alimentation à découpage générant un courant continu - d'une part le **5V DC** nécessaire pour l'électronique de contrôle, d'autre part une tension plus élevée telle que **12V** ou **24V** DC. Cette tension plus élevée est ensuite fournie à un onduleur (en anglais *inverter*, vous verrez ce terme régulièrement utilisé, parfois à mauvais escient avec des auteurs qui assimilent l'intégralité de l'alimentation à un *inverter* alors que celui-ci n'en représente que la moitié).

Il arrive que l'onduleur soit déporté sur une carte séparée, dans ce cas conçue par d'autres ingénieurs voire d'autres sociétés. (Ce qui vous donne d'ailleurs à réfléchir sur le niveau de compétence du concepteur de votre télévision, qui se contente en fait d'assembler des composants qu'il n'a pas conçus ni fabriqués. Et on s'étonne que ça tombe en panne.)

### Alimentation DC ###

Si vous êtes curieux je vous recommande chaudement la lecteur de l'article suivant, qui explique très en détail comment fonctionne une alimentation d'ordinateur. La partie AC->DC de l'alimentation d'un écran plat est très similaire, voire identique (présence d'un PFC actif) sur les "fortes" puissances.

[http://www.tomshardware.fr/articles/Fonctionnement-d-une-alimentation-1ere-partie,2-265.html](http://www.tomshardware.fr/articles/Fonctionnement-d-une-alimentation-1ere-partie,2-265.html)

On trouve parfois, sur cette partie de l'alimentation, un PFC actif. En général un PFC passif est présent (voire pas de PFC du tout, ce qui il me semble n'est autorisé en Union Européenne qu'en dessous d'une valeur de puissance tellement faible que cela ne s'applique probablement qu'aux écrans 17").
On a bien sûr un pont de redressement, des condensateurs d'entrée, des transistors de découpage, un transformateur, des diodes de redressement, et des condensateurs de filtrage en sortie. La cause de panne la plus courante sur cette partie est la dégradation (âge et températures) des condensateurs électrolytiques de filtrage en sortie. Nous y reviendrons.

![Alimentation DC avec PFC actif et sortie 5V, 12V, 24V](psu_front.jpg)
![PFC actif](psu_pfc_transistor.jpg)
![Transistors de découpage](psu_transistors.jpg)

### Onduleur ###

Cet étage est en général attaqué par une tension un peu plus élevée que les 3.3V ou 5V de l'électronique de contrôle. En effet les lampes consomment une puissance non négligeable (surtout sur des diagonales importantes), et puisqu'il faudra découper après et élever la tension, autant se dispenser de faire circuler de trop gros courants. Sur un écran d'ordinateur de 17", l'alimentation DC attaquait l'onduleur avec **12V DC**, alors que sur une télévision 37" dont je montrerai quelques photos plus loin, c'était du **24V DC** (avec tout de même **6A** de courant nominal).

Des condensateurs d'entrée sont présents, et la tension est découpée et fournie à un transformateur par lampe (4 lampes, 4 transformateurs). Ce transformateur dispose d'un ratio important qui génère une tension d'environ **1kV AC**. (Je n'ai pas mesuré très précisément). 
En général sur l'onduleur, la panne vient des transistors de découpage, systématiquement sous-dimensionnés, mais parfois également de leur driver (sachant que la mort du transistor entraîne souvent la mort du driver).

Sur l'onduleur ci-dessous, j'ai déjà commencé à faire la réparation et j'ai retiré 3 transistors ainsi qu'un driver (qui a brûlé). On voit toujours les capacités d'entrée, les quatre transformateurs, les 8 transistors, et les 2 drivers.
![Onduleur](inverter_fullview.jpg)

# Réparer l'écran plat

Je m'intéresse ici strictement aux problèmes d'alimentations, qui sont majoritaires.

## SÉCURITÉ

Avant toute chose, il me faut aborder la question de la sécurité. Réparer une alimentation électronique est une activité dangereuse. Une fausse manipulation peut vous blesser, voire théoriquement vous tuer. Même une fois débranchée, une alimentation (c'est d'ailleurs valable pour les circuits de flash des appareils photos) peut rester dangereuse pendant plusieurs minutes. Le risque "réaliste" est celui d'une brûlure grave à un doigt, et d'une douleur que je suis fier d'être incapable de décrire car je ne l'ai jamais expérimentée. Le risque léthal n'est néanmoins pas exclu, car les condensateurs d'entrée stockent une énergie qui est théoriquement suffisante pour vous tuer, si le courant venait à traverser votre coeur.

### Hors tension

Hors tension, c'est-à-dire débranchée de la prise (et non seulement avec l'interrupteur ouvert, car celui-ci commute normalement la phase, mais vous ne savez pas vraiment si la phase est à gauche ou à droite chez vous), la seule source de danger d'une alimentation provient de son stockage d'énergie à haute tension, c'est-à-dire le ou les condensateurs électrolytiques qui sont situées à l'entrée. Ceux-ci sont en effet chargés à une tension d'environ **400V**, et disposent d'une quantité d'énergie susceptible de vous brûler ou de dépolariser votre coeur. En général, une résistance de décharge de forte valeur est présente (encore que je ne l'ai pas vue sur la dernière alimentation que j'ai réparé, mais peut-être était elle intégrée dans le *driver*), qui permet de vider progressivement le condensateur. 
Après la mise hors tension je recommande d'attendre au moins une minute avant de toucher n'importe quel composant. Ensuite, une vérification au voltmètre aux bornes des condensateurs d'entrée permettra de vérifier que la tension à leur borne est inférieure à **30V**. À ce stade, l'alimentation est inoffensive et vous pouvez la toucher (avec les doigts, mais pas avec la langue !) sans crainte, du côté primaire (avant le transformateur) comme du côté du secondaire.
Évitez d'avoir les mains qui tremblent lors de votre mesure sur les condensateurs, et ne négligez pas le délai d'attente. Si vos mains tremblent, vous risquez de court-circuiter le condensateur avec les sondes du multimètres, imposant une décharge rapide qui fera des étincelles et détruira le condensateur. Ça fait de la lumière, du bruit, ça fait peur, et ça peut faire mal.

Le délai d'attente vise à vous éviter de mesurer des tensions importantes. Mesurer une tension de 300V ne pose pas de vrai problème et peut se faire en sécurité avec la plupart des multimètres, mais pour un multimètre premier prix avec des sondes premier prix il est raisonnable de s'interroger sur la qualité de l'isolation. En plus, faire la mesure avec vos deux mains met le coeur en plein dans le passage, donc autant éviter de mesurer des tensions trop importantes.

### Sous tension

C'est malheureux, mais la plupart des diagnostics ne sont pas réalisables hors tension, car il faut bien regarder l'alimentation fonctionner pour voir à quel endroit elle ne fonctionne précisément pas.

#### Alimentation DC

Au secondaire de l'alimentation DC ne sont présentes que des tensions faibles qui ne présentent pas de danger particulier. Ne manipulez rien avec des mains mouillées, faites attention à votre outillage, mais vous pouvez toucher n'importe quel point au secondaire sans trop de danger. Si par hasard l'alimentation fournit une tension supérieure à 24V je recommande d'être prudent. 
Au primaire de l'alimentation DC, **tous les points sont à un potentiel du secteur**. Ne touchez rien avec les doigts, même pas un radiateur ou la carte nue, et faites le moins possible de mesures au voltmètre de ce côté là (pour éviter les accidents).

#### Onduleur (alimentation DC->AC)

Pour l'onduleur, c'est l'inverse (à supposer qu'il soit sur une carte séparée) : le primaire ne présente pas de danger particulier, mais le secondaire vous présente plus de **700V** AC, avec un courant qui peut atteindre plusieurs centaines de milliampères. De plus vous risquez de vous retrouver en incapacité physique (par tétanisation des muscles) de relâcher. **Le secondaire de l'onduleur ne doit pas être touché sous tension !** (Hors tension, par contre, il n'est pas dangereux et ce sans délai d'attente car il n'y a pas de condensateur de stockage à haute tension, puisque le secondaire est entièrement AC.)

Attention aux limites de votre multimètre, un multimètre À Pas Cher(TM) n'a en général pas une isolation lui permettant de mesurer la tension présentée aux lampes. Ça ne m'a pas empêché de le faire quelques fois mais ce n'est pas une très bonne idée. 

## Déterminer quel élément est responsable

Maintenant que vous tremblez de peur, nous allons commencer par quelques manipulations sans risque !

L'alimentation est en général responsable du problème, mais nous allons tenter de le vérifier. Les symptômes d'une panne d'alimentation sont les suivants :

### Le mode "veille" de la télévision fonctionne (LED témoin allumée), mais lorsque vous démarrez la télévision, rien ne se passe

Panne probable sur l'alimentation DC ou l'onduleur.

### Même chose, mais l'image apparaît un instant et s'éteint immédiatement

Panne probable sur l'alimentation DC ou l'onduleur.
 
### Même chose, mais l'image apparaît pour de bon, sauf qu'elle "vibre", est sous ou sur dimensionnée, ...

Panne probable sur l'alimentation DC.

### le mode "veille" de la télévision ne fonctionne même pas (pas de LED témoin) -> cas rare

Panne probable sur l'alimentation DC.

### Son OK mais pas d'image

Si le son est OK mais l'image n'est pas présente, vérifiez si ce n'est pas le rétroéclairage qui est en panne (cas courant). Pour cela, collez vous à l'écran, vous devriez voir l'image très sombre et sans contraste : panne de rétroéclairage.
Si pas d'image du tout, panne de la dalle ou de l'électronique de contrôle, votre appareil n'est pas réparable.

Pour une panne du rétroéclairage, dans le cas présent on soupçonnera d'abord les lampes, car dans le cas où l'onduleur a un problème il est courant qu'il se mette en court-circuit (ce qui coupe l'alimentation DC et donc tout l'appareil). 


Les cas qui ne sont probablement *pas* des problèmes d'alimentation sont les suivants :

- mauvaise réception TNT
- pixels morts ou coincés
- entrée (HDMI, VGA, ...) qui ne fonctionne plus
- image OK mais pas de son

## Trouver la panne sur l'alimentation DC

La panne provient à 90% des condensateurs électrolytiques en sortie. Dans une alimentation, ces condensateurs sont pratiquement des pièces d'usure. Un condensateur électrolytique, c'est un cylindre en aluminium, scellé, qui contient un électrolyte liquide. Lorsque le condensateur chauffe (parce qu'il est soumis à une température élevée, courant car les diodes de redressement en sortie s'échauffent, ou parce qu'un gros courant le traverse), l'électrolyte se dilate, et il arrive qu'il fuie. Vous voyez cela si le sommet du condensateur (là où une croix métallique est destinée, précisément pour permettre l'expansion sans explosion) est bombé, ou s'il a fui.
C'est une panne très courante et plutôt bien décrite sur Internet, par exemple dans [cet article](http://www.tomshardware.fr/articles/Reparer-carte-mere,2-434-4.html).

![Condensateurs de sortie, en parfait état](psu_24v_diodes.jpg)

Ne vous inquiétez pas à propos des condensateurs en entrée (les très gros, en général marqués 400V) : ceux là chauffent peu et ne s'usent donc pratiquement pas. Seuls les condensateurs électrolytiques (cylindriques de gros volume) situés en sortie sont réellement susceptible d'être "usés".

Parfois, les condensateurs de sortie ne sont pas visiblement bombés. Cela ne permet pas pour autant de les mettre hors de cause (et sur une alimentation d'écran que j'ai réparée, rien ne permettait de voir que ces condensateurs devaient être changés).
Pour vérifier qu'ils sont vraiment en cause, l'idéal serait de brancher un oscilloscope sur la sortie de l'alimentation et de regarder si la tension est stable. Si vous possédez un oscilloscope vous n'êtes probablement pas en train de lire mon article :)

Mon approche consiste à brancher le voltmètre sur la sortie et à démarrer l'écran (*avec* une charge, c'est-à-dire avec la carte électronique branchée sur l'alimentation), et à regarder si la tension de sortie varie. Si le condensateur est en mauvais état vous arriverez souvent à voir une baisse sur le voltmètre (par exemple, 3.8V au lieu de 5V). C'était le cas sur un écran que j'ai réparé où tout fonctionnait, mais l'image était déformée, et clignotait, signe que l'électronique de contrôle "plantait" mais sans complètement se bloquer.
À noter qu'en général la chaleur tend à réduire les problèmes des condensateurs défectueux : parfois, lorsqu'ils sont chauds (certains les attaquent au sèche-cheveux), le problème peut disparaître. C'est un signe de plus que les condensateurs de sortie sont à changer.

Ce changement n'est pas une opération très difficile, les composants étant faciles à trouver et à changer. Le coût en revanche peut être conséquent.

## Trouver la panne sur l'onduleur

Sur l'onduleur, la cause courante de la panne sera les transistors de découpage (qui sont parfois nombreux, étant donné qu'on trouve en général plusieurs transformateurs chacun attaqué par deux transistors). Ceux-ci sont souvent sous-dimensionnés et mal refroidis, et se mettent en court-circuit. Ils ne jouent plus leur rôle de "robinet" pour le courant et deviennent constamment passants, ce qui détruit souvent la puce *driver* et crée un court-circuit à l'entrée de l'onduleur (auquel l'alimentation DC réagit en coupant tout).

Pour tester les transistors, j'ai une technique très approximative qui fonctionne néanmoins plutôt bien. Identifiez (à l'aide de la *datasheet* obtenue sur *Google* à partir des marquages présents sur le transistor) quel pin correspond à quelle fonction - en général sur les MOSFET de surface l'ordre est gate, drain, source, et vérifiez avec un ohmmètre la résistance entre le drain et la source, avec le + sur le drain, et le - sur la source (impératif). Vous devriez trouver une résistance infinie, ou du moins très grande. Si vous trouvez 0, il y a de très fortes chances que le transistor soit en court-circuit. Dans ce cas il est souhaitable de le déssouder (si possible sans le détruire) et de le tester hors du circuit pour confirmer.

Pour tester le driver, je ne connais pas de méthode. Si un des transistors est en court-circuit il est préférable de changer le driver qui aura possiblement été détruit lorsque le transistor s'est mis en court-circuit, mais je me suis déjà contenté de ne changer que le transistor et cela fonctionnait très bien. Pour moi, le remplacement du driver va surtout dépendre de contraintes économiques et techniques : est-il possible de le trouver à bas coût en quantité raisonnable (car la bobine de 5000 ne vous intéresse probablement pas) ? Est-il possible de le changer avec votre fer à souder sans détruire la carte ?
Souvent la réponse à l'une de ces questions est non, ce qui emporte la décision.

## Se procurer les composants

Voir [mon article sur les achats sur Internet](http://perso.aquilenet.fr/~sven337/francais/2014/06/02/Acheter-des-composants-electroniques-sur-Internet.html) pour comprendre où je me fournis.

En général et pour les pannes décrites dans cet article, le meilleur choix est ebay.com (ne faites pas vos recherches en français, c'est inutile).

### Les condensateurs

Pour les condensateurs, repérez : 

- leur capacité (en général de l'ordre de 500 micro-farads)
- leur tension de service (à peu près le double de la tension nominale de sortie)
- si vous avez un pied à coulisse, leur dimension

Le critère est de trouver un condensateur de même capacité, de tension de service supérieure ou égale, et de dimensions compatibles avec l'espace disponible sur la carte (souvent, c'est serré !). En général, vous aurez besoin d'un condensateur marqué "low ESR" (*equivalent series resistance*, un critère secondaire mais important).

Certains recommandent de prendre une grande marque de condensateurs, par exemple Panasonic. Le problème est que leur coût est parfois prohibitif pour réparer du matériel usagé. J'ai tendance à penser qu'un achat de condensateur dans les bons critères, mais À Pas Cher(TM), est une bonne stratégie. S'il meurt à nouveau dans l'année qui vient vous saurez que vous pouvez acheter du haut de gamme !

### Les transistors de découpage

Le marquage sur les transistors vous indique toujours leur type, dont vous pourrez trouver la *datasheet* avec peu d'efforts. Le remplacement se fait de préférence à l'identique, mais cela pose rarement problème, en particulier pour les transistors de découpage de l'onduleur car les concepteurs utilisent systématiquement des transistors très courants et peu onéreux (d'où les pannes fréquentes...).

Si vous ne pouvez pas remplacer à l'identique, bon courage pour trouver un transistor compatible. Cela n'est pas dur mais sort franchement du cadre de cet article introductif.

### Les circuits intégrés *driver*

Pour les *drivers*, le remplacement est **systématiquement** à l'identique. Parfois, la puce est introuvable, ou à un coût délirant (plus de 20EUR, par exemple). Dans ce cas, vous êtes tout bonnement coincé, et même si vous trouvez la puce, elle pourrait bien s'avérer impossible à remplacer techniquement.

## Remplacer les composants défectueux

Le remplacement, c'est le moment où vous aller toucher une carte électronique avec un bout de métal surchauffé, dans le but de la réparer. Le risque de destruction en cas de fausse manipulation est bien réel. (Concernant votre sécurité personnelle, les lunettes de protection sont une bonne idée, et essayez de ne pas attraper le fer chaud avec la main sous peine de voir votre femme vous verser le ketchup jusqu'à la fin de vos jours.)

### Matériel

Chez les snob, on va vous conseiller un fer à souder de grande marque (trois fois le prix de votre écran neuf), probablement cinq à dix outils spécifiques, ruineux, et pas toujours utiles, etc.
Pour la réparation À Pas Cher(TM), on se contentera de :

- fer à souder premier prix, sans réglage de température, puissance 20W minimum (en dessous c'est un jouet pour les enfants)
- tresse à déssouder en cuivre
- soudure étain-plomb la moins chère que vous trouvez dans un diamètre raisonnable
- pompe à déssouder
- (optionnel) panne de fer à souder de forme plate (type tournevis plat), plus efficace qu'une panne pointue malgré l'intuition
- (optionnel) pince brucelle inversée
- (optionnel) troisième main (l'outil, pas la partie du corps)
- (optionnel) loupe

### Déssouder les composants défectueux

Regardez une vidéo Youtube si vous ne savez pas faire. Pour les condensateurs traversants c'est le genre de chose que vous avez fait au collège. Pour les composants de surface il y a des astuces mais je ne suis pas spécialement expert. Pour les puces en format type TSOP (voir photos dans cet article), il y a des astuces *compliquées*.

Faites très attention à une chose : les petites pistes sur les PCB tendent à se décoller voire à se couper quand elles ont trop chauffé. Si cela arrive, votre travail va devenir très difficile, car vous vous êtes engagé dans la destruction de la carte, ce qui n'était pas notre objectif premier. Notez que vous pouvez toujours tenter de remplacer la carte, pour cela cherchez sur *Google* un des marquages apposés sur le PCB. Quand vous verrez le prix, vous changerez probablement d'avis et reprendrez votre fer à souder en main !

![Transistor TO252 déssoudé](inverter_transistor_ripout.jpg)

### Installer les nouveaux composants

Installer les composants est plus facile que de les enlever : vous avez donc fait le plus dur.
Pour les composants traversants (attention au sens des condensateurs électrolytiques qui sont polarisés !), si vous n'avez pas réussi à retirer toute la soudure du trou, vous pouvez tenter d'insérer le composant tout en faisant fondre la soudure, ou carrément de percer dans le trou. Attention à percer au diamètre le plus faible possible : il ne faut surtout pas élargir le trou dans le PCB, car le PCB est pourvu d'une bague en métal qui fait contact. Si vous détruisez celle-ci vous aurez énormément de difficulté à souder correctement le nouveau composant.

Pour les composants en surface, il faut de la patience, *Youtube*, et ne pas trop trembler. La tension de surface de l'étain fondu, associée à la magie de la tresse à déssouder, rendent l'installation d'un chip assez facile par rapport à ce qu'on peut s'imaginer.

Le problème arrive lorsque l'étape de déssoudage a été mal réalisé, comme sur la catastrophe, dont je ne suis pas fier d'être responsable, que je vous présente ci-dessous. Voyez comment plusieurs des pistes (entourées sur l'image) sont cassés, ce qui nécessitera un raccord avec du fil. Notez également que certaines pistes semblent ne plus être droites : c'est parce qu'elles sont décollées ! Un enfer pour la réparation.

![Driver BD9898FV déssoudé](inverter_TSOPremove_view.jpg)
![Détail pour l'installation du nouveau BD9898FV](inverter_TSOPremove_detail.jpg)

<script>
    $(document).ready(function() {
		$("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>
