---
layout: post
title: "Vidange de terrasse tropézienne avec panneau solaire"
date: 2016-06-06 06:30:17
tags: electronics
category: francais
comments: true
img_rel: "/~sven337/data/terrasse"
---


L'appartement que je loue dispose d'une terrasse tropézienne : c'est une terrasse fabriquée en enlevant une partie du toit de la maison et en étanchéifiant le sol. Voir par exemple ici : http://www.deco.fr/jardin-jardinage/terrasse/actualite-493004-terrasses-tropeziennes.html
![Terrasse tropézienne](tropezienne.jpg)

Ma terrasse utilise des dalles en bois exotique posées sur des plots en plastique, et fait environ 3m x 3m.

# Élevage de moustiques

J'ai observé un problème dès l'emménagement dans cet appartement : après une période de pluie, la terrasse ne se vidange pas correctement, et il reste par endroits de l'eau stagnante pouvant monter jusqu'à 2 cm. Coïncidence ou non, il y avait de nombreux moucherons et moustiques lorsque j'ai emménagé.
Il y a deux défauts.

- La terrasse dispose bien d'une évacuation d'eau dans un coin, mais celle-ci est située pas loin de 2 cm au dessus du reste de la terrasse, et ne me semble pas facile à modifier (car les plaques de bitume pour l'étanchéité sont relevées sur les bords de la terrasse, et si je creuse un peu je risque d'envoyer l'eau dans l'appartement du dessous).
- La pente pour l'évacuation est très insuffisante, peut-être à cause d'une mauvaise réalisation, ce qui fait que l'eau n'est pas dirigée vers l'évacuation mais s'accumule à d'autres endroits.

J'ai parlé du souci au propriétaire, qui ne me frappe pas comme étant un grand bricoleur, et qui a fait le mort (probablement après avoir vu le devis de l'artisan qui est venu et est resté dix minutes). Il n'est pas improbable, au vu de ce que j'ai lu, que cet artisan lui ait par ailleurs dit que de l'eau  stagnante sur ce type de terrasse n'était pas un défaut. Ce qui est sûrement vrai du point de vue de l'artisan cherchant à justifier du travail douteux, mais nettement moins du point de vue de l'habitant !

# Vidange 

Par conséquent j'ai décidé de prendre les choses en main, et j'ai donc acheté une pompe et du tuyau, et j'ai monté un prototype sur piles dont le coût total est de moins de 15 euros. La pompe que j'ai utilisé est une pompe ÀPasCher, qui semble conçue pour les aquariums, achetée [ici](http://www.ebay.com/itm/182072189622).
![Pompe d'aquarium](pompe_ebay.jpg)
Elle fonctionne en (très, très) basse tension, a bien sûr une puissance et un débit ridicule, mais il se trouve que cela suffit. Le magasin de bricolage local vendait du tuyau au mètre que j'ai utilisé pour relier la pompe (placée dans un des points bas de la terrasse où l'eau s'accumule) à l'évacuation.

![Prototype: pompe en place](pompe.jpg)
![Prototype: évacuation](tuyau.jpg)
![Prototype: pompe cachée](closed.jpg)

En fonctionnement normal, la vidange de la terrasse est réalisée par cette pompe en environ 2 heures. Dans un premier temps j'alimente la pompe avec 3 piles NiMH et un circuit boost +5V (qui sur la photo sont dans un sac congélation sur la terrasse, et à terme seront bien sûr cachés sous les dalles).

## Défauts

- La vidange n'est pas complète et laisse environ un millimètre d'eau : la pompe désamorce s'il y en a moins.
- J'ai noté quelques difficultés à l'amorçage, même lorsqu'il y a beaucoup d'eau. Je pense que cette pompe est vraiment en limite de puissance pour pousser l'eau dans 2m de tuyau et 2cm de dénivelé. En effet si je retire le tuyau l'amorçage est immédiat, et en replaçant le tuyau le pompage continue sans problème. Ces difficultés à l'amorçage semblent se présenter une fois sur quatre, ce qui est assez gênant. J'ai remarqué qu'en appliquant des impulsions (arrêter et redémarrer la pompe plusieurs fois), l'amorçage semblait plus facile à réaliser. 

# La suite : système automatique !

Ce premier prototype me donne satisfaction, et j'ai décidé de racheter une deuxième pompe pour faire une vidange plus exhaustive. J'ai pour projet d'automatiser le montage (avec détection du niveau d'eau et panneau solaire), j'aborderai la question dans un deuxième article.


<script>
    $(document).ready(function() {
		$("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>
