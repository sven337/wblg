---
layout: post
title: Effets lumineux synchronisés avec la musique dans une fête
date: 2015-07-20 10:27:17
tags: electronics
category: francais
comments: partylight
img_rel: "/~sven337/data/party_strobe"
---

À l'occasion d'une fête, j'ai réalisé un montage permettant d'avoir des effets lumineux sur le dancefloor.

# Objectifs

L'objectif est d'analyser en temps réel la musique et de piloter des effets lumineux d'ambiance.

On se fixe comme objectif de réaliser trois type d'effets d'ambiance :

- fondu entre plusieurs couleurs vives à rythme lent (pour les moments plus calmes tels que le repas)
- allumage synchronisé avec le rythme de la musique (pour faire danser)
- stroboscope à fréquence variable (activé manuellement et ponctuellement)

La sélection de l'effet doit être réalisable à la main par n'importe qui, y compris un invité ivre.

# Réalisation : matériel

Cette réalisation a, comme souvent, été faite dans l'urgence avec les moyens du bord. Pour la lumière, on choisira un bandeau de LED RGB, de préférence en 5050, et de longueur suffisante par rapport à la taille de la pièce à éclairer. Ce bandeau devra être piloté par des transistors de puissance correctement dimensionnés, par facilité j'ai utilisé un des ["amplificateurs"](/~sven337/english/2015/01/19/Tearing-down-a-RGB-LED-strip-amplifier.html)[EN] que j'avais. Ces petits circuits sont conçus pour amplifier le signal sur de très longs rubans à LED, mais en les disséquant on peut récupérer les transistors de puissance. Ceux-ci sont un peu faiblards mais c'est tout ce que j'avais sous la main.
L'alimentation sera un classique bloc 12V DC 6A, le courant étant à adapter en fonction de la longueur du bandeau. Il faut garder à l'esprit que le courant moyen sera assez faible par rapport aux spécifications maximales théoriques : en mode stroboscope, le rapport cyclique vaudra 50%, et il sera globalement plus faible dans les autres modes car on utilisera rarement R G et B en même temps et à pleine puissance (ou alors on choisirait un bandeau blanc, qui revient moins cher).

Pour l'électronique de contrôle, j'ai utilisé l'éternel ["Arduino pro mini"](http://www.ebay.com/itm/Redesign-Pro-Mini-atmega328-3-3V-8M-Replace-ATmega128-Arduino-Compatible-Nano-/200914924969), en tout cas son clone chinois dont le prix est imbattable. Le modèle que j'utilise est un 3.3V à 8MHz, et non un 5V à 16MHz (la tension plus faible est utile pour les montages sur batterie). En conséquence la puissance de calcul disponible sera assez faible et cela pourrait poser problème pour l'analyse de la musique.

Pour intercepter le signal sonore, il faut un connecteur jack 3.5mm femelle, et le même connecteur mâle. J'ai récupéré le connecteur femelle sur un vieux lecteur de CD-ROM dont j'ai scié le PCB  ; et j'ai récupéré le connecteur mâle sur un vieux câble jack 3.5mm. De cette façon, au lieu de brancher l'amplificateur directement à la sortie son de l'ordinateur, on intercale mon montage.

![Connecteur jack femelle](jack_female2.jpg)
![Connecteur jack femelle - envers](jack_female.jpg)
![Connecteur jack mâle](jack_male.jpg)


L'interface pour interagir avec le montage prend, dans mon cas, la forme d'un microswitch et d'un potentiomètre, tous deux récupérés sur un autre lecteur de CD-ROM dont j'ai à nouveau scié le PCB. Le potentiomètre servait à la base de réglage du volume sonore, dans ce montage nous nous en servirons pour faire varier la fréquence du stroboscope, le microswitch  permettant de changer entre les différents effets (OFF, FADE, MUSIC, STROBE).

![Interface](microswitch_potentiometer.jpg)

![Montage complet](complete_electronics.jpg)

# Réalisation : logiciel - théorie

J'ai déjà réalisé le fondu entre couleurs dans un autre projet que je n'ai pas encore documenté : il s'agissait de réimplémenter les effets lumineux fournis par les très célèbres contrôleurs-avec-télécommande chinois. Ceux-ci sont d'assez mauvaise qualité mais la télécommande est utile.
![Contrôleur-avec-télécommande chinois](chinese_controller.jpg)
À l'occasion je documenterai ce projet.

Le stroboscope est conceptuellement simple à écrire, et faire varier sa période dynamiquement en fonction de la valeur du potentiomètre ne pose pas de problème particulier. La principale difficulé porte évidemment sur l'analyse en temps réel de la musique et c'est une partie qui m'a occupé plus de dix heures.

Il y a en fait deux problèmes :

1. analyser la musique pour calculer des valeurs numériques corrélées aux "temps forts" de la musique  (en détectant des "choses" intéressantes dans la musique)
1. utiliser ces valeurs pour déterminer les valeurs R, G, B à utiliser (et donc la couleur à donner au bandeau)

Ces deux éléments sont distincts, et il faut faire du bon travail sur les deux : si on réalise une mauvaise détection, la couleur du bandeau ne variera pas en fonction des moments forts de la musique, et inversement si on réalise une détection parfaite des moments forts mais que les effets lumineux ne suivent pas, le résultat sera sans intérêt.

## Analyse de la musique

