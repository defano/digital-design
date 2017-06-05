# Introduction to Digital Design

An introduction to designing, simulating and synthesizing digital hardware designs using the Verilog hardware description language with open-sourced tools and hardware. This tutorial consists of several hardware designs which can be synthesized and loaded onto [GadgetFactory's Papilio](http://papilio.cc) hardware.

## Hardware

No hardware is required to experiment with simulating circuit designs but you'll need to invest in a Papilio if you wish to realize these designs in physical form. :)

This tutorial makes use of the [Papilio Pro](http://papilio.cc/index.php?n=Papilio.PapilioPro) and [Papilio LogicStart Megawing](http://papilio.cc/index.php?n=Papilio.LogicStartMegaWing) development boards. These can be purchased as a kit [for about $100.00 online](http://store.gadgetfactory.net/logicstart-megawing-papilio-bundle/). The Papilio Pro contains a [Spartan 6 Xilinx FPGA](https://www.xilinx.com/products/silicon-devices/fpga/spartan-6.html) which will accept our integrated circuit designs, and the LogicStart Megawing provides various IOs (like buttons, LEDs,  seven segment displays, etc.) to experiment with.

A detailed description (and schematic) of the [Papilio Pro hardware can be found here](http://papilio.cc/index.php?n=Papilio.PapilioPro); the [LogicStart Megawing, here](http://papilio.cc/index.php?n=Papilio.LogicStartMegaWing).

#### Looking to test a brand new Papilio Pro?

Each of the example projects include a pre-built `.bit` file that's ready to be programmed onto the Papilio Pro's Spartan 6 FPGA. Simply install the `papilio-prog` programmer ([instructions here](docs/install-instructions.md)), then program the device following [these instructions](docs/papilio-instructions.md).

## Getting Started

This tutorial is organized as a series of example projects that you can study and experiment with. Start by installing the electronic design automation (EDA) tools on your computer or virtual machine, then simulate, synthesize and load these projects onto your Papilio hardware:

1. [Instructions for installing EDA tools](docs/install-instructions.md)
2. [Instructions for simulating designs and viewing waveforms](docs/simulation-instructions.md)
3. [Instructions for synthesizing designs for Xilinx chips on the Papilio hardware](docs/synthesis-instructions.md)
4. [Instructions for loading synthesized designs onto the Papilio board](docs/papilio-instructions.md)

## Example Projects

Each of these projects contain:

* Verilog RTL source code and a testbench to verify the design and generate simulation waveforms.
* A synthesis script for translating your design into either a gate-level netlist (just for fun) or a Xilinx programming file.
* A user constraints file that defines a mapping of physical pins on the FPGA to inputs/outputs in the design
* A pre-built `.bit` file that can be immediately loaded onto the Papilio Pro without having to install or run Xilinx' ISE software.

Projects are listed in ascending order of complexity.

Project | Description
--------|---------------------------
[Knight Rider](knight-rider/) | A starter project that cycles the Papilio LogicStart Megawing's eight LEDs in a pattern reminiscent of Kit from the 80s TV show Knight Rider. This is a good starting point for testing your toolchain and hardware.
[Breathing LEDs](breathing-led/) | Drives all the LEDs on the LogicStart MegaWing in a breathing pattern, slowly modulating their brightness from 0 to 100% and back again.
[Seven Segment Counter](seven-segment-counter/) | A slightly more complicated project that drives each of the four seven-segment displays on the LogicStart with a rapidly incrementing base-10 count.
[Konami Acceptor](konami-acceptor/) | A simple state machine that listens to d-pad inputs on the LogicStart MegaWing to detect the famous Konami Contra sequence, up-up-down-down-left-right-left-right.
[Serial Communications UART](uart/) | Implementation of a serial communications UART; allows the Papilio to communicate with a host PC using a serial communications terminal like PuTTY or minicom.
[Microblaze Microcontroller](microblaze/) | Instructions for creating a basic "system on a chip" design, including the Xilinx Microblaze CPU, 16KB of internal "block" RAM, a general purpose output module for controlling LEDs, and an embedded software project to drive it.
