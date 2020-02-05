---
layout: post
title: Régulation de chauffage central avec une chaudière Acleis - prototype
date: 2015-11-06 23:38:31
tags: electronics
category: francais
comments: true
img_rel: "/~sven337/data/acleis"
disqus_comment_thread: Acleis1
---

Le logement dans lequel je viens d'emménager dispose d'un **chauffage central** au gaz avec une chaudière E.L.M. Leblanc Acleis de 2008. **Aucun thermostat** d'ambiance n'est présent, et il n'y a par ailleurs **pas de robinet thermostatique** sur les radiateurs : en d'autres termes il n'existe aucun des moyens raisonnablement modernes de contrôler la température du logement, et le choix est celui d'avoir trop chaud et de brûler trop de gaz, ou d'avoir trop froid.
En effet le seul réglage possible est celui de la température de départ de l'eau du chauffage, directement sur la chaudière.

Ce système archaïque ne me convient absolument pas, et j'ai décidé d'installer un thermostat d'ambiance... mais pourquoi payer pour acheter un système du commerce qui sera limité, alors que je pourrais contrôler la chaudière avec un ordinateur ?

# Découvrir ce qu'il est possible de faire avec cette chaudière

La décision a donc été prise de fabriquer mon propre thermostat d'ambiance. Première étape : lire le manuel de la chaudière et la démonter, pour savoir le type de montage qu'il faudra réaliser.

## Manuels techniques

Le manuel d'installation de la chaudière était fort heureusement présent dans le logement. L'image ci-dessous montre ce qu'il nous propose concernant l'installation d'un thermostat.

