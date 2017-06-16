# Konami Acceptor

A state machine that accepts a user-entered Konami code (that is, pressing `up`, `up`, `down`, `down`, `left`, `right`, `left` `right` on the LogicStart's d-pad). Displays state changes and sequence acceptance on the four digit seven-segment display.

For those too old or too young to remember, this key sequence is most famous for its use as [a cheat code](https://en.wikipedia.org/wiki/Konami_Code) in Konami's 1987 video game, Contra (on the Nintendo NES); when a user keyed a similar sequence they'd be awarded 30 lives.

#### Theory of operation

This circuit implements debounce and edge detection logic for the d-pad inputs, plus a FSM (state machine) with a four-bit state register.

_Wait, what's a debounce circuit?_ As the metal contacts present in the d-pad come in contact with one another, the force of their collision will cause them to vibrate and "bounce" off one another. This, of course, is a microscopic effect that happens much too quickly to be perceptible to humans. However, with our clock "sampling" this input every 31 billionths of a second, the effect is not too small to be captured by our circuit. Without the debouncer in place you'd find that the circuit _mostly_ works, but will occasionally seem to capture an extra key press (which is just enough to cause our cheat code to be rejected).

The edge detector works by sampling the debounced d-pad inputs into a two-bit shift register on every rising clock edge. That is, at each clock cycle the current pressed/released state of each direction is placed into the least-significant bit of a two bit register and the previous least-significant bit is moved into the most-significant bit position. With this, we can detect a "key up" event by watching for the shift register to reach the value `2'b10`.

State     | Value    | Seven-Segment Display | Description
----------|----------|-----------------------|------------
`START`   | `4'd0`   | `----`                | Initial state; transitions to `UP_1` upon release of the up key.
`UP_1`    | `4'd1`   | `UP-1`                | Transitions to `UP_2` upon release of the up key; transitions to `REJECT` after a 1 second timeout or in the presence of any other input
`UP_2`    | `4'd2`   | `UP-2`                | Transitions to `DOWN_1` upon release of the down key; transitions to `REJECT` after a 1 second timeout or in the presence of any other input
`DOWN_1`  | `4'd3`   | `Dn-1`                | Transitions to `DOWN_2` upon release of the down key; transitions to `REJECT` after a 1 second timeout or in the presence of any other input
`DOWN_2`  | `4'd4`   | `Dn-2`                | Transitions to `LEFT_1` upon release of the left key; transitions to `REJECT` after a 1 second timeout or in the presence of any other input
`LEFT_1`  | `4'd5`   | `LF-1`                | Transitions to `RIGHT_1` upon release of the right key; transitions to `REJECT` after a 1 second timeout or in the presence of any other input
`RIGHT_1` | `4'd6`   | `rh-1`                | Transitions to `LEFT_2` upon release of the left key; transitions to `REJECT` after a 1 second timeout or in the presence of any other input
`LEFT_2`  | `4'd7`   | `LF-2`                | Transitions to `ACCEPT` upon release of the right key; transitions to `REJECT` after a 1 second timeout or in the presence of any other input
`ACCEPT`  | `4'd9`   | `9999`                | Transitions to `START` upon release of any key
`REJECT`  | `4'd10`  | `0000`                | Transitions to `START` upon release of any key

#### Suggested modifications

* (Easy) Remove the debounce logic and re-test the circuit. Notice any difference? Does it seem a little "flaky"?
* (Harder) The original Konami code also required players to key in `B-A-Select-Start` at the end of the sequence. Wire up some of the toggle switches to act as `A`, `B`, `Select` and `Start` keys and modify the state machine to accept the full sequence. (Don't forget that you'll need to modify the `papilio-pro.ucf` user constraints file, too, if you intend to implement the design for the Papilio hardware).   

## Makefile

Target       | Description
-------------|------------
`waveform`   | Executes the Verilog simulation producing a VCD waveform as output: `waveform.vcd`.
`clean`      | Removes generated files produced by the `compile`, `simulate` and `synthesize` targets.

## Design files in this project

File | Description
-----|------------
[`rtl/konamiacceptor.v`](rtl/konamiacceptor.v) | Top-level circuit module; implements a state machine that accepts a Konami code input. Instantiates a display character coder and display driver circuit.
[`rtl/konamicoder.v`](rtl/konamicoder.v) | Converts a state id into the set of segments that should be lit on each seven segment display.
[`rtl/displaydriver.v`](rtl/displaydriver.v) | Circuit that accepts four seven-input segment signals and multiplexes them onto the hardware's single segment/enable bus (driving each character for a fraction of a second).
[`test/testbench.vt`](test/testbench.vt) | Circuit test bench.
[`papilio/papilio-pro.ucf`](papilio/papilio-pro.ucf) | User constraints file providing a mapping of logical ports (defined in Verilog) to physical pins on the FPGA.
