# Seven Segment Counter

A circuit that displays a rapidly incrementing value on the four-digit seven-segment displays found on the Papilio LogicStart MegaWing hardware.

This is slightly more complicated than one might expect:

Our hardware has four seven-segment displays that, together, are equipped only with 7 segment pins (segment_[6:0]) and 4 enable pins (digit_enable_[3:0]). This means we can't "drive" all four digits independently all at the same time (as you might have assumed we could--that would require 28 signals). Instead, we drive each digit for a fraction of a second, then move on to the next digit. This cycling occurs too quickly to be seen by the human eye.

To make matters worse, we need to give the circuit some time to "cool off" between driving one digit and the next. If we don't, we'll see flickering and ghosting of the previous digit's value.


## Makefile

Target       | Description
-------------|------------
`waveform`   | Executes the Verilog simulation producing a VCD waveform as output: `waveform.vcd`.
`clean`      | Removes generated files produced by the `compile`, `simulate` and `synthesize` targets.

## Design files in this project

File | Description
-----|------------
[`rtl/sevensegment.v`](rtl/sevensegment.v) | Top-level circuit module; instantiates four binary coded decimal to seven-segment coders, plus one display driver to multiplex the segment signals.
[`rtl/bcdcoder.v`](rtl/bcdcoder.v) | Converts a _binary coded decimal_ (BCD) value to the set of segments that should be lit in order to display the number. (BCD is a 3-bit binary value representing the quantities 0..9, and ignoring the remaining bit patterns `3'd10` and `3'd11`.)
[`rtl/displaydriver.v`](rtl/displaydriver.v) | Circuit that accepts four seven-input segment signals and multiplexes them onto the hardware's single segment/enable bus (driving each character for a fraction of a second).
[`test/testbench.vt`](test/testbench.vt) | Circuit test bench.
[`papilio/papilio-pro.ucf`](papilio/papilio-pro.ucf) | User constraints file providing a mapping of logical ports (defined in Verilog) to physical pins on the FPGA.
