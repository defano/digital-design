// Directive indicates that 1ns is the time period used when specifying delays
// (i.e., #10 means 10ns); 100ps is the smallest unit of time precision that
// will be simulated (100ps = .1ns; thus #.1 is meaningful, #.00001 is equivalent
// to #0)
`timescale 1ns / 100ps

module testbench ();

   reg clk;
   reg reset_;
   wire [6:0] segments;
   wire [3:0] enables;
   
   // Create an instance of the circuit under test
   sevensegment sevensegment_0 (
				.clk(clk),
				.reset_(reset_),
				.segment_(segments),
				.digit_enable_(enables)
				);
   
   // Initialize the clock signal to zero; drive reset_ active (low) for the
   // first 100ns of the simulation.
   initial begin
      clk = 1'b0;
      reset_ = 1'b0;
      #100 reset_ = 1'b1;
   end
   
   // Stop the simulation after 400ms; note that simulations can run indefinitely
   // (with waveforms loaded incrementally in the viewer.) Press ctrl-c to break
   // iverilog, then enter '$finish' to stop the simulation.
   initial begin
      #400000000 $finish;   // 400ms
   end

   // Toggle the clock every 31.25ns (32 MHz frequency)
   initial begin forever
     #31.25 clk = ~clk;
   end
   
   // Produce a waveform output of this simulation
   initial begin
      $dumpfile("waveform.vcd");
      $dumpvars();
   end
   
   // Sample the output for each display digit when it changes (so that we output
   // this value to the console).
  
   reg [6:0] digit_0;
   reg [6:0] digit_1;
   reg [6:0] digit_2;
   reg [6:0] digit_3;  

   always@(enables) begin
      case(enables)
	4'b1110: digit_0 <= segments;
	4'b1101: digit_1 <= segments;
	4'b1011: digit_2 <= segments;
	4'b0111: digit_3 <= segments;          
      endcase
   end

   // Display changes to the seven-segment displays
   always@(digit_3 or digit_2 or digit_1 or digit_0)
     $display("Display changed to [%s][%s][%s][%s]",
    	      segment_decode(digit_0),
    	      segment_decode(digit_1),
	      segment_decode(digit_2),
	      segment_decode(digit_3));
   
   // Function converts seven-segment display "segments" back into a human readable
   // character (the opposite of what bcdcoder.v is doing)  
   function [7:0] segment_decode;
      input [6:0] segments;
      begin
	 segment_decode = segments === ~7'b0111111 ? "0" :
      			  segments === ~7'b0000110 ? "1" :
			  segments === ~7'b1011011 ? "2" :
			  segments === ~7'b1001111 ? "3" :
	      		  segments === ~7'b1100110 ? "4" :
			  segments === ~7'b1101101 ? "5" :
			  segments === ~7'b1111101 ? "6" :
			  segments === ~7'b0000111 ? "7" :
			  segments === ~7'b1111111 ? "8" :
			  segments === ~7'b1101111 ? "9" :
			  segments === ~7'b1000000 ? "_" : "?";			
      end
   endfunction

endmodule
