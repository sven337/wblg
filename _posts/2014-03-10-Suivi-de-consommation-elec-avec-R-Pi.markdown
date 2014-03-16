---
layout: post
title: "Suivre sa consommation électrique avec un Raspberry Pi"
date: 2014-03-09 22:17:00
category: francais
---

Cet article détaille comment **suivre sa consommation électrique** avec un **Raspberry Pi** et un montage électronique simple et surtout très bon marché. 
Il nécessite de disposer d'un compteur électrique suffisamment moderne.

# Introduction

Le Raspberry Pi est un mini ordinateur capable de faire fonctionner Linux, et qui coûte peu cher. De nombreuses personnes suggèrent de s'en servir comme serveur (web, e-mails, ...), mais je doute que ses performances soient suffisantes pour cela. (À vrai dire je n'ai jamais testé car j'utilise un eeePC 701 comme serveur depuis plusieurs années, dont je suis très satisfait.)

Néanmoins je possède un Raspberry Pi, ainsi qu'un placard électrique dans lequel je peux le poser, le brancher, et l'interfacer avec le compteur. En avant !

# La sortie téléinfo

La sortie **téléinfo** est présente sur **tous les compteurs EDF** de moins de quelques années. Le mien ressemble à cela : <a href="data/teleinfo/compteur.jpg"  title="Compteur A14C5"><img src="data/teleinfo/compteur-thumb.jpg" /></a>. La vis que j'indique sur la photo n'est normalement pas scellée, et permet d'ouvrir la trappe inférieure qui vous donnera accès aux bornes I1/I2 (à gauche) de la téléinfo. Il y a deux autres bornes qui elles véhiculent (parfois) du 230V AC, donc ne mettez pas les doigts, je crois qu'elles servent pour brancher une lampe témoin du _jour plein_ (option tarifaire désuète).

La téléinfo répond à une spécification disponible en ligne : <http://norm.edf.fr/pdf/HN44S812emeeditionMars2007.pdf>. De nombreux projets se contentent de **capter l'impulsion lumineuse** du compteur (une impulsion = 1W.h en général), mais la sortie téléinfo peut nous donner bien plus que cela :

