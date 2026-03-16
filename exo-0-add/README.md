# Tool Configuration (Siemens Questa)

Simulator: Siemens Questa

Top Entity: Test1_tb

Run Time: 1 us

Open EPWave after run: Enabled

# Signaux à observer dans EPWave

| Signal | Rôle | Ce qu'on vérifie |
|--------|------|-----------------|
| `ENTREE1_in` | entrée 1 | stimulus |
| `ENTREE2_in` | entrée 2 | stimulus |
| `SORTIE_out` | résultat AND | doit valoir **1 seulement** quand E1=1 ET E2=1 |

Vérification rapide : SORTIE_out ne passe à 1 qu'à t=400 ns (E1=1 et E2=1).
