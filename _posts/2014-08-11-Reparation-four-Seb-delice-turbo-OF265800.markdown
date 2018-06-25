---
layout: post
title: Réparation four Seb délice turbo OF265800
date: 2014-08-11 09:27:31
tags: electronique reparation
category: francais
comments: true
img_rel: "/~sven337/data/four"
---

Je vais expliquer comment ouvrir et changer des pièces dans le four Seb <s>turbo-diesel</s> délice turbo **OF265800**. Ces informations sont probablement valables pour les modèles de la même gamme mais de taille différente (30L, ...).

![Photographie commerciale du four](image-four.jpg)

# La panne 

Ce four est mon deuxième mini-four Seb, en sept ans, dont le **mécanisme de la porte** a **cassé**. Je ne doute pas qu'il m'arrive de manipuler la porte avec un peu plus de force que la *ménagère de moins cinquante kilogrammes* pour laquelle ce genre d'appareil est prévu, mais je considère anormal qu'un appareil de cuisine nécessite d'être manipulé avec la plus grand douceur si on souhaite qu'il vive plus de 4 ans.

Sur le précédent four, c'était la pièce métallique qui relie la porte au four qui avait cassé, et les pièces n'étaient plus disponibles. J'avais donc été contraint de le changer. Cette fois-ci, le problème était moins important : la porte n'était plus retenue à l'ouverture, elle avait tendance à tomber d'un coup. Le cran intermédaire d'ouverture de la porte ne "fonctionnait" plus.
J'ai décidé de ne pas céder à la stratégie du jetable que les constructeurs essaient de nous imposer et d'ouvrir pour voir.

# Démontage

Le démontage et remontage m'ont pris plus longtemps que prévu. En effet le four est constitué de tôles fines, qui se déforment donc assez facilement, assemblées entre elles par des vis. Étant donnée l'épaisseur des tôles il n'y a aucun taraudage et les vis ne tiennent par conséquent pas très bien. 

## Retirer les vis 


### Dessous

Pour démonter ce four il faut commencer par le retourner et retirer les 8 vis cruciformes (tournevis aimanté obligatoire) qui tiennent les tôles. 6 des vis sont directement apparentes, 2 autres sont sous les caches en caoutchouc sous les pieds avant du four. Attention, ces deux caches ne sont pas identiques, notez bien lequel va où (même si je pense qu'ils sont interchangeables). 

### Derrière

Une fois ces vis enlevées, remettez le four dans le bon sens et retirez les vis de la face arrière. L'une d'entre elles a une tête de type SnakeEye, mais vous ferez comme moi et l'appellerez PutainDeVisÀLaCon. (En réalité je ne suis pas certain du premier nom, mais pour le deuxième il n'y a aucun doute.)

