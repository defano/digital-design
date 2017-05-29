# Breathing LED

This circuit causes all eight LEDs on the Papilio LogicStart MegaWing to "breath". That is, the brightness of the LEDs slowly modulate from dim to bright, then bright to dim.

LED brightness can be achieved by rapidly turning on and off the LED; the longer we leave the LED on, the brighter it will appear. So long as we "flash" the LED at a high rate, this will be imperceptible to the human eye. This circuit uses a 128 clock-cycle period in which a varying fraction of that period the LED is driven on.

To create a breathing effect, we slowly modulate the brightness level, first increasing it until it reaches 100%, then slowly decreasing it.

## Makefile

Target       | Description
-------------|------------
`waveform`   | Executes the Verilog simulation producing a VCD waveform as output: `waveform.vcd`.
`clean`      | Removes generated files produced by the `compile`, `simulate` and `synthesize` targets.

## Design files in this project

File | Description
-----|------------
[`rtl/breathing-led.v`](rtl/breathing-led.v) | Top-level circuit module; drives LEDs in a breathing pattern.
[`test/testbench.vt`](test/testbench.vt) | Circuit test bench.
[`papilio/papilio-pro.ucf`](papilio/papilio-pro.ucf) | User constraints file providing a mapping of logical ports (defined in Verilog) to physical pins on the FPGA.
