---
layout: post
title:  "Low power wireless gas meter monitoring"
date:   2014-03-12 01:02:03
categories: english
---

# Monitoring gas consumption

I monitor my consumption of gas and electricity. I've covered electricity in a previous article, in French only because it only applies to meters from our national power company. The setup uses a Raspberry Pi and a custom electronics board to interface the meter to the Raspberry Pi. 
Here, we will use use the same Raspberry Pi for gas monitoring, associated to other elements.

# Constraints

I have a **Actaris G4** gas meter, located in the hallway outside of my apartment. For technical reasons, an electricity meter will always be located near a source of electricity and a place where networking cables can be installed - this is not the case for gas and water meters, which are usually located in a where no electricity is available, and no Ethernet cable is present.
This implies that the system must be **battery-powered** and must use **wireless transmission**. Low power consumption will be a major objective, as I don't intend to change batteries more than once a year. 
Another objective is for the system to be **low cost**. My budget is a total of about 35EUR.

# Architecture and hardware

## 1-Getting data from the meter

### How does it report data to us, anyway?
This model of gas meter (and apparently most models) has a small magnet mounted on one of the digits of the liter (that's one-thousands of a cubic meter for those readers using a broken unit system). The magnetic field can be picked up by a sensor, in the very same way that bike speedometers work (magnet mounted on the wheel and detector on the fork).
Additionally, the digit *6* is designed to reflect light very well. This can be picked up by another kind of sensor.
Finally, we could try to use OCR. I'm sure some crazy (and incompetent) people have thought about it. I won't elaborate as to why this is the worst idea.

### Light

What sounds the easiest is to pick up the light reflected from digit 6. You need a LED, a photodiode, direct them both towards the front of the meter and you're in business... but this is not a good idea for the following reasons:

- you are required not to hinder meter reading. The meter is the property of the gas company (in France, at least). If you put something in front of it, you're bound to getting it ripped off, broken, stolen, or a combination of those.
- to detect a change in light reflection, you need to constantly emit light. The well-known [CNY70](http://www.vishay.com/docs/83751/cny70.pdf) reflective sensor is built just for that. It costs several dollars apiece, is fairly bulky, and draws at least 1mA *all the time* - you have to light the LED. On a typical 2000mAH NiMH AA battery (I'll write a separate article about why I'm sticking to this technology), that's less than three months of autonomy, not accounting for the electronics. 
- it requires placing the sensor at a very specific position and not ever opening the door again (for fear you'll add some light into the sensor and make it no longer detect pulses). This is likely to be unreliable in the long run.

### Magnetic

Going magnetic is a better solution. The Actaris G4 has a small depression intended for magnetic sensors. There are commercial ones, and homemade ones such as the one described there: <https://www.flukso.net/content/actaris-g4-pulse>. I built my own, naturally.

There are two technologies to detect a magnet passing in front of you. One of them is purely mechanical, the other is electrical.

#### Hall-effect sensor

Magnetic fields generate currents into conductors, and currents generate magnetic fields. One can use a Hall-effect sensor to generate an electrical signal when the magnet passes in front of the sensor. Unfortunately, those sensors are expensive, are active so they constantly draw current (see the paragraph about reflective sensors), and the datasheets are a little too much for my taste - there appears to be many different models of Hall-effect sensors, all of which with slightly different characteristics, and I just want this to work.

#### Reed 

A reed switch is made of two metal reeds inside a tiny glass bulb. The contacts will touch when a magnet is near them, making them electrically connect. This is completely passive: they draw no current, they cost next to nothing (fortunately so, because you *will* break many of them, so buy ten at once), and they provide a pretty clear numerical output instead of the questionable, comparator-requiring outputs of the other methods. So naturally, I went for reed switches.
(Some people complain about debouncing, that is supposedly difficult to do correctly with a reed switch. It's the easiest thing on the planet.)

## 2-Transmitting data to a server = Raspberry Pi

### Wireless data link

Wired transmission was out of the question. I had two solutions: storage onto a SD card that I would manually plug into the server every few months, or wireless transmission. OK, that's really only one solution.
Wireless transmission can be done in many different ways. There apparently are [WiFi interfaces for Arduino](http://arduino.cc/en/Main/ArduinoWiFiShield)! I shudder to think about the battery autonomy. Probably a few seconds. Then there are some more manageable protocols such as ZigBee, a bunch of proprietary protocols over the unlicensed 433MHz FM band (in Europe at least), and some others over the 2.4GHz band.
The choice boils down to: 
- will it <s>blend</s>go through two 60cm stone walls and 15 meters of indoors open space?
- will it cost a lot?
- will it consume a lot of power?

I choosed the [**nRF24L01+**](http://www.nordicsemi.com/eng/Products/2.4GHz-RF/nRF24L01P) transmitter, which is very inexpensive and - I found out after buying - goes across my walls without a problem. It has a low-power idle mode that is rater Mine come from there: <http://yourduino.com/sunshop2/index.php?l=product_detail&p=188>. You can't possibly beat that price - competing solutions are easily 10 times more expensive. If you're uncomfortable about buying from China, comfort yourself: everything is made there anyway. Might as well give money to the guys who make it rather than to the guys who import it.
The nRF24L01+ (say it a few times, you'll remember it) has a low power mode at about 1 micro-ampere, while the transmit (_TX_) mode is rated at 12mA (and receive mode - _RX_ - at 14mA, this is counter intuitive but in radio receiving costs more than emitting). We will not transmit all the time, we will actually transmit very little: once every pulse at most (and possibly a _heartbeat_ packet so the server doesn't think we're dead), then immediately go back to sleep. 

The bad news is that this chip talks over the SPI bus, which requires complex electronics to drive. We'll need a microcontroller, a simple circuit will never be enough.

### Microcontroller

### Pulse counting

We want to transmit every pulse we receive to the Raspberry Pi. What if it's currently powered down? What if our wireless packet wasn't properly received? Transmitting every single pulse is certainly a good idea, but we can do better at no extra cost, since we're buying a microcontroller anyway: **count the pulses**, and transmit the count (at every pulse) to the server. This way the server will never miss pulses (if it missed a packet, it will see that two pulses happened since the last, and our data is reliable even with packet losses, which happen a lot in wireless), and if it's powered down for some reason, when it goes back up, it will catch up automatically.
Counting pulses is just incrementing a counter, which a microcontroller that does SPI can do without a problem.

### Batteries
### Case

## 3-Receiving data on the server

# Hardware implementation and BOM

## Custom reed sensor
## Microcontroller, wireless transmitter
## Case and LEDs

# Software

There are **three** pieces of software.

## 1-On the JeeNode

The code on the JeeNode has the following responsibilities:

1. receive the pulses from my reed switch sensor and accumulate them
1. transmit pulse count over radio to the Raspberry Pi

## 2-On the Raspberry Pi

The code on the Raspberry Pi does the following:

1. receive the pulse count from the JeeNode
1. report the pulse count to a web-based application for storage and graphing

It does **not** store data or generate graphs, this is taken care of by a separate computer to which the Pi sends data over wifi. The Pi is not a powerful enough computer for certain things, and I already have an eeePC set up for various other tasks. You do this, by the way, with <http://dx.com/p/mini-usb-2-4ghz-150mbps-802-11b-g-n-wifi-wireless-network-card-adapter-black-120933> (unfortunately sold out as of this writing). Luckily, Linux has gotten to a point where USB controllers and wifi controllers almost all work out of the box (unlike on Windows 7 where some of them require separate drivers to be installed), and this dongle just worked without my doing anything.

Why, then, do I not have the eeePC receive pulses directly from the JeeNode, instead of going through this intermediary? 
The eeePC is a **computer** with USB interfaces for I/O and that is it. How am I supposed to get a SPI-based wireless chip to work on that? I could buy a USB<->SPI chip, but I don't know if this exists at all, and I have a Pi anyway which has a SPI interface already.

### Receive pulse
### Report pulse

### WiFi reliability 

A bit off-topic - the WiFi interface, being cheap, is somewhat unreliable, which doesn't matter all that much given that we send about 5 packets every minute, and they're not critical in the first place. Still, I have a script that periodically checks if the interface or the network went down, and electrically disconnects and reconnects the dongle to restore everything. It works beautifully, and I can take out the dongle or disable the wifi for whatever reason, everything comes back up automatically without me having to log on to the Pi - which I can only do over WiFi anyway. 
See ``https://github.com/sven337/home-monitoring-client/blob/master/data/check_wlan0.sh`` for details.


## 3-On the web server

A separate web server, which happens to run on a eeePC 701, receives the information from the Raspberry Pi, stores it, generates graphs, serves them over the web, makes coffee and ratatouille.

# Feedback and lessons learned
