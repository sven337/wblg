---
layout: post
title: Thoughts on the Xilence XPXQ-1000R4 computer power supply unit
date: 2015-01-26 21:28:57
tags: electronics
category: english
comments: true
img_rel: "/~sven337/data/xilence"
---


A friend of mine bought a Xilence-branded power supply. The model is XPXQ-1000R4, a one-kilowatt "silent" power supply.

![Label](label.jpg)

It died after barely a year of light use, with the computer exhibiting symptoms that were at first puzzling: the computer would suddenly reboot, many times, every time it was started up in the morning. After about 30 reboots (presumably once the power supply had warmed up), it would be stable, until the next time it was powered down.
All other causes were ruled out, and the definitive confirmation came when said PSU was replaced by a Seasonic P860, widely recognized as one of the best PSUs money can buy. Since my friend had no use for the Xilence PSU, he gave it to me and I've looked inside.

This article describes my analysis of the failure, including the design issues that make this model an absolute must-not-buy in most use cases. 

# Xilence 1000W and 850W power supplies

First of all, the 1000W model is using the same base design as the 850W version that was reviewed here: <http://www.techpowerup.com/reviews/Xilence/XQ_850W/>. The difference is that the PCB is fully populated, but otherwise it's very similar. The manufacturer is Solytech, a well-known OEM.

The link above has pictures that look better than my own, so I'll use them whenever possible. Even though the pictures are good, I think the "review" they wrote isn't good because it missed several important points, including the design flaw that I believe caused the failure I've seen.

## Semi-passive

I've seen this PSU before it broke and I must say one thing: it's very silent. The reason for this is that it's **semi-passive**. The PSU doesn't even spin its fans if it's running below a certain load threshold (I believe it is 30%). This is awesome for silence. We'll see later on why it's a major mistake on this unit.

## Suspicious manual modifications

An important point that wasn't mentioned in the article, and do note that I'm using **their own pictures**, is that very sloppy reworks had been done on the PCB of the PSU that they received.
I've annotated the crazy parts below. This kind of thing is seen very often in electronics manufacturing - but not on a production-stage product!

![Sloppy rework](PCB_back_annotated.jpg)

And don't tell me that it's just the "reviewer sample" they received, because my PSU, bought 18 months later, has exactly the same thing:

![Sloppy rework - still doing it](PCB_back_my.jpg)
![Sloppy rework - closeup](rework_closeup.jpg)

Just this is enough to worry a little bit about the attention this power supply design received.

## Capacitors

Everybody knows that electrolytic capacitor failures are the number 1 cause of failure in power supplies. Most components don't really age, but electrolytic capacitors do, and temperature is their enemy. The choice of a particular brand of capacitors has real impact on the reliability of the power supply, but all capacitors will die some day. They're usually only rated for a few thousand hours of runtime at 105°C.
This power supply uses a few Chinese brands of capacitors which aren't known for their quality. Usually, the filtering capacitors at the output of the power supply are the ones that will die first. 

# The failure

The failure is easy to see.

![Leak of electrolyte](leak.jpg)
![Closeup on the leak](leak_closeup.jpg)

The leak comes from the input capacitors (not the typical failure). 

![PFC capacitors](pfc_caps.jpg)

## Semi-passive on 1000W = fail

Semi-passive is a nice concept, but it has to be implemented correctly. Not running the fans at all until you reach 30% load is OK on small capacity power supplies, because the threshold *will* be reached from time to time. On a 1000W PSU, setting the threshold at 300W means that the PSU will be running for hours, if not days, without ever spinning its fans. And I can attest, having watched the power supply fans while my friend was playing demanding video games, that there doesn't appear to be a thermal trigger for the fan. 

## Capacitors touching heatsink and active components = fail

Worse yet, the capacitors are clearly seen on the picture to be in contact with the heatsink for most of the active components in this power supply. So the MOSFETs and diodes are going to heat the capacitors, and this is what caused this early failure.
I'm not sure that I wish to fix the unit: given this design flaw it will fail again unless I hack the fan control so that the fans run more often.

# Thoughts on the brand

I think it's pretty clear what I think of this brand of power supplies.
<script>
    $(document).ready(function() {
        $("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script> 


