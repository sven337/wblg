---
layout: post
title: Analyse d'un babyphone pourri
date: 2016-04-10 12:35:59
tags: electronics
category: francais
comments: true
img_rel: "/~sven337/data/babyphone"
---

J'ai récupéré à bon prix un "babyphone" d'occasion. Celui-ci est un Hama BC823 qui transmet non seulement le son, mais également la vidéo.

![Récepteur](receiver.jpg)
![Transmetteur](transmitter_face.jpg)

Cet appareil est un désastre. Il dispose que 4 canaux de transfert sans fil, tous dans la bande des 2.4GHz. Le transfert est fait en analogique (sans surprise, car transférer de la vidéo numérique en temps réel nécessite une puissance de calcul assez importante), avec une très mauvaise qualité d'image mais surtout du son : l'appareil est très sensible aux perturbations et la portée effective pour une transmission de qualité est de l'ordre de 4 mètres (dans un logement qui, il est vrai, a des murs épais). Le premier canal écrase purement et simplement mon réseau wifi. Les trois autres n'interfèrent pas avec mon wifi, mais peut-être avec celui des voisins.

Bref, l'appareil est tout à fait inutilisable. Dans cet article, je vais m'intéresser un peu à son architecture. Mon objectif à la base était de faire les améliorations nécessaires pour pouvoir m'en servir, mais j'ai rapidement conclu que la bonne solution était de refaire intégralement l'électronique pour utiliser un système de transmission numérique du son, et de perdre la vidéo, qui me semble de toute façon relever du gadget. Je détaillerai ce travail dans les prochains articles.  

# Transmetteur

![Transmetteur de profil](transmitter_side.jpg)
![Étiquette du produit](transmitter_label.jpg) 

