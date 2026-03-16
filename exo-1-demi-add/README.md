# Tool Configuration (Siemens Questa)

Simulator: Siemens Questa

Top Entity: DemiAdd_tb

Run Time: 1 us

Open EPWave after run: Enabled

# Signaux à observer dans EPWave

| Signal | Rôle | Ce qu'on vérifie |
|--------|------|-----------------|
| `ENTREE1_in` | entrée A | stimulus |
| `ENTREE2_in` | entrée B | stimulus |
| `SORTIE_out` | somme (XOR) | 1 quand **exactement une** entrée vaut 1 |
| `CARRY_out` | retenue (AND) | 1 **seulement** quand E1=1 ET E2=1 |

Vérification : quand E1=1 et E2=1 → SORTIE=0 et CARRY=1 (1+1=10 en binaire).
