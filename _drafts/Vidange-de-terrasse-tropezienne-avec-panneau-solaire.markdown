---
layout: post
title: "Vidange de terrasse tropézienne avec panneau solaire"
date: 2016-06-06 17:36:21
tags: electronics
category: francais
comments: true
img_rel: "/~sven337/data/terrasse"
---

Dans un précédent article j'ai présenté mon montage de vidange de terrasse. Il est temps d'automatiser celui-ci, et de profiter de l'exposition optimale de la terrasse pour adjoindre au dispositif un panneau solaire !

# Éléments

- pompe de vidange, 3-6V, courant inconnu
- STM32F103C8, tension XXX
- panneau solaire 2V 300mA
- "mobile power bank" 5V input 5V output (boost included)
- water level sensor
- current sense with shunt resistor
- FDS6690 for power
- DS18B20

steps
1	STM32 MOSFET pump control
2	current shunt on pump control
3	STM32 current measurement & reporting 
4	STM32 with temperature reading
5	STM32 ESP8266 CH_PD
6  	ESP8266 data reporting
7	solar panel (???)

