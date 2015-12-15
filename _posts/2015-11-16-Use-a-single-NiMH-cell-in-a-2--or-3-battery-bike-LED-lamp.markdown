---
layout: post
title: Use a single NiMH cell in a 2- or 3-battery bike LED lamp
date: 2015-11-16 18:44:44
tags: electronics
category: english
comments: true
img_rel: "/~sven337/data/ledlamp_boost"
---

I have a LED lamp for my bicycle. It uses 2 AAA batteries. I've used it for some time with rechargeable NiMH AAA batteries, but these have a lower voltage and this means the lamp is not as bright, also, NiMH Eneloop batteries are pretty expensive.

Luckily, chinese factories have very cheap boost modules on sale - on eBay you can find modules with a description as follows: *DC-DC ( Input 0.8-3.3V ) ( Output 3.3V ) Step-UP Boost Voltage Converter Module* that cost 3 dollars, which is essentially the same cost as a quality AAA NiMH battery. Wouldn't it be cool to use one fewer battery in the lamp? It literally took me fifteen minutes to do the project.

![A cheap, 3.3V boost module](boost-module.jpg)

Running with two AAA NiMH batteries, I had 2.8V and a current of about 60mA.
After replacing one of the batteries with a 3.3V boost module (that's higher than the voltage two alkalines would give!), the LED draw a current of about 150mA, which is somewhat over the rating of the boost module (meaning it's going to heat up a lot and perhaps even burn? This needs careful testing.)
The lamp is much brighter now, and uses only one battery. Of course I'll have to recharge it more often but that doesn't bother me much.

![](bikelamp_1.jpg)
![](bikelamp_2.jpg)

<script>
    $(document).ready(function() {
		$("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>
