---
layout: post
title: Appairage de volets Profalux Zigbee
date: 2023-06-02 01:27:46
tags: electronics
category: francais
comments: true
img_rel: "/~sven337/data/profalux"
---

Cet article rapide trace l'appairage de volets roulants à motorisation Profalux Zigbee, car on lit beaucoup de choses soit incorrectes soit pas à jour.
Mes volets ont été achetés en 2023. J'utilise Zigbee2MQTT mais n'importe quel autre système fonctionnera probablement.

# Appairer un volet Profalux

Ne pas faire de reset aux fils, ne pas suivre les procédures anciennes décrites sur les forums. Ce qu'il faut faire est ajouter le volet dans le réseau Zigbee. Profalux décrit une procédure pour cela dans sa "documentation" [NSAV061](https://www.profalux-pro.com/download/1.%20Notices,%20Plans,%20Technique/1.%20Volets%20roulants/3.%20Moteurs%20Commandes%20et%20Accessoires/1.%20Moteur/Moteur%20Profalux%20Zigbee/Notice%20SAV%20Moteur%20Zigbee%203.0%20-%20A%20partir%20de%20Septembre%202021%20-%20NSAV061.pdf)

Copie disponible [ici](/~sven337/data/profalux/NSAV061.pdf).

En ce qui nous concerne il s'agit de : 
- brancher le moteur et tester sa télécommande (étapes 1-4)
- ouvrir l'appairage dans Zigbee2MQTT
- suivre le b) de l'étape 5.1 c-a-d 4 appuis courts sur le bouton R de la télécommande suivis d'un appui long de 15 secondes sur le même bouton
- le volet va rejoindre le réseau Zigbee et se mettre à faire des mouvements pour indiquer qu'il attend l'appairage de la télécommande
- appuyer sur stop pour demander à la télécommande de s'appairer
- la télécommande va rejoindre le réseau Zigbee mais surtout s'attacher ("bind") au volet
- à ce stade la commande du volet doit être possible depuis la télécommande et depuis le coordinateur Zigbee
- à noter que Zigbee2MQTT à ce jour n'intègre pas le mode de commande qui me semble être celui pour lequel les volets ont été conçus, il faut envisager d'ajouter [cette merge request](https://github.com/Koenkk/zigbee-herdsman-converters/pull/5788)

# Éteindre les routeurs lors de l'appairage

J'ai des ampoules Philips Hue dans mon réseau qui ne sont pas toujours alimentées électriquement. C'est conçu pour, mais ... pas la spécification Zigbee et en tout état de cause pas les télécommandes Profalux. Plusieurs de mes télécommandes lors de l'appairage ont décidé de router leurs paquets à travers les ampoules situées à 3m (alors que le volet est à 1m...). Lorsque l'ampoule n'est pas alimentée, les télécommandes ne fonctionnent plus.

Il est donc préférable d'éteindre tous les routeurs lors de l'appairage (ou de n'ouvrir l'appairage que sur le coordinateur) pour éviter ce désagrément. 

Pour régler le problème cela m'impose au reset aux fils qui est assez ennuyeux à mettre en oeuvre.

# Conseils de menuiserie

J'ai voulu jouer lors de ma deuxième commande à prendre moins de jeu de montage que sur la première. J'avais commencé en déduisant 5mm, mais j'ai pensé qu'avec 3mm ce serait plus élégant (joints moins épais) et plus simple à poser.
Mal m'en a pris, j'ai dû buriner l'enduit d'un tableau qui n'était pas droit, et raccourcir plusieurs coulisses qui, si elles passaient effectivement dans le plan vertical en translation, ne pouvaient s'insérer une fois le coffre en place car il faut les incliner.
Moralité, déduisez 5mm ou écoutez votre revendeur.

En parlant de revendeur j'ai acheté chez [Kalytea](https://www.kalytea.com) dont je suis content autant des prix que du service client. J'avais également eu un bon contact avec Clic-volet, mais qui était plus cher sur le modèle précis que je recherchais.

