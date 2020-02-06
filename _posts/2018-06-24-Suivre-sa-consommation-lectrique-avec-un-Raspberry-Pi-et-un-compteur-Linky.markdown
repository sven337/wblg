---
layout: post
title: Suivre sa consommation électrique avec un Raspberry Pi et un compteur Linky en mode historique
date: 2018-06-24 12:31:54
tags: electronics
category: francais
comments: teleinfolinky
img_rel: /~sven337/data/teleinfo
---

Je décrivais voila 4 ans [le montage que j'utilise](/~sven337/francais/2014/03/09/Suivi-de-consommation-elec-avec-R-Pi.html) pour le suivi de consommation électrique en utilisant la téléinfo du compteur bleu électronique. 
J'ai récemment eu l'honneur de voir ce compteur, somme toute en parfait état de fonctionnement, remplacé par un compteur communiquant "Linky". 
Je n'ai pas grand chose à dire sur Linky (CanardPC Hardware a fait [un dossier intéressant](https://www.cpchardware.com/download/hw28_linky.pdf) sur Linky). Cela a été l'occasion d'une discussion enrichissante avec le technicien qui venait pour l'installation, qui semblait heureux d'être accueilli avec le sourire. Il semble que la vie des poseurs de Linky est un peu désagréable.

Mon montage ne fonctionnait pas sur le compteur Linky, alors que le mode par défaut de la téléinfo (dénommé "mode historique") Linky est le même que sur l'ancien compteur. La [spécification de la téléinfo pour Linky](http://www.enedis.fr/sites/default/files/Enedis-NOI-CPT_54E.pdf) mentionne également un nouveau mode, dénommé "mode standard", auquel je m'intéresserai peut-être plus tard.

# Même spécification, implémentation différente

Si la spécification du mode historique est identique, l'implémentation semble légèrement différente sur le Linky au niveau électrique.
En effet, le signal avait la forme d'une sinusoïde immonde d'environ +8V/-8V d'amplitude : 
![Signal issu de l'ancien compteur correspondant à un 0](scope_meter_output.png)

Maintenant, la forme est beaucoup plus belle, la fréquence reste à 50kHz (j'ignore pourquoi mon oscilloscope ÀPasCher(TM) affiche 30kHz, mais en comptant à partir de la résolution horizontale c'est bien 50kHz ce qui correspond à la spécification), mais l'amplitude est bien moindre puisqu'on est en gros sur +3.6/-3.6V. On va le voir, cette tension bien plus faible entraîne des transitions moins franches dans le dispositif, ce qui pose problème à la sortie.

![Signal issu du Linky correspondant à un 0](2018_linky_new_signal.png)

![Entrée et sortie du circuit avant modification](2018_linky_both_problem.png)

Sur cette courbe sont représentées en jaune (canal 1) l'entrée du circuit, c'est-à-dire le signal de téléinfo émis par le Linky. On retrouve l'amplitude de 3.6V; et en bleu (canal 2) la sortie du circuit, c'est-à-dire ce qui est transmis au port série du Raspberry Pi. Pour mémoire, celui-ci exige un créneau à 3.3V correspondant à un 1, et 0V pour un 0. On voit bien qu'on n'a ni l'un, ni l'autre : la tension est de 3V pour un 1 (ce qui suffit) et de péniblement 1V pour un 0, ce qui est déjà trop élevé, et surtout le signal n'a rien d'un créneau. Il faut une transition plus franche car le port série ne voit tout simplement pas les zéros.

L'image ci-dessous montre le problème plus en détail.

![Signal en sortie - détail](2018_linky_badsignal_details.png)

# Correction

J'écris cet article plusieurs semaines après avoir fait le changement, et sans avoir pris de notes. 
Je pense que l'origine du problème est que la tension plus faible du signal d'entrée impliquait un courant plus faible à travers l'optocoupleur. Or, ce dernier paramètre est important puisqu'un optocoupleur est une diode placée en face d'un phototransistor, qui lui même est un transistor bipolaire un peu spécial... et un des élements qui définit un transistor bipolaire est son *current transfer ratio*, que la [datasheet du PC817](http://www.futurlec.com/Datasheet/LED/PC817.pdf) que j'utilise montre comme étant de l'ordre de 1 (là où un transistor bipolaire, utilisé pour l'amplification, a un ratio de l'ordre de 50).
Le courant à travers l'optocoupleur en sortie était donc plus faible, et s'avérait insuffisant pour annuler la tension de sortie à travers la résistance de pullup. Voir le schéma du circuit ci-dessous.

![Schéma redressement téléinfo](schema.jpg){:style="border:1px solid black"}

Les modifications ont consisté à diminuer R2 et augmenter la résistance de pullup. Le résultat est visible dans la comparaison ci-dessous qui montre l'ancien et le nouveau circuit (en jaune). Les transitions sur le nouveau sont bien plus nettes et, sans surprise, le port série du Raspberry Pi arrive à nouveau à lire la téléinfo.


![Comparaison avant-après](2018_linky_before_after.png)

Prochaine étape, passer en "mode standard" ? Je ne sais pas encore si j'y vois un intérêt.

<script>
    $(document).ready(function() {
		$("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>


