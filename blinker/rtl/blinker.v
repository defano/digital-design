module blinker (
    clk,
    reset_,
    led
);

input   clk;
input   reset_;
output  led;

// 250ms period: approx 3,993,608 32Mhz clock cycles per 250ms
parameter LED_BLINK_PERIOD = 22'd3993608;

reg [21:0]  clk_div;
reg         led;

always@ (posedge clk or negedge reset_)
  if (!reset_)
    clk_div <= 22'h000000;
  else if (clk_div == LED_BLINK_PERIOD)
    clk_div <= 22'h000000;
  else
    clk_div <= clk_div + 1;

always@ (posedge clk or negedge reset_)
  if (!reset_)
    led <= 1'b0;
  else if (clk_div == LED_BLINK_PERIOD)
    led <= ~led;

endmodule
