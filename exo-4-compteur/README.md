# Tool Configuration (Siemens Questa)

Simulator: Siemens Questa

Top Entity: Compteur_tb

Run Time: 10 us

Open EPWave after run: Enabled

# Note
Exercice du camarade correspondant au PSF 4 (compteur avec reset asynchrone).
Differences avec le PSF : compteur 24 bits (non 8 bits), sans reset, sorties sur LEDs (non sur un bus 8 bits).

# Signaux à observer dans EPWave

| Signal | Rôle | Ce qu'on vérifie |
|--------|------|-----------------|
| `clks` | horloge 10 MHz | stimulus |
| `LED5s` | bit 19 du compteur | change le plus souvent (toutes les ~52 µs) |
| `LED4s` | bit 20 | change 2× moins vite que LED5s |
| `LED3s` | bit 21 | change 4× moins vite que LED5s |
| `LED2s` | bit 22 | change 8× moins vite que LED5s |
| `LED1s` | bit 23 | change le moins souvent |

Avec Run Time = 10 µs et horloge 10 MHz : les LEDs ne bougent pas encore
(bit 19 nécessite 2¹⁹ × 100 ns ≈ 52 ms). Ce testbench sert à vérifier
que le compteur s'incrémente correctement — observer `clks` uniquement suffit
pour confirmer la compilation. Pour voir les LEDs changer, simuler au moins 100 ms.
