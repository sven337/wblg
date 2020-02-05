---
layout: post
title: Raspberry Pi "UPS" backup battery using a mobile power bank
date: 2016-07-08 10:21:56
tags: electronics
category: english
comments: true
img_rel: "/~sven337/data/piups"
disqus_comment_thread: RPiPowerbank
---

I decided to write this article because I could find no reliable account on the web of **what mobile power banks** will work as a **battery backup for a Raspberry Pi**.

I use a Raspberry Pi at home as a server for a few of my home automation devices. I also use an old eeePC as an e-mail server and for the more demanding tasks. The big flaw of the Pi is that, unlike the laptop, it isn't tolerant to mains failures. Every time there is a storm, power gets cut for a few seconds to a few minutes, and that **reboots the Pi**, making it sometimes lose data, and forcing me to manually intervene. I wanted to add a battery to the Pi such that it could behave like a laptop: have some run time even without mains power, even if it's not a lot. This turned out to be a more difficult adventure than I had anticipated.

# Possibilities

There are multiple possible ways that people have implemented. 

## Battery backup without a charger

The simplest solution that comes to mind is to hook up batteries of any chemistry to a 5V output DC-DC converter, and to connect that in parallel to the Pi's power supply port. 
There are two problems with that solution :

- The batteries will slowly discharge due to the quiescent current of the DC-DC converter, and as there is no charging circuit, you will have to manually pull them out and charge them from time to time. It is highly likely that when a power failure happens, the batteries are already half empty or worse!
- Connecting the battery pack in parallel to the supply port requires surgery on either the Pi (soldering wires) or its mains power supply wire. In neither case is this particularly difficult, but it is inelegant.

## Battery backup with bespoke charging circuit

The lack of a charging circuit is a problem, so why not add one? For nickel or lead cells, it's not *too* difficult to build a charging circuit that will work *well enough*. However the circuit will never be as good as a properly engineered product, it still represents more components that one might want, and the only chemistry that wouldn't require many cells is lithium, which is dangerous to charge in a DIY manner. 
So I gave up on the bespoke charging circuit, even though I'd like to implement one some day.

## Battery backup with commercial charging circuit

Naturally, it would be best to have a battery with an integrated boost module to output 5V, and an integrated charge circuit, that could be plugged in series with the power input, just like a real UPS...

## Why bother?

... and this already exists: it's called a **"mobile power bank"**, and is basically a **lithium battery** with a 5V **boost module** connected to a USB port, with a **micro USB port for charging**. This is used by people who have modern mobile phones - very mobile, but not for long, because every day or so they need to be recharged. I like my old phones that last a week on battery, thank you.

# Mobile power banks

Mobile power banks are common items that appear mainly as cheap gadgets, and a few premium brands. On paper, it looks like they provide **exactly what we want** for the Pi. We don't even need a very big battery, if all we are after (like I was) is a few hours of run time on battery.
These banks are made of a lithium-ion cell (the most expensive part *by far*) and a solid-state single-chip charge&boost module (with some external circuitry of course), and can be found for as little as a few euros.

## Wait, just about any of them?

Unfortunately, most mobile power banks **will not work** for our use case, because we want the ability to **discharge the battery at the same time as it is being charged**, and as of 2016, very few provide that! Specifically, we want the +5V output of the power bank to still be present when its input is connected. Otherwise, it will **cut power to the Pi while it is charging**, that is, as soon as mains is present, the Pi will not be powered. This is impossible to work around without, yet again, some wire surgery that I deem inelegant. 
We also want the transition to battery powered mode to be instantaneous : if it takes too long, the Pi will shutdown because the battery will not have done its backup role fast enough. 

Unfortunately, it seems that most devices on the market use the exact same chip, whose reference I forgot. That chip's boost module (the output) is off while the battery is charging, so most mobile power banks, especially the cheaper ones, are useless for our purpose! Worse yet, "manufacturers" (importers, really) will change the specification without changing the model number, so I wasted about ten euros on a **Logilink PA0064 power bank**. Earlier versions of the device used to work, as evidenced by [that Youtube video](https://www.youtube.com/watch?v=6nh11axTXQo), but mine didn't, and the manufacturer claims that it never did.

![Logilink PA0064 - do NOT buy](LOGILINK_PA0064.jpg)

## Finally one that charges and discharges at the same time!

A received a "promotional" mobile power bank, an item that was given away by a company to make me remember them. I tested it and I was pleasantly surprised to see that it did charge and discharge at the same time, so it was usable... or was it?
The problem with that one is the following: its power rating is 1A, which is too low for what I'm running on the Pi, so the battery will slowly discharge, and end up cutting power to the Pi after a day and a half because it is completely empty.

A battery with a larger power rating, able to draw and source more current, is needed - and I kept this promotional power bank to use in other projects.

## Xiaomi power bank

A friend of mine reported that large **Xiaomi** power banks (20000mAh) were known to work, and I had heard the same thing from other places. However I was still wary due to the previously mentioned Youtube video being misleading. 

![Xiaomi 20000mAh power bank](xiaomi20k.jpg)

I ended up buying a smaller **Xiaomi 5000mAh** power bank for 14 euros, and I confirm that it works perfectly!

![Xiaomi 5000mAh power bank - I have this one and it works](xiaomi5k.jpg)


I got it from [Dealextreme](http://www.dx.com/p/xiaomi-universal-5000mah-li-po-mobile-usb-power-source-bank-silvery-365318). It's still a little more expensive than I would have hoped for, but it does the job without any hacking required, and that's something I appreciate once in a while!
<script>
    $(document).ready(function() {
		$("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>

