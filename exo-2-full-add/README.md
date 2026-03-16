# Tool Configuration (Siemens Questa)

Simulator: Siemens Questa

Top Entity: FullAdd_tb

Run Time: 2 us

Open EPWave after run: Enabled

# Signaux à observer dans EPWave

| Signal | Rôle | Ce qu'on vérifie |
|--------|------|-----------------|
| `A_in` | entrée A | stimulus |
| `B_in` | entrée B | stimulus |
| `Cin_in` | retenue entrante | stimulus |
| `SUM_out` | bit de somme | A XOR B XOR Cin |
| `CARRY_out` | retenue de sortie | 1 si au moins deux entrées valent 1 |

Cas critiques à repérer :
- A=1 B=1 Cin=1 → SUM=1 CARRY=1 (1+1+1=11)
- A=1 B=1 Cin=0 → SUM=0 CARRY=1 (1+1=10)
