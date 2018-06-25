---
layout: post
title: Détection de présence pour éclairage à LED
date: 2014-08-03 20:04:50
tags: electronics lighting
category: francais
comments: true
img_rel: ""
---

<script type="text/javascript" src="//cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

Cet article vise à expliquer théoriquement comment rajouter une détection de présence à un système d'éclairage à LED. Je l'écris pour un ami, sans avoir réalisé tous les montages que je vais décrire. N'hésitez pas à me rapporter d'éventuelles erreurs, ou les détails de votre réalisation.

# Objectif

On suppose une pièce éclairée par un ruban de LED 12V. Ce type d'installation devient à la mode : c'est plutôt joli, peu coûteux, et la qualité de lumière est acceptable, surtout depuis que les lampes à incandescence sont interdites en Union Européenne car c'est cela qui va sauver la planète, oui-je-suis-parti-en-Guadeloupe-à-Noël-dernier-mais-j'ai-mis-des-lampes-à-économie-d-énergie.

L'objectif de cet article est d'améliorer le montage typique d'éclairage à ruban de LED, pour y rajouter une détection de présence qui sera très pratique dans un couloir, une pièce de stockage, ... et de manière générale toute pièce aveugle. Référez-vous à mon [premier article sur la détection de présence](/~sven337/english/2014/03/30/Automatic_lighting_in_bathroom.html), en anglais, pour plus de détails sur les choix techniques dans la détection de présence. Je ne reviens pas dessus.

# Situation de départ

Le montage de départ est le suivant : un ruban de LED d'une seule couleur (à deux fils, un + et un -) alimentée à environ 1 ampère/mètre sous 12V par une alimentation à découpage ÀPasCher(TM) reliée au secteur. Cette alimentation est reliée à une prise commandée par un interrupteur : lorsque l'utilisateur rentre dans la pièce, il ferme l'interrupteur, ce qui active l'alimentation, qui fait s'éclairer les LED.

# Détection de présence

On réalisera la détection de présence avec un détecteur à infrarouge passif ÀPasCher(TM) acheté sur eBay : <http://www.ebay.com/itm/400330055400>.
Ce détecteur doit être alimenté par 3.3...12V DC, et a une sortie binaire : 1 = présence detectée, 0 = pas de présence détectée.

# Commutation

## Dans l'alimentation

J'en parle en premier afin d'évacuer le sujet rapidement. Il est courant que les contrôleurs PWM des alimentations disposent d'une patte "on/off" activable avec un niveau logique compatible avec celui du détecteur choisi. 
Toutefois, ce n'est pas évident que le modèle précis de votre alimentation ait une telle patte, et même si le contrôleur en avait une il faudrait aller y souder un fil. Cela peut-être compliqué.
Mais le vrai problème est la **sécurité**. Le contrôleur est situé au primaire de l'alimentation, c'est-à-dire pour une alimentation secteur du côté du 230V AC. Si on s'amuse à interfacer un capteur avec le primaire de l'alimentation, on perd l'isolation galvanique qui est une propriété fondamentale d'une alimentation secteur : théoriquement le montage va fonctionner sans tuer son utilisateur, mais au moindre problème, on court le risque de voir du 230V AC se promener dans le capteur, et donc à la sortie, tuant à la fois l'électronique en sortie (de manière spectaculaire), et, pourquoi pas, l'utilisateur.
Pour réaliser le montage correctement il faut rajouter un optocoupleur (c'est comme ça que fonctionnent les alimentations avec standby qu'on trouve par exemple dans les télévisions ou les ordinateurs), mais cela devient compliqué à faire.

Oublions donc cette idée qui avait pour elle l'avantage de l'élégance.

## En AC à l'entrée

L'idée la plus simple, c'est de remplacer (ou de compléter) l'interrupteur physique par un interrupteur électronique commandé par le capteur. 
Il y a deux méthodes pour commuter une tension "secteur" en toute sécurité : 

1. un relais électromécanique
1. un relais à semiconducteurs

