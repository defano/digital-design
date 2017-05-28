# Knight Rider

A simple integrated circuit that cycles the  LogicStart MegaWing's eight LEDs back-and-forth in a pattern reminiscent of Kit from Knight Rider.

This is a good place to get started--both as a simple to understand "Hello World" project and also as a known-good example with which to test your Papilio hardware and software toolchain.

## Makefile

Target       | Description
-------------|------------
`waveform`   | Executes the Icarus Verilog compiler and simulator to generate a waveform output (`.vcd`) of the simulated design.
`clean`      | Removes generated files produced by other targets.

## Design files in this project

File | Description
-----|------------
[`rtl/knight-rider.v`](rtl/knight-rider.v) | Top-level circuit module; drives eight LEDs in a Knight Rider pattern.
[`test/testbench.vt`](test/testbench.vt) | Circuit test bench.
[`papilio/papilio-pro.ucf`](papilio/papilio-pro.ucf) | User constraints file providing a mapping of logical ports (defined in Verilog) to physical pins on the FPGA.
