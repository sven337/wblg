---
layout: post
title: Transforming halogen lamp into LED lamp
date: 2014-03-30 18:42:05
tags: electronics lighting
category: english
comments: true
img_rel: "/~sven337/data/hal2led"
---

# Introduction 

I found a old halogen lamp in a dumpster years ago. My wife redecorated it, and I did minor fixes. 
Unfortunately, it doesn't have a dimmer, nor a switch, and instead of spending time on improving a dying technology (I am not even sure R7S bulbs are still being sold in the EU), I decided to turn it into something modern! The 300W it consumed were too much anyway and I never really used it. With a LED-based solution I won't have to think twice before powering it up!

# What the lamp looks like

![The lamp](orig_lamp.jpg)
![Power cord](orig_plug.jpg)
![Top view - side](top_side.jpg)
![Top view](orig_top.jpg)

# Objectives

- Light output > 700lm
- Warm white because [cold white is bad for the eyes](http://ceolas.net/Docs/Zissis_et_alia_LEDs_and_Eyes_04_2011.pdf)
- Auto-dimming based on ambient light level
- Presence detection
- Dimmable via remote control (from webapp/computer/smartphone)

The last three objectives will be done separately - and described in another article. They're still relevant for this project because the result has to be compatible with what will be done later on, so we will take them into account when choosing parts.

# LED technology

Typical LEDs, as used to report information in millions of electronics devices, draw about 20mA and generate a negligible amount of light. Those are hard to use for lighting unless you use a lot of them. This is what LED strips do - they use normal SMD LEDs, put a lot of them next to each other, and voila! Unfortunately a LED strip is physically bulky, and although you can cut it, you still need a significant length if you want to use it for lighting.
Enter power LEDs. A power LED is a regular LED that is designed to emit a lot of light, at the cost of a high power consumption - and heat generation.

## Driving a power LED

LEDs are current-driven devices: their voltage is almost a constant, and brightness is controlled by the current through them. If fed with a typical constant-voltage power supply, and for some reason the voltage increases even a little bit, this will translate into a big spike of current, which will make the LED very bright for a few seconds, then very hot, and then very dead. That is the issue of power LEDs: they need a driver, which is a constant-current power supply. That supply can be powered by the mains, or by constant-voltage power supply.
If we look at our objectives, we will likely require some electronics, probably in the form of a JeeNode microcontroller board (handling remote control, taking action on presence detection, automatically dimming, as well as, perhaps, temperature and current monitoring). Electronics usually need a constant-voltage supply, so we'll go the way of a constant-voltage supply, and a separate LED driver.

## Cooling a power LED

Power LEDs may have better efficiency than incandescent light bulbs, they still dissipate a lot of power as heat. However, unlike light bulbs, a power LED:
	- has a small surface, so natural dissipation is reduced
	- cannot stand higher temperatures than about 100°C (unlike light bulbs which are happier the hotter they get)
So a heatsink is needed. I have no idea of its volume, having never used power LEDs before, but based on my experience with computer chips even a 20W power LED will require a fairly big heatsink.

## Choosing a power LED

There appears to be two types of power LEDs: 
	- 1-3W "stars" like ![3W star](http://www.futurlec.com/Pictures/LUXEON_3W_WW.jpg) (taken from <http://www.futurlec.com/>)
	- 10W-50W Chip On Board (**COB**) LEDs, combining multiple LEDs into a single package (see <http://www.cob-led.com/What-is-cob-LED-chips-on-board.html>)

The stars appear to more or less have their own heatsinking, while COBs need a separate and somewhat bulky heatsink. COBs also typically require a fairly high forward voltage - 30V appears to be a common value. Higher voltages tend to translate to higher efficiencies in the power supplies.
As I'm aiming for at least 700lm, I went for a power LED that can achieve this value, without making the wiring more complex - so a COB is probably a better choice. It's better if forward voltage doesn't exceed 12V: the electronics our project will have can't really stand more than 12V, and most LED drivers appear to be buck converters (they *reduce* voltage, they can't increase it). I picked a 10W COB from DealExtreme: <https://www.dx.com/p/diy-10w-1000lm-3300k-warm-white-light-led-module-12v-164358> - this one is advertised to have a 12V forward voltage. 10W is not much, and to achieve higher light output it would be better to aim for 20W or even 30W. However, this would mean a bigger heatsink, and also a bigger power supply and driver. The problem is that the power supply will need to fit next to the LED in the top "bowl" of the lamp, and there is *some* room but not so much. Due to being curved, most of the volume up there is unusable. 
Looking at available metal-cased 12V 10W 20W and 30W power supplies, it turns out only the 10W ones will fit easily in the top part of the lamp. Non-China-designs don't achieve a significant reduction in volume, so paying three times as much at Conrad or whatever popular reseller isn't going to help.
I picked a low-price, but CE-compliant, power supply, about which I reported in [another article](/~sven337/english/2014/04/15/Dangerous-Chinese-power-supply.html).

# Bill of materials

We need: 
- constant voltage power supply - 3.5EUR
- constant current DC-DC LED driver - 2EUR
- power LED - 5EUR
- heatsink - 2EUR
- microcontroller with PWM capability - 14EUR

Things could be simpler if there weren't the "extra" objectives described at the beginning. An AC-DC constant current LED driver, a power LED and its heatsink, and we would be done.

I tried to find a 12V COB power LED - most COBs appear to be require around 30V, but 30V is too much for a microcontroller, and settled on the one listed above. I bought a generic heatsink to go with it, keeping in mind that there are serious physical constraints in this project. The microcontroller, as usual, will be a **JeeNode**. 
The LED driver was a bit more difficult to find, because DC-DC 10W 900mA LED drivers don't appear to be that easy to find! I picked <http://www.dx.com/p/mr16-1-3w-650-700ma-constant-current-regulated-led-driver-8-40v-input-13557>. The description doesn't appear to match, but the module is based on a [PT4115](http://www.micro-bridge.com/data/CRpowtech/PT4115E.pdf) chip which is rated for 1.2A and has a **DIM** pin available. I will need to modify the module to change its current output to the **950mA** my LED wants, and expose the **DIM** pin.

I also bought 7 meters of 3 * 0.75mm^2 electrical cable, to change that of the original lamp that was too short, and a male rewirable EU power plug with ground pin (which is the first time in my whole life that I bought an item more expensive on the Internet than in a physical shop).

# Implementation

