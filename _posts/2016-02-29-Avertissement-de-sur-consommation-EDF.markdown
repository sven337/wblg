---
layout: post
title: Avertissement de sur-consommation EDF
date: 2016-02-29 10:36:11
tags: electronique
category: francais
comments: true
img_rel: "/~sven337/data/teleinfo"
---

J'ai présenté, il y a bien longtemps, mon montage de [suivi de consommation électrique](/~sven337/francais/2014/03/09/Suivi-de-consommation-elec-avec-R-Pi.html) utilisant la téléinfo EDF. Jusqu'à présent je m'en servais assez peu : pour m'épargner le déplacement jusqu'au compteur lorsque, quelques fois par an, mon fournisseur d'énergie me demande une auto-relève ; et pour tirer des courbes que je ne regarde au demeurant que très peu souvent (celles de température sont parfois utiles, celles de consommation électrique, très rarement).

![Exemple de courbe de consommation électrique - lissée sur la journée](teleinfo_jsgraph2.jpg)

Une utilisation concrète fait suite à l'acquisition par mon foyer d'un sèche-linge, sans augmentation de la puissance de mon abonnement d'électricité (car c'est très cher et peu justifié). Pour éviter les coupures de courant intempestives qui arrivent lorsque le sèche-linge est utilisé au mauvais moment (c'est-à-dire en même temps que le four, la machine à laver, les plaques à induction, ...), j'ai modifié ma petite application Flask afin d'y ajouter un avertissement dès que la puissance efficace dépasse 5500W (mon abonnement est de 6000VA, mais j'ai remarqué que le disjoncteur principal était assez laxiste et me permettait de monter jusqu'à 6500W avant coupure). J'ai fixé ce seuil empiriquement de telle sorte qu'il corresponde à une situation critique (il faut réagir *vite* sinon *ça va couper*), mais rattrapable (en éteignant quelques appareils on évite la coupure générale). 

Le script d'avertissement m'envoie un e-mail, un SMS, et met le son au maximum sur l'eeePC qui me sert de serveur afin de jouer un mp3 d'alarme. La combinaison de ces méthodes de notification suffit en général à attirer mon attention à temps.

``` bash
#!/bin/bash
amixer sset PCM 255
amixer sset Master 100
amixer sset Speaker 100
mpg123 alarm.mp3 &
echo "POWER WARNING $1 W"| ~/sms-send-notification.sh
echo "POWER WARNING $1 W" | mail -s 'POWER WARNING'  root
```

Cela me permet de continuer à lancer le sèche-linge au mauvais moment, sans payer le prix de mon étourderie sous la forme d'une coupure générale d'électricité qui est toujours agaçante (et sensiblement dommageable au système d'exploitation des multiples ordinateurs qui fonctionnent à la maison, et par exemple du Raspberry Pi que j'utilise comme pour certaines fonctionnalités domotiques... il faut que je mette en place un système de batterie de secours pour cet appareil).

<script>
    $(document).ready(function() { 
        $("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script> 

