---
layout: post
title:  "Low power wireless gas meter monitoring"
date:   2014-03-12 01:02:03
categories: english
---

# Monitoring gas consumption

I monitor my consumption of gas and electricity. I've covered electricity in a previous article, in French only because it only applies to meters from our national power company. The setup uses a Raspberry Pi and a custom electronics board to interface the meter to the Raspberry Pi. We'll use the same Raspberry Pi for gas monitoring.

# Constraints

I have a Actaris G4 gas meter, located in the hallway outside of my apartment. For technical reasons, an electricity meter will always be located near a source of electricity and a place where networking cables can be installed - this is not the case for gas and water meters, which are usually located in a where no electricity is available, and no Ethernet cable is present.
This implies that the system must be **battery-powered** and must use **wireless transmission**. Low power consumption will be a major objective, as I don't intend to change batteries more than once a year. 
Another objective is for the system to be **low cost**. My budget is a total of about 35EUR.

# Architecture

## Getting data from the meter

## Transmitting data to a server

# Hardware implementation

## Pulse sensor
## Wireless transmitters
## Microcontroller
## Batteries
## Case

# Software

## On the JeeNode
## On the Raspberry Pi
## On the web server

# Feedback and lessons learned