Voir la [section correspondante](/~sven337/english/2014/03/30/Automatic_lighting_in_bathroom.html#turn-on-the-light) dans mon précédent article.

Le relais électromécanique coûte cher, nécessite une diode supplémentaire, et un courant assez important pour le maintenir en "on" : pas forcément une super idée.
Le relais à semiconducteurs coûte cher, est assez gros, et nécessite un courant *un peu moins* important [...].
Dans les deux cas le courant nécessaire pour commuter le relais est trop important pour le modèle de capteur que j'ai retenu, donc il faudra rajouter un transistor.

Cette solution est intéressante mais nécessite de faire attention lors du branchement et de la "mise en boîte", car le montage va manipuler les tensions importantes. Il faut impérativement couper l'électricité au compteur avant de toucher à l'installation, et s'assurer d'avoir correctement sécurisé les composants et les câblages.

Le type de relais importe peu, et le choix de cette solution dépend principalement de vos contraintes spécifiques pour l'intégration. De manière générale je pense que la commutation AC demande de faire plus attention (sécurité), donc l'intégration est plus compliquée, donc ce n'est pas la solution que je retiendrais.

## En DC à la sortie

L'autre possibilité est de faire la commutation au niveau de la **sortie** de l'alimentation, c'est-à-dire rajouter un transistor qui va "couper l'électricité" aux LED sauf lorsque le capteur le rend passant.

Par rapport à la solution "AC", voici les avantages :

- pas de question de sécurité lors du montage et en utilisation
- volume plus faible
- coût plus faible
- pas de courant de "holding", donc pas de transistor supplémentaire à rajouter
- câblage plus simple

Et les inconvénients :

- le transistor va chauffer, donc il faut un radiateur
- difficile de s'y retrouver parmi les centaines de milliers de transistors sur le marché

### Ennuis thermiques

Cette solution a bien sûr ma faveur, toutefois il faut faire vraiment attention à l'aspect thermique. Faire passer 6A dans un transistor ne pose aucune espèce de problème à condition que celui-ci soit pourvu d'un radiateur. Celui-ci n'a pas besoin d'être énorme, mais sa présence est indispensable sous peine de détruire le transistor et de créer un danger d'incendie. Les vrais ingénieurs en électronique dimensionnent leurs radiateurs par le calcul théorique. Ce n'est pas difficile à faire, mais superflu pour un projet de ce genre. Il suffit d'acheter un radiateur conçu pour le format de transistor retenu (TO-220 par exemple), de le monter, et de mettre les doigts dessus pour voir s'il chauffe trop. Pour mémoire, vous commencez à vous brûler les doigts aux alentours de 50°C, et un transistor peut fonctionner sans problème jusqu'à 90°C voire 105°C. 

Notons également que ce genre de système d'éclairage est plutôt conçu pour les pièces de passage, et non pour les pièces de vie : la lumière reste rarement allumée plus de quelques minutes ! Par conséquent le transistor ne sera passant que pendant quelques minutes à chaque fois, et n'aura pas trop le temps de chauffer.

### Choix du transistor

Il existe pratiquement autant de modèles de transistors que d'êtres humains sur Terre, mais le choix est assez simple.
D'abord, on va se restreindre à ceux qu'on peut [acheter facilement](/~sven337/francais/2014/06/02/Acheter-des-composants-electroniques-sur-Internet.html), ce qui réduit énormément la liste.
On cherche un transistor de puissance, c'est-à-dire un transistor qui fait passer de gros (> 1A) courants, et dans un package suffisamment volumineux pour ne pas avoir de problème de dissipation thermique.

Nos critères sont les suivants :

- courant nominal > 6A (en supposant 5 mètres de ruban à 1.2A/m), le plus grand est le mieux
- tension de claquage >= 16V (en supposant qu'on alimente en 12V, en prenant une marge de sécurité)
- gate en "logic level" c-à-d tension de seuil < 3.3V (sinon le capteur n'imposera pas une tension assez grande pour commuter le transistor)

En [trois secondes sur eBay](http://www.ebay.com/itm/5x-IRLZ44N-PBF-MOSFET-N-Channel-Logic-Level-41A-55V-0-022OHM-TO-220-IRLZ34NL-/121129875333?pt=LH_DefaultDomain_0&hash=item1c33e73785), je trouve des transistors qui ont l'air de faire parfaitement l'affaire (il est possible de les brancher en parallèle - correctement - pour diminuer le stress thermique ou faire passer des courants plus grands, à noter que les 47A nominaux de ce transistor ne sont atteignables qu'avec un *gros* radiateur, et si vous commutez 47A d'éclairage vous avez probablement mal conçu votre solution).

Pour les radiateurs, c'est un peu plus compliqué car il y en a plein et j'ignore quelle taille prendre. J'aurais tendance à choisir un modèle [de ce genre](http://www.ebay.com/itm/Lots-10-Heatsink-Heat-Sink-With-Screw-Sets-For-TO-220-/310317074587?pt=US_CPU_Fans_Heatsinks&hash=item484056c89b).

# Réalisation en commutation DC

On va "couper" la sortie de l'alimentation pour rajouter un transistor. Cela peut se faire sur le + ou sur le -, mais le choix n'est pas indifférent ! Avec un transistor de type N (le plus courant), il faut obligatoirement placer le transistor sur le - de telle sorte que sa patte "source" soit reliée au - de l'alimentation (la gate sera reliée à la sortie du capteur, et le drain sera relié au retour du - des LED). Cet article est bien assez long donc je n'explique pas pourquoi c'est ainsi.
