---
layout: post
title: Automatic lighting in the bathroom using a motion sensor
date: 2014-03-30 21:22:39
tags: english
category: electronics 
comments: true
img_rel: "/~sven337/data/pir_ssr"
---

Automatically turning lights on and off is one of the first projects one thinks about when talking about home automation. We press switches dozens of times a day, sometimes when our hands are full, and we often forget to turn off the lights, which consumes energy and wears down the bulbs.
This article presents a project of automating the lighting of my bathroom. 

As usual with me, the goals are to design a simple, low-cost system. 

# Why?
## Incandescent light bulbs

I still use traditional light bulbs, because they provide a higher quality light and cost next to nothing. Unfortunately, basic incandescent light bulbs are no longer sold in the European Union. Instead we now have halogen bulbs within a standard glass bulb with E27 or B22 sockets. They emit a little more light at a given power level, live twice as long, and cost four times as much. The alternatives are naturally compact fluorescent lamps and LEDs. I hate CFLs but confess I haven't tested LEDs for room lighting. It's on my list.

The problem with incandescent bulbs is that they consume quite a bit of energy, so you don't want to leave them on when you don't need them. I wanted to make sure the lights would be off when nobody was in the room.

## Comfort

Pressing a switch is no big deal. But once you have fully working automatic lights, you realize that it *is* more comfortable not to have to press a switch. One gets quickly used to luxury! 

# How?

Following my usual bottom-up approach, the question of **what can I do** comes **before** the question of **what will I attempt to do**. So let's look at how an automatic lighting system works! There are two big parts: detect the presence of a human being (as well as the absence thereof), and actually turning on - and off - the light.

## Detect presence

A room needs to be lit whenever there is a human being inside. This sounds simple, but it's not that easy.

### Magnetic contact on door opening

A simple solution is to use a door-opened sensor, like alarms typically have. Reed switch attached to the side of the door, magnet on the door, whenever the door opens the contact is broken and we know that the door was opened. 
The question  **is the door opened?** sometimes strongly correlates with  **is there a human in the room?**, and we can take advantage of that in certain cases. However, this doesn't work for all rooms (toilets, bathroom, as you typically use those with the door closed), and it makes integration of the system much harder because the device will be fully visible. For those rooms where it works (walk-in closets, kitchen, garage), this is the easiest and lowest cost solution, but it can be awkward in the rare cases where you close the door while you're in.

### Infrared beam

