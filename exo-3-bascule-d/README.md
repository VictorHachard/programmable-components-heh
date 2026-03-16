# Tool Configuration (Siemens Questa)

Simulator: Siemens Questa

Top Entity: BasculeD_tb

Run Time: 2 us

Open EPWave after run: Enabled

# Signaux à observer dans EPWave

| Signal | Rôle | Ce qu'on vérifie |
|--------|------|-----------------|
| `clks` | horloge | front montant = seul moment de capture |
| `Ds` | donnée entrée | valeur à mémoriser |
| `qs` | sortie Q | **ne change qu'au front montant de clks** |
| `nqs` | sortie NQ | toujours l'inverse de qs |

Point clé à vérifier : quand D change mais que clk ne monte pas, Q reste stable.
- t=400 ns : clk=0, D passe à 1 → Q reste 0 (pas de front montant !)
- t=600 ns : clk monte à 1, D=1 → Q passe à 1 (capture au front montant ✓)
