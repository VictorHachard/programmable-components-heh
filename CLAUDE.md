# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a VHDL exercises repository for a programmable components course. Each exercise lives in its own folder and targets the **Siemens Questa** simulator.

## Simulation with Siemens Questa

Each exercise folder contains a `README.md` specifying the top entity name and run time. To compile and simulate from the command line:

```bash
# Compile (run from inside the exercise folder)
vcom design.vhd testbench.vhd

# Simulate (non-interactive)
vsim -c -do "run <RunTime>; quit" <TopEntity>

# Example for exo-2-full-add
cd exo-2-full-add
vcom design.vhd testbench.vhd
vsim -c -do "run 2us; quit" FullAdd_tb
```

To open the waveform viewer (EPWave) after simulation, use the Questa GUI instead of `-c`.

## Exercise Structure

Each exercise folder follows this layout:

```
exo-N-<name>/
  design.vhd      # Entity/architecture under test
  testbench.vhd   # Testbench
  README.md       # Top entity name and run time for the simulator
```

## Exercises Summary

| Folder | Top entity (tb) | Run time | Description |
|--------|-----------------|----------|-------------|
| exo-0-add | (combinational) | — | Simple adder, behavioral |
| exo-1-demi-add | (combinational) | — | Half-adder, behavioral |
| exo-2-full-add | `FullAdd_tb` | 2 µs | Full-adder, structural (HalfAdd × 2) |
| exo-3-bascule-d | `BasculeD_tb` | 2 µs | D flip-flop (first sequential circuit) |
| exo-4-compteur | `Compteur_tb` | 10 µs | 24-bit counter, LED output (bits 19–23) |
| exo-5-decodeur-7seg | `Decodeur7Seg_tb` | 4 µs | 4-bit to 7-segment decoder, active-low |
| exo-6-double-affichage | `DoubleAffichage_tb` | 30 µs | Counter + 7-seg display, two entities in one file |
| exo-7-serial-frame | `SerialFrameGen_tb` | 2.5 µs | 8-bit serial frame generator, shift-register FSM |

## Architecture Patterns

Three design styles are used:

- **Behavioral**: Direct logic expressions on signals (exo-0, exo-1, exo-3, exo-4, exo-5).
- **Structural**: Component instantiation with internal signals connecting sub-components (exo-2, where `FullAdd` is built from two `HalfAdd` instances; exo-6, where `DoubleAffichage` instantiates `SSegments`).
- **FSM + shift register**: State machine with a shift register for sequential bit output (exo-7, `SerialFrameGen`).

When a `design.vhd` contains multiple entities (e.g., exo-2 defines both `HalfAdd` and `FullAdd`; exo-6 defines both `SSegments` and `DoubleAffichage`), the sub-component entity must be declared before the top entity that instantiates it.

## Testbench Convention

Testbenches have no ports (`entity Foo_tb is end Foo_tb`). Stimulus is driven by a single infinite `loop` process with `wait for 200ns` intervals (combinational exercises) or clock-based processes (sequential exercises). The top entity name for simulation is always `<ComponentName>_tb`.

## Naming Conventions

- Earlier exercises use French signal names (`ENTREE1`, `ENTREE2`, `SORTIE`); newer exercises use English (`A`, `B`, `SUM`, `CARRY`, `Cin`, `clk`, `reset`, etc.).
- Internal testbench signals are suffixed `_in` for inputs and `_out` for outputs; some exercises use an `s` suffix (e.g., `clks`, `qs`).
- The UUT instance is always named `uut`.
- Active-low signals (buttons, 7-segment outputs) are driven/read with inverted logic: `'0'` = active.

## Sequential Design Notes

- Clock edges are written as `clk'event and clk = '1'` (equivalent to `rising_edge(clk)`).
- Reset is active-low in exo-6 (`reset = '0'` clears the counter).
- The 24-bit counter in exo-4/exo-6 uses bits 19–22 for FPGA synthesis (visible LED rate); bits 3–6 are used in simulation to see changes within a short run time.
