---
layout: post
title: Éclairage automatique d'étagères
date: 2015-01-25 18:04:41
tags: electronics lighting
category: francais
comments: true
img_rel: "/~sven337/data/shelves"
---

Mon cellier avait besoin d'étagères. J'ai fait le choix, risqué, d'un produit ÀPasCher(TM) chez Leroy Merlin. Il s'agit de [ce modèle](http://www.leroymerlin.fr/v3/p/produits/etagere-avasco-racky-en-acier-epoxy-blanc-l75xh150xp30cm-e62980), à 10EUR. J'en ai acheté 3. J'ai ensuite amélioré ces étagères en rajoutant un système d'éclairage automatique, à détection de présence, qui permet non seulement d'éclairer le contenu des étagères mais aussi l'ensemble de la pièce. Cet article explique ma réalisation.


# Une étagère à 10 euros

![Étagère Leroy Merlin](etagere-avasco-racky-en-acier-epoxy-blanc-l75xh150xp30cm.jpg)
Ne vous laissez pas impressionner par les commentaires sur le site, cette étagère fait ce qu'on lui demande. Évidemment elle n'est pas très solide, mais en la montant correctement (c'est-à-dire en serrant les boulons **progressivement** et **après** les avoir tous placés, comme toujours pour monter un meuble en tôle fine) elle fait ce que j'en attends. Je ne pense pas qu'elle soit appropriée pour des charges importantes. La spécification annonce 50Kg par tablette, c'est très optimiste. En pratique je ne me risquerais pas au delà de 25Kg, ce qui est déjà bien suffisant pour la plupart des usages.

Au-delà du coût, les trois avantages majeurs de cette étagère sont :

- finition blanc brillant (qui reflète donc très bien la lumière)
- présence d'un repli sous chaque tablette dont la largeur correspond exactement à celle d'un bandeau de LED 3528 !
- tablettes fabriquées avec une seule plaque de tôle pliée, laissant des petits trous aux angles permettant de passer des fils

# Choix des composants

## Bandeau

On va acheter un bandeau de LED 3528, à une seule couleur, de type "warm white" (blanc chaud). Sous chacune des tablettes de chaque étagère (à l'exception de celle du bas, à moins que vous ne souhaitiez éclairer votre sol pour mettre la poussière en évidence !), on placera une longueur de LED (environ 70 cm) sur le repli de tôle qui semble prévu pour.

### Type waterproof

Je conseille fortement de choisir un bandeau de type "waterproof" IP65. Ce type de bandeau est recouvert d'une protection en silicone. Il n'est absolument pas étanche (l'appellation *waterproof* est donc trompeuse), mais au moins vous pourrez le nettoyer avec une éponge humide. (Pour une utilisation immergée ce sont des bandeaux IP67 ou IP68 qu'il faut, qui sont intégralement **enrobés** dans une résine et non simplement **recouverts**.) Voir [ici](http://www.bestledstriplights.com/waterproof-vs-non-waterproof) pour les détails, je reproduis ci-dessous une de leurs images.
![Types de bandeaux "waterproof"](http://www.bestledstriplights.com/wp-content/uploads/2014/10/waterproof-types.jpg)

L'intérêt des bandeaux IP65 est que, dans ma maigre expérience, ils sont de meilleure qualité que les bandeaux IP60 (non waterproof). De plus, la surface siliconée des IP65 les rend plus faciles à nettoyer, et évite les court-circuits accidentels qui détruiraient immédiatement l'électronique de contrôle (ou pourraient causer un incendie). Par conséquent même pour un usage au sec, je préfère dépenser un peu plus et acheter un bandeau IP65.

### Dimension

Il existe deux principaux types de bandeaux, ceux à LED 5050 et ceux à LED 3528. Les 3528 éclairent moins, mais ils font 8mm de large, alors que les 5050 font 10mm. Le repli sur les tablettes fait 8mm, donc on choisira du 3528. J'ai constaté après assemblage que la puissance d'éclairage était largement suffisante avec des LED 3528 de toute façon.

### Commande

J'ai commandé [2 rouleaux de 5 mètres](http://www.ebay.com/itm/400542008436) sur eBay. 

Prix : environ 24EUR.

## Alimentation

Ces bandeaux s'alimentent en **12V** et sont annoncés pour consommer environ **0.4A** par mètre. Pour chaque étagère on aura $$ 3 * 0.7 = 2.1m $$ de bandeau, c'est-à-dire une consommation de $$ 2.1 * 0.4 = 0.84A $$ par étagère. Pour mes trois étagères, cela fait une puissance totale inférieure à **3A**, mais j'ai branché une alimentation **7A** car je me suis trompé dans mes calculs lors de la commande :) 
De toute façon, en achetant du matériel chinois, il n'est jamais trop prudent de surdimensionner très largement les composants. En effet la spécification est rarement réaliste, et mon alimentation vendue pour *7A* ne les tient certainement pas, vu son poids et sa taille.

J'ai commandé [cette alimentation](http://www.ebay.com/itm/261704378838) sur eBay, mais je ne vous conseille pas d'acheter la même. Préférez plutôt [celle-là](http://www.aliexpress.com/item/12V-6A-72W-AC-DC-Power-Adapter-Supply-Charger-for-3528-5050-RGB-LED-Strip-Light/587961982.html), à adapter bien sûr en fonction de votre besoin en puissance. 

Prix : environ 15EUR.

## Capteur de présence

Si vous avez lu [mes](/~sven337/english/2014/03/30/Automatic_lighting_in_bathroom.html#pyro-electric-sensor) [articles](/~sven337/francais/2014/08/03/Detection-de-presence-pour-eclairage-a-LED.html#dtection-de-prsence) [précédents](/~sven337/francais/2014/11/04/Eclairage-decoratif-LED-avec-detection-presence.html#choix-du-matriel) vous savez que j'affectionne tout particulièrement [un modèle précis](http://www.ebay.com/itm/400330055400) de capteur, à la fois efficace et pas cher.
Celui-ci commandera l'allumage des LED à travers un transistor.

Prix : environ 2EUR.

## Transistor de puissance

Si on branchait directement les bandeaux sur l'alimentation, ceux-ci seraient éclairés en permanence. On préfèrera n'allumer les LED que quand une personne entre dans la pièce de stockage. Le capteur de présence donnera un signal lorsqu'une personne passe devant, mais il n'est pas assez puissant pour alimenter les LED directement. Il faut donc faire intervenir un transistor de puissance, et le dimensionner correctement.
On cherchera un transistor "logic level", c'est-à-dire dont la tension de seuil est d'environ **3.3V**. Ce transistor devra être capable de supporter 12V (c'est à peu près toujours le cas), mais surtout de pouvoir faire circuler les courants considérés. Dans le cas présent on parle d'environ **5A** : la plupart des transistors qui ne sont pas dans des formats minuscules (type transistors SMD) supportent théoriquement des courants de cet ordre de grandeur, mais attention à l'aspect thermique. Un transistor doit être refroidi. Pour éviter de trop s'embêter il est préférable de choisir un transistor dans un grand *package*, par exemple un TO-220. Du simple fait de sa taille, la dissipation thermique sera naturellement suffisante pour faire circuler quelques ampères sans difficulté, et au pire on pourra toujours rajouter un petit radiateur.

J'ai donc fait le choix d'un transistor [STP16NF06](http://www.st.com/web/en/resource/technical/document/datasheet/CD00002501.pdf) acheté [ici](http://www.ebay.com/itm/310725334401). Ils sont largement surdimensionnés, ce qui me garantissait la tranquilité d'esprit.

Finalement, j'ai préféré réutiliser un [FDD8447](http://www.farnell.com/datasheets/695790.pdf) (acheté [ici](http://www.aliexpress.com/item/FDD8447L-FDD8444-TO252-new-original-spot-Double-Crown-store/1372672839.html)) qui me restait d'un [précédent projet](/~sven337/francais/2014/06/15/Mon-ecran-plat-est-en-panne--Comment-le-reparer-.html) (la télévision en photographie dans cet article n'a finalement pas été réparée). 
Le format D-PAK de ce transistor en fait un composant de surface, ce qui m'arrangeait bien pour la réalisation (l'écartement entre ses pattes étant compatible avec la [veroboard](https://en.wikipedia.org/wiki/Veroboard) que j'utilise), et ses caractéristiques électriques et thermiques étaient compatibles avec le projet.

Prix : environ 3EUR.

## Fils de connexion

Pour relier les étages de LED entre eux, il va falloir mettre des fils. Ceux-ci doivent-être capables de transporter un courant suffisant sans surchauffer, il est important de ne pas les sous-dimensionner.
Les fils qui relient la tablette du bas (sous laquelle se situera l'alimentation) à celle du dessus vont transporter les courants correspondant à 3 tablettes, c'est-à-dire un peu moins de **1A** d'après nos calculs. C'est une valeur plutôt faible.
Le problème est qu'on ne peut pas choisir des câbles arbitrairement gros : il faut qu'ils passent dans les "trous" (créés par le pliage de la tôle lors de la fabrication) aux coins des tablettes. Ces trous font environ 2.5mm de diamètre, donc il faudra des câbles de moins de 1.25mm de diamètre.
J'ai acheté du [câble blanc](http://www.ebay.com/itm/111278677076) (pour plus de discrétion), avec conducteurs 28AWG, qui peut transporter le courant désiré sans problème sur des courtes distances.

Prix : environ 2EUR.

# Réalisation : électronique

Je n'ai malheureusement pas photographié le petit circuit de connexion que j'ai réalisé. Il s'agit simplement de relier entre eux une prise "jack" femelle compatible avec l'alimentation choisie, le transistor, le détecteur de présence, et deux fils de sortie "puissance" pour le bandeau de LED. 
J'ai fixé mon montage sur une plaque de plastique afin d'assurer l'isolation, et j'ai scotché (...) le circuit sous la tablette du bas d'une des étagères.
Rien de très compliqué si vous avez un peu d'expérience.

# Réalisation : installation sur l'étagère

## Préparation des bandeaux
L'installation sur l'étagère est conceptuellement très simple mais prend pas mal de temps, essentiellement au niveau de la préparation des fils et des bandeaux. De plus, j'ai choisi de réaliser les connexions par des "dominos". En effet j'avais acheté des connecteurs spéciaux (de [ce type](http://www.lightingxy.co.uk/led-accessories/led-strip-connectors/t-shape-2-pads-single-colour-solderless-connector-for-3528-5050-smd-led-strip-for-1-39.html)), mais ils ne font pas l'affaire pour plusieurs raisons, à commencer par leur incompatibilité avec mes bandeaux de LED.
![Connecteur incompatible - fermeture écrase la LED](bad_connector.jpg)
![Domino avec adhésif double face](domino.jpg)

Sur chaque bandeau de LED j'ai donc soudé une courte longueur de fil, noyé la soudure dans de la colle à chaud afin d'améliorer la résistance mécanique et d'isoler (car un court-circuit serait dangereux), et repéré le '+' avec un peu d'adhésif rouge (à l'extrémité du fil).

Le bandeau est ensuite collé sur le repli sous la tablette, les LED sont dirigées vers le haut (et la peinture blanche brillante prend tout son intérêt, permettant un éclairage indirect de grande qualité).

![Bandeau pour tablette supérieure](mounting_top_strip.jpg)

## Raccords

Le concept est le suivant : chaque bandeau sera connecté à un domino, qui verra arriver les fils de l'étage supérieur, et les fils de l'étage inférieur.
En photo :
![Installation en cours](mounting_middle.jpg)
![Raccords terminés pour cet étage](mounting_middle_done.jpg)

À l'étage du haut, on ne met pas de domino, car il n'y a pas d'étage au dessus : les fils de connexion sont plus longs et descendent directement à l'étage en dessous.

![Fils étage du haut](mounting_top.jpg)

## Installation finale

Les étagères sont connectées entre elles avec des fils de plus gros diamètre (car les longueurs de raccords sont importantes, surtout entre l'étagère qui est située à droite dans ma pièce et les deux autres), avec encore une fois des dominos. Le capteur de présence est placé au niveau du sol, il détectera nos jambes (et cela fonctionne !).

On constate, et c'est visible sur les photographies suivantes prises sans autre éclairage que celui des bandeaux, que la puissance d'éclairage permet de se dispenser du plafonnier de la pièce.

![Montage final, côté gauche](final_left.jpg)
![Montage final, côté droit](final_right.jpg)
![Éclairage indirect](mounted_top.jpg)

Après montage, les fils sont maintenus invisibles (sauf depuis l'intérieur de l'étagère) :
![Fils cachés](mounted_middle.jpg)

Il reste un petit défaut, indiqué en rouge sur la photo suivante : selon l'angle de vue, on peut se retrouver avec une LED qui émet directement dans l'oeil de l'utilisateur, ce qui est désagréable. J'ai réglé le problème en masquant les trous concernés par un peu de papier blanc.
En vert, la position du capteur de présence, très discret et néanmoins fonctionnel.

![Éblouissement en rouge, capteur de présence en vert](final_left2.jpg)


<script>
    $(document).ready(function() {
		$("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>
<script type="text/javascript" src="//cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

