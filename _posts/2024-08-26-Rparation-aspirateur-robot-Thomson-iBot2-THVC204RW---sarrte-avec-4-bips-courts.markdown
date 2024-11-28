---
layout: post
title: Réparation aspirateur robot Thomson iBot2 THVC204RW - s'arrête avec 4 bips courts
date: 2024-08-26 18:47:05
tags: electronics
category: francais
comments: thomsonvac
img_rel: "/~sven337/data/thomsonvac"
---


Dépannage d'un aspirateur robot Thomson iBot 2 THVC204RW

# Le problème

On m'a donné un aspirateur robot Thomson iBot 2 THVC204RW qui présente le défaut suivant :
- Il démarre puis s'arrête au bout d'une à deux secondes
- L'arrêt est accompagné de **4 bips courts**
- Le manuel ne fait aucune mention des codes d'erreur

# Recherche de la cause

En effectuant des recherches, je découvre que ce modèle est probablement basé sur un aspirateur robot de la marque **iLife**, possiblement le modèle **V3s Pro** ou V5s Pro. Les suggestions trouvées en ligne pour ce code d'erreur (4 bips courts) pointent vers :

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

# La véritable cause

Après investigation, il s'avère qu'**un des moteurs de roue** ne tourne plus. Ce n'était pas si évident à observer pour quelqu'un comme moi qui ne connaissait pas le comportement normal du robot.

En testant le moteur défectueux à vide (sans la boîte de vitesse), et après avoir forcé un peu son axe, je peux le faire fonctionner avec 12.8V à ses bornes :
- Consommation du moteur défectueux : 140mA
- Consommation du moteur fonctionnel : 75mA (à vitesse apparemment identique)

Cette différence de consommation indique clairement un **problème mécanique dans le moteur défectueux**, mais au moins il tourne.

# Informations sur le moteur

Le moteur en question porte le marquage suivant :
```Standard motor
RP365-ST /1 41 75 /DV
SMDN281114
```

![Moteur](motor_markings.jpg)

