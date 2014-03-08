---
title: Suivre sa consommation électrique avec un Raspberry Pi
date: 2014-03-08
category: francais
---

Cet article détaille comment **suivre sa consommation électrique** avec un **Raspberry Pi** et un montage électronique simple et surtout très bon marché. 
Il nécessite de disposer d'un compteur électrique suffisamment moderne XXX détails et photos.

# Introduction

Le Raspberry Pi est un mini ordinateur capable de faire fonctionner Linux, et qui coûte peu cher. De nombreuses personnes suggèrent de s'en servir comme serveur (web, e-mails, ...), mais je doute que ses performances soient suffisantes pour cela. (À vrai dire je n'ai jamais testé car j'utilise un eeePC 701 comme serveur depuis plusieurs années, dont je suis très satisfait.)

Néanmoins je possède un Raspberry Pi, ainsi qu'un placard électrique dans lequel je peux le poser, le brancher, et l'interfacer avec le compteur. En avant !

# La sortie téléinfo

La sortie **téléinfo** est présente sur **tous les compteurs EDF** de moins de quelques années. Elle répond à une spécification disponible en ligne : <http://norm.edf.fr/pdf/HN44S812emeeditionMars2007.pdf>. 
De nombreux projets se contentent de **capter l'impulsion lumineuse** du compteur (une impulsion = 1W.h en général), mais la sortie téléinfo peut nous donner bien plus que cela :

- puissance instantanée en watts
- indice du compteur
- situation heure pleine/heure creuse (qui ne me concerne toutefois pas car je me contente de l'option base, plus avantageuse dans ma situation)

La sortie téléinfo implémente un protocole qui n'est électriquement pas compatible avec les protocoles que parlent les ordinateurs en général (RS-232, USB, parallèle, ...), ni d'ailleurs avec les protocoles du monde de l'informatique embarquée tels que I2C, SPI, ou un bête GPIO. C'est un choix curieux de la part d'EDF, mais le protocole téléinfo est assez facile à convertir en un protocole connu tel que **RS-232**.
La spécification est publique et plutôt bien écrite, alors au travail !

La forme du signal est la suivante : un **0** correspond à une **sinusoïde** à **50KHz** variant entre **+0V** et **+12V**, un **1** correspond à un plateau à **+0V**. (j'écris cela de mémoire, vous référer à la spec pour être sûrs).
**RS-232** utilise quant à lui **+12V** pour un 1, et **-12V** pour un 0. Cette tension négative est un mauvais choix technique qui complique beaucoup la vie de l'électronique moderne souhaitant implémenter RS-232. En général les circuits intégrés ont une UART qui utilise des niveaux de signaux différents (TTL) : +Vdd = 3.3V pour un 1, et +0V pour un 0. C'est plus simple, et plus logique... mais les ports série des ordinateurs "parlent" du vrai RS-232. Le circuit **MAX232** est un exemple de circuit intégré qui s'occupe de la conversion des niveaux entre RS-232 "réel" et RS-232 TTL (celui à 3.3V).

# Travaux précédents

J'ignore ici les montages basés sur la **détection de l'impulsion lumineuse**. De nombreuses personnes ont réalisé des montages (et parfois créé une activité commerciale) permettant d'**interfacer la téléinfo avec RS-232**. On trouve un exemple abouti et bien expliqué, qui a servi de base à ma réalisation, à l'adresse suivante : <http://www.chaleurterre.com/forum/viewtopic.php?t=15153>.

Le problème de ces montages est que bien souvent ils visent à obtenir une compatibilité avec RS-232 (par exemple <https://store.adtek.fr/home/12-interface-teleinfo-rs232.html>, mais aussi probablement, au vu du prix supérieur, <https://store.adtek.fr/home/10-teleinfo-usb-sans-souris-folle-v2.html>. Je ne connais pas cette société ni leurs produits, dont je n'ai pas de raison de penser qu'ils fonctionnent mal. Par contre, dépenser 30 euros ou plus pour ce genre de montage est clairement en dehors du budget que je m'étais fixé.). Or, RS-232 ne nous intéresse pas, puisque le R-Pi implémente RS-232 avec des niveaux TTL, incompatible, mais aussi plus simple. Je ne suis bien sûr pas le premier à le remarquer, et on voit des montages qui consistent à brancher directement un optocoupleur bidirectionnel **SHF6206** à la sortie téléinfo et au Pi... sauf que ce modèle est pratiquement introuvable, et que de manière générale les optos bidirectionnels coûtent cher.

J'ai donc réalisé un montage différent basé sur des composants facilement disponibles (sur eBay, DealExtreme ou AliExpress, par exemple).

# Architecture

Ayant eu beaucoup de mal à trouver un optocoupleur qui ferait l'affaire pour un branchement direct (car il faut non seulement qu'il soit bidirectionnel mais aussi que ses caractéristiques soient compatibles avec le timing du signal, chose pas toujours facile à garantir), j'ai opté pour un montage redresseur et un filtrage (permettant d'obtenir **1** = **+12V** constant, **0** = **+0V**, qui attaque l'optocoupleur le moins cher que j'ai pu trouver, dont la sortie est reliée au Pi de manière similaire au message du forum dont je donne un lien ci-dessus.

Bien sûr, cela représente considérablement plus de composants, mais au final le montage m'est revenu moins cher que les alternatives, et je peux attester après 8 mois de fonctionnement continu que la fiabilité est au rendez-vous !
	
# Réalisation électronique


## Achat des fournitures
## Assemblage et branchement
# Intégration logicielle