Le système s'avère être "idiot" : pas de détection de niveau sonore. Le transmetteur transmet en permanence son et vidéo sur le canal sélectionné. La caméra est pourvue d'un capteur de luminosité, et de plusieurs LEDs infrarouges pour la "vision de nuit" (sans quoi l'intérêt de la fonction vidéo serait très, très réduit).

On voit ici le microphone (électret) utilisé par l'appareil, et un ensemble de fils qui partent dans le module caméra (que j'ai démonté mais que je n'ai pas photographié). L'amplification du microphone est réalisée dans le module caméra.

![Electret du transmetteur](transmitter_internal_electret.jpg)

La carte mère du transmetteur ne contient pas grand chose.
![Carte mère du transmetteur](transmitter_internal_front_board.jpg)	
![Carte mère du transmetteur - verso](transmitter_back.jpg)	
![Carte mère avec antenne (et condensateur à ignorer)](transmitter_internal_front_addedCAP.jpg)	

On distingue une LED D1 (allumée lorsque le transmetteur est allumé), l'interrupteur SW2, le connecteur d'alimentation J1 (6V 400mA), le connecteur J3 pour le module caméra, le sélecteur de canal (1 2 3 4) SW 1, et un module radio au centre derrière un bouclier métallique, et dont sort une antenne.

Je n'ai pas trouvé de référence de ce module, ne l'ayant pas retiré de la carte afin de me garder la possibilité de revendre le babyphone (ce que je ne ferai normalement pas étant donné mon projet de remplacement intégral de l'électronique interne, mais à l'heure où j'écris ces lignes celui-ci n'est qu'à environ 30% d'avancement).

La documentation de [ce module radio](https://www.dpcav.com/data_sheets/AWM631TX.pdf) me donne à penser que le module présent sur la carte, quoique différent, est très similaire, notamment avec le choix du canal 4 par défaut. De toute façon ce module ne vaut rien donc ça ne m'intéresse pas vraiment de l'étudier en détail.

À l'intérieur du module camera, on trouve un amplificateur opérationnel LM358 pour le microphone, un LM386 qui est probablement utilisé par le circuit vidéo (mais je n'ai pas vérifié), un petit chip marqué C0 21F, et un chip de caméra marqué [ViMicro](http://www.vimicro.com/) VA10. Ce produit n'apparaît pas sur le site de ViMicro, je présume que la société ne conserve pas en ligne la documentation de ses anciens produits (ce qui est une pratique aussi courante que détestable).


# Récepteur

Là où le transmetteur était très simple, le récepteur nous montre une étonnante complexité.

![Ouverture du récepteur](receiver_disassemble.jpg)

## Côté pile

![Côté pile](receiver_back_board.jpg)

D'un côté de la carte, on observe :

- un module radio marqué R(??)7RX(PCB) rev 1.2, 01RW67RX2L 1-210040-00. Mes recherches me donnent à penser qu'il pourrait s'agir d'un produit taiwanais nommé [Richwave RW67RX](http://www.richwave.com.tw/product.php?CNo=9) (RT6712?). On trouve également mention de ce produit sur cette [curieuse page Wikipédia](https://en.wikipedia.org/wiki/Spy_video_car).
- un amplificateur opérationnel LM358, dont j'ignore l'utilisation
- un [APA4880](http://www.anpec.com.tw/ashx_prod_file.ashx?prod_id=122&file_path=20090109105809347.pdf&original_name=APA4880.pdf) qui semble être un amplificateur pour oreillettes (utilisé également pour le haut parleur ? non vérifié), un produit d'une société dénommée Anpec qui m'est inconnue
- un régulateur linéaire 560mA [APL5508](http://www.anpec.com.tw/ashx_prod_file.ashx?prod_id=412&file_path=20131021181317165.pdf&original_name=APL5508R/9R.pdf), également produit Anpec
- l'interrupteur sélecteur de canal en haut de la photo
- un bouton qui active le rétroéclairage de l'écran
- un bouton qui active la fonction "vox", dont l'effet est... d'éteindre l'écran si le bébé ne fait pas de bruit. Tout en laissant le son. Vous avez donc le choix entre dormir avec un bruit blanc (plus diverses perturbations sur le canal), ou ne pas entendre votre bébé car vous avez baissé le volume pour pouvoir dormir. C'est un des éléments qui me fait dire que cet appareil est une désastre qui n'aurait jamais dû être vendu.
- un potentiomètre de réglage du volume
- un potentiomètre de réglage de "sensibilité", dont je soupçonne fortement qu'il ne sert à rien. On peut imaginer qu'il détermine à partir de quel seuil le récepteur va restituer le son, seulement celui-ci semble être restitué en permanence, indépendamment de la valeur du potentiomètre.

## Côté face

![Côté face](receiver_internal_back.jpg)
![Microcontrôleur](receiver_uc.jpg)

C'est de ce côté qu'on voit le plus de choses intéressantes. On note que ce PCB est double face, et comprend un grand nombre de composants (y compris une quantité impressionnante de condensateurs).

On observe :

- un microcontrôleur 8-bit bas de gamme [MDT10P22A3S](http://www.digchip.com/datasheets/download_datasheet.php?id=2799060&part-number=MDT10P22A3S)
- à nouveau deux régulateurs linéaires 560mA APL5508 (!), tension 3.3V
- un décodeur de vidéo analogique [ADV7180](http://www.analog.com/en/products/audio-video/video-decoders/adv7180.html) (dont la sortie est, j'imagine, reliée à l'écran, que je n'ai pas étudié)
- un chargeur de batterie NiMH [LS2364T](http://www.datasheetspdf.com/PDF/LS2364T/718641/1), qui semble être un [produit chinois](http://www.linkas.com.cn/e0.html)
- deux amplificateurs opérationnels ST [LM324](http://www.st.com/web/catalog/sense_power/FM123/SC61/SS1378/PF63709) dont j'ignore l'utilisation

Ce qui est intéressant sur ce circuit c'est la présence d'un circuit de recharge NiMH que j'aimerais conserver, et pourquoi pas - si je trouve où - conserver également le circuit d'amplification pour le haut-parleur ainsi que le potentiomètre de réglage du volume.
<script>
    $(document).ready(function() {
		$("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>

