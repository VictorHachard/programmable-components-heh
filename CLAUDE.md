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
  testbench.vhd   # Testbench (infinite loop, 200 ns stimulus intervals)
  README.md       # Top entity name and run time for the simulator
```

## Architecture Patterns

Two design styles are used:

- **Behavioral**: Direct logic expressions on signals (used in exo-0, exo-1).
- **Structural**: Component instantiation with internal signals connecting sub-components (used in exo-2, where `FullAdd` is built from two `HalfAdd` instances).

When a `design.vhd` contains multiple entities (e.g., exo-2 defines both `HalfAdd` and `FullAdd` in the same file), the sub-component must be declared before the top entity that uses it.

## Testbench Convention

Testbenches have no ports (`entity Foo_tb is end Foo_tb`). Stimulus is driven by a single infinite `loop` process with `wait for 200ns` intervals. The top entity name for simulation is always `<ComponentName>_tb`.

## Naming Conventions

- Earlier exercises use French signal names (`ENTREE1`, `ENTREE2`, `SORTIE`); newer exercises use English (`A`, `B`, `SUM`, `CARRY`, `Cin`).
- Internal testbench signals are suffixed `_in` for inputs and `_out` for outputs.
- The UUT instance is always named `uut`.
