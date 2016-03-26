---
layout: post
title: Transformer un babyphone pourri en babyphone pas trop mal
date: 2016-03-03 21:35:59
tags: XXX
category: english
comments: true
img_rel: "/~sven337/data/XXX"
---

# Receiver
back side

uC: MDT10P22A3S
http://www.digchip.com/datasheets/parts/datasheet/605/MDT10P22A3S-pdf.php


ADV7180 "video decoder"
http://www.analog.com/en/products/audio-video/video-decoders/adv7180.html

LS2364T NiMH battery charger
http://www.datasheetspdf.com/PDF/LS2364T/718641/1
http://www.linkas.com.cn/e0.html
Looks like a chinese design - this is probably a rebranded generic chinese device then?

APL5508
Low Dropout 560mA Fixed Voltage Regulator
Anpec, another taiwan company
http://www.anpec.com.tw/ashx_prod_file.ashx?prod_id=412&file_path=20131021181317165.pdf&original_name=APL5508R/9R.pdf
marking AL9AE33 doesn't really match, but 3.3V

2*ST LM324 (marking eZ4R935)
	http://www.st.com/st-web-ui/static/active/en/resource/technical/document/datasheet/CD00000457.pdf
	http://www.st.com/web/catalog/sense_power/FM123/SC61/SS1378/PF63709

front side (with monitor)

	APA4880 (TL6P7)

	LM358

	shielded radio module marked R(unreadable)7RX(PCB) rev 1.2
	(inside 01RW67RX2L 1-210040-00

	https://en.wikipedia.org/wiki/Spy_video_car
	Richwave RW67RX?
	another tw company

	http://www.richwave.com.tw/product.php?CNo=9 RT6712? supposedly has noise squelch!

# Transmitter

	dumb - caméra, micro, led, switch, et modules

	https://www.dpcav.com/data_sheets/AWM631TX.pdf différent mais très similaire, notamment le default to ch4. Same chip inside I bet.

	inside the camera module - LM386L, ST 358 YR0912, one small chip marked C0 21F, vimicro VA10
