module loopback(
   clk,
   reset_,
   tx,
   rx);

   input      clk;
   input      reset_;
   output     tx;
   input      rx;

   wire [7:0] data;
   wire       enable;

   // Universal asynchronous receiver transmitter; wired for loopback operation
   uart uart(
	     .clk32(clk),
	     .reset_(reset_),
	     .rx(rx),               // Rx from FTDI USB chip
	     .tx(tx),               // Tx to FTDI USB chip
	     .txdata(data),         // Rx (parallel) data looped to Tx
	     .rxdata(data),
	     .rx_enable(enable),    // Rx enable looped to Tx
	     .tx_enable(enable)
	     );

endmodule
