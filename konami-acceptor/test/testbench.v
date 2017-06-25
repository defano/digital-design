// Directive indicates that 1ns is the time period used when specifying delays
// (i.e., #10 means 10ns); 100ps is the smallest unit of time precision that
// will be simulated (100ps = .1ns; thus #.1 is meaningful, #.00001 is equivalent
// to #0)
`timescale 1ns / 100ps

module testbench ();

   reg clk;
   reg reset_;
   reg up_;
   reg down_;
   reg left_;
   reg right_;

   wire [6:0] segment_;
   wire [3:0] digit_enable_;

   // Create an instance of the circuit under test
   konamiacceptor uut (
		       .clk(clk),
		       .reset_(reset_),
		       
		       .up_(up_),
		       .down_(down_),
		       .left_(left_),
		       .right_(right_),
		       
		       .segment_(segment_),
		       .digit_enable_(digit_enable_)
		       );

   always@ (uut.state)
     $display("Konami state changed to %d (%s)", uut.state,
	      uut.state == 4'd0 ? "START"   :
	      uut.state == 4'd1 ? "UP_1"    :
	      uut.state == 4'd2 ? "UP_2"    :
	      uut.state == 4'd3 ? "DOWN_1"  :
	      uut.state == 4'd4 ? "DOWN_2"  :
	      uut.state == 4'd5 ? "LEFT_1"  :
	      uut.state == 4'd6 ? "RIGHT_1" :
	      uut.state == 4'd7 ? "LEFT_2"  :
	      uut.state == 4'd9 ? "ACCEPT"  :
	      uut.state == 4'd10 ? "REJECT" : "(BUG!)"      
	      );

   // Initialize the clock signal to zero; drive reset_ active (low) for the
   // first 100ns of the simulation.
   initial begin
      clk = 1'b0;
      reset_ = 1'b0;
      up_ = 1'b1;
      down_ = 1'b1;
      left_ = 1'b1;
      right_ = 1'b1;
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

   initial begin
      #500;
      press_up();
      press_up();
      press_down();
      press_down();
      press_left();
      press_right();
      press_left();
      press_right();
      #100000;
      $finish;
   end

   // Produce a waveform output of this simulation
   initial begin
      $dumpfile("waveform.vcd");
      $dumpvars();
   end

   task press_up;
      begin
	 up_ <= 1'b0;
	 @(posedge uut.up_debounced);
	 up_ <= 1'b1;
	 @(negedge uut.up_debounced);
      end
   endtask

   task press_down;
      begin
	 down_ <= 1'b0;
	 @(posedge uut.down_debounced);
	 down_ <= 1'b1;
	 @(negedge uut.down_debounced);
      end
   endtask

   task press_left;
      begin
	 left_ <= 1'b0;
	 @(posedge uut.left_debounced);      
	 left_ <= 1'b1;
	 @(negedge uut.left_debounced);            
      end
   endtask
   
   task press_right;
      begin
	 right_ <= 1'b0;
	 @(posedge uut.right_debounced);      
	 right_ <= 1'b1;
	 @(negedge uut.right_debounced);      
      end
   endtask
   
endmodule
