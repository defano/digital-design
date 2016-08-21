module blinker (
    clk,
    reset_,
    led
);

input   clk;
input   reset_;
output  led;

parameter LED_BLINK_PERIOD = 24'h3cf008;

reg [23:0]  clk_div;
reg         led;

always@ (posedge clk or negedge reset_)
  if (!reset_)
    clk_div <= 24'h000000;
  else if (clk_div == LED_BLINK_PERIOD)
    clk_div <= 24'h000000;
  else
    clk_div <= clk_div + 1;

always@ (posedge clk or negedge reset_)
  if (!reset_)
    led <= 1'b0;
  else if (clk_div == LED_BLINK_PERIOD)
    led <= ~led;

endmodule
