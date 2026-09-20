# Usage Guide

## Prerequisites
This project requires a Linux environment with the following dependencies installed:
* **Verilator (v5.0+):** Required for `--timing` flag support to execute SystemVerilog delay statements natively.
* **Make:** For build automation.
* **GTKWave:** For viewing `.vcd` waveform dumps.

## Build and Simulation
The project includes a `Makefile` to streamline compilation and execution. All build artifacts, logs, and waveforms are routed to the `sim/` directory.

### 1. Execute the Full Test Suite
To clean previous builds, compile the SystemVerilog RTL, and execute the self-checking testbench in a single command:
```bash
make