Similar to a door-opened sensor, a infrared beam across the door frame being cut by the human walking in may enable one to detect when a person walks in and out. This breaks down quickly when two people are susceptible to walking in (I know, you can use two beams next to each other, but that's overkill). This fares better on toilets than the previous solution, but will not work on the bathroom or any other.

### Pyro-electric sensor

This strange name had me wondering at first - did I just read **pyro**? Do I want that in my house? As it turns out, the *eBay* listing for the device I'm going to talk about <http://www.ebay.com/itm/400330055400> is correct - there really is the word **pyro** in there.
Relax, though - pyroelectricity refers to the ability of certain materials to generate a voltage when their temperature changes, even for tiny temperature changes like that due to the infrared emissions of a warm body. 
A good article at <http://learn.adafruit.com/pir-passive-infrared-proximity-motion-sensor/> explains how the technology works (and the pictures are very similar to the device I've used). More details at <http://www.glolab.com/pirparts/infrared.html>.

Anyway, the principle of operation is that it detects **movement**. There is a very strong correlation between **movement in a room** and **human in the room**, so this choice is bound to be one of the most reliable, although it won't work everywhere (toilets).

### Pressure plates on the floor

Just kidding.

## Turn on the light

Once we know that a human is there, how do we power up the light? 

### Relay

The closest thing to pressing a switch (save for a cam that actually presses the physical switch) is a relay. Relays are noisy, bulky, somewhat expensive for the 230VAC variants, need a flyback diode, and the inexpensive non-latching ones need a *holding* current applied that is typically too high for a battery-powered circuit. (My original implementation was battery-powered, or at least needed to be able to be battery-powered, for reasons I'll explain below).

### Semi conductors

Semi conductors provide almost free switching capabilities. MOSFETs are plentiful, inexpensive, and can switch high currents while consuming practically nothing. But they only work on **DC** (direct current). If you want AC switching, you can use a triac, or a MOSFET located at the output of a rectifier. Fortunately, there are fully integrated triac-based AC switching devices called **SSR** (solid state relays), and they're not more expensive than relays. They do require a non-negligible holding current, though much lower than that of a relay. They're *very* bulky.

### Low voltage switching and dimming

Can we do better than **ON/OFF**? A LED-based lighting system that uses a dimmable driver (a real dimming driver with PWM input, not the stupid "dim me with a triac" drivers which will die in 15 days if you do) might be driven by a low power, low cost, low voltage solution. 
Alas, I'm still using incandescent bulbs, so I need 230V AC switching. Future circuits will be based on LEDs.

# Where?

- Toilets are probably the worst place in a house where one can attempt to automate the light switch, yet for some reasons they are typically the first room people think about - and I was no exception! The problem is that presence and absence detection in toilets is very difficult to do reliably, as we'll see later on. It's also critical - at least for men - that the light turns on and off at the right moment. Doing your business standing, with no light at all, is recipe for disaster. I do not believe it possible to reliably automate lighting in toilets - if you look at the three sensor mechanisms I've described, none of them will work reliably for toilets.
- The bedroom is out for the very same reason - you close the door and stay static inside it for a lot of time. You definitely don't want lights to be turned on at full power in the middle of the night because you're turning over. 
- Walk-in closet is a good idea. It's got a predictible usage pattern and all three sensor mechanisms apply.
- Bathroom similarly will work well with a motion sensor except when you're taking a bath. I wish to discourage my family from taking baths. I don't mind if the lights go out while they're in the bath. 

For integration reasons (see further down), I decided to work on the bathroom first.

# Implementation

## Detection

I used a practically free motion sensor: <http://www.ebay.com/itm/400330055400>.

## Load activation 

My bathroom lights are low voltage 12V halogen bulbs, powered by a 230V AC transformer. It is very easy to connect a relay between the live wire and the transformer, cutting the transformer's output to place a MOSFET there would have been feasible as well but I didn't want to cut the wire there because I don't own the transformer.
So I went for a 230V AC **SSR-25DA** SSR, bought from eBay for 3EUR.

The sensor output can't (as I found out) turn on the SSR, because it doesn't provide enough current. I had to use a transistor (a cheap MOS I had lying around in a toolbox, from a computer monitor power supply repair job) to provide enough current to the SSR.

## Integration

This is a big topic. First of all, we have safety constraints - we're switching mains voltage, which means that good isolation must be employed, a closed plastic case is unavoidable, and the case must not be accessible to chilren or house guests.
Then, there are electrical issues, and significant looks constraints - for the sensor to see you, it needs to be visible to you. You may try to hide a little bit, but there's always going to be a lens pointed at you that you can see. If it's too ugly, the wife will yell, and you can say goodbye to her.

### **Safety & legal**

You're about to follow instructions from some random guy on the Internet. If you are uncomfortable in any way with electricity, or unexperienced in working with mains voltage, you may hurt yourself and your family. This project is dangerous if you do not know what you are doing. **I shall not be responsible for whatever happens to you.**

I bought plastic "project boxes" off eBay, unfortunately they turned out to be too small (by one millimeter) to accomodate the height of the solid state relay. This means that I can't close the case firmy, and instead it holds with adhesive tape. Luckily it's located 2 meters off the ground so nobody can put their hand there unintentionally. I'm still not very happy with that situation.

### Electrical

Up to now it was a walk in the park. Just find the components, assemble them, put them in a case or something, and we're done. Except: 
- the sensor needs to see you and send its output to the mains-switching components. The mains-switching components occupy a large volume, and such a volume may not be readily available next to any ideal position of the sensor!
- the sensor needs to be powered with +3.3 .. +12V DC

One might think about physically replacing the switch by the sensor and mains-switching components. In Europe this is unlikely to work for an amateur design because our "boxes" in the wall (behind the switches) are too small to accomodate everything, unless it's very tightly integrated. Even industrial-scale circuits such as <http://www.ebay.com/itm/370689906940> **DO NOT BUY THIS IF YOU ARE IN EUROPE** will not fit in french boxes, which are round and not square like the american ones. (You shouldn't buy this item since it doesn't have **CE** markings and is therefore, to the best of my knowledge, illegal to import in the EU.) Powering the sensor might be done with a transformerless power supply (that's what the device above does), but its design will be quite complex because light switches in France **only operate the hot wire**. The neutral wire is not connected to the switch at all, instead it goes to the lamp directly. We could also use a battery, and that's why I designed this to be battery-operated originally.

My bathroom has light fixtures over the mirror. Mains wiring comes at the top, and connects to the transformer there. Everything is just placed on the top side of the fixtures, as if it was a shelf. A normal height human being won't see anything there. Naturally, I decided to lay my device there, where a large volume is available. I hardwired to physical switch to "always on", ensure that 230V AC would constantly be present on the SSR.

My original implementation used batteries, but was using them a little too quickly to my taste, so when came the opportunity to salvage a low voltage wall plug adapter I took it. It's a linear unregulated 13V DC adapter.

### Appearance


# Feedback 

The system isn't tightly integrated, but the 
# Further work
