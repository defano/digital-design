module sevensegment (
  clk,
  reset_,
  segment_,
  digit_enable_
  );

  input clk;                    // 32 Mhz clock
  input reset_;                 // Active low reset
  output [6:0] segment_;        // Segments of the display (active low)
  output [3:0] digit_enable_;   // Active low digit enable (which digit are we driving?)

  reg [19:0] increment_ctr;
  reg [3:0] display_0;
  reg [3:0] display_1;
  reg [3:0] display_2;
  reg [3:0] display_3;

  wire [6:0] display_0_coded;
  wire [6:0] display_1_coded;
  wire [6:0] display_2_coded;
  wire [6:0] display_3_coded;

  // Display driver circuit used to multiplex the four, seven-segment display
  // values onto the single segment_ bus.
  displaydriver driver (
    .clk(clk),
    .reset_(reset_),
    .digit_0(display_0_coded),
    .digit_1(display_1_coded),
    .digit_2(display_2_coded),
    .digit_3(display_3_coded),
    .segment_(segment_),
    .digit_enable_(digit_enable_)
    );

  // Instantiate four display coders; each coder converts a binary coded decimal
  // value (that is, four bits representing the decimal values 0..9) to a seven
  // bit vector indicating which LEDs in the display should be energized in
  // order to display the desired value
  bcdcoder display_0_coder (
    .segment(display_0_coded),    // output: segments on display to energize
    .bcd(display_0)               // input: binary coded value from counter
    );

  bcdcoder display_1_coder (
    .segment(display_1_coded),
    .bcd(display_1)
    );

  bcdcoder display_2_coder (
    .segment(display_2_coded),
    .bcd(display_2)
    );

  bcdcoder display_3_coder (
    .segment(display_3_coded),
    .bcd(display_3)
    );

  // Increment signals for each of the four displays
  assign display_0_inc = &increment_ctr;
  assign display_1_inc = display_0_inc && display_0 == 4'd9;
  assign display_2_inc = display_1_inc && display_1 == 4'd9;
  assign display_3_inc = display_2_inc && display_2 == 4'd9;

  // Counter used to control the speed at which the displayed value increments.
  // 20 bit counter rolls over approx 30 times per second clocked at 32MHz.
  always@ (posedge clk or negedge reset_)
    if (!reset_)
      increment_ctr <= 20'd0;
    else
      increment_ctr <= increment_ctr + 20'd1;

  // Binary coded decimal counters. Each represents the value displayed in a
  // single, 7-segment display on the hardware (a number between 0 and 9).
  always@ (posedge clk or negedge reset_)
    if (!reset_)
      display_0 <= 4'd0;
    else if (display_0_inc && display_0 == 4'd9)
      display_0 <= 4'd0;
    else if (display_0_inc)
      display_0 <= display_0 + 4'd1;

  always@ (posedge clk or negedge reset_)
    if (!reset_)
      display_1 <= 4'd0;
    else if (display_1_inc && display_1 == 4'd9)
      display_1 <= 4'd0;
    else if (display_1_inc)
      display_1 <= display_1 + 4'd1;

  always@ (posedge clk or negedge reset_)
    if (!reset_)
      display_2 <= 4'd0;
    else if (display_2_inc && display_2 == 4'd9)
      display_2 <= 4'd0;
    else if (display_2_inc)
      display_2 <= display_2 + 4'd1;

  always@ (posedge clk or negedge reset_)
    if (!reset_)
      display_3 <= 4'd0;
    else if (display_3_inc && display_3 == 4'd9)
      display_3 <= 4'd0;
    else if (display_3_inc)
      display_3 <= display_3 + 4'd1;

endmodule
