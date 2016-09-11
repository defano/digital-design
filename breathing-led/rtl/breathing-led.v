module breathingled (
  clk,
  reset_,
  led
  );

  input clk;
  input reset_;
  output [7:0] led;

  // Theory of operation:
  //
  // LED brightness can be achieved by rapidly turning on and off the LED; the
  // longer we leave the LED on, the brighter it will appear. So long as we
  // "flash" the LED at a high rate, this will be imperceptable to the human
  // eye. This circuit uses a 128 clock-cycle period in which a varying fraction
  // of that period the LED is on. 
  //
  // To create a breathing effect, we slowly modulate the brightness level, first
  // increasing it until it reaches 100%, then slowly decreasing it.

  reg [18:0] next_ctr;            // Counter to create a ~60Hz change in brightness
  reg [6:0] duty_ctr;             // Counter to create a 128 clock cycle period
  reg [6:0] duty_cycle;           // Number of ticks in duty_ctr that LED is on/off

  reg inhale;                     // When set, duty cycle is increasing
  reg led_state;                  // LED is on when set, off when cleared

  assign led = {8{led_state}};    // Drive all eight LEDs with led_state
  assign next = &next_ctr;        // Advance duty cycle when next_ctr saturates

  // Counter to advance the duty cycle (i.e., increase or decrease the LED
  // brightness) approx 60 times per second
  always@ (posedge clk or negedge reset_)
    if (!reset_)
      next_ctr <= 19'd0;
    else
      next_ctr <= next_ctr + 19'd1;

  // Duty cycle is number of clock cycles the led will be off (when inhale = 1'b0)
  // or on (when inhale = 1'b1) per each 128 clock cycle period. The greater the
  // number of cycles the led is energized per period, the brighter it will appear.
  always@ (posedge clk or negedge reset_)
    if (!reset_)
      duty_cycle <= 7'd0;
    else if (next)
      duty_cycle <= duty_cycle + 7'd1;

  // Counts the 128 clocks per duty cycle period.
  always@ (posedge clk or negedge reset_)
    if (!reset_)
      duty_ctr <= 7'd0;
    else
      duty_ctr <= duty_ctr + 7'd1;

  // Indicates whether duty cycle specifies number of clock cycles LEDs are on,
  // or number of cycles LEDs are off. This enables us to use an incrementing
  // counter to both increase and decrease brightness over time
  always@ (posedge clk or negedge reset_)
    if (!reset_)
      inhale <= 1'b0;
    else if (next && &duty_cycle)
      inhale <= ~inhale;

  // Drive the LEDs on or off depending on where in the 128 clock period cycle
  // we are.
  always@ (posedge clk or negedge reset_)
    if (!reset_)
      led_state <= 1'b0;
    else if (inhale)
      led_state <= (duty_ctr < duty_cycle);
    else
      led_state <= (duty_ctr > duty_cycle);

endmodule
