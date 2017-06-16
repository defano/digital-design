# Knight Rider

A simple integrated circuit that cycles the  LogicStart MegaWing's eight LEDs back-and-forth in a pattern reminiscent of Kit from Knight Rider.

This is a good place to get started--both as a simple to understand "Hello World" project and also as a known-good example with which to test your Papilio hardware and software toolchain.

#### Theory of Operation

How do we turn on and off LEDs on the LogicStart? By driving eight output signals on the FPGA from a register (`reg [7:0] led`) in our design `knight-rider.v`. This register is connected to the module's output (`output [7:0] led`) as a result of the register and output port sharing the same name. Furthermore, the `papilio-pro.ucf` user constraints file specifies that when we implement this design for the Xilinx FPGA these logical outputs are to be attached to the pins on the FPGA that are electrically connected to the LEDs on the circuit board (`NET LED<0> LOC="P123"`). How did we know that LED 0 is connected to pin `P123` on the FPGA? By referring the [LogicStart documentation and schematic](http://papilio.cc/index.php?n=Papilio.LogicStartMegaWing), of course!

Thus, a `1` in any bit position in the `led` register results in a 3.3v output on the pin connected the LED associated with that position (i.e., a value of `8'b1000_0001` turns on LEDs 7 and 0 and turns off the rest.)

#### Suggested modifications

* (Easy) Invert the pattern such that instead animating an "on" LED in a field of "off" LEDs, you animate an "off" LED against a field of "on" LEDs.
* (Harder) Add a second animated LED that criss-crosses the first. As the first LED moves left to right, the second moves right to left overlapping at the center.

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
