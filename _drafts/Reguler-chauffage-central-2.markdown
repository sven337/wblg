---
layout: post
title: Régulation de chauffage central - thermostat d'ambiance
date: 2015-11-06 22:59:05
tags: electronics
category: francais
comments: true
img_rel: "/~sven337/data/acleis"
---

Dans le précédent article nous avons vu un prototype permettant de contrôler la chaudière. Dans cet article nous verrons le dispositif qui envoie les ordres à la chaudière en fonction de différents paramètres.

Il s'agit ici uniquement de logiciel, qui fait intervenir :

- un thermomètre intérieur (DS18B20, nRF24L01+) présent dans ma [lampe de bureau](/~sven337/english/2014/05/08/Transforming-halogen-lamp-into-LED-lamp.html)
- un deuxième thermomètre intérieur situé dans une autre pièce
- un thermomètre extérieur (DS18B20, nRF24L01+, NiMH 1.2V, module boost, panneau solaire, projet que je n'ai pas encore décrit sur ce weblog car il a été victime du **syndrome du prototype** : on fait quelque chose, ça marche du premier coup, on le met en place sans jamais le mettre au propre parce qu'il marche parfaitement, et on l'oublie)
- une interface permettant de choisir le mode COLD, HOT et AWAY, le changement étant réalisé à travers une crontab
- un programme serveur qui, en fonction du mode en cours et des températures, calcule s'il faut activer le chauffage ou pas

# Données d'entrée

Le principe du contrôle climatique pour le chauffage est de se baser sur la température extérieure, afin d'anticiper les variations éventuelles de température intérieure. Je crois que c'est souvent mis en oeuvre dans les grands bâtiments tertiaires, en revanche cela me semble moins justifié pour une habitation. Dans le cas présent je souhaite me baser sur la température intérieure afin que les apports de chaleur, par exemple ceux de l'électroménager ou de la cuisine, soient pris en compte.
Voici l'approche que j'ai retenue :

- une "température de non chauffage", d'environ 15°C d'après les différentes pages web que j'ai lues (à ajuster à l'usage). Cette température est un seuil de température extérieure à partir duquel on arrête de chauffer.
- un calcul de température intérieure, sous forme de moyenne pondérée de différentes pièces (sachant que le poids change selon nuit/jour)
- une décision binaire chauffer/pas chauffer selon la comparaison de la température de l'étape précédente avec une valeur de consigne (différente selon le mode "chaud" et d'un mode "froid")

# Interface

# Prise de décision

Je vais décrire ici le fonctionnement 
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


