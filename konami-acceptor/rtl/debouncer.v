module debouncer(
   clk,
   reset_,
   raw,
   debounced);

   input      clk;
   input      reset_;
   input      raw;
   output     debounced;

   // This circuit debounces a raw input. That is, it "ignores" brief changes
   // to the raw signal and outputs a steady value that cannot change more often
   // than once per 256 clock cycles.

   reg [7:0]  counter;      // 256 clock cycle counter
   reg 	      debounced;    // Debounced (steady) output
   reg 	      sampled;      // Raw input sampled by clock

   // "Clock in" the  raw input
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       sampled <= 1'b0;
     else
       sampled <= raw;

   // Count the number of cycles the sampled input is steady
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       counter <= 8'd0;
     else if (raw != sampled)
       counter <= 8'd0;
     else
       counter <= counter + 8'd1;

   // When the counter reaches its saturated state, output the sampled value
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       debounced <= 1'b0;
     else if (counter == 8'hff)
       debounced <= sampled;

endmodule
