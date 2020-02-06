---
layout: post
title: Dangerous Chinese power supply
date: 2014-04-15 18:32:39
tags: electronics
category: english
comments: true
img_rel: "/~sven337/data/chinese_smps"
disqus_comment_thread: ChineseSMPS
comments: ChineseSMPS
---

I bought a cheap, Chinese, [12V 1A power supply](http://www.smunchina.com/html_products/10W-12V-Ultra-thin-single-output-series-186.html), to use in my LED lamp retrofit project (about which I've been writing an article for weeks, but it's not published yet). It's marked CE (meaning it respects European norms, which essentially have to do with EMI interference), but it still has a serious problem.

# The power supply

Below are pictures of the accused. While the power supply is cheap, it's not one of the cheapest. There is an EMI filter on the input side, it's got a fuse (yes, there are supplies without fuses...), and overall doesn't appear to be a very poor design.
However, this is sold as a "supercompact" supply, in a metal case - and the metal case touches components inside, effectively **connecting it to mains voltage**! I'm lucky to have noticed it before actually plugging it in!

![Power supply - red tape visible](outside_fixed.jpg)

# Metal case danger

The fuse inside (see picture below) is installed vertically, and its top lead touches the metal case - or if it doesn't, it has about a quarter of a millimeter of clearance, which is dangerous in case of a surge, and dangerous in case you touch the case because pressing it even very slightly will make contact. The supply has an "Earth" pin, tied to the metal case - because every time you have a metal case and mains together, you **need** an Earth connection!
If you've connected the Earth pin, and have a proper residual-current circuit breaker ("disjoncteur différentiel" in French), the breaker will trip as soon as the plug is connected, electricity in the house will be cut, and you won't die - and probably not get a shock at all, unless you're touching the power supply right as you plug it in.
If you've neglected to connect this pin, you'll have a 50% chance of **getting a nasty shock**, depending upon whether it's the *hot* or *neutral* wire that touches the case. (Do note that if you follow the wiring diagram on the supply, it's the neutral wire that ends up touching the case. As a result, the power supply will trip the breaker, but will not tase you - **assuming your power plug has a standard L and N wiring**, which isn't the case of European plugs!)

# How to secure it

To safely use this power supply, you need to:

- add a few layers of electrical tape to isolate the case from the fuse's top lead. My tape isn't really mains rated, but I'm pretty sure it will isolate well enough. See the pictures for where to add the tape.
- check with a digital multimeter than L, N & GND are *not* in contact before you plug the power supply
- do the same check while pressing on the case
- move the big resistor a tiny bit to increase creepage distance

(Disregard the blue annotations which are not relevant to safety.)

![Isolating the case from mains](case_internal_tape.jpg)
![Internals](internals_annotated.jpg)
![Output resistor creepage distance](creepage.jpg)
![Not dangerous but strange](resistor_wtf.jpg)

# Internals

This is a typical switched-mode power supply. Let's take another look at the "internals" picture, this time paying attention to the blue annotations.

The different stages of the supply are:

1. the fuse (marked "danger" on the picture for the reasons exposed above. I haven't checked its current rating)
1. the red capacitor and the choke, which act as an EMI filter. This supply is low power enough that no PFC circuit is required by EU regulations.
1. the bridge noted **E** - it is a [DB157](http://www.rectron.com/data_sheets/db151-db157.pdf) bridge rectifier. This appears to be a standard, low-cost rectifier which doesn't deserve particular comments.
1. the large electrolytic capacitor marked **A**. It is a 10 micro-farad capacitor, 400V rated. The capacity sounds a little low, although I'm mostly experienced with larger power supplies so I'm not sure how low that really is.
1. the IC at **B** is a [**VIPer22A**](http://www.st.com/web/catalog/sense_power/FM142/CL1454/SC432/PF93117) chip that integrates a power MOSFET and a PWM controller
1. **D** is the step-down transformer
1. **F** are the output diodes, generally this is a Schottky barrier but I suspect those are regular silicon diodes and not Schottky ones. Not a major problem for a 1A rated power supply, but efficiently is probably not great.
1. **C** is the feedback optocoupler
1. The rest of the components are for output filtering and voltage sensing.


![Input capacitor](input_stage.jpg)
![Bridge](input_stage2.jpg)
![PWM and MOSFET IC](driver.jpg)
![Output diodes](output_diodes.jpg)
![Back](back.jpg)

<script>
    $(document).ready(function() {
		$("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif']").attr('rel', 'gallery').fancybox();
    });
</script>
