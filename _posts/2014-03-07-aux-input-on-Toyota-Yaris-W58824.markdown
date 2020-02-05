---
layout: post
title:  "DIY - Add AUX input on Toyota Yaris W58824 head unit"
date:   2014-03-07 21:16:55
categories: english
img_rel: /~sven337/data/w58824
disqus_comment_thread: YarisAuxEN
---

# Objective

Add a **AUX input** to a **2007 Toyota Yaris** from Europe, featuring a **W58824** head unit (Toyota model **86120-0D210**, Panasonic model **CQ-TS0570LC**).

I want to report on my attempts, so that people who have the same purpose know what to try and what has already been tried.

# Introduction
I have a french Yaris with a W58824 head unit (radio, CD player with MP3, no USB host, no aux input). This device is special in that unlike the american Yaris many people here report about, it doesn't have an analog AUX input, nor an AUX button on front.

I have, naturally, attempted to plug a jack on the **D74** connector, using the pinout described in the (**US**) Yaris repair manuals available on the Internet <http://microimageonline.com/forums/showthread.php?4232-YARIS-REPAIR-TECH-TSB-FILES>. I confirm it doesn't work: there is no way to tell the head unit to switch to the AUX input (no AUX button, none of the other buttons work to that effect either). I believe the pins are actually reused for other things on the W58824 - and others are used for the steering wheel commands.

![D74 used for steering wheel controls](conn_SW.jpg)

**So what are the remaining options?**

1.**emulate a CD changer**
2.**inject AUX input at CD reader output**
3.**inject AUX input directly at amplifier input**

Emulating a CD changer is harder than it seems. This unit does have a CD changer connector, but it uses **AVC-LAN**. You need some electronics to talk to the unit over the AVC-LAN bus, to make it think that there is a CD changer. Refer to <http://www.softservice.com.pl/corolla/avc/avclan.php> for details. Although my skills would enable me to do that, I was looking for a simpler and less expensive solution. An AUX input isn't that great as compared to just plugging a USB thumb drive with MP3s, so that isn't worth a lot of time nor money to me.

**2** and **3** require dissassembling the unit, and I thought I would report on that - and my subsequent failures at both options - so that others can take it from there.

# Removing the device from the car

This is documented in various places. Quick recap:
- The two plastic parts on the side can be removed by gently pulling, starting from the bottom and working your way up. At the top, where the warning button and passenger airbag warning lie, you have to put a little more strength, taking care not to rip the connectors off.
- Then, four screws are accessible and can be removed. You'll need a magnetic screwdriver not to lose them.
- The plastic frame for the speed meter/clock is treacherous, as it uses "back facing" claws to hold the unit in place. You have to lift the frame very carefully and take out the three claws before you can start pulling on the radio.

![](front.jpg)
![back_connected.jpg](back_connected.jpg)
![conn_main1.jpg](conn_main1.jpg)
![conn_main1p.jpg](conn_main1p.jpg)
![conn_main2.jpg](conn_main2.jpg)

# Disassembling the device
To disassemble the device, after you've taken it out of the car, you need to:

![back.jpg](back.jpg)

