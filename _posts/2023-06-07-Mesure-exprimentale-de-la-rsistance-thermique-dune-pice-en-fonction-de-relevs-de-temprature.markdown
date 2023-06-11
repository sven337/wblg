---
layout: post
title: Mesure expérimentale de la résistance thermique d'une pièce en fonction de relevés de température
date: 2023-06-07 11:15:33
tags: XXX
category: francais
comments: MesureIsolation
img_rel: "/~sven337/data/MesureIsolation"
---

Ma maison date de 1985, l'isolation n'est pas géniale, et j'ai plusieurs projets d'amélioration.
Selon l'exposition des pièces, le confort en hiver n'est pas le même, les pièces exposées au Nord sont plus froides.

J'ai dans ma domotique un suivi des températures de la plupart des pièces ainsi que de l'extérieur.
(Pour cela j'ai à la fois des [thermomètres Zigbee](https://fr.aliexpress.com/item/1005004728929707.html?), mais avant d'avoir ces produits commerciaux j'avais conçu des thermomètres DIY avec nRF24L01+, Arduino Pro Mini et un module boost qui permet de fonctionner avec un seul accu AAA. Je ne les ai jamais présentés ici mais j'en suis très content, globalement plus que des Zigbee même si c'était un peu plus de travail.)

J'ai bien évidemment appliqué la méthode 3CL (celle des DPE), et on pourrait faire une simulation thermique plus poussée, mais ces modèles ont le défaut de prendre en entrée des données simplifiées (résistance thermique de l'isolant). Ici on va essayer de retrouver une valeur globale par pièce à partir de mesures objectives.

# Théorie 

En théorie la déperdition énergétique d'une pièce est proportionnelle à la différence de température entre cette pièce et l'extérieur.
C'est un modèle un peu simplifié car il y a un souci d'inertie thermique, mais peut-on sur la base de ce modèle simplifié estimer une valeur de résistance thermique propre à la pièce, cela afin de pouvoir :
- comparer les valeurs entre pièces (donnant ainsi une valeur objective à l'observation "cette pièce est moins confortable")
- quantifier le résultat des travaux d'isolation

Soit T la température de la pièce, E la température extérieure, mathématiquement on a :
```
dT / dt = (E - T) * R
```

où R est la résistance thermique constante de la pièce que l'on cherche.

En disposant de relevés horodatés de E et T, on peut calculer tout le reste en s'aidant de Pandas en Python.

```
ext=pd.read_csv("exterior.csv", index_col=0, parse_dates=True, infer_datetime_format=True)
room=pd.read_csv("room.csv", index_col=0, parse_dates=True, infer_datetime_format=True)
```

Mes relevés ne sont pas exactement faits au même moment (à la seconde près), donc on va fusionner les deux dataframes et interpoler les valeurs afin d'avoir des dates qui coïncident : 
```
df=pd.merge(ext, room, how='outer', left_index=True, right_index=True)
df=df.interpolate('index')
df=df[~df.index.duplicated()] # Deduplication des index lorsque le capteur a envoyé une température deux fois dans la même seconde
```

Cette opération va énormément augmenter le nombre de points, mais sans pour autant créer de vraie donnée puisque les relevés sont de toute façon faits toutes les 10 à 60 minutes (et, ce sera important pour la suite, avec une précision limitée, à 0.1°C près dans ma configuration).

On va donc sélectionner uniquement les points qui correspondent à un relevé réel de la pièce :
```
df=df.reindex(room.index)
```

Nous avons désormais E et T pour chaque pas de temps, il reste à calculer E - T et les différentielles avec [Dataframe.diff](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.diff.html)

Différente de température intérieur-extérieur :
```
df['delta'] = df['exterior']-df['room']
```

Variation de température dans la pièce à chaque pas de temps (dT) :
```
df['dT'] = -df['room'].diff(periods=-1)
```

Durée des pas de temps (dt) :
```
df['dt'] = df.index
df['dt'] = -df['dt'].diff(periods=-1)
```

On peut désormais estimer R :
```
R=df['dT']/(df['dt']/pd.Timedelta(hours=1))/df['delta']
```

Dans mon cas, le résultat est assez moche par défaut, avec pas mal de valeurs aberrantes. Ce n'est pas étonnant, il y a plein de cas tordus :
- thermomètre extérieur exposé au soleil (il n'est pas placé parfaitement)
- fenêtre ouverte 
- fin de journée où la température extérieure descend sous la température intérieure, mais la pente de celle-ci ne s'inverse pas immédiatement (effet déphasage)
- ...

La valeur est en "degrés par heure par degré de différence avec l'extérieur".
On va filtrer les valeurs aberrantes (et là rentre un degré d'arbitraire qui peut remettre en question le sérieux de la méthode). D'abord on sait que la valeur est positive (mais on va avoir des cas où elle apparaît comme négative à cause du déphasage), et on sait qu'elle est située dans un intervalle "raisonnable".
En observant graphiquement et au doigt mouillé j'élimine les valeurs extrêmes comme suit :
```
R=R[R<1][R>0]
```
ce serait sûrement plus propre d'utiliser les quantiles comme vu [sur Stackoverflow](https://stackoverflow.com/a/50612631).

Moyenne et écart-type :
```
In [331]: R.mean()
Out[331]: 0.10049690360655793
In [333]: R.std()
Out[333]: 0.1313761127379149

```

On peut obtenir un [intervalle de confiance](https://stackoverflow.com/a/34474255), attention cela suppose que les valeurs sont distribuées normalement. Visuellement ça a l'air d'être le cas (avant d'éliminer les R < 0 ! mais je suis obligé de les éliminer).


```
In [338]: st.t.interval(0.95, len(R)-1, loc=np.mean(R), scale=st.sem(R))
Out[338]: (0.09353911842416428, 0.10745468878895158)
```

On va donc retenir que cette pièce (chambre) présente un R = 0.1004.
(Ce n'est pas à proprement parler une résistance thermique, mais plutôt une constante de temps : 1/R représente "combien d'heures cette pièce met-elle à rejoindre la température extérieure")

Sur une autre pièce de la maison (salon), je trouve R = 0.1211.. Cette autre pièce serait donc moins bien isolée. 

Dans ma chambre, pièce isolée mais beaucoup moins bien que les autres (défaut de mise en oeuvre), je trouve R = 0.1431. avec malheureusement un intervalle de confiance très large :
```
In [547]: st.t.interval(0.95, len(R)-1, loc=np.mean(R), scale=st.sem(R))
Out[547]: (0.11512652993743998, 0.1712436398644456)
```

Mon cellier, pièce essentiellement non isolée, obtient 0.1649, avec un intervalle de confiance à 95% un peu plus large que pour les autres.

Avant travaux d'isolation j'ai donc :

{:.CSSTableGenerator}
| Pièce | R | 1/R (h) |
| Chambre sud | 0.1004 | 9.96h
| Salon | 0.1211 | 8.25h
| Chambre mal isolée | 0.1431 | 6.98h
| Cellier non isolé | 0.1649 | 6.06h
| Bureau | 0.0804 | 12.42h

Et pour s'amuser, on peut faire le calcul avec la piscine (après tout j'ai un suivi de température de l'eau, autant s'en servir !).

```
In [587]: st.t.interval(0.95, len(R)-1, loc=np.mean(R), scale=st.sem(R))
Out[587]: (0.20431535060975592, 0.3028853387478535)

In [588]: R.mean()
Out[588]: 0.2536003446788047
```

soit une valeur de 3.94h ce qui est *très* sous-estimé. Je n'explique pas ce résultat.
