---
layout: post
title: Replacing the power supply in Altec Lansing 2100 subwoofer
date: 2024-08-31 00:00:00
tags: electronics
category: english
comments: Altec
img_rel: "/~sven337/data/altec"
---

Publishing this about ten years after it was actually done, with much less information than I wanted (and no pictures), but it's useful.

I have owned an Altec Lansing 2100 kit for more 15 years. It has served me very well and I am fairly happy with the product. However, it uses a linear power supply and the transformer hums a bit at 50Hz. Since it's located inside the box of the subwoofer, that tends to make the subwoofer vibrate at 50Hz when the device is plugged in but turned off. And at night, you can hear it.
Also, the power supply being linear has very bad efficiency, so I thought it was time to upgrade it to the 21st century and use a switched-mode power supply.

# Power consumption

I used a watt-meter  to compare the power consumption of the speakers with the original linear power supply and the new switched mode power supply I replaced it with.

The results are good but not great :

{:.CSSTableGenerator}
| Condition | SMPS | Original supply |
| Power supply only (subwoofer not plugged) | 1.7W | N/A |
| Off (standby) | 2.1W | 5.7W |
| On (no sound) | 4.6W | 7.7W |


The new power supply consumes 1.7W when it's not connected to anything. This is not a good figure. When connected to the speakers in standby ("off") mode, it draws 2.1W, to be compared to 5.7W in the original power supply. That's a net saving of 3.6W which works out to about 31.5kWh/year of electricity, which at 0.19€/kWh of average price for me is 6€ per year of electricity. The new power supply pays for itself within a few years... if it doesn't die, which is another story.


