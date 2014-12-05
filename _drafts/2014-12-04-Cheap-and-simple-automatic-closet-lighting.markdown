---
layout: post
title: Cheap and simple automatic closet lighting
date: 2014-12-04 18:53:52
tags: electronics
category: english
comments: true
img_rel: "/~sven337/data/closet"
---

First of all, a disclaimer: this project runs on mains. So for most closets, where no electricity is available, it won't really work. With that bit of awesomeness out of the way, let's see how to build the simplest, cheapest automated lighting for use in a closet, cabinet, ...

# Objective

We installed shelves under our stairs, and under the shelves is a storage area. It's closed with curtains, but that's enough to make it very similar to a closet in that you **need artificial lighting** in there if you want to see anything. Luckily, a mains socket is available in this closet, which will simplify the design.

So here's what we need:

- **sufficient light output** for a 2 square meter storage area full of different things
- **cheap** solution
- **automatically** lights the closet when somebody opens the door/curtain

Let me show you how I achieved it.

# Hardware

I decided to try a COB LED bar. These are (fairly) high-powered LEDs in the form of a metal bar that is about 15 cm x 1 cm. It looks like it will be a perfect thing to attach along one of the shelves' supports.
The LED needs a driver (if you connect it to the power supply directly, you risk overdriving it and killing it quickly, not to mention the dangers of producing a - localized - lot of heat in a closet), so we'll buy a ready-made one.
I had a 14V 400mA power supply, salvaged from an old epilator (not mine!).

## BOM

Here is what I used:

{:.CSSTableGenerator}
| Élément | Lien | Coût |
| 4W COB LED stick | <http://www.dx.com/p/0412-12010-4w-350lm-3300k-cob-led-warm-white-light-stick-white-yellow-223799> | 2.80USD |
| MR16 4W LED constant current driver | <http://www.dx.com/p/4w-led-constant-current-source-power-supply-driver-8-12v-197205> | 1.75USD | 
| Passive infrared sensor | <http://www.ebay.com/itm/400330055400> | 1.90USD |
| Power supply | salvaged | 0USD |
| 12V jack connectors | http://www.ebay.com/itm/321088164543 | 2.70USD |
| KF2510-2P connectors | http://www.ebay.com/itm/370696057892 | 1.35USD |
| FDS6690A transistors | Ebay | 3USD ||
||||
| Total of required parts || **13.50USD** |

## Pics or it didn't happen

# Design

There are very few components so this is a simple project. However, it still requires a little bit of skill with a soldering iron.
The general idea is for the **PIR** sensor to **turn the LED driver on and off**, thereby switching the light on and off. What's interesting is that there are many cheap, 3-5W LED drivers in a MR16 form factor, just like the one I picked. The PCB is similar between these different drivers, but the components onboard may actually differ quite a bit. The controlling IC is always a buck power supply, but the exact model of IC chosen will depend on which Chinese plant the device comes from (or something like this).
I bought a driver like this for my [LED lamp](/~sven337/english/2014/05/08/Transforming-halogen-lamp-into-LED-lamp.html), and it was using a **PT4115** chip. The huge advantage of this chip is that it had a *DIM* pin, which was basically a logic-level, PWM-ready input pin: in other words one could hook it up directly to any sensor or microcontroller. Of course this required soldering a wire to the tiny, tiny pin, but this wasn't as hard as it seemed.
Unfortunately the particular model of driver that I received is based on a different chip - I forgot to take note of its reference, and this isn't happening now that the driver is thoroughly coated in hot glue - and it doesn't have a *DIM* pin.

This means that the PIR sensor cannot be connected to the driver directly: we'll instead use it to switch power to the driver, with a suitably chosen transistor. Of course the output of the PIR sensor cannot be used as the '+' input of the driver, because its current output capability is ridiculously low (as is normal for a logic pin).
Any transistor that has a ~3.3V threshold voltage, can isolate 15V or more, and can tolerate at least 1A continuously, will do. I happen to have these FDS6690 transistors lying around: they're **SOIC**, in other words **surface mounted devices** (SMD). Most transistors for amateur electronics use a through-hole format such as TO-92, but I find that SMDs can be equally easy, if not more, to solder, and they occupy less space which makes them easier to integrate.