![Installation d'un thermostat : manuel](manuel_thermostat.jpg)

On voit qu'il existe plusieurs mécanismes. L'un correspond au type le plus courant, figure 25 sur le document ci-dessus : une **commutation en 230V AC**. Un deuxième mécanisme figure 24 nous propose une **commutation en 24V DC avec 3 fils**, sans plus d'information.

On trouve sur le Web des manuels techniques de la marque, pour des chaudières différentes, mais qui donnent plus d'information. Celui-ci, par exemple :
![Installation d'un thermostat : autre manuel](manuel_installation.jpg)

On identifie rapidement le connecteur ST12 qui est l'alimentation de la chaudière, **ST8** qui correspond au branchement figure 25, et **ST13** qui correspond au branchement figure 24 (utilisant les bornes 1 2 4, laissant les 9 et 8 avec leur strap). Ce document nous montre également un branchement utilisant les bornes 9 et 8 sur **ST13**, le cas 2', ce branchement n'étant pas documenté dans l'autre manuel.

On a donc au minimum 3 méthodes de branchement possibles. Ouvrons la chaudière pour repérer les connecteurs.

## Ouverture de la chaudière

![Panneau de connexion de la chaudière](panel_connectors.jpg)

Sur cette photo (dont la qualité laisse à désirer), j'ai repéré en **A** le connecteur **ST12** (alimentation), en **B** le connecteur **ST8** (commutation 230V AC, ici avec un strap car pas de thermostat), en **C** les trois bornes de **ST13** utilisées pour le branchement du cas 3', en **D** les deux bornes du cas 2', et en **E** le connecteur qui sert (je crois) au thermostat TA 211E auquel le manuel fait vaguement référence (et qui contrôle une vanne mélangeuse 3 voies, il me semble).

Plus en détail, voici le connecteur ST8, avec son strap :

![Connecteur ST8](panel_230V.jpg)

Et le ST13, avec un strap également sur les bornes 9 et 8 (ainsi que deux fils que j'utilisais pour mes tests) :

![Connecteur ST13](panel_24V.jpg)

## Comparaison des méthodes de raccord

### commutation ST8 (230V AC, circulateur)

Je pense que la commutation sur ST8 contrôle la **pompe de circulation** du chauffage. La chaudière maintient en permanence l'eau à la température réglée en façade, et l'eau ne circule que lorsque le thermostat fait le demande.
Cette commutation se fait en **230V AC**, et cela me posait problème pour une raison évidente de sécurité. En effet cela nécessite une isolation un peu sérieuse du montage électronique, et complique la mise au point car il faut débrancher avant toute manipulation.
De plus, c'est un système de type **tout ou rien** : soit le thermostat est en demande (et la chaudière va chauffer _à pleine puissance_), soit le thermostat n'est pas en demande et l'eau ne circule pas dans le circuit de chauffage.

C'est ce qui est en place **chez la plupart des gens** et ce système fonctionne plutôt pas mal, mais j'ai réalisé qu'on pouvait faire mieux.

### commutation ST13 broches 9 et 8 (24V DC, brûleur on/off)

Les broches 9 et 8 sont pontées sur ma chaudière. En enlevant le pont afin de faire un test, on constate que ces broches (en 24V DC, donc aucun danger à faire des manipulations sous tension) commandent le **brûleur** de la chaudière en **tout ou rien**. Même défaut que pour **ST8**, mais au moins on travaille en **basse tension**... sauf qu'il y a un énorme problème : l'eau chaude sanitaire n'a pas la priorité sur la commande, c'est-à-dire que si on branchait un thermostat sur ces broches 9 et 8, il n'y aurait d'eau chaude sanitaire que lorsque le thermostat est en demande de chauffage ! 
Il n'est pas surprenant, dès lors, que ce branchement ne soit pas documenté dans le manuel de la chaudière : il est en pratique **parfaitement inutilisable**.

### commutation ST13 broches 1 2 4 (24V DC, contrôle de débit du brûleur)

J'ai gardé le meilleur pour la fin. En lisant la documentation commerciale du thermostat TR200 prévu pour se brancher sur ces broches, on voit que E.L.M Leblanc parle d'une "régulation continue". Or, les méthodes avancées de régulation du chauffage ne fonctionnent pas en tout ou rien, mais en modulant de manière continue la température de l'eau du chauffage : eau plutôt pas très chaude (45-50°) quand il n'y a pas besoin de beaucoup chauffer, et eau très chaude (jusqu'à 90°) lorsque les locaux sont très froids. Voir par exemple [cette page](http://www.energieplus-lesite.be/index.php?id=10959) pour plus d'explications.

Il y avait donc de fortes chances que ces 3 broches permettent un contrôle continu de la température de l'eau. J'ai rapidement identifié que la broche **1 (+24V DC)** et **4 (GND)** servaient d'alimentation. J'ai ensuite prié pour ne rien casser, et j'ai branché la 2 sur la 1 puis sur la 4 (courant observé : 4mA) successivement. La chaudière n'a pas explosé, et j'ai constaté que ces opérations permettaient un fonctionnement **tout-ou-rien** du **brûleur** (mais cette fois-ci l'eau chaude sanitaire fonctionnait).

Cela n'avait rien d'évident : il y aurait pu avoir un **bus de communication** évolué avec "handshake" entre le microcontrôleur dans la chaudière et dans le thermostat. D'ailleurs je pense que les chaudières récentes fonctionnent comme cela, en tout cas c'est ce que moi je ferais pour éviter la concurrence sur les thermostats d'ambiance (produits dégageant sans nul doute de très fortes marges).

Bref, par chance, j'ai identifié comment faire fonctionner le chauffage en **tout-ou-rien** avec une commutation à **basse tension**, ce qui est déjà un très bon point.

En installant un potentiomètre j'ai ensuite observé que la tension sur la broche n°2 semblait piloter le **débit de gaz** du brûleur&nbsp;: à 6.5V ou moins (3kOhm), le chauffage est complètement coupé, aux alentours de 10V le débit de gaz est moyennement important, et à 21V et plus il est maximal.
J'ignore si cette tension commande la **température de consigne de l'eau** (ce que j'espère), ou bien sert seulement à moduler la **puissance du brûleur** (ce que je crains). Il est possible de réaliser quelques expériences pour le vérifier mais j'estime que ce n'est pas nécessaire dans cette première étape.
Il serait peut-être plus simple de démonter la carte électronique pour faire une vraie ingénierie inverse, mais je ne suis pas propriétaire de cette chaudière et c'est difficile d'étudier le programme d'un micro-contrôleur de toute façon.

Ce qui est important, c'est que nous savons que nous pouvons utiliser les broches 1 2 et 4 pour une commutation tout-ou-rien, et plus si affinités (régulation continue).

# Prototype

Maintenant il s'agit de réaliser un prototype de thermostat, basique, afin de prouver que le système fonctionne. L'objectif est d'avoir un montage relié à la chaudière, qui la contrôle en fonction des instructions qu'il reçoit de mon serveur de domotique (qui lui prendra sa décision en fonction de l'heure, de la température intérieure, de la température extérieure, ...). Ce serveur (une combinaison d'eeePC et de Raspberry Pi) fonctionne sous Linux en wifi, et dispose également d'une interface nRF24L01+. Ici on utilisera du wifi car le montage ne fonctionnera pas sur batterie, donc pas besoin de subir les contraintes du nRF24L01+ afin d'économiser de l'énergie.

## Microcontrôleur

L'**ESP8266** est un produit chinois qui est arrivé récemment sur le marché des bidouilleurs. Ce microcontrôleur est très bon marché (quelques euros), et dispose d'une interface **wifi** (y compris WPA). Il est, grâce au travail de la communauté et depuis 2015, compatible avec l'écosystème **Arduino**, ce qui simplifie la mise en oeuvre.

J'ai fait un travail d'ingénierie inverse sur le firmware de l'ESP8266, que je n'ai pour l'instant jamais publié, mais je ne m'en suis jusqu'à présent jamais servi pour un montage. Il faut bien commencer un jour !

## Alimentation

L'ESP8266 fonctionne en **3.3V** (en réalité, et bien que la documentation indique explicitement le contraire, il semble fonctionner correctement jusqu'à près de 5V). La chaudière, dans sa grande bonté, nous propose **24V**. C'est trop pour un régulateur linéaire, mais j'avais un petit module *buck* sous la main qui pouvait faire l'affaire. Il s'agit de [celui-ci](http://www.dx.com/p/mini-3a-4-5-28v-input-0-8-20v-output-step-down-voltage-regulator-green-238815). Le réglage est assez compliqué du fait du potentiomètre qui permet très peu de précision, donc j'ai fait le choix d'adjoindre à ce module un régulateur linéaire MCP1702-33, afin d'assurer une sortie 3.3V stable pour l'ESP8266 (associer ainsi des régulateurs n'est pas, théoriquement, une très bonne idée du fait du risque d'instabilité, mais je ne l'ai pas observé).

## Contrôle de la chaudière

Pour contrôler la chaudière, on souhaite à terme imposer sur la broche n°2 une **tension variable**, entre 0 et 24V (en réalité entre 6 et 21 car c'est l'intervalle qui semble faire une différence). Dans un premier temps, on se contentera d'y mettre soit 0V, soit 24V.

Par défaut, la broche 2 est **flottante** dans la chaudière (pas de pont installé en usine) : cela veut dire qu'en déconnectant simplement cette patte, la chaudière va fonctionner normalement (avec une tension observée de l'ordre de 21V : il y a certainement un *pull-up* interne à la chaudière). 

La solution est donc d'utiliser un transistor qui connectera cette broche à la masse (à travers une LED et une résistance, à des fins de diagnostic et de sécurisation de la chaudière en limitant le courant appelé), ou qui la laissera flottante. Il n'est pas possible de relier directement la broche au microcontrôleur : celui-ci ne tolèrera certainement pas de voir 24V sur un de ses outputs.

À terme, pour faire une variation continue, un PWM semble être une bonne idée, à condition de lisser correctement le signal (car on ignore le type de signal que la chaudière attend ou tolère !). Pour cela un condensateur entre la broche 2 et la masse devrait suffir.

## Photographies

Voici le montage tel que réalisé sur *breadboard*. Mes excuses pour la piètre qualité des photographies.

![ESP8266 et transistor de sortie](breadboard_esp8266.jpg)
![Alimentation](breadboard_power.jpg)
![Autre vue](breadboard_out.jpg)

Le transistor utilisé pour la sortie est un FDS6690A ÀPasCher(TM) acheté sur eBay. 
Je ne fais pas le schéma électronique car il est très simple, si un lecteur le demande je prendrai peut-être le temps de m'en occuper.

Mise à jour en juillet 2016 : à l'occasion de quelques retouches logicielles, j'ai pris une photo de la carte. J'en suis assez fier car elle est propre !

![Carte finale](chaudiere_in.jpg)


## Code

Le montage reçoit en UDP une valeur de 0 à 100 correspondant à la puissance à commander à la chaudière. 
Le code est en ligne [ici](https://github.com/sven337/jeenode/blob/master/heating/heating.ino). 
Les tests montrent que le système fonctionne correctement, en revanche les mises à jour *over-the-air* (OTA) en wifi de l'ESP8266 ne fonctionnent qu'une fois sur deux (j'utilise un module ESP-201 qui utilise une puce flash de 512Ko, valeur un peu faible pour les OTA, j'expliquerai peut-être les détails un jour), le module redémarre parfois de lui même sans raison apparente, ... mais c'est du détail.

# La suite...

Dans un prochain article je parlerai du côté serveur qui commande ce montage à partir du jour, de l'heure, et des températures intérieures et extérieures.

<script>
    $(document).ready(function() {
		$("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>
