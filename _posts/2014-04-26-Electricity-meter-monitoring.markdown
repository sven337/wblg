---
layout: post
title: "Electricity meter monitoring with Raspberry Pi"
date: 2014-03-26 22:17:00
category: english
img_rel: /~sven337/data/teleinfo
---

This article is a short translation of <http://perso.aquilenet.fr/~sven337/francais/2014/03/09/Suivi-de-consommation-elec-avec-R-Pi.html>. It describes how to monitor electricity consumption with a Raspberry Pi and simple electronics, on a french meter.

# Table of contents
{:.no_toc}

1. contents placeholder
{:toc}

# La sortie téléinfo

All recent french meters by **EDF** have a *teleinfo* hardware output. Mine looks like that: !["Compteur A14C5"](compteur.jpg). 
The screw opens a door to two contacts labelled I1 and I2. Those contacts carry a signal with a documented protocol (in French) <http://norm.edf.fr/pdf/HN44S812emeeditionMars2007.pdf>. The meter reports information through that interface every second. This information includes, but isn't limited to:
- current power in watts
- index of the meter
- peak/off-peak hours (which I don't care about because my subscription is a flat kW.h rate, which is less expensive in my case)

This protocol is standard, but it's not compatible with typical computer (or electronics) protocols, so conversion is needed. Luckily, the teleinfo protocol was designed to be close enough to **RS-232** that the job is not very hard.

The signal is as follows: a **0** is a **50kHz sine** from **-12V** to **12V**, a **1** is a constant **+0V**. I've designed a circuit that converts that into TTL-level RS-232, as required by the Raspberry Pi.

# Previous works

Detecting the light pulse on the meter is a common solution, but it's inferior to this protocol both in terms of reliability and exhaustivity. I'm ignoring these.
Many people have also realized a system similar to mine, but they went for a more expensive solution than I liked, by working with USB UARTs and real RS-232 signal levels, neither of which are needed if you're using a R-Pi. The simplest circuit is that (in French) described at the following webpage, but it makes use of a hard-to-find and expensive optocoupler: <http://www.chaleurterre.com/forum/viewtopic.php?t=15153>.

My solution uses more components, but they're much easier to find and less expensive overall.

# Architecture

I'm skipping the details as they really only pertain to EDF meter users, who read French. The circuit is a simple rectifier with a basic filter and optocoupler at the output.

This is the input from the meter:
![Meter input](spice_input_signal.jpg)


This is the output with full-wave rectification:
![Full wave rectifier output](spice_output_4D.jpg)

## BOM 

- 1N4148 diode, 10x on eBay for 1EUR
- PC817 optocoupler, 10x on eBay for 1EUR (one's enough, you get nine others to play with)
- basique 1/4W resistors from a kit such as <http://dx.com/p/1-4w-resistance-metal-film-resistors-400-piece-pack-121339>
- 22nF ceramic disc capacitor, 10x en eBay for 1EUR
- mini breadboard for prototype, prototype PCB for final realization, ...

## Assembly

![Assembled device in its cardboard case](montage_final.jpg)


# Software

The device will send data to the Pi's serial port. C programs I wrote read the data, accumulate it over one minute, and pass it on to a web application for storage into a ``rrdtool`` database. 

The programs are on my Github account: <https://github.com/sven337/home-monitoring-client>.

# Graphs

## RRD graph
![RRD electricity consumption over a week](teleinfo_rrdgraph.png)

Interesting information is present on this graph, with fairly large granularity. I spent a lot of time cooking on Friday night - both the oven and the induction stove were on at the same time. You can also see that I cooked on Tuesday at noon in addition to the evening, while I usually only cook in the evening (I don't remember *what* I ate and that unfortunately isn't on the graph). 
On Wednesday I unplugged the system to take the pictures on this very page.

Energy total and associated cost are computed by RRD as part of ``rrd_render_graphs.sh``.

## Javascript graph
![Day consumption](teleinfo_jsgraph.jpg)

This is an interactive Hihcharts-based graph, created from the same data exported by ``rrdtool``. On this screenshot, data over a single day is visible.
The fridge's compressor started up at 1AM and ran until 2AM, then again at 4AM until 5AM. I got up at 8.50AM and powered on my computer (which stays in _suspend to RAM_ overnight). Right before noon, there is the typical consumption curve of one induction plate used to cook pasta: _booster_ mode for a few minutes at 3.2kW (until the water boils), then 1.75kW (80% load) for the rest of the time.
Then there is the electric water boiler for tea, vacuum cleaner, hair dryer... with a baseline of about 300W (computers, mechanical ventilation, fridge) during the day, and about 600W in the evenings (incandescent lighting).

<script>
    $(document).ready(function() {
		$("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>

