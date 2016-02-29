---
layout: post
title: Régulation de chauffage central - thermostat d'ambiance
date: 2015-11-06 22:59:05
tags: electronics
category: francais
comments: true
img_rel: "/~sven337/data/acleis"
---

Dans le précédent article nous avons vu un prototype permettant de contrôler la chaudière. Dans cet article nous verrons le dispositif qui envoie les ordres à la chaudière en fonction de différents paramètres.

Il s'agit ici uniquement de logiciel, qui fait intervenir :

- un thermomètre intérieur (DS18B20, nRF24L01+) présent dans ma [lampe de bureau](/~sven337/english/2014/05/08/Transforming-halogen-lamp-into-LED-lamp.html)
- un thermomètre intérieur situé le séjour, caché dans le pot d'une plante (DS18B20, nRF24L01+, NiMH 1.2, module boost)
- un thermomètre situé dans la chambre (DS18B20, ESP8266, sur secteur), intégré dans le placard à côté de l'électronique d'éclairage à LED automatique (non présentées sur ce weblog pour l'instant)
- un thermomètre extérieur (DS18B20, nRF24L01+, NiMH 1.2V, module boost, panneau solaire, projet que je n'ai pas encore décrit sur ce weblog car il a été victime du **syndrome du prototype** : on fait quelque chose, ça marche du premier coup, on le met en place sans jamais le mettre au propre parce qu'il marche parfaitement, et on l'oublie... et deux ans après il faut tout refaire car les défauts du prototype finissent par poser problème - dans le cas présent, l'électronique s'est retrouvée noyée à plusieurs reprises après de fortes pluies, et les contacts ont fini par se corroder)
- une interface permettant de choisir le mode COLD, HOT et AWAY, le changement étant réalisé à travers une [crontab](https://en.wikipedia.org/wiki/Cron)
- un programme serveur qui, en fonction du mode en cours et des températures, calcule s'il faut activer le chauffage ou pas

# Données d'entrée

Le principe du contrôle climatique pour le chauffage est de se baser sur la température extérieure, afin d'anticiper les variations éventuelles de température intérieure. Je crois que c'est souvent mis en oeuvre dans les grands bâtiments tertiaires, en revanche cela me semble moins justifié pour une habitation. Dans le cas présent je souhaite me baser sur la température intérieure afin que les apports de chaleur, par exemple ceux de l'électroménager ou de la cuisine, soient pris en compte.
Voici l'approche que j'ai retenue :

- une "température de non chauffage", d'environ 15°C d'après les différentes pages web que j'ai lues (à ajuster à l'usage). Cette température est un seuil de température extérieure à partir duquel on arrête de chauffer.
- un calcul de température intérieure, sous forme de moyenne pondérée de différentes pièces (sachant que le poids change selon nuit/jour, par exemple la nuit, on pondèrera fortement la chambre, alors que le jour c'est plutôt le séjour qui prendra le pas)
- une décision binaire chauffer/pas chauffer selon la comparaison de la température de l'étape précédente avec une valeur de consigne (différente selon le mode "chaud" et d'un mode "froid")

C'est un gros défaut du chauffage central que de ne pas avoir la possibilité d'un contrôle fin pièce par pièce. J'espère à terme disposer d'un chauffage électrique que je pourrai piloter pièce par pièce en fonction de la température de cette pièce, ce qui m'éviterait le bricolage décrit dans cet article.

# Contrôle de chauffage

## Températures
Un programme serveur est responsable de calculer la température à intervalles réguliers. Pour cela il fait une requête HTTP adressée à la mini-application Flask que j'utilise pour stocker mes températures, et calcule une moyenne en fonction d'une pondération qui dépend de l'heure du jour.

Voici un exemple des températures relevées :

``` python
{'bed': 18.75, 'living': 21.6875, 'office': 22.18, 'exterior': 6.25, 'pantry': 15.312}
{'bed': datetime.datetime(2016, 2, 29, 21, 9, 11, 853085), 'living': datetime.datetime(2016, 2, 29, 21, 16, 22, 277984), 'office': datetime.datetime(2016, 2, 29, 21, 7, 2, 392827), 'exterior': datetime.datetime(2016, 2, 29, 21, 6, 38, 335546), 'pantry': datetime.datetime(2016, 2, 29, 21, 15, 4, 386432)}
```

## Consigne

La température obtenue est comparée à la température de consigne, qui dépend de l'état du programme. Il y a trois états :

- HOT: température de consigne de 21.5°C
- COLD: température de consigne de 18.5°C
- AWAY: température de consigne de 12°C

En pratique, je n'utilise pas AWAY : quand je pars, je coupe tout simplement la chaudière. Ma femme ne manque pas de me faire remarquer, à chaque retour de vacances, qu'il fait froid, mais la maison est chaude en 2 heures, donc je ne vois pas bien l'intérêt de laisser fonctionner une chaudière en mon absence, même si c'est pour qu'elle chauffe très peu.

Le changement HOT/COLD est déterminé par une crontab qui ressemble à cela :

``` cron
## Basic rule: "hot" period is 5h30-8h30, then 17h-20h30
30 5    * * *  heating_control.sh hot
00 17   * * *  heating_control.sh hot
30 8,20 * * *  heating_control.sh cold

## Wife is home on Mondays, Wednesday, Saturdays and Sundays: these days are full-hot 5h-20h
## Note minute = 01 to override the basic block above
01 5-19 * * mon,wed,sat,sun heating_control.sh hot
```


# Interface utilisateur

## Bouton "j'ai froid"

La partie matérielle qui gère la chaudière n'a pratiquement pas d'interface : elle est alimentée directement par la chaudière, donc il n'y a pas de bouton on/off, et puisque les températures et états sont gérés logiciellement par un serveur sous Linux, il n'est pas possible de les modifier.
J'ai tout de même rajouté un bouton, dénommé "j'ai froid". Lorsque vous appuyez sur ce bouton, le dispositif démarrera le brûleur pendant 20 minutes, ce qui est en général suffisant (sinon, il suffit d'appuyer à nouveau) pour fournir le confort manquant.

Voici le dispositif :


## Commande "j'ai froid"

Le script **heating_control.sh** est minimaliste et envoie simplement un paquet UDP au programme serveur, qui reconnaît les commandes **hot**, **cold**, et **away**. Une autre commande est **forceheating**, qui force le programme à activer le brûleur pendant 20 minutes. Cette commande intervient à un niveau différent du bouton précédemment décrit, mais son effet est le même. Ma femme utilise le bouton car c'est le plus simple pour elle, mais quand j'ai froid et que je ne veux pas me lever de mon bureau, j'utilise **forceheating**, cela m'évite de me lever !

# Bilan

Ce montage est en fonctionnement depuis quelques mois et donne, à mon sens, de bons résultats. Il fait parfois trop froid ou trop chaud, mais c'est une conséquence du chauffage central au gaz sans robinets thermostatiques. Cette technologie (ou, plus exactement, cette **absence** de technologie) ne permet pas un contrôle suffisamment fin pour avoir un confort optimal.
