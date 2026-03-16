# Tool Configuration (Siemens Questa)

Simulator: Siemens Questa

Top Entity: DoubleAffichage_tb

Run Time: 30 us

Open EPWave after run: Enabled

# Signaux à observer dans EPWave

| Signal | Rôle | Ce qu'on vérifie |
|--------|------|-----------------|
| `clks` | horloge 10 MHz | stimulus |
| `resets` | reset actif-bas | doit rester 0 pendant 500 ns, puis passer à 1 |
| `As..Gs` | segments de sortie | changent toutes les ~800 ns (bit 3 du compteur) |
| `DPs` | point décimal | actif-bas comme les autres segments |

Séquence attendue :
- t=0 à 500 ns : reset=0 → tous les segments figés (NBRE=0)
- t=500 ns : reset=1 → le compteur démarre, les segments commencent à changer
- Les segments défilent 0→1→2→...→F en boucle toutes les ~6,4 µs (bit 6)

Note bits : le design utilise les bits 3-6 pour la simulation (visibles en 30 µs).
Pour la synthèse sur carte FPGA (50 MHz), remplacer par les bits 19-22.
