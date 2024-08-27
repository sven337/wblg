---
layout: post
title: Réparation aspirateur robot Thomson iBot2 THVC204RW - s'arrête avec 4 bips courts
date: 2024-08-26 18:47:05
tags: electronics
category: francais
comments: true
img_rel: "/~sven337/data/thomsonvac"
---


# Dépannage d'un aspirateur robot Thomson iBot 2 THVC204RW

## Le problème

On m'a donné un aspirateur robot Thomson iBot 2 THVC204RW qui présente le défaut suivant :
- Il démarre puis s'arrête au bout d'une à deux secondes
- L'arrêt est accompagné de 4 bips courts
- Le manuel ne fait aucune mention des codes d'erreur

## Recherche de la cause

En effectuant des recherches, je découvre que ce modèle est probablement basé sur un aspirateur robot de la marque iLife, possiblement le modèle V3s Pro ou V5s Pro. Les suggestions trouvées en ligne pour ce code d'erreur (4 bips courts) pointent vers :

1. Un problème de moteur de la brosse centrale
2. Un "gyro problem" (problème de gyroscope)

Cependant, le THVC204RW n'ayant pas de brosse centrale, la première hypothèse est à écarter, et j'ignore ce que gyro problem peut signifier (problème de gyroscope, certes, mais ces choses là sont fiables donc je n'y crois pas).

Pour retrouver l'OEM (iLife) je me suis aidé du peu de fonctionnalités du robot ainsi que de la conception de ses pièces en plastique.

![](remote.jpg)
![](inside1.jpg)
![](mobo.jpg)

On remarque un microcontrôleur GD32F303 et 4 pins pour un port SWD. J'ai déjà travaillé sur ce microcontrôleur lorsque je m'intéressais au [robot tondeuse Parkside](https://github.com/sven337/ParksideRobomower/wiki).
Malheureusement le "readback" de la mémoire flash semblait bloqué, et je n'ai rien pu extraire en y passant 15 minutes. Je n'ai pas insisté.
La carte mère dispose d'un port pour un module wifi qui n'est pas présent dans ce modèle.

## La véritable cause

Après investigation, il s'avère qu'un des moteurs latéraux ne tourne plus. Ce n'était pas si évident à observer pour quelqu'un comme moi qui ne connaissait pas le comportement normal du robot.

En testant le moteur défectueux à vide (sans la boîte de vitesse), et après avoir forcé un peu son axe, je peux le faire fonctionner avec 12.8V à ses bornes :
- Consommation du moteur défectueux : 140mA
- Consommation du moteur fonctionnel : 75mA (à vitesse apparemment identique)

Cette différence de consommation indique clairement un problème mécanique dans le moteur défectueux, mais au moins il tourne.

## Informations sur le moteur

Le moteur en question porte le marquage suivant :
```Standard motor
RP365-ST /1 41 75 /DV
SMDN281114
```

![Moteur](motor_markings.jpg)

Il semble être fabriqué par [Standard Motor](https://www.standardmotor.net/product-category/home/home_6/?lang), une entreprise spécialisée dans les petits moteurs électriques. Malheureusement, je ne peux pas trouver facilement un moteur de remplacement identique.
Tout d'abord le modèle exact n'est pas sur leur site, et de toute façon ils vendent par 5000 unités (je crois).

### Dimensions du moteur

Pour faciliter la recheriche d'un moteur de remplacement, voici les dimensions que j'ai relevées.

| Caractéristique | Dimension |
|-----------------|-----------|
| Diamètre        | 27.5 mm   |
| Longueur du corps | 34.4 mm |
| Longueur de l'arbre | 8 mm  |
| Espacement entre vis de fixation | 16 mm |

Peut-on trouver un moteur de remplacement avec ces dimensions ?

Sur aliexpress je vois du RP-365-SV-14175, les dimensions ont l'air compatibles, le reste des spécifications je n'en sais rien...
On trouve d'autres moteurs sur ebay avec des spécifications proches.

## La solution

En réalité, nul besoin de remplacer le moteur : un coup d'aspirateur bien puissant au niveau des moteurs, et ça repart.
Ces moteurs ont des évents qui sont situés juste dans le plan des roues, donc au fur et à mesure que les roues soulèvent de la poussière, celle-ci doit s'accumuler dans le moteur et finit par le bloquer.

![Où aspirer](wheretovac.jpg)

Après aspiration je suis redescendu à 60mA à vide, et le robot fonctionne désormais normalement.
Cela est une bonne chose car outre la difficulté de trouver un moteur compatible ou identque, le remplacement n'aurait pas été aisé. En effet, sur les moteurs du robot sont montés des encodeurs rotatifs qui sont à la fois rentrés en force sur l'arbre et soudés aux pattes.
(Il s'agit de la petite carte électronique et du disque noir sur la photo ci dessus) - ceux ci ne font pas partie du moteur mais sont rajoutés par le fabriquant du robot.

<script>
    $(document).ready(function() {
        $("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>