L'approche la plus naïve serait de détecter les grandes variations d'amplitude. Cependant l'intuition donne à penser que cela fonctionnera très mal, en particulier sur de la musique pop dont la dynamique a été compressée de telle sorte que l'amplitude maximale (l'enveloppe) ne varie pas vraiment.

La méthode naturelle qui vient à l'esprit est la transformée de Fourier, qui réalise une analyse fréquentielle d'un segment de la musique, permettant de différencier les basses des aigus, et, peut-être, d'en tirer des conclusions utiles.
On ne va pas s'amuser à réimplémenter une transformée de Fourier sur l'Arduino. En fait c'est un algorithme proche qu'on va utiliser : la [FHT](https://en.wikipedia.org/wiki/Discrete_Hartley_transform#Fast_algorithms), implémentée dans une bibliothèque qui fera toutes les mathématiques pour nous : [ArduinoFHT](http://wiki.openmusiclabs.com/wiki/ArduinoFHT).

Le fonctionnement est le suivant : on va capturer avec le convertisseur analogique-numérique (ADC) un certain nombre d'échantillons de la musique qui est en train d'être jouée. La FHT va analyser ces échantillons et nous donner l'amplitude dans chaque intervalle de fréquence. Ensuite, il nous appartiendra de regarder si ces valeurs changent en effet en fonction des temps forts de la musique, et si c'est le cas nous pourrons piloter les lumières.

Il est intéressant d'utiliser le [*channel analyzer*](http://wiki.openmusiclabs.com/wiki/ArduinoFHT?action=AttachFile&do=view&target=FHT_128_channel_analyser.zip) fourni avec ArduinoFHT, qui permettra de visualiser graphiquement les différentes amplitudes et de **voir** directement si celles-ci varient en fonction des temps forts.
La réponse est oui, mais de manière moins évidente que ce qu'on aurait pu penser. Tout d'abord, chaque intervalle de fréquence a sa propre amplitude "de base" : quand aucun son ne passe, les valeurs d'amplitude ne sont pas à 0. Dans les basses, la valeur de base est de l'ordre de 192 (sur 256), ce qui signifie que l'amplitude de variation (de l'amplitude !) sera assez faible, donc potentiellement difficile à détecter.
On remarque également (en envoyant des signaux sinusoïdaux de fréquence donnée avec `` speaker-test -t sine -f 400 ``) qu'il y a une corrélation non-souhaitée entre les différents intervalles de fréquence : par exemple un signal à 5kHz va faire réagir (dans notre analyse) l'intervalle contenant 5kHz, mais également les intervalles adjacents. Cela veut dire que la précision de l'analyse est quand même limitée et qu'il ne faut pas trop y faire confiance.

Néanmoins, en passant de la musique du genre de ce qu'on passe en soirée (non, je ne donnerai pas de lien), il est facile de remarquer visuellement, avec le *channel analyzer*, que les valeurs évoluent réellement en fonction des temps forts, ou du moins en fonction des "beats" (coups de percussion, de fréquence plutôt basse). Je suis désolé de n'avoir conservé aucune capture d'écran.

En gros, la FHT telle qu'implémentée permet de détecter les beats, et pas grand chose de plus. Est-ce suffisant ? On verra plus loin que oui, mais j'ai dû expérimenter une dizaine d'heures avant de trouver le bon algorithme pour le pilotage.

## Pilotage des lumières

On sait désormais que notre analyse, si elle fonctionne, n'est pas d'une précision extrême et va donc nécessiter une certaine quantité de post-traitement. Il faut noter que je présente ici mes résultats dans l'ordre "logique", mais en réalité j'ai brûlé les étapes et tenté de piloter directement les lumières avec la sortie de la FHT (comme de nombreuses réalisations sur Internet le proposent ! et sans surprise la plupart sont mauvaises). C'est lorsque que je me suis rendu compte que le résultat était nul que j'ai dû réfléchir un peu plus sérieusement, utiliser le *channel analyzer* pour étudier le comportement de la FHT, et en déduire l'algorithme à utiliser.

L'idée de base était d'attribuer une bande de fréquence par canal de couleur : le bleu pour les basses, le vert pour les medium, et le rouge pour les aigus. Or, cela ne marche absolument pas, pour deux raisons :

1. la détection des medium et des aigus ne marche pas très bien (notamment la discrimination entre les deux est assez inefficace)
1. les medium, les aigus, et les basses arrivent souvent en même temps, générant une superbe couleur R+G+B = blanc-tout-moche, ce qui n'exploite pas le potentiel d'un bandeau RGB

Après de très nombreuses expérimentations (qui ont incrusté la mélodie de Axel F. dans mes rêves pendant une nuit) et une discussion avec des amis, j'ai retenu l'idée d'une approche [HSV](https://en.wikipedia.org/wiki/HSL_and_HSV) au lieu de RGB. Ici, on va utiliser les basses pour piloter la valeur (= la luminosité) du bandeau, et les aigus (sans s'embêter à savoir si c'est vraiment aigu ou seulement medium) pour piloter la **vitesse de variation** de la teinte (hue). La saturation, elle, reste tout le temps au maximum : si on a acheté un bandeau lumineux ce n'est pas pour faire des couleurs fades.

Afin d'éliminer la composante constante des valeurs d'amplitude, le post-traitement consiste à calculer la moyenne glissante exponentielle (la plus simple qui soit à implémenter) de l'amplitude. La différence entre cette moyenne glissante et la valeur instantanée est la grandeur utilisée pour piloter la lumière.

Puisqu'on a observé que la détection des basses était assez fiable, c'est celles-ci qu'on va utiliser exclusivement pour décider de l'intensité lumineuse - et chaque coup de grosse caisse est accompagné de son "flash" lumineux. Les aigus ont de toute façon moins d'importance dans les temps forts de la musique, donc ils vont avoir un effet présent mais moins évident sur la couleur du bandeau à travers le changement de teinte.

# Code

Le "sketch" Arduino pour ce projet se trouve [ici](https://github.com/sven337/jeenode/blob/master/party_strobe/party_strobe.ino).

<script>
    $(document).ready(function() {
        $("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>

