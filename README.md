# Introduction to Digital Design

An introduction to designing, simulating and synthesizing digital hardware designs using the Verilog hardware description language with open-sourced tools and hardware. This tutorial consists of several hardware designs which can be implemented (synthesized) and loaded onto [GadgetFactory's Papilio Pro](http://papilio.cc) hardware.

See the [Introduction to Digital Design](introduction-to-digital-design.pdf) slides from the 2017 Chicago Coder Conference for a refresher on chip design with Verilog.

## Hardware

No special hardware is needed to simulate circuit designs, but to fully realize your work in electronic form you'll want your own [Papilio Pro](http://papilio.cc/index.php?n=Papilio.PapilioPro) and [Papilio LogicStart Megawing](http://papilio.cc/index.php?n=Papilio.LogicStartMegaWing) development boards. I recommend purchasing them together as a kit [for about $100.00 online](http://store.gadgetfactory.net/logicstart-megawing-papilio-bundle/).

The Papilio Pro contains a [Xilinx Spartan 6  FPGA](https://www.xilinx.com/products/silicon-devices/fpga/spartan-6.html) that will accept our circuit designs. The LogicStart Megawing is a daughter board that plugs into the Papilio Pro and provides various buttons, switches, LEDs, and seven-segment displays to experiment with.

A detailed description (and schematics) of both boards can be found on GadgetFactory's website. ([Papilio Pro ](http://papilio.cc/index.php?n=Papilio.PapilioPro) | [LogicStart Megawing](http://papilio.cc/index.php?n=Papilio.LogicStartMegaWing))

#### Looking to test a brand new Papilio Pro?

Looking for a known-good example with which to verify your setup? Each of the example projects include a pre-built `.bit` file that's ready to be programmed onto the Papilio Pro's Spartan 6 FPGA.

Install the `papilio-prog` programmer ([instructions here](docs/install-instructions.md)), then program the device following [these instructions](docs/papilio-instructions.md).

## Getting Started

I find that the best way to learn a new language or technology is to experiment with a working example. Each of the example projects (below) offers a sandbox to play in. Simulate the design; view the waveforms; figure out what's happening; and see if you can make the recommended modifications. You'll be ready to create your own from scratch in no time!

See each of the instruction guides to learn how to install the toolchain, simulate and synthesize the designs, and load them onto the Papilio development boards:

* [Instructions for installing open source tools](docs/install-instructions.md)
* [Instructions for simulating designs and viewing waveforms](docs/simulation-instructions.md)
* [Instructions for synthesizing designs for Xilinx chips on the Papilio hardware](docs/synthesis-instructions.md)
* [Instructions for loading synthesized designs onto the Papilio board](docs/papilio-instructions.md)

## Example Projects

Each of these projects represents a working design that includes RTL source code, a simulation testbench, a user-constraints file (that provides a mapping of Verilog inputs/outputs to physical pins on the chip), scripts to synthesize the design to hardware, and a pre-built `.bit` programming file that you can load onto the Papilio without having to install or run Xilinx' ISE software.

Projects are listed in ascending order of complexity.

Project | Description
--------|---------------------------
[Knight Rider](knight-rider/) | A "hello world" project that does nothing but cycle the Papilio LogicStart Megawing's eight LEDs in a pattern reminiscent of Kit from the 80s TV show Knight Rider. This is a good starting point for testing your toolchain and hardware.
[Breathing LEDs](breathing-led/) | Drives all the LEDs on the LogicStart MegaWing in a breathing pattern, slowly modulating their brightness from 0 to 100% and back again.
[Seven Segment Counter](seven-segment-counter/) | A slightly more complicated project that drives all four seven-segment digits on the LogicStart with a rapidly incrementing base-10 count.
[Konami Acceptor](konami-acceptor/) | A simple state machine that listens to d-pad inputs on the LogicStart MegaWing to detect the famous Konami sequence, up-up-down-down-left-right-left-right.
[Serial Communications UART](uart/) | Implementation of a serial communications UART; allows the Papilio to communicate with a host PC using a serial communications terminal like PuTTY or minicom.
[Microblaze Microcontroller](microblaze/) | Instructions for creating a basic "system on a chip" design that includes the Xilinx Microblaze CPU, 16KB of internal "block" RAM, a general purpose output module for controlling LEDs and an embedded software project to drive it.
[LogicStart Microcontroller](lsuc/) | A demonstration of controlling custom hardware components in software using a MicroBlaze CPU with IO bus integration to the UART, 7-segment displays, d-pad, toggle switches and LEDs. Provides hardware control via a terminal interface.
