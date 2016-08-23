module knightrider (
    clk,
    reset_,
    led);

   input   clk;
   input   reset_;
   output  [7:0] led;

   // 250ms period: approx 3,993,608 32Mhz clock cycles per 250ms
   parameter LED_BLINK_PERIOD = 22'd3993608;

   reg [21:0] clk_div;
   reg [7:0] led;
   reg 	    left_shift;

   wire     shift;

   assign shift = clk_div == LED_BLINK_PERIOD;

   always@ (posedge clk or negedge reset_)
     if (!reset_)
       clk_div <= 22'h000000;
     else if (clk_div == LED_BLINK_PERIOD)
       clk_div <= 22'h000000;
     else
       clk_div <= clk_div + 1;

   always@ (posedge clk or negedge reset_)
     if (!reset_)
       left_shift <= 1'b1;
     else if (led[7:0] == 8'b1000_0000)
       left_shift <= 1'b0;
     else if (led[7:0] == 8'b0000_0001)
       left_shift <= 1'b1;

   always@ (posedge clk or negedge reset_)
     if (!reset_)
       led[7:0] <= 8'b1000_0000;
     else if (shift && left_shift)
       led[7:0] <= led[7:0] << 1;
     else if (shift && !left_shift)
       led[7:0] <= led[7:0] >> 1;

endmodule
