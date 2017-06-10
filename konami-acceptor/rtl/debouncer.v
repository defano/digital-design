module debouncer(
   clk,
   reset_,
   raw,
   debounced);

   input      clk;
   input      reset_;
   input      raw;
   output     debounced;

   reg [7:0]  counter;
   reg 	      debounced;
   reg 	      sampled;
   
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       sampled <= 1'b0;
     else
       sampled <= raw;
	        
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       counter <= 8'd0;
     else if (raw != sampled)
       counter <= 8'd0;
     else
       counter <= counter + 8'd1;
      
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       debounced <= 1'b0;
     else if (counter == 8'hff)
       debounced <= sampled;
   
endmodule
   
   
