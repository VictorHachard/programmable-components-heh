# Tool Configuration (Siemens Questa)

Simulator: Siemens Questa

Top Entity: Decodeur7Seg_tb

Run Time: 4 us

Open EPWave after run: Enabled

# Signaux à observer dans EPWave

| Signal | Rôle | Ce qu'on vérifie |
|--------|------|-----------------|
| `BP0s..BP3s` | entrées boutons (actifs-bas) | stimulus — 0=touche enfoncée |
| `As` | segment A (haut) | actif-bas : 0=allumé |
| `Bs` | segment B (droite haut) | actif-bas : 0=allumé |
| `Cs` | segment C (droite bas) | actif-bas : 0=allumé |
| `Ds` | segment D (bas) | actif-bas : 0=allumé |
| `Es` | segment E (gauche bas) | actif-bas : 0=allumé |
| `Fs` | segment F (gauche haut) | actif-bas : 0=allumé |
| `Gs` | segment G (milieu) | actif-bas : 0=allumé |

Logique d'entrée (piège fréquent) :
- Le design fait `with NOT Boutons select`
- Pour afficher le chiffre N : chaque BP = **inverse** du bit correspondant de N
- `BP='1'` = bouton relâché = bit 0 ; `BP='0'` = bouton enfoncé = bit 1

Vérification rapide (à t=0, BP0..3='1' → chiffre 0) :
- A B C D E F = **0** (allumés), G DP = **1** (éteints) ✓

Astuce : regrouper As..Gs en bus dans EPWave pour lire le code d'un coup.
