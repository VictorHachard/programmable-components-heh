# Tool Configuration (Siemens Questa)

Simulator: Siemens Questa

Top Entity: SerialFrameGen_tb

Run Time: 2,5 us

Open EPWave after run: Enabled

# Signaux à observer dans EPWave

| Signal | Rôle | Ce qu'on vérifie |
|--------|------|-----------------|
| `clkin_in` | horloge 50 MHz | stimulus continu |
| `go_in` | déclencheur | impulsion courte (20 ns) → front montant détecté |
| `clkout_out` | horloge de sortie | **inactive en IDLE**, active uniquement pendant la trame |
| `dat_out` | données série | doit suivre exactement l'ordre de la trame |
| `a1_in..e1_in` | données d'entrée | valeurs verrouillées au moment du GO |

Ordre de la trame à vérifier sur `dat_out` (synchronisé sur fronts montants de `clkout_out`) :

```
Position :   0    1    2    3    4    5    6    7
Bit :        A1   0    B1   C1   0    D1   1    E1
                  ^              ^         ^
             fixe=0         fixe=0    fixe=1  (pièges !)
```

Test 1 (A1=1 B1=0 C1=1 D1=1 E1=0) → DAT attendu : `1 0 0 1 0 1 1 0`
Test 2 (A1=1 B1=1 C1=1 D1=1 E1=1) → DAT attendu : `1 0 1 1 0 1 1 1`
Test 3 (tout à 0)                  → DAT attendu : `0 0 0 0 0 0 1 0` ← bit 6 reste 1 !