- remove the black ventilation "tunnels", which are clipped to the plastic front of the W58824 by 3 clips on top and 3 at the bottom. You have to lift very carefully the bottom ones first, then pull on the front a little to free the 3 top clips.
- remove the front of the unit. This is by far the most difficult step. The front uses those annoying **hard plastic clips** that tend to break if you look at them the wrong way. There is **NO screw** to take off, it's just the clips that hold the plastic front to the metal frame! Very carefully, free them one by one. I had to get help from another person to simultaneously pull on the metal frame. You can pull with quite some strength without risk.
- remove all screws you can see :) and try to remember where they go. The unit is made of a mainboard and a separate CD player. Its design is actually quite similar to that of another Panasonic unit, **CQ-TS7471A**. The repair manual of that unit is [available online](http://www.s-manuals.com/pdf/car_audio/panasonic/panasonic_cq-ts7471a_%28toyota%29_service_manual.pdf) and will help us for the electronics part.
- pay attention to the **ribbon cable** between the CD player and the mainboard! It is accessed by removing a small metal plate on the side of the unit. Remove it before completely separating the boards and starting to look at them. I tore it a little bit, without any adverse impact, but play it safe and remove it first.

![front-noplastic.jpg](front-noplastic.jpg)
![side.jpg](side.jpg)
![side2.jpg](side2.jpg)

## Electronics

Unfortunately, it seems that most of the chips present on both boards are either internal Panasonic components, or very confidential designs, as I was able to find practically **no datasheet** on the Internet!
That's where the aforementioned repair manual helps you - the chips are different, but some of the names, and the general architecture, are identical.
One difference I am aware of is that the **CQ-TS0570LC** (Panasonic's name for the W58824 unit we're looking at) has **MP3-data-CD ability**, which the **CQ-TS7471** doesn't have. I have not been able to find out which chip was responsible for decoding the MP3. I would expect the **main DSP** on the mainboard to take care of it, but the 14-pin interface between the CD reader and the motherboard hasn't changed from the CQ-TS0570LC.
Perhaps the **serial data** pins are used to transfer the mp3 contents, I am not sure. I hope the interface remains analog, because if it isn't that will destroy option 2 (inject AUX at CD reader output).

## CD reader output

![cdreader_board.jpg](cdreader_board.jpg)
The CD reader connector has fourteen pins, of which three pins are interesting - Left, AGND, Right. Identify them - refer to the repair manual linked above. On the mainboard - sorry I don't have pictures - they are the three top pins of the connector, next to each other. On the other side of the connector is a +8V power supply, with a trace which is physically a little further away, and a capacitor next to it. You don't want to get the connections wrong. :)
So you can hook up your jack connector there, that's what I did. There are tiny vias next to all of those pins, if you have wire that is thin enough (I used single strands of copper wire). Good luck soldering them. I destroyed part of a trace, without any impact on functionality. Still, you have to be confident in your abilities because this is tiny, and I actually wasted more time on that aspect than I thought possible.
The problem I had was that it **didn't work**. When I plugged the jack connector (I used a male cable instead of the more common female sockets people use for AUX inputs) into the MP3 player, the sound from the currently playing CD was completely muted (overpowered?), but I didn't hear anything from the MP3 player. Note that I neglected to put **small capacitors** in series with both channels on the jack connector. This is unlikely to explain the issue. I was quite tired by the time I tested, and don't have an oscilloscope available, so I couldn't easily check if I made a simple mistake or if the CD reader output cannot easy be highjacked.

Note that [other people have succeeded in this approach](http://archive.is/7wo4f) (on another car) - link updated in 2016 to an archive link as the website seems no longer to be up.

## Amplifier input

![mainboard.jpg](mainboard.jpg)
The amplifier is pretty easy to identify on the mainboard. If you can't spot it within 15 seconds, please reassemble everything and gain more experience before you mod a car radio. Mistakes are expensive here (I ran across a Panasonic repair prices document, this is pretty scary stuff.)

The center pins have four easy to notice tiny traces, with a slightly bigger one in the middle. Those are the **Front**L**eft/**F**ront**R**ight/**R**ear**L**eft/**Re**ar**R**ight and **GND** traces. You can identify them easily since the other pins of the amplifier are outputs and consequently have larger amounts of copper to them (wider traces). You can attempt to plug your jack connector there.
The problem I had was that it didn't work either. Again, the signal would be muted (overpowered?), but it's not like I heard anything from my MP3 player either. Do note that I still didn't have capacitors in place, and also as I realized later this unit uses a small preamplifier. For all I know the signals levels were completely wrong, and should have been injected before the preamplified instead.

# Future work

I'm giving up on 2) and 3). The connections are hard to make, and my attempts didn't work. An AUX connector is just not worth more than the 7-and-a-half hours I spent on this small project.

A second try on the CD reader might be interesting. Hooking up to the preamplifier sounds like the best strategy, however.
You may want to try injecting the signal at the radio's output, but I'm not sure it would make any difference.

I need to learn more about the signal levels at the output of a CD reader and on a typical 3.5mm jack connector.

<script>
$(document).ready(function() {
		$("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>
