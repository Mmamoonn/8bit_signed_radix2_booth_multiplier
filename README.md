# 8-Bit Signed Radix-2 Booth Multiplier

## Project Objective
A cycle-accurate, synthesizable SystemVerilog implementation of an 8-bit Radix-2 Booth Multiplier. This project encompasses a structured RTL design separating the datapath and controller, accompanied by a self-checking verification environment using constrained-random stimulus.

## Hardware Architecture
The design adheres to a modular architecture, isolating the sequential control logic from the arithmetic datapath:

* **Datapath:** Utilizes a 16-bit combined Product/Multiplier shift register. It evaluates a 2-bit window (Multiplier LSB and a trailing Booth bit) to execute one Booth iteration per clock cycle. 
* **9-Bit ALU Extension:** To safely handle intermediate two's complement overflow during corner-case operations (e.g., `-128 x -1` or `-128 x -128`), the internal Adder/Subtractor and multiplexer bypass are sign-extended to 9 bits. This guarantees that the Arithmetic Shift Right accurately duplicates the correct sign bit into the 16-bit accumulator.
* **Controller FSM:** A Moore finite-state machine governing the arithmetic sequencing. It cycles through `IDLE`, `LOAD`, `CALCULATE`, and `DONE` states, interacting with the external environment via `start`, `busy`, and `done` handshaking signals.

## System Diagrams
Architectural flowcharts and state diagrams detailing the hardware routing and FSM logic are available in the `docs/` directory:
* [Datapath Block Diagram](docs/Datapath/datapath.drawio.png)
* [Controller FSM State Diagram](docs/Controller_FSM_StateDiagram/controller_fsm(state_diagram).drawio.png)
* [Booth Algorithm Flowchart](docs/Flowchart/Multiplication_cycle_flowchart.drawio.png)

## Verification Methodology
The multiplier is validated using a fully automated, self-checking SystemVerilog testbench (`tb_top.sv`) compiled with Verilator. The verification suite inherently avoids manual waveform inspection by calculating expected results dynamically.

1. **Directed Testing:** Verifies standard operand combinations including positive, negative, mixed-sign, and zero multiplications.
2. **Corner Cases:** Explicitly tests critical hardware boundaries, including $127 \times 127$, $-128 \times -128$, and $0 \times X$.
3. **Randomized Testing:** Executes hundreds of constrained-random simulation iterations, comparing the DUT output against the native SystemVerilog `$signed()` multiplication operator.
4. **SystemVerilog Assertions (SVA):** Concurrent assertions are embedded within the controller to formally verify critical timing and mutual exclusion properties (e.g., ensuring `busy` and `done` are never simultaneously active).
5. **Functional Coverage Tracking:** Because Verilator does not natively support SystemVerilog `covergroup` constructs, functional coverage is achieved via custom testbench tracking logic. Counters manually log operand data bins (Zero, Max Positive, Min Negative, Standard Positive, Standard Negative) to guarantee the randomized stimulus hits all critical cross-sections.
   
