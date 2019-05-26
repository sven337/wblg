---
layout: post
title: Réparer l'horloge de tableau de bord HS d'une Toyota Yaris
date: 2019-05-26 13:55:19
tags: electronics auto
category: francais
comments: true
img_rel: "/~sven337/data/yarisclock"
---

L'horlogue du tableau de bord (qui affiche également l'autonomie restante du véhicule) a fini par mourir après quelques semaines à perdre en luminosité. Cela semble être un problème assez courant. Quelques personnes en ont discuté sur [le forum YarisWorld (en anglais)](http://www.yarisworld.com/forums/showthread.php?t=44172). Après beaucoup de travail j'ai identifié la cause de la panne et fait une bonne réparation.
Les détails de mon travail sont sur [l'article en anglais](/~sven337/english/2019/05/25/Fixing-a-broken-dashboard-clock-on-Toyota-Yaris.html). Ici je ne mets que le résumé de la réparation faite.

# Cause

6 transistors, servant de régulateur linéaire pour déliver 1.5V 300mA à partir du 12V batterie aux filaments de l'afficheur, chauffent trop et finissent par mourir.

# Procédure de démontage
 
- retirer les deux pièces plastique sur le côté (voyant airbag passager et bouton warning), ce sont des clips en plastique il faut juste tirer vers vous en commençant par en bas
- enlever le cache du compteur de vitesse en le tirant (fort) vers vous
- retirer les deux vis qui maintiennent le compteur
- retirer le compteur, il faudra le tourner un peu et déformer légèrement le plastique du haut
- retourner au labo, retirer les 2 vis à l'arrière du compteur + les clips plastique
- tirer sur l'arrière du compteur, attention il y a un miroir qui risque de tomber
- déconnecter la carte mère (celle qui fait 10x10cm, il faut juste tirer elle se déconnectera toute seule)
- retirer 1 vis sur le cache frontal, ensuite retirer le cache frontal (plein de clips)
- retirer le cache en plastique de l'afficheur principal (4 vis + 1 clip et ouvrir en pivotant)
- déconnecter le cable ruban en notant bien son sens et son chemain
- maintenant vous pouvez retirer la carte puissance en enlevant les deux clips et en tirant, ce qui va également déconnecter l'afficheur de l'horloge
- c'est la carte puissance qu'il faut réparer


# Réparation

Il faut retirer les 6 transistors et leurs résistances de base et d'émetteur pour faire de la place sur la carte.
!["Cleaning up" the board](cleanboard.jpg)

Ensuite j'ai utilisé module buck ÀPasCher(TM) à base de MP1584-EN. (Marque chinoise "D-Sun".) On en trouve partout sur eBay, par exemple
(https://www.ebay.fr/itm/Ultra-Small-...-/322408214136)

Réglé sur 1.5V, il faut le connecter pour qu'il alimente les filaments de l'afficheur.

Désolé pour la qualité des photos. 

![Test setup](test_setup.jpg)
![1.5V 0.5W](halfwatt.jpg)


![Final result](final.jpg)


<script>
    $(document).ready(function() {
		$("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>