Il semble être fabriqué par [Standard Motor](https://www.standardmotor.net/product-category/home/home_6/?lang), une entreprise spécialisée dans les petits moteurs électriques. Malheureusement, je ne peux pas trouver facilement un moteur de remplacement identique.
Tout d'abord le modèle exact n'est pas sur leur site, et de toute façon ils vendent par 5000 unités (je crois).

## Dimensions du moteur

Pour faciliter la recherche d'un moteur de remplacement, voici les dimensions que j'ai relevées.

{:.CSSTableGenerator}
| Caractéristique | Dimension |
| Diamètre        | 27.5 mm   |
| Longueur du corps | 34.4 mm |
| Longueur de l'arbre | 8 mm  |
| Espacement entre vis de fixation | 16 mm |

Peut-on trouver un **moteur de remplacement** avec ces dimensions ?

Sur aliexpress je vois du RP-365-SV-14175, les dimensions ont l'air compatibles, le reste des spécifications je n'en sais rien...
On trouve d'autres moteurs sur ebay avec des spécifications proches.

# Une solution... très temporaire

Nul besoin de remplacer le moteur : **un coup d'aspirateur bien puissant** au niveau des moteurs, et **ça repart**.
Ces moteurs ont des évents qui sont situés juste dans le plan des roues, donc au fur et à mesure que les roues soulèvent de la poussière, celle-ci doit s'accumuler dans le moteur et finit par le bloquer.

![Où aspirer](wheretovac.jpg)

Après aspiration je suis redescendu à 60mA à vide, et le robot **fonctionne désormais normalement**.
Cela est une bonne chose car outre la difficulté de trouver un moteur compatible ou identque, le remplacement n'aurait pas été aisé. En effet, sur les moteurs du robot sont montés des **encodeurs rotatifs** qui sont à la fois rentrés en force sur l'arbre et soudés aux pattes.
(Il s'agit de la petite carte électronique et du disque noir sur la photo ci dessus) - ceux ci ne font pas partie du moteur mais sont rajoutés par le fabriquant du robot.

Sauf qu'après 2 jours, **le problème est revenu**, ce qui n'est pas vraiment surprenant. J'étais néanmoins déçu.

# Solution (temporaire ?) de réparation

J'ai donc **démonté entièrement le moteur** pour comprendre ce qu'il se passait, et je n'ai **pas trouvé de problème** évident.

Les **balais** sont bons.
![Balais](brushes.jpg)

Les **roulements** sont un peu curieux, il s'agit de simple disques de métal ("friction bearings"?), mes soupçons se portent un peu sur eux qui peut-être en s'étant chargés de poussière (ou de débris de balais) seraient devenus durs.
J'ai tout démonté, non sans difficulté pour certaines étapes, et **graissé au silicone les roulements**. Le remontage est assez compliqué (au **marteau**, mais avec **délicatesse** !), et j'ai pu obtenir un **moteur fonctionnel**. **44mA de consommation avec 13V aux bornes** : on est mieux que sur le deuxième moteur encore fonctionnel !

![Consommation test du moteur réparé](final_power.jpg)

## Procédure de démontage

- **Retirer l'encodeur** rotatif ![Encodeur](encoder.jpg) en enlevant le disque noir de l'arbre (faire levier délicatement avec un outil en plastique)
- S'aider du fer à souder pour **retirer la carte électronique** de l'encodeur en avancant millimètre par millimètre ![Carte encodeur](encoder_board.jpg)
- Couper les **4 rivets plastiques** et les **4 parties repliées** du boîtier pour libérer la face arrière ![Boîtier](case.jpg)
- Au niveau de la sortie du moteur, le roulement est tenu dans le boîtier et assez difficile à sortir, j'ai dû **taper sur l'arbre avec un marteau** pour faire sortir le **rotor** ![Rotor](rotor.jpg)
- Et voici une vue du **stator** ![Stator](stator.jpg)


L'astuce a consisté à retirer les deux bagues métalliques qui servent de roulement pour les graisser, tout nettoyer et tout remonter.
J'ignore combien de temps cela va tenir.

# Remplacement du moteur

Je n'ai pas de doute qu'il faudra **remplacer ce moteur**, ne serait-ce que parce que le démontage m'a pris 1h30 car certaines pièces étaient assez difficiles à retirer.
On trouve sur Aliexpress pas mal de "roues + moteurs" pour le robot iLife v3s Pro sur lequel ce modèle est basé. Seulement, **le plastique n'est pas compatible** (les pièces ne sont pas de la même forme), donc il faudrait racheter une roue+moteur complète dans le but de démonter le moteur en croisant les doigts pour qu'il soit compatible.
À 20€ je ne suis pas très motivé, mais c'est une piste à explorer.

Ma piste préférée pour l'instant (et je mettrai à ce ce post en fonction de mes résultats) est d'acheter un moteur Standard Motor *proche* puisque je n'en retrouve pas dont les spécifications sont *identiques*. Dès lors qu'il rentre physiquement et que le diamètre de l'arbre est compatible avec le pignon de sortie et l'encodeur, à peu près n'importe quel moteur devrait faire l'affaire... enfin j'espère. La suite au prochain épisode.

Mon choix s'est porté sur [**ce modèle PRI-365SV-14175**](https://www.aliexpress.com/item/1005006868330376.html) dont les cotes semblent correspondre au mien. La photographie éclatée correspond exactement ce qui me donne bon espoir.
Il faudra monter l'ancienne carte encodeur dessus. Il existe des moteurs proposés avec un encodeur, mais leur connecteur de sortie ne correspond pas au mien (que ce soit son type ou son nombre de pins), une incompatibilité sans nul doute volontaire de la part de l'OEM.
Mise à jour du post :  ce modèle fonctionne parfaitement et le montage a été relativement aisé.

Pour choisir le moteur il faut être vigilant à ce que l'arbre **dépasse des deux côtés** (afin de pouvoir monter l'encodeur), et que l'arbre sur sa sortie dispose de **stries** puisque c'est ce que l'arbre d'origine a. (On en trouve certains en D mais surtout un grand nombre qui sont lisses.)

Je pense également avoir identifié une **réference de roue complète** (roue + boîte de vitesse + moteur) qui serait [celle-ci](https://www.aliexpress.com/item/1005005461425476.html), concue pour un robot Proscenic 830. Par contre impossible de trouver le moteur seul avec son encodeur dans le bon format.

<script>
    $(document).ready(function() {
        $("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>

