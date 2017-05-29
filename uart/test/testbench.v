`timescale 1ns/10ps

module testbench();
   
   wire       serial_loopback;
   wire [7:0] rxdata;
   wire       rx_enable;
   
   reg [7:0]  txdata;
   reg 	      tx_enable;
   reg 	      reset_;
   reg 	      clk;
   
   uart uut(
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

   // 32MHz clock generation
   initial forever begin
      #31.25 clk <= ~clk;
   end

   // Reset assertion
   initial begin
      clk <= 0;
      reset_ = 0;
      #10;
      reset_ = 1;
   end

   // Kick-off test by transmitting first byte when chip comes out of reset...
   initial begin
      @(posedge reset_);  // wait until reset is deasserted
      txdata <= 8'h0;
      tx_enable <= 1'b1;
   end

   // ... subsequent bytes are triggered by rx of first byte
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       txdata <= 8'd0;

     // Received byte from UUT
     else if (rx_enable) begin
	// Check if txdata == rxdata
	if (rxdata == txdata) begin
	   $display("Success. Tx byte %x, received byte %x", txdata, rxdata);
	   txdata <= txdata + 1;
	   tx_enable <= 1'b1;	   
	end

	// txdata did not match rxdata
	else begin
	   $display("Failure. Expected %d but got %d.", txdata, rxdata);
	   $finish;	   
	end
     end // if (rx_enable)

     // Received last byte, we're done
     else if (rxdata == 8'hff)  
       $finish;

   // Clear tx_enable one clock after asserting it
   always@ (posedge clk or negedge reset_)
     if (tx_enable)
       tx_enable <= 1'b0;
   
endmodule
