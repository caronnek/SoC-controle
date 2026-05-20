# Examen

## Structure du dossier

```
DE0_Nano/
└── Examen/
    ├── README.md
    ├── controle/         <- énoncé et questions de l'examen
    ├── schema/           <- schéma d'architecture du système
└── ip_cores/
        ├── byte_swap_avalon_interface.vhd   <- wrapper Avalon-MM Slave
        └── byte_swap_core.vhd               <- logique combinatoire pure
```

---

## Description du composant

Le composant **byte_swap** effectue une inversion des octets d'un mot de 32 bits.

Deux modes disponibles via le signal `sel` :

| sel | Entrée | Sortie |
|-----|--------|--------|
| `0` | `[Octet3\|Octet2\|Octet1\|Octet0]` | `[Octet0\|Octet1\|Octet2\|Octet3]` |
| `1` | `[Octet3\|Octet2\|Octet1\|Octet0]` | `[Octet1\|Octet0\|Octet3\|Octet2]` |

---

## Fichiers ip_core

### `byte_swap_core.vhd`
Composant de calcul pur, sans aucun signal Avalon.
- Entrée : `data_in` 32 bits + `sel` 1 bit
- Sortie : `data_out` 32 bits
- Logique entièrement combinatoire (0 cycle de latence)

### `byte_swap_avalon_interface.vhd`
Wrapper Avalon-MM Slave qui instancie `byte_swap_core`.

Signaux Avalon-MM :

| Signal | Direction | Description |
|--------|-----------|-------------|
| `clock` | in | Horloge système |
| `resetn` | in | Reset actif bas |
| `chipselect` | in | Sélection du composant |
| `write` | in | Écriture depuis le NIOS |
| `writedata` | in 32 bits | Donnée + sel (bit 0) |
| `read` | in | Lecture depuis le NIOS |
| `readdata` | out 32 bits | Résultat inversé |

---

## Intégration dans Platform Designer

1. Ajouter les deux fichiers `.vhd` dans le projet Quartus
2. Dans Platform Designer, créer un nouveau composant et pointer sur `byte_swap_avalon_interface.vhd`
3. Connecter l'interface Avalon-MM Slave au NIOS II master
4. Assigner une adresse de base (ex: `0x00041000`)
5. Régénérer le système

---


## Environnement

- Carte : DE0-Nano (Altera Cyclone IV)
- Fréquence FPGA : 50 MHz
- Outil : Quartus Prime + Platform Designer (Qsys)
- Processeur : NIOS II
