---
layout: post
title: Régulation de chauffage central - thermostat d'ambiance
date: 2015-11-06 22:59:05
tags: electronics
category: francais
comments: true
img_rel: "/~sven337/data/acleis"
---
température ext de non chauffage environ 15°C

dans un premier temps, fonctionnement en tout-ou-rien (avec température raisonnable configurée sur la chaudière) basé sur l'heure de la journée, température intérieure (corrigée), et température extérieure.

int compute_burner_power()
{
	// Set target interior temp based on date&time
	datetime_set_target_interior_temp();

	// Compute power based on exterior temperature
	int power = process_ext_temperature();

	// Alter it based on interior temperature
	power = process_int_temperature(power);
	return power;
}

int process_ext_temperature() 
{
	// Is exterior temperature reliable?
	if (!ext_temperature_is_old()) {
		if (ext_temperature() >= 16) {
			// Stop heating at 16° outside
			return 0;
		} else {
			return 100;
		}
	} else {
		warn("Exterior thermometer is out of order.");
		return 100;
	}
}

int datetime_set_target_interior_temp()
{
	int hot_target = 210;
	int cold_target = 180;
	int target = cold_target;
	if (hot_period(datetime)) {
		target = hot_target;
	}
}

int process_int_temperature(int power)
{
	interior_temperature = (2*office_temp() + rdc_temp()) / 3;

	if (interior_temperature < int_temperature_target - 5) {
		if (!power) {
			warn("Exterior is at no-heat temperature, but internal temp is below target!");
		}
		power = 100;
	} else if (interior_temperature > int_temperature_target + 5) {
		if (power == 100) {
			warn("Exterior requests heating, but internal temp is above target!");
		}
		power = 0;
	} else {
		// Temperature is within internal constraints - heat or not based on exterior decision
		;
	}

	return power;
}


