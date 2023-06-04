---
layout: post
title: Grésillement radiateur Acova Taffetas 2
date: 2023-06-04 11:29:55
tags: electronics
category: francais
comments: true
img_rel: "/~sven337/data/acovataffetas"
---

Ce radiateur [Acova Taffetas 2](https://www.leroymerlin.fr/produits/chauffage-plomberie/chauffage-electrique/radiateur-electrique/radiateur-a-inertie/radiateur-electrique-a-inertie-seche-1500-w-acova-taffetas-2-connecte-blanc-82646782.html) fait un bruit insupportable dès qu'il chauffe. Malheureusement il était déjà hors garantie lorsque j'ai acheté la maison.
Le bruit ressemble à un grésillement à 50Hz, comme si une commutation était mal faite. Gradateur à triac ? Ils n'auraient pas osé ?

Au démontage on trouve une carte d'alimentation non isolée (sans transformateur), et sans fusible. 
![Alimentation](powerboard3.jpg)
Réduction maximale des coûts, la qualité et la fiabilité de cette carte sont franchement douteux.

Au lieu d'un condensateur de chute de tension comme il se pratiquait, semble-t-il, auparavant chez Acova (groupe Zehnder), on a droit à un [NCP1052](https://datasheet.octopart.com/NCP1052ST136T3G-ON-Semiconductor-datasheet-78758780.pdf). Mais... pas utilisé comme prévu dans la datasheet !
C'est en trouvant une [*application note AN8098*](/~sven337/data/acovataffetas/AN8098.pdf) du constructeur (ON Semi) que j'ai trouvé l'explication : on peut utiliser ce composant pour réaliser un buck non-isolé ! 

Je cite une phrase de ce document : **burst-mode control produces low-frequency waveform comparing to the switching frequency. Part of the power loss in this low frequency becomes audible noise. Therefore, burst-mode control is not suitable for high power applications such as more than 20 W**.

Mais serait-ce l'origine de notre bruit ? A priori non. La bobine de filtrage "pleurniche" en effet en permanence, mais le bruit que je traque est bien plus fort et ne se produit que lorsque le radiateur est en chauffe. Le pleurnichage de bobine ne me dérange pas depuis mon lit.

Il n'y a pas grand chose qui peut vibrer à part la carte elle-même. La régulation est faite avec un triac, si elle est faite comme sur les gradateurs de lampe halogène cela expliquerait le bruit, mais j'ai le problème même lorsque le radiateur est à pleine puissance auquel cas je m'attends à ce que le triac soit tout le temps passant.

J'ai remonté en plaçant du joint néoprène à tous les endroits de couplage vibratoire potentiel : entre la carte et son radiateur, entre le radiateur et le support plastique, et entre le support plastique et le corps de chauffe en métal. 

Je pense que le bruit provient en fait du corps de chauffe, qui vibre à 50Hz quand il est alimenté. J'ignore si c'est normal mais vu la qualité globale du produit on va supposer que oui. Avec la conception de ce radiateur, le corps de chauffe met en vibration le support plastique de la carte électronique. Tout cela fait caisse de résonnance (car le refroidissement du triac nécessite de laisser du vide), c'est la raison pour laquelle le bruit est si fort et semble provenir de la commande électronique.

D'autres commentaires sur le site de Leroy Merlin se plaignent de ce problème. Leur produit n'est pas défectueux c'est juste qu'il est mal conçu.
Je sais quelle marque éviter.

![Alimentation](powerboard1.jpg)
![Alimentation](powerboard2.jpg)
![Triac au verso de la carte](triac.jpg)


<script>
    $(document).ready(function() {
        $("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>

