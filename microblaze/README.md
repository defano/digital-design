# Microblaze System-on-a-Chip

In this project, we'll create a microcontroller "system on a chip" by creating a design that incorporates a Xilinx Microblaze CPU, 16KB of "block" RAM (memory that's onboard the FPGA), a general purpose output (_GPO_) module to control LEDs via software, and the firmware that will control it.

This is not a trivial exercise. It's a bit like launching a rocket to the moon: There are quite a few steps involved and each has very little margin for error. Be sure to follow these instructions carefully. Even minor deviations in naming or configuration will prevent this from working. And when it doesn't, it just won't. Don't expect helpful error messages or warnings to guide you along the way; the toolchain is not beginner friendly.

You've been warned. Stick with the script until you've got a good sense of what you're doing...

## Setup

There are a couple issues with our toolset that we need to resolve before getting started:

#### Link `gmake` to `make`

The Xilinx software development kit (`xsdk`) we'll be using expects to be able to call `gmake` (GNU Make) instead of the system `make`. For Ubuntu, the difference is irrelevant and the problem is easily solved with a link:
```
$ sudo ln -s /usr/bin/make /usr/bin/gmake
```

#### Upgrading a buggy iVerilog

As of this writing, the version of Icarus Verilog that's released and made available to Ubuntu through the `apt` repositories (and which you were instructed to install in the software installation procedure) contains a bug that prevents it from simulating Xilinx' block memory models. A fix is available, but we'll need to upgrade our `iverilog` tool the old fashioned way: by downloading and compiling the source code.

I had little trouble getting this to work, but it does take a few minutes. This will overwrite the version you may have previously installed with `apt`.

Follow these instructions:

1. Download the source by navigating to a directory where you'd like to keep the source, then:
```
$ cd ~/
$ git clone https://github.com/steveicarus/iverilog.git
```

2. Change into the `iverilog` directory created by checking out the source:
```
$ cd iverilog
```

3. Build and run the configuration scripts:
```
$ sh autoconf.sh
$ ./configure
```

4. Compile the software. Note that your compile will likely fail as a result of various tools being absent on your Ubuntu build (stuff like `bison` and `flex`). You can easily remedy these errors by installing the tool each time your reach an error. For example: `sudo apt install bison`.
```
$ make
```

5. When the compile has succeeded, install the binaries with:
```
$ sudo make install
```

## Create the Microblaze Core

A "core" is the integrated circuit equivalent of a "library" in software. That is, it's a "black box" circuit developed by a third party which we instantiate and use inside our circuit without regard for the implementation details. It's port definition is, essentially, its API.

That said, Xilinx' cores are not one-size-fits-all. They're configurable and dynamically generated using the "Xilinx Core Generator" tool.

[Microblaze](https://en.wikipedia.org/wiki/MicroBlaze) is a microprocessor design from Xilinx that is "easily" incorporated into an FPGA. It provides a simulation model that will let us simulate our design and watch the instruction execution. Note, however, that unlike the other Verilog RTL we've used, this simulation model is used purely for simulation. The Verilog contained within is _not_ used when generating the FPGA design (and uses parts of the language that cannot be easily synthesized). Xilinx uses some "secret sauce" to create the Microblaze inside the FPGA during the implementation phase.

1. Open the Xilinx `coregen` tool with `$ coregen`. If it seems that command doesn't exist (or isn't in your path), then you likely haven't installed Xilinx ISE Webpack or sourced the setup shell script described in the software setup instructions. Otherwise, you should momentarily be presented with this screen: <br><br>![Coregen](doc/coregen/1.png)

2. Create a new project by choosing File -> New Project. Create the new project inside the `core` directory of this tutorial. Use the default project name: `coregen`.

3. You'll be prompted to select "Project Options". These define the type of FPGA we're "targeting" and some selections about how we'd like the simulation model built. Enter these options exactly as shown (no change required to the "Advanced" section): <br><br>![Part Options](doc/coregen/2.png)<br><br>![Generation Options](doc/coregen/3.png)

4. Close the project options by clicking "OK", then find the Microblaze core within the available library of Xilinx-provided cores. Fastest way to do this is to type `microblaze` into the "Search IP Catalog" field.

5. Double-click on the "Microblaze MCS 1.4" element in the library tree. This will display the core's configuration options. Enter these options exactly as shown (paying close attention to the change in input clock frequency, memory size and enabling the trace bus):<br><br>![MCS Options](doc/coregen/4.png)

6. Click the GPO tab to view general purpose output configuration and enter these options exactly as shown:<br><br>![GPO Options](doc/coregen/5.png)

7. Generate the core by clicking the "Generate" button. This process will take several minutes to complete. When it does, you'll see this screen:<br><br>![Success](doc/coregen/6.png)

8. Congratulations! You've created your first microprocessor core! Dismiss the "Readme" dialog and quit the Coregen application. Then, take a look at the contents of the `core/` directory to admire your handywork.
