---
layout: post
title: Reverse engineering a Chervon cordless drill battery management system
date: 2016-07-19 18:39:46
tags: XXX
category: english
comments: true
img_rel: "/~sven337/data/XXX"
---

uC is 95F264K 1347 E23DJI

according to https://www.fujitsu.com/downloads/MICRO/fma/mcu/a07000494e.pdf:
New 8FX MB95200  Series Starter Kit
Equipped with an MB95F264K (20 KByte Flash, 496 Byte RAM)

	this is an MB95200 series
	F^2MC-8FX (8-bit CISC CPU)

	maybe MB95264?

	MB95F264: 20kB ROM, 496B RAM (yes, B)

	sold (?) to Cypress, datasheet available here:
	http://www.cypress.com/documentation/datasheets/mb95260h270h280h-series-new-8fx-8-bit-microcontrollers?source=search&keywords=MB95260&cat=technical_documents
	http://www.cypress.com/file/247316/download
	HW doc more complete http://www.cypress.com/file/237651/download

	FPT-20P-M09
	FPT-20P-M10  20 pins

	battery D pin connects to R37 200ohm, then goes to a 1AMm SOT-23 transistor http://www.onsemi.com/pub_link/Collateral/MMBT3904LT1-D.PDF real name MMBT3904L

	MCU DBG pin connects through res+capacitor to a MMDT5451 http://www.diodes.com/_files/datasheets/ds30171.pdf Q13

	2Am transistor is MMBT3906L http://www.onsemi.com/pub_link/Collateral/MMBT3906LT1-D.PDF
