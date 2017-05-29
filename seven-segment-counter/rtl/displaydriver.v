module displaydriver (
  clk,
  reset_,
  digit_0,
  digit_1,
  digit_2,
  digit_3,
  segment_,
  digit_enable_
  );

  input clk;
  input reset_;
  input [6:0] digit_0;
  input [6:0] digit_1;
  input [6:0] digit_2;
  input [6:0] digit_3;

  output [6:0] segment_;
  output [3:0] digit_enable_;

  // Theory of operation:
  //
  // Our hardware has four, seven-segment displays that are equipped with 7
  // segment pins (segment_[6:0]) and 4 enable pins (digit_enable_[3:0]).
  //
  // Thus, we can't "drive" all four digits at once (as you might intuitively
  // think--that would require 28 signals). Instead, we drive each digit for a
  // fraction of a second, then move on to the next digit. This cycling occurs
  // too quickly to be seen by the human eye.
  //
  // To make matters worse, we need to give the circuit some time to "cool off"
  // between driving one digit and the next. If we don't, we'll see flickering
  // and ghosting of the previous digit's value.

  reg [7:0] refresh_ctr;
  reg [1:0] digit;

  // Multiplex the active digit's encoded value on the segment pins of the
  // display
  assign segment_ =
          (digit == 2'd0) ? ~digit_3 :
          (digit == 2'd1) ? ~digit_2 :
          (digit == 2'd2) ? ~digit_1 :
          ~digit_0;

  // Apply power to the display only during the middle half of the refresh
  // cycle. This gives the circuit time to drain before we begin driving
  // the next digit.
  assign enable_ = !(refresh_ctr > 8'd64 && refresh_ctr < 8'd192);

  // This four-bit vector indicates which digit on the display is currently
  // being driven. Signal is active low; a 0 in the vector means "being drivin".
  assign digit_enable_ = enable_ ? 4'b1111 :
          (digit == 2'd0) ? 4'b1110 :
          (digit == 2'd1) ? 4'b1101 :
          (digit == 2'd2) ? 4'b1011 :
          4'b0111;

  // Counter that rolls over ever 256 clock cycles; used to cycle the digit
  // to be driven
  always@ (posedge clk or negedge reset_)
    if (!reset_)
      refresh_ctr <= 8'h00;
    else
      refresh_ctr <= refresh_ctr + 8'h01;

  // Indicates which of the four displays are being driven. Cycles through each
  // display, updated at each refresh pulse (ever 256 clock cycles).
  always@ (posedge clk or negedge reset_)
    if (!reset_)
      digit <= 2'd0;
    else if (refresh_ctr == 8'hff)
      digit <= digit + 2'd1;

endmodule
