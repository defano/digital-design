`timescale 1ns/10ps

module testbench();
   
   wire       serial_loopback;
   wire [7:0] rxdata;
   wire       rx_enable;
   
   reg [7:0]  txdata;
   reg 	      tx_enable;
   reg 	      reset_;
   reg 	      clk;
   
   uart uart(
	    .clk32(clk),
	    .reset_(reset_),
	    .rx(serial_loopback),
	    .tx(serial_loopback),
	    .txdata(txdata),
	    .rxdata(rxdata),
	    .rx_enable(rx_enable),
	    .tx_enable(tx_enable));

   // Generate VCD waveform
   initial begin
      $dumpfile("waveform.vcd");
      $dumpvars();
   end

   // Clock generation
   initial forever begin
      #1 clk <= ~clk;
   end

   // Reset assertion
   initial begin
      clk <= 0;
      reset_ = 0;
      #10;
      reset_ = 1;
   end

   // Kick-off test by transmitting first byte...
   initial begin
      @(posedge reset_);
      txdata <= 8'h0;
      tx_enable <= 1'b1;
   end

   // ... following bytes are triggered by rx of first byte
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       txdata <= 8'd0;
     else if (rx_enable) begin

	// Check if txdata == rxdata
	if (rxdata == txdata) begin
	   $display("Success. Received test data %d", rxdata);
	   txdata <= txdata + 1;
	   tx_enable <= 1'b1;	   
	end

	// txdata did not match rxdata
	else begin
	   $display("Failure. Expected %d but got %d.", txdata, rxdata);
	   $finish;	   
	end
     end 
     else if (rxdata == 8'hff)  // done when finished with last byte
       $finish;

   // Clear tx_enable one clock after asserting it
   always@ (posedge clk or negedge reset_)
     if (tx_enable)
       tx_enable <= 1'b0;
   
endmodule
