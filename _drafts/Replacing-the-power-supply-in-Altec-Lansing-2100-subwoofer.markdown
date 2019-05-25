---
layout: post
title: Replacing the power supply in Altec Lansing 2100 subwoofer
date: 2018-06-24 21:10:29
tags: electronics
category: english
comments: true
img_rel: "/~sven337/data/altec"
---

I have owned an Altec Lansing 2100 kit for more ten years. It has served me very well and I am fairly happy with the product. However, it uses a linear power supply and the transformer hums a bit at 50Hz. Since it's located inside the box of the subwoofer, that tends to make the subwoofer vibrate at 50Hz when the device is plugged in but turned off. And at night, you can hear it.
Also, the power supply being linear has very bad efficiency, so I thought it was time to upgrade it to the 21st century and use a switched-mode power supply.

# Design 

# Experimental setup

# Power consumption

I purchased a Chacon Ecowatt 570 watt-meter. It's not a bad device and the price was reasonable (15€ delivered). I used it to compare the power consumption of the speakers with the original linear power supply and the new switched mode power supply I replaced it with.

The results are good but not great :

SMPS:
power supply only (subwoofer not plugged) 2.1W
off (standby) 2.8W
on (no sound) 4.9W

original PSU:

off (standby) 5.7W
on (no sound) 7.7W

The new power supply consumes 2.1W when it's not connected to anything. That is obviously a very bad figure, probably related to the presence of a bright LED that I need to (but can't) remove. When connected to the speakers in standby ("off") mode, it draws 2.8W, to be compared to 5.7W in the original power supply. That's a net saving of 2.9W which works out to about 4€ per year of electricity. The new power supply therefore pays for itself in about 4 years.


