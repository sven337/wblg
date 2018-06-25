---
layout: post
title: Éclairage d'escalier à LED avec détection de présence
date: 2014-11-04 13:06:25
tags: electronics lighting
category: francais
comments: true
img_rel: "/~sven337/data/stairs"
---

<script type="text/javascript" src="//cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

Dans un [article précédent](/~sven337/francais/2014/08/03/Detection-de-presence-pour-eclairage-a-LED.html) j'abordais la détection de présence pour un éclairage monochrome et tout ou rien.
Je présente ici un montage plus complexe que j'ai réalisé et installé dans mon escalier. Il s'agit d'un éclairage d'ambiance (et de sécurité), en couleurs, relié à un détecteur de présence.

# Objectifs

On souhaite automatiser l'éclairage d'un escalier (ou couloir) tout en fournissant un effet lumineux plaisant. Le cahier des charges est le suivant :

- allumage automatique sur détection de présence
- puissance d'éclairage suffisante pour ne pas avoir besoin d'utiliser une autre source lumineuse
- possibilité de projeter plusieurs couleurs et de faire des fondus ("fade") entre elles
- bonne esthétique du montage
- coût réduit

# Choix du matériel

Comme d'habitude pour la détection de présence, j'utilise un PIR (**détecteur passif à infrarouge**) *ÀPasCher(TM)* [acheté sur eBay](http://www.ebay.com/itm/400330055400). Ce détecteur est très sensible, ne coûte presque rien, et est très facile à interfacer avec une électronique de contrôle quelle qu'elle soit.

Afin d'obtenir un bel effet lumineux, uniforme sur la longueur à éclairer, le choix d'un **ruban à LEDs** RGB est naturel. J'ai choisi un ruban de LED SMD en 5050 (vendu pour 1,2A/m, même si en réalité la puissance est plus faible). Ces rubans sont contrôlables par des MOS à canal N : ils exposent un pin +, un R, un G, et un B. Dans ma réalisation j'utilise 3 mètres de ruban le long de mon escalier, et la puissance d'éclairage est suffisante pour bien voir les marches et ne plus avoir besoin de l'ampoule au plafond.

Pour réaliser l'effet lumineux en lui même, il faudra des **transistors de puissance**, contrôlés par une plateforme qui permet une **sortie "analogique"** PWM (pour la gradation lumineuse). J'ai choisi d'utiliser une plateforme compatible **Arduino**, dont la simplicité de programmation et le bas coût ne sont plus à démontrer. Au lieu d'installer moi même les transistors, j'ai fait le choix d'un module tout intégré dénommé [**LEDNode**](http://www.digitalsmarties.net/products/led-node-v2), conçu par la même personne qui a créé le **[JeeNode](http://www.digitalsmarties.net/products/jeenode)** que j'utilise dans mes montages sur piles. Le prix du LEDNode est assez prohibitif, et si le montage était à refaire j'achèterais moi-même les transistors de puissance. 

Il faudra prévoir une **alimentation en 12VDC** capable de fournir la puissance demandée par les LED. J'ai choisi une 6A, valeur ajustable à la baisse selon la longueur (et consommation réelle) du ruban, en prenant en compte que la durée d'allumage sera de toute façon très courte. Néanmoins les alimentations chinoises sont connues pour être étiquettées trompeusement, donc il est utile de prendre un peu de marge.

## Coût

{:.CSSTableGenerator}
| Élément | Lien | Coût |
| LED Node | <http://www.digitalsmarties.net/products/led-node-v2> | 27.50EUR |
| Ruban LED | [AliExpress](http://www.aliexpress.com/item/Best-13-02-5m-5m-300LED-IP65-waterproof-12V-SMD-5050-white-cold-white-warm/725423136.html) | 11.01EUR| 
| Alimentation | [AliExpress (un peu cher)](http://www.aliexpress.com/item/12V-6A-72W-AC-DC-Power-Adapter-Supply-Charger-for-3528-5050-RGB-LED-Strip-Light/587961982.html) | 11.70EUR | 
| Détecteur de présence | [eBay](http://www.ebay.com/itm/400330055400)| 1.51EUR | 
||||
| Total || **51.47EUR** |

Je pense qu'on pourrait diviser les coûts par deux en utilisant un clone d'Arduino, des transistors de puissance peu chers, et une alimentation moins chère.

# Réalisation


## Connexions 

Le ruban à LED se connecte directement au LEDNode avec des pins au format standard. Par contre, ce n'est pas souhaitable d'avoir l'électronique de puissance physiquement proche du ruban à LED, pour des raisons d'esthétique&nbsp;: en effet le ruban est nécessairement à un endroit où il sera **visible** (même indirectement), alors qu'on souhaite que l'électronique de la solution soit invisible. J'ai donc fabriqué une **rallonge** de 2 mètres avec du câble que j'avais. Attention à utiliser des conducteurs suffisants pour transporter les courants importants qui vont circuler.
Le détecteur de présence sera placé de telle sorte que sa lentille de Fresnel puisse détecter correctement les gens. Ce détecteur a deux réglages : un potentiomètre pour la "portée", dont la valeur peut faire varier la qualité de la détection, et un potentiomètre pour le délai d'allumage, qu'il convient de régler sur une valeur assez faible. On se moque en réalité de cette durée, puisqu'elle sera **gérée par le microcontrôleur** et non le capteur, mais plus elle est importante plus le capteur mettra du temps à re-détecter un mouvement après avoir été enclenché. On reliera le détecteur sur un pin d'input du LEDNode.

## Programmation

Mon code est disponible sur [Github](https://github.com/sven337/jeenode/blob/master/stairs_light/stairs_light.ino). Quelques commentaires&nbsp;:

### Logique

Le principe général est le suivant : lorsque l'Atmega détecte que le capteur envoie un **1** (correspondant à une présence détectée), et qu'il n'est pas déjà en train d'exécuter une phase d'éclairage, le programme va démarrer la séquence d'éclairage, et prendre note de la "date" à laquelle la présence a été détectée.
Il allume également une LED de diagnostic dont la présence simplifiera la phase de debug. Ma femme m'a fait retirer cette LED une fois l'installation terminée.

La séquence d'éclairage est composée d'une série de "rampes" linéaires qui seront exécutées l'une après l'autre, sachant qu'au bout de 15 secondes le programme va déclencher la phase d'extinction et marquer la phase d'éclairage comme terminée (permettant l'allumage à la prochaine détection de présence).

### Système de "rampes"

Je n'ai pas inventé ce concept. Une rampe est définie par une couleur cible (RGB), un temps pour l'atteindre (en millisecondes), et une autre rampe à exécuter ensuite. L'exécution de cette rampe correspond à un fondu linéaire entre la couleur actuelle des LED et la couleur cible, sur la durée définie par la rampe.  Lorsque cette durée est atteinte, la rampe suivante est exécutée automatiquement. Si on ne souhaite pas changer de rampe, il suffit de la faire boucler sur elle-même pour maintenir la couleur.

La toute première rampe du programme est dénommée *OFF* et est un peu spéciale : elle vise le noir complet en une milliseconde. C'est celle qu'on pourra utiliser pour une extinction d'urgence (par exemple en cas de souci thermique). Mon programme ne s'en sert que comme rampe d'initialisation. (Je n'ai d'ailleurs pas mis de sécurité thermique, même si j'ai câblé une thermistance, vestige d'un montage précédent, car il n'y a aucun risque de surchauffe des transistors pour une durée d'allumage de quelques secondes par heure en moyenne.)

Je définis ensuite un certain nombre de rampes d'allumage (qui ont été modifiées plusieurs fois pour obtenir l'effet désiré), et la même chose pour l'exctinction. Le choix des rampes a été fait en famille afin d'obtenir les couleurs souhaitées. On désire un allumage franc (afin d'éclairer suffisamment les marches), et une extinction lente.

Voici les rampes pour l'allumage :

```C
	// delay, R, G, B, next
	{    1, 0.02, 0.01, 0   , 2 }, //RISE_START
	{  200, 0.15, 0   , 0.08, RISE_END },
	{ 1000, 1   , 0.35, 0.08, RISE_END }, // RISE_END
```

Soit en bon français : 

1. atteindre la couleur $$R = 0.02, G = 0.01, B = 0.00$$ en 1 milliseconde.
1. atteindre la couleur $$R = 0.15, G = 0.00, B = 0.08$$ en 200 millisecondes.
1. atteindre la couleur $$R = 1.00, G = 0.35, B = 0.08$$ en 1000 millisecondes, et maintenir cette couleur


Et pour l'extinction :

```C
	{ 1000, 0.15, 0, 0.13, 9 }, // FADEOUT_START
	{ 1000, 0.15, 0, 0.08, FADEOUT_END },
	{ 4000, 0   , 0, 0   , FADEOUT_END }, // FADEOUT_END
```

1. atteindre la couleur $$R = 0.15, G = 0.00, B = 0.13$$ en 1 seconde.
1. atteindre la couleur $$R = 0.15, G = 0.00, B = 0.08$$ en 1 seconde.
1. s'éteindre complètement, progressivement, en 4 secondes


### Arithmétique point fixe

Afin de calculer la bonne couleur à attribuer aux LED à un instant donné, on doit calculer lors du démarrage de la rampe le *delta* qui sera appliqué. Les valeurs des LED sont un entier sur 8 bits, donc avec 256 valeurs discrètes. À un pas de temps donné (qui dans mon programme correspond empiriquement à 11ms), les LED varieront en général d'une valeur inférieure à 1 : comment, dès lors, calculer la valeur à attribuer à chaque LED ?
Sur un ordinateur on utiliserait des nombres à point flottant, sur un Arduino pour des raisons de performance mais surtout de simplicité de programmation, l'arithmétique à point fixe est un meilleur choix.
Le concept est le suivant : on va calculer toutes les valeurs avec des nombres entiers, mais en multipliant celles-ci par 1000. Ainsi, on pourra représenter les nombres décimaux jusqu'à 3 chiffres après la virgule. Par exemple, si on souhaite additionner $$1 + 0.5 + 0.75$$, on va calculer $$1000 + 500 + 750 = 2250$$. **2250** est la représentation de la valeur **2.25**, qu'on n'aurait pas obtenue en travaillant uniquement sur les parties entières.
Bien sûr, les ordinateurs travaillent en base 2, donc on ne va pas multiplier par une puissance de 10, mais par une puissance de 2. Cela ne change rien au concept de base.
On passe de la valeur à sa représentation point fixe en décalant d'un certain nombre de bits vers la gauche (multiplication par **2^N**), et de la représentation point fixe à la valeur à envoyer aux LEDs en décalant du même nombre de bits vers la droite (division euclidienne par **2^N**):

```C
	#define I2F(I) (I << 20)
	#define F2I(F) (F >> 20)
```

### Correction de luminosité

Le signal envoyé par l'Arduino pour commander les LED est un PWM linéaire. Or, une variation linéaire du rapport cyclique ne se traduit pas par une variation linéaire de la luminosité perçue par l'être humain, et c'est très simple de s'en convaincre. En programmant une rampe de 0 à 255 sur plusieurs secondes, on voit très facilement que pour les faibles valeurs, les variations sont très perceptibles, alors que pour une luminosité plus élevée il faut varier beaucoup plus l'intensité pour percevoir une différence à l'oeil.
De manière générale, la sensation est le logarithme de la stimulation : il faut corriger les valeurs de PWM de telle sorte que nos rampes linéaires soient linéaires *du point de vue de l'humain*. On va donc corriger les valeurs pour leur faire suivre une courbe de forme exponentielle, ce qui *linéarisera* la rampe.
À noter que de nombreuses personnes sur Internet appliquent une correction gamma (basée sur une fonction puissance), ce qui me semble être incorrect mais que je n'ai pas creusé. De toute façon on ne recherche pas la perfection théorique, mais simplement à avoir une forme *un peu meilleure* qu'un simple PWM linéaire.

J'ai choisi la fonction exponentielle la plus simple qui associe l'intervalle $$[0;1]$$ à des valeurs dans $$[0;1]$$ :
$$
bri(in) = e^{\ln{2} * in} - 1
$$

$$in$$ représente la valeur de PWM linéaire, $$bri(in)$$ est la valeur corrigée à utiliser pour piloter les LED.

Voici le graphe de la fonction, avec une fonction linéaire pour comparer :

![Courbe de correction](bri_correction_1.jpg)

On constate que l'écart est assez faible avec une échelle linéaire, et les résultats ne sont d'ailleurs pas très convaincants. Il faudrait augmenter la courbure pour obtenir une meilleure correction.

[D'autres](http://jared.geek.nz/2013/feb/linear-led-pwm) [personnes](http://electronics.stackexchange.com/questions/1983/correcting-for-non-linear-brightness-in-leds-when-using-pwm) ont traité le problème différemment.

## Intégration

Ce projet a une dimension esthétique importante. Par "chance", mon propriétaire a mal installé son escalier et n'a pas réalisé les finitions qu'il aurait dû : il restait donc beaucoup de place sous l'escalier pour placer l'électronique, et j'ai utilisé un panneau de particules peint pour dissimuler le montage, avec un trou pour faire apparaître le détecteur. 
J'ai fait quelques photographies.

![Vue d'en haut](lit_top.jpg)
![Vue d'en haut (2)](lit_top2.jpg)
![Vue d'en bas](lit_bottom.jpg)
![Installation du ruban à LED](ledstrip_view.jpg)
![Connecteur du ruban à LED](ledstrip_connector.jpg)
![Capteur de présence](PIR.jpg)
![Électronique](elec_top.jpg)
![Vue de côté](lit_side.jpg)
![Extinction progressive 1](fade_side_1.jpg)
![Extinction progressive 2](fade_side_2.jpg)

Voir également [une vidéo](/~sven337/data/stairs/stairs_light.avi) sur laquelle la puissance d'éclairage semble très faible, en réalité il est assez puissant.

## Résultat

Le résultat est excellent et approuvé par la famille et les amis. Le positionnement du capteur m'a un peu inquiété au début mais il est suffisamment sensible pour détecter la présence à la montée comme à la descente. On s'habitue tellement vite à l'éclairage automatique qu'on souhaiterait l'avoir dans toute la maison !

<script>
    $(document).ready(function() {
		$("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>
