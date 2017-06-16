# RS-232 Universal Asynchronous Receiver / Transmitter

This project implements a [universal asynchronous receiver/transmitter](https://en.wikipedia.org/wiki/Universal_asynchronous_receiver) (UART) that echoes received data back to the transmitter.

Of course, echoing serial communication is as simple as connecting the transmit (`tx`) signal back to the receive (`rx`); that is not what this project does. This project fully "deserializes" the incoming data by taking the bits, each transmitted one-by-one over the wire, and converting the stream into a byte. This deserialized byte is then "looped back" into the UART to be re-serialized into a stream of bits and sent back.

#### Theory of operation

The Papilio development board contains a dual-port USB serial port (provided by the [FTDI FT2232D chip](http://www.ftdichip.com/Support/Documents/DataSheets/ICs/DS_FT2232D.pdf)). This serial port is used by the `papilio-prog` tool to load Xilinx `.bit` files onto the FPGA, but can also be used to implement serial data communication between the FPGA and a host computer. The FTDI chip lets our circuit remain unaware of the USB protocol and all the complexity associated with it; we can simply send and receive data to/from the host computer via the much simpler [RS-232 serial communications standard](https://en.wikipedia.org/wiki/RS-232).

The result of this being that we can connect the Papilio to a computer via USB, open a serial communications app (like PuTTY, miniterm or cutecom), send bytes over the USB serial port, and see them echoed back to us. [Detailed instructions below.](#testing-serial-communications)  

#### Testing Serial Communications

The UART implemented in this circuit is intended to communicate with the host PC using these settings:

* **Baud**: 115,200
* **Parity**: None
* **Handshaking**: None (neither hardware or software)
* **Stop Bits**: 1
* **Data Bits**: 8


1. Start by connecting the Papilio to your host computer via USB and loading the `loopback.bit` Xilinx file to it.

2. The USB chip on the Papilio will _enumerate_ itself as two serial ports. Identify the Linux device associated with the second port. On Linux, we can grep `dmesg` for this information (you'll note in this example that our device is `ttyUSB1`):
```
root@ubuntu-vm-i386:# dmesg | grep tty
[    0.000000] console [tty0] enabled
[ 9715.923563] usb 2-1: FTDI USB Serial Device converter now attached to ttyUSB0
[ 9715.927584] usb 2-1: FTDI USB Serial Device converter now attached to ttyUSB1
[ 9738.389022] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disconnected from ttyUSB0
[10364.012161] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disconnected from ttyUSB1
```

3. Install `cutecom` (available on Linux and macOS) using `sudo apt install cutecom`. (Other tools like Putty will suffice, too.)

4. Open the terminal application as superuser (without superuser permission, you won't be able to access the serial port hardware) using the command `sudo cutecom`

5. Open a connection to the Papilio using the serial device you identified in the last step, and configured using the baud, parity, stop bits, and data bits shown above.

6. Transmit some text over the serial port; witness the same text echoed back.

#### Suggested modifications

* (Easy) Modify the baud rate of the serial communications from 115,200 to some other value (like 57,600).
* (Harder) Change the transmit and receive modules to support other communication modes (like parity and/or a different number of stop bits or data bits). Extra credit: Make these changes compile-time options with the Verilog `parameter` directive.

## Makefile

Target       | Description
-------------|------------
`waveform`   | Executes the Verilog simulation producing a VCD waveform as output: `waveform.vcd`.
`clean`      | Removes generated files produced by the `compile`, `simulate` and `synthesize` targets.

## Design files in this project

File | Description
-----|------------
[`rtl/loopback.v`](rtl/loopback.v) | Top-level module; instantiates a UART configured for loopback (that is, echoing received data back to sender).
[`rtl/uart.v`](rtl/uart.v) | UART circuit for serializing/deserializing data from the FTDI USB chip.
[`rtl/tx.v`](rtl/tx.v) | UART transmiter module.
[`rtl/rx.v`](rtl/rx.v) | UART receiver module.
[`test/testbench.vt`](test/testbench.vt) | Circuit test bench.
[`papilio/papilio-pro.ucf`](papilio/papilio-pro.ucf) | User constraints file providing a mapping of logical ports (defined in Verilog) to physical pins on the FPGA.
