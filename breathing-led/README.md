# Breathing LEDs

This circuit causes all eight LEDs on the Papilio LogicStart MegaWing to "breathe". That is, the brightness of the LEDs slowly modulate from dim to bright to dim in a repeating pattern.

#### Theory of operation

LED brightness can be achieved by rapidly turning on and off the LED; the longer we leave the LED on, the brighter it will appear (this is essentially the same technique that dimmer switches apply when controlling incandescent lights in your house). So long as we "flash" the LED on and off at a high rate the effect will be imperceptible to the human eye. This circuit uses a 128 clock-cycle period in which a varying fraction of that period the LED is driven on (thus, the led is never off more than `31.25ns * 128`, or 4us).

To create the breathing effect we slowly modulate the brightness level, first increasing it until it reaches 100%, then slowly decreasing it back to 0%.

#### Suggested modifications

* (Easy) Change the rate at which the LEDs breath.
* (Harder) Improve the breathing pattern so that it doesn't operate in a completely linear way. As it's currently implemented, the LEDs appear dim longer than they appear bright; see if you can improve this.
* (Hardest) Make the center LEDs breath deepest and have the breathing depth trail off as you move left and right. That is, have the center LEDs (3 and 4) breath from 0-100%; LEDs 2 and 5 breath from 0-85%; LEDs 1 and 6 breath from 0-70% and LEDs 0 and 7 breath from 0-55%.

## Makefile

Target       | Description
-------------|------------
`waveform`   | Executes the Verilog simulation producing a VCD waveform as output: `waveform.vcd`.
`clean`      | Removes generated files produced by the `compile`, `simulate` and `synthesize` targets.

## Design files in this project

File | Description
-----|------------
[`rtl/breathing-led.v`](rtl/breathing-led.v) | Top-level circuit module; drives LEDs in a breathing pattern.
[`test/testbench.v`](test/testbench.v) | Circuit test bench.
[`papilio/papilio-pro.ucf`](papilio/papilio-pro.ucf) | User constraints file providing a mapping of logical ports (defined in Verilog) to physical pins on the FPGA.