Par chance je possède un coffret d'embouts "bizarres" dont l'un convenait parfaitement. (Pour ceux que cela intéresse, il s'agit de l'ancienne version de [ce coffret chez Castorama](http://www.castorama.fr/store/Coffret-35-embouts-de-precision-prod8540001.html). Le commentaire client - qui n'est pas de moi - reflète mon avis.) Si vous n'en avez pas, vous pouvez, au choix :

1. courir acheter un coffret similaire. Cela vous servira si vous faites régulièrement de la réparation électronique, car de nombreux appareils sont pourvus de TorxPlus (PutainDeVisDeMerde) et autres vis conçues pour vous **empêcher de réparer** l'appareil que vous **possédez**.
1. essayer à la pince, la vis n'étant pas très serrée, mais pourvue d'une rondelle spéciale qui peut vous compliquer un peu la vie
1. limer un tournevis plat pour le transformer en tournevis pour PutainDeVisÀLaCon. À mon sens c'est stupide de faire cela quand on peut acheter le bon embout à bon prix, mais c'est votre argent.

### Devant

Ouvrez la porte du four : un certain nombre de vis sont présentes, qui maintiennent différents éléments de la façade. Je propose de faire simple et de toutes les enlever (3 de chaque côté et 3 en haut, si ma mémoire est bonne).

## Dépose du capot

Une fois les vis retirées il devient possible d'enlever le capot. Celui-ci fonctionne comme la voiture suivante (la photo n'est pas de moi) :

![Principe d'ouverture du capot](tesla-model-x-portes.jpg).

Il faut lever chaque côté du four, jusqu'à ce que les trois éléments en métal du côté qui sont enfichés dans le dessus se dégagent. Il n'est pas utile d'exercer beaucoup de force : si ça ne vient pas assez facilement, c'est que quelque chose coince, et vous risquez de tordre la tôle de manière qui sera difficile à réparer. J'en sais quelque chose.

Une fois les côtés retirés vous pouvez enlever l'arrière, quoique cela ne soit pas utile pour réparer le ressort de porte, je trouve que c'est l'occasion de faire un nettoyage poussé du four (et le retrait de l'arrière va aider), y compris de la vitre de la lampe.

# Réparation du ressort

Sur ce modèle de four, la porte est retenue par deux ressorts. Dans mon cas, l'origine du problème était facile à voir :

![Ressort de porte cassé](ressort-porte-casse.jpg)
![Point de fixation du ressort](ressort-porte-fixation.jpg)

Il aurait été judicieux d'essayer de remplacer ce ressort. J'imagine que Seb, à l'image des constructeurs automobiles, aurait été ravi de m'en vendre un au prix du four. Je n'ai pas fait de recherches chez d'autres fournisseurs (j'imagine qu'on doit pouvoir acheter en Chine, directement depuis l'usine, des ressorts dont certains seraient compatibles) car j'étais pressé de faire la réparation, et j'avoue n'avoir même pas noté les dimensions du ressort ce qui est une erreur.

Bref, considérant que la casse s'est produite sur la première spire du ressort, j'ai décidé de dérouler quelques-unes des spires à la pince (attention le ressort est particulièrement raide, ne vous blessez pas !) et de recréer le crochet de fixation. La raideur du ressort est évidemment modifiée, et surtout les contraintes qu'il va subir seront plutôt plus importantes qu'avant, donc je ne prévois pas que cette réparation soit particulièrement durable.
J'imagine que le ressort a cassé à cause des contraintes thermiques qu'il a subi : c'est en effet le seul élément de tout le four qui n'est pas protégé par une gaine, ce qui est une erreur de conception (ou plutôt un choix délibéré pour vous forcer à changer le mini-four au bout de 5 ans).

Voici une photographie de ma réparation : 

![Ressort après réparation](ressort-repare.jpg)
	
	
On note que l'autre ressort est protégé *partiellement* par une gaine, je ne comprends pas pourquoi la gaine ne fait pas toute la longueur :

![Gaine thermique du ressort de porte](ressort-porte-gaine.jpg)

# Anatomie

J'en ai profité pour prendre une photographie de la partie électrique du four, afin de montrer les différents organes. La photo n'est pas très bonne et j'en suis désolé.

![Anatomie](anatomie.jpg)

- En rouge, le thermostat - à gauche le bouton qui fait tourner un dispositif à lame métallique dont la dilatation thermique (je crois) joue le rôle de dispositif de coupure. J'ai connu cela dans un réchaud de cuisson électrique et c'était absolument nul, mais dans ce four je n'en suis pas déçu.
- En bleu foncé, le sélecteur de mode. Son rôle est de mettre en tension la résistance supérieure, inférieure, ou le ventilateur.
- En vert, la minuterie, qui met en tension le sélecteur de mode.
- En bleu clair, un des contacts de la résistance supérieure. La résistance inférieure est cachée sous les fils. J'ignore à quoi sert le ressort.
- En jaune, le ventilateur du mode "turbo". Je ne crois pas que les pales qu'on voit là sont celles responsables de la ventilation, je pense qu'elles servent simplement à refroidir les bobinages qui ne tolèrent pas de travailler à 300°C.


# Avis

Ci-dessous quelques commentaires sur cet appareil.

## Autres problèmes

### Minuterie 

Un problème que cet appareil a eu dès son achat, et au vu des commentaires sur Internet je refuse de croire que le mien était un cas isolé, est que la minuterie ne fonctionne parfois pas. Vous la remontez en position, elle commute correctement (donc le four chauffe), mais elle reste en position et on entend pas le "tic tac" typique de ces minuteries mécaniques. Vous partez faire autre chose, et revenez quand ça sent le brûlé car votre quart d'heure à 230° n'a pas été respecté puisque la minuterie ne fonctionne pas.
Le contournement consiste à donner une pichenette à la minuterie à travers le bouton, de telle sorte que vous entendez le bruit caractéristique de la minuterie. Dans mon expérience cela marche à tous les coups mais montre, à mon sens, une légèreté coupable de la part de Seb dans la conception et le contrôle qualité de l'appareil.

### Protection thermique

Le four se coupe parfois totalement. C'est un peu curieux car lors du démontage je n'ai pas vu de dispositif de sécurité thermique, mais je suis à peu près certain que sa sécurité thermique est un peu trop sensible. Si vous faites régulièrement griller des légumes (à la température maximale du four), vous serez probablement confronté au problème. Sachez qu'il suffit d'attendre que le four redescende en température pour qu'il fonctionne à nouveau.
Cela fait assez peur car l'électricité dans le four est totalement coupée, et on croit rapidement à une panne totale.

### Résistance

Je le mentionne pour ceux qui sont concernés : les résistances chauffantes des appareils de cuisson ne vivent pas éternellement, et si elles sont utilisés intensivement elles finissent par casser. En général, la casse prend la forme d'une coupure de circuit, et la résistance ne chauffe plus (c'est comme si elle n'était plus branchée). Peut-être qu'elle peut aussi se mettre en court-circuit, j'en doute un peu mais je ne suis pas expert, auquel cas elle va chauffer beaucoup, et mettre le feu à votre habitation à moins que la protection thermique du four ne réagisse avant (ce qui est normalement le cas), sachant que le tableau électrique devrait également couper le circuit au bout d'un moment.

Lorsque la résistance est cassée, elle n'est pas réparable : il faut la changer. Cela peut être assez cher (j'avais compté environ 30EUR pour une résistance de friteuse, ce qui est une bonne affaire vu le prix d'une friteuse neuve, mais tout de même pas donné), et surtout, il peut être très compliqué de trouver la bonne référence, si le constructeur ne coopère pas. Par expérience les quelques réparateurs d'électro-ménager qui n'ont pas fait faillite sont de bon conseil et peuvent vous aider à trouver la bonne pièce (car ils ont accès à un catalogue de pièces constructeurs et génériques, exactement comme votre garagiste), mais cela reste une démarche hasardeuse.

Je réalise n'avoir pas vérifié si la résistance était démontable sur ce modèle de four, et ce n'est pas très visible sur la photo que j'ai prise.

Je n'ai **pas eu de problème** avec les résistances de mon four - pour l'instant.

## Qualité

La qualité globale me fait plutôt peur. Elle correspond à ce que j'ai observé sur du matériel d'entrée de gamme et sans marque. On note ainsi le thermostat dont l'axe n'est pas aligné avec celui du bouton qui le contrôle (joli travail, les gars !), l'absence de protection thermique sur un des ressorts de porte, un capot tellement fin qu'il est très difficile à remonter, etc.
J'avoue être, en revanche, impressionné par le fonctionnement du thermostat étant donné la simplicité du dispositif. J'ai en fait hésité à modifier le four (puisqu'il était ouvert) pour rajouter une sonde de température (malheureusement pour supporter 240°C il faut utiliser une thermistance, une sonde à semiconducteurs ne supportant pas plus de 110°C)... je le ferai probablement un jour, à la prochaine panne.

Mon prochain mini-four sera d'une autre marque, car je n'apprécie pas du tout de devoir réparer un appareil acheté neuf il y a moins de cinq ans, et j'apprécie encore moins que le constructeur ait estimé important de me compliquer la manoeuvre (PutainDeVisÀLaCon, tôles vissées directement, manuel de réparation non disponible, ...).

<script>
    $(document).ready(function() {
		$("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>