- puissance instantanée en watts
- indice du compteur
- situation heure pleine/heure creuse (qui ne me concerne toutefois pas car je me contente de l'option base, plus avantageuse dans ma situation)

La sortie téléinfo implémente un protocole qui n'est électriquement pas compatible avec les protocoles que parlent les ordinateurs en général (RS-232, USB, parallèle, ...), ni d'ailleurs avec les protocoles du monde de l'informatique embarquée tels que I2C, SPI, ou un bête GPIO. C'est un choix curieux de la part d'EDF, mais le protocole téléinfo est assez facile à convertir en un protocole connu tel que **RS-232**.
La spécification est publique et plutôt bien écrite, alors au travail !

La forme du signal est la suivante : un **0** correspond à une **sinusoïde** à **50KHz** variant entre **-12V** et **+12V**, un **1** correspond à un plateau à **+0V**.
**RS-232** utilise quant à lui **+12V** pour un 1, et **-12V** pour un 0. Cette tension négative est un choix technique discutable qui complique la vie de l'électronique moderne souhaitant implémenter RS-232. En général les circuits intégrés ont une UART qui utilise des niveaux de signaux différents (TTL) : +Vdd = 3.3V pour un 1, et +0V pour un 0. C'est plus simple, et plus logique... mais les ports série des ordinateurs "parlent" du vrai RS-232. Le circuit **MAX232** est un exemple de circuit intégré qui s'occupe de la conversion des niveaux entre RS-232 "réel" et RS-232 TTL (celui à 3.3V).

# Travaux précédents

J'ignore ici les montages basés sur la **détection de l'impulsion lumineuse**. De nombreuses personnes ont réalisé des montages (et parfois créé une activité commerciale) permettant d'**interfacer la téléinfo avec RS-232**.

Le problème de ces montages est que bien souvent ils visent à obtenir une compatibilité avec RS-232 (par exemple <https://store.adtek.fr/home/12-interface-teleinfo-rs232.html> ou  <https://store.adtek.fr/home/10-teleinfo-usb-sans-souris-folle-v2.html>. Je ne connais pas cette société ni leurs produits, dont je n'ai pas de raison de penser qu'ils fonctionnent mal. Par contre, dépenser 30 euros ou plus pour ce genre de montage est clairement en dehors du budget que je m'étais fixé.). Or, RS-232 ne nous intéresse pas, puisque le R-Pi implémente RS-232 avec des niveaux TTL, incompatible, mais aussi plus simple. Je ne suis bien sûr pas le premier à le remarquer, et on voit des montages qui consistent à brancher directement un optocoupleur bidirectionnel **SHF6206** à la sortie téléinfo et au Pi... sauf que ce modèle est pratiquement introuvable, et que de manière générale les optos bidirectionnels coûtent cher. On trouve un exemple abouti et bien expliqué, qui a servi de base à ma réalisation, à l'adresse suivante : <http://www.chaleurterre.com/forum/viewtopic.php?t=15153>.

J'ai réalisé un montage différent dont l'objectif (atteint) était de n'utiliser que des composants facilement disponibles (sur eBay, DealExtreme ou AliExpress, par exemple), et peu chers.

# Architecture

Ayant eu beaucoup de mal à trouver un optocoupleur qui ferait l'affaire pour un branchement direct (car il faut non seulement qu'il soit bidirectionnel mais aussi que ses caractéristiques soient compatibles avec le timing du signal, chose pas toujours facile à garantir), j'ai opté pour un montage redresseur et un filtrage (permettant d'obtenir **0** = **+12V** constant, **1** = **+0V**, qui attaque l'optocoupleur le moins cher que j'ai pu trouver, dont la sortie est reliée au Pi de manière similaire au message du forum dont je donne un lien ci-dessus.

Voici le schéma correspondant (cliquez pour l'avoir en grand):
<a href="data/teleinfo/schema.jpg" title="Schéma redressement teleinfo" ><img src="data/teleinfo/schema-thumb.jpg" style="border:1px solid black" width="80%" /></a>

J'ai d'abord tenté un redressement simple alternance, mais comme on verra dans le paragraphe suivant ce n'était pas une bonne idée.

# Réalisation électronique

## Simulation

Avant toute chose et afin de dimensionner correctement les composants, j'ai choisi de simuler le circuit à l'aide de **ngspice** (logiciel libre disponible sous Linux). Ce type de simulateur ne donne pas toujours de bons résultats mais pour un circuit aussi simple il nous sera très utile. Une alternative consisterait à calculer la valeur du condensateur et de la résistance de protection de l'optocoupleur à la main, mais cela nécessiterait de savoir ce qu'on veut obtenir en termes mathématiques ! En réalité, on se contentera de regarder la forme du signal et de décider si oui ou non il se rapproche suffisament du signal carré attendu par l'UART du Raspberry Pi. N'ayant pas d'oscilloscope, je fais tout cela en simulation.

Voici un premier circuit à simuler, avec redressement en simple alternance :
[title="Circuit redressement mono alternance"](data/teleinfo/filtrage_1diode.net)

Pour lancer la simulation, ``ngspice filtrage_1diode.net`` va charger le fichier, ensuite la commande ``tran 0.05us 3.2ms`` fait une simulation pendant 3.2 ms par pas de 0.05 us, et on peut visualiser la courbe de tension en un point donné en utilisant la commande ``plot``.
``plot v(1)`` nous montre le signal appliqué à l'entrée :
<a  href="data/teleinfo/spice_input_signal.jpg"><img src="data/teleinfo/spice_input_signal-thumb.jpg" /></a>

Il s'agit de la séquence 0->1->0->1. Bien sûr, c'est plutôt la sortie qui nous intéresse. Ce qu'on voudrait voir, c'est quand est-ce que **le Pi** voit un zéro ou un un. Ce n'est pas quelque chose qu'on trouve directement, mais cette information dépend du courant qui traverse la LED de l'optocoupleur, qui est lui-même proportionnel à la tension aux bornes du condensateur. On se contentera donc de regarder la tension aux bornes du condensateur, et de décider _au doigt mouillé_ si les transitions sont suffisamment franches ou pas.

Pour la tension aux bornes du condensateur, c'est ``plot v(3)``. On obtient la courbe suivante :
<a  href="data/teleinfo/spice_output_1D.jpg" title="Redressement mono-alternance"><img src="data/teleinfo/spice_output_1D-thumb.jpg" /></a>

### Qu'est-ce qu'on aimerait avoir ?

Un beau signal en créneau !

### Qu'est-ce qu'on a ?

Un moche signal en créneau :)
Plus sérieusement, deux éléments attirent l'oeil : 
1. l'ondulation résiduelle entre 4.5 et 5.7V, alors qu'on aimerait quelque chose de bien plat. Cela pourrait se traduire par 0 qui n'est pas complètement stable et qui risquerait d'être mal interprété
1. le temps de chute lors du passage à 0V, qui est tellement important que le 0V n'est jamais atteint. Cela pourrait se traduire par un 1 qui est systématiquement lu comme un 0 car le niveau logique bas n'est jamais atteint

Ces points sont-ils vraiment un problème ? Dur à dire sans rentrer plus en détails dans les caractéristiques de l'optocoupleur.

### Redressement double alternance 

On peut améliorer l'ondulation résiduelle en faisant un redressement double alternance, ce qui correspond au schéma que j'ai présenté plus haut.

[Circuit redressement double alternance](data/teleinfo/filtrage_4diodes.net)

Voici le signal aux bornes du condensateur :
<a  href="data/teleinfo/spice_output_4D.jpg" title="Redressement bi-alternance"><img src="data/teleinfo/spice_output_4D-thumb.jpg" /></a>

Si le temps de chute n'a pas bougé, et reste inquiétant, on note que l'ondulation résiduelle est bien meilleure (car on charge le condensateur deux fois plus souvent, il se décharge donc deux fois moins pendant l'oscillation !). On pourrait faire mieux, mais il faudrait alors augmenter la capacité (ce qui compromettrait très fortement le temps de chute, alors qu'on est déjà limite), ou diminuer la résistance **R1** afin d'augmenter le courant de charge - mais cela nous sortirait de la spécification d'EDF, ce qui nous enverrait probablement directement en prison après le départ de feu à notre compteur ! 

Pour améliorer le temps de chute, on peut jouer sur la valeur de **R2**, mais on assiste alors (je vous laisse jouer avec Spice) à un phénomène de _vases communicants_ : le passage à 0 est plus rapide si on diminue R2, mais l'ondulation résiduelle à 1 devient très importante.
La valeur de R2 est contrainte par la sécurité de l'optocoupleur, qui nous impose dans la datasheet un courant maximal correspondant à une résistance d'au moins 270 Ohm. J'ai choisi 2.2 kOhm.

## Achat des fournitures

- diode 1N4148, vendue par 10 sur ebay à environ 1EUR (le montage en nécessite une seule, mais autant en utiliser 4 et faire un redressement double alternance)
- optocoupleur PC817, vendu par 10 sur ebay à environ 1EUR (un seul est nécessaire et nous n'en mettrons pas quatre)
- résistances 0.25W classiques (900 Ohm, 2.2 kOhm, 47 kOhm), à acheter dans un assortiment tel que <http://dx.com/p/1-4w-resistance-metal-film-resistors-400-piece-pack-121339>
- un condensateur de 22nF, j'ai pris un _ceramic disc_ sur eBay à environ 1EUR les 10 (vous commencez à connaître le refrain)
- (optionnel) une mini breadboard pour un premier montage (<http://dx.com/p/mini-prototype-printed-circuit-board-breadboard-white-140716>, <http://dx.com/p/breadboard-jumper-wires-for-electronic-diy-65-cable-pack-118826>, <http://dx.com/p/male-to-female-dupont-breadboard-jumper-wires-for-arduino-40-piece-pack-20cm-length-146935>)
- un petit PCB proto pour mettre le montage au propre <http://dx.com/p/pcb-prototype-blank-pcb-2-layers-double-side-3-x-7cm-protoboard-green-140924>
- une boîte de biscuits en carton, des ciseaux et du scotch pour faire un boîtier moche **ou** un boîtier plastique qui vous coûtera plus cher que tous les composants réunis

## Assemblage et branchement

J'ai réalisé un premier prototype sur platine d'essai (_breadboard_). Le fonctionnement m'ayant donné satisfaction j'ai décidé de réaliser un assemblage plus propre sur un PCB proto, que j'ai ensuite placé dans un écrin en carton-de-paquet-de-biscuits.

<a href="data/teleinfo/montage_final.jpg" title="Montage final en écrin carton"><img src="data/teleinfo/montage_final-thumb.jpg" /></a>

Note : les connexions sont faites avec des _jumper wires_ que j'ai soudés. En effet ce type de PCB dispose de pastilles mais pas de pistes pré-tracées, et je me suis rendu compte que les connexions sont finalement assez difficiles à faire. Je préfère travailler avec une [Veroboard](https://en.wikipedia.org/wiki/Veroboard).


# Intégration logicielle

Si tout est bon matériellement, le Pi recevra sur son port série un signal qu'il est capable de comprendre.
Il faut tout de même:

1. s'assurer qu'aucun programme (par exemple un **getty** pour la console série) n'écoute sur le port série
1. configurer le port en **1200 baud**, **7/E/1** (7 bits de données, 1 bit de parité paire, 1 bit de stop)
1. lancer un programme pour écouter sur le port série
1. créer des tableaux, des graphes, présenter tout dans une application web, ...

Je couvrirai le dernier point dans un article séparé, qui concernera l'électricité mais aussi le gaz.

Mon Raspberry Pi fonctionne avec la distribution Arch Linux, et voici le script que j'utilise :
~~~ bash
systemctl stop serial-getty@ttyAMA0.service
./ti_cat | egrep '^(PAPP|BASE)' -a --line-buffered | ./cksum | ../data/report_to_hm_web.sh
~~~

La deuxième ligne n'est pas l'expression la plus simple. 

- Le programme ``ti_cat`` est une version très allégée d'un programme de teleinfo réalisé par quelqu'un d'autre, celui-ci se contente d'écrire tout ce qu'il reçoit du port série, après l'avoir configuré correctement. ``cat`` n'est malheureusement pas suffisant opur cela.
- Le grep filtre les seuls éléments qui m'intéressent, qui sont la puissance apparente et l'indice du compteur. Peut-être certains autres vous intéresseront-ils en particulier pour les abonnements HP/HC. 
- ``cksum`` est un programme qui calcule les checksums tels que spécifiés par EDF, et, comme son nom ne l'indique pas, accumule les valeurs pour calculer une moyenne de puissance sur une minute. En effet la plupart des programmes tels que ``teleinfofs`` fournissent, lorsque vous les interrogez, la valeur *instantanée* de la puissance apparente, alors qu'il est plus correct de faire la moyenne depuis la dernière requête, ce que fait cksum.

Au final, on obtient, chaque minute, l'indice du compteur, ainsi que la puissance apparente. Rigoureusement l'intégrale de la puissance apparente doit nous permettre de retrouver l'indice, mais cela simplifie les calculs de coût par jour d'avoir l'indice sous la main (le calcul devient dès lors une simple soustraction).

Ces programmes sont disponibles sur Github : <https://github.com/sven337/home-monitoring-client> dans le répertoire **edf**. Les autres programmes seront couverts dans les articles suivants, parfois en anglais. Si vous ne parlez pas anglais et qu'un article vous intéresse, je ferai la traduction sur demande. Mon objectif est de décrire en français ce qui concerne uniquement notre brave patrie, et en anglais ce qui peut intéresser une plus large audience.

# Graphes

Je traiterai cela plus en détail dans un prochain article, mais voici quand même un _teaser_:

## Graphe RRD
<a href="data/teleinfo/teleinfo_rrd.png" title="Graphe de consommation RRD sur une semaine"><img src="data/teleinfo/teleinfo_rrd-thumb.png" /></a>

On voit ici plusieurs informations intéressantes, mais c'est à grosse maille. J'ai beaucoup cuisiné vendredi soir, et on peut voir que le four et les plaques à induction étaient allumés en même temps car j'ai consommé une puissance importante. On voit également assez facilement que, contrairement à mon habitude, j'ai cuisiné le mardi midi en plus du soir (je ne me souviens pas de ce que j'ai mangé et cela n'est pas sur le graphe).
Le trou mercredi correspond à la désactivation temporaire du système de reporting afin de prendre les photos qui sont présentes sur cette page. (Ce n'est d'ailleurs pas une grande réussite).

Le total de puissance et le coût correspondant sont calculés par RRD avec le script ``rrd_render_graphs.sh``.

## Graphe Javascript
<a href="data/teleinfo/teleinfo_jsgraph.jpg" title="Graphe de consommation sur la journée"><img src="data/teleinfo/teleinfo_jsgraph-thumb.jpg" /></a>

Ce graphe est interactif, en Javascript, et créé à partir des mêmes données. Sur la capture que je montre ce sont les données sur une journée. On visualise entre 1h et 2h du matin l'activation du compresseur du réfrigérateur, puis à nouveau de 4h à 5h. Je me suis levé vers 8h50 et j'ai allumé mon ordinateur. Un peu avant 12h on observe la courbe caractéristique (parce que j'ai l'habitude de la voir) de la plaque à induction utilisée pour faire chauffer de l'eau : en mode _booster_ pendant quelques minutes à 3.2kW, puis à 1.75kW pendant le temps de cuisson de ce qui était (je m'en souviens) des pâtes.
On a ensuite la bouilloire électrique, l'aspirateur, et le sèche-cheveux, le tout pour une consommation en régime permanent d'environ 300W (informatique, réfrigérateur, VMC) en journée, et 600W le soir (éclairage à _économie de gaz naturel_, je veux dire, éclairage incandescent).


<script>
    $(document).ready(function() {
		$("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>

