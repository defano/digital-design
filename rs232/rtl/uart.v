module uart(
    clk32,
    reset_,
    rx,
    tx,
    txdata,
    rxdata,
    rx_enable,
    tx_enable);

   input        clk32;       // 32 Mhz clock input
   input        reset_;      // Reset
   input        rx;          // Serial RX from FTDI USB chip
   output       tx;          // Serial TX from FTDI USB chip
   input  [7:0] txdata;      // Byte to be transmitted
   output [7:0] rxdata;      // Byte received
   output       rx_enable;   // When high, rxdata is ready
   input        tx_enable;   // Set high to tell transmitter to send txdata

   wire 	baud;
   wire 	sample;

   reg [8:0] 	baud_ctr;
   reg [4:0] 	sample_ctr;

   // Serial transmission baud rate
   parameter BAUD_FREQ = 115_200;

   // Incoming clock frequency
   parameter CLK32_FREQ = 32_000_000;

   // Serial input is sampled at 16x the baud rate
   parameter SAMPLE_FREQ = 16;

   // Accumulator/counter max values to create sample/baud pulse
   parameter BAUD_MAX = CLK32_FREQ / BAUD_FREQ;
   parameter SAMPLE_MAX = CLK32_FREQ / (BAUD_FREQ * SAMPLE_FREQ);

   assign baud = baud_ctr == BAUD_MAX;         // Pulse at baud frequency
   assign sample = sample_ctr == SAMPLE_MAX;   // Pulse at sample frequency

   // Serial transmitter
   tx transmit (
	.clk(clk32),
	.reset_(reset_),
	.baud(baud),
	.txdata(txdata),
	.tx_enable(tx_enable),
	.tx(tx));

   // Serial receiver
   rx receive(
	.clk(clk32),
	.reset_(reset_),
	.sample(sample),
	.rx(rx),
	.rx_enable(rx_enable),
	.rxdata(rxdata));

   // Baud frequency counter
   always@ (posedge clk32 or negedge reset_)
     if (!reset_)
       baud_ctr <= 9'd0;
     else if (baud_ctr == BAUD_MAX)
       baud_ctr <= 9'd0;
     else
       baud_ctr <= baud_ctr + 9'd1;

   // Input sample frequency counter
   always@ (posedge clk32 or negedge reset_)
     if (!reset_)
       sample_ctr <= 5'd0;
     else if (sample_ctr == SAMPLE_MAX)
       sample_ctr <= 5'd0;
     else
       sample_ctr <= sample_ctr + 5'd1;
   
endmodule
