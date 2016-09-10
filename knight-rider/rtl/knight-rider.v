module knightrider (
    clk,
    reset_,
    led);

   input   clk;
   input   reset_;
   output  [7:0] led;

   // Goal is to change LED pattern roughly every 250ms. The Papilio Pro
   // clock runs at 32 MHz (32.25 ns period). If we increment a 21 bit counter
   // on each clock cycle, it will roll over approximately each quarter second.
   // (Arithmetic left to the interested student.)
   reg [20:0] count;

   // Board has eight LEDs; this vector represents the state of each LED. A one
   // in the corresponding bit turns the LED on; a zero turns it off.
   reg [7:0]  led;

   // A single bit indication of whether the LED animation is moving right
   // to left. (Once the active LED is in the left-most position, we clear this
   // value to signal we should start shifting right.)
   reg         left_shift;

   // Change the LED pattern each time our counter rolls over. The shift signal
   // will go high (1'b1) only for the single clock cycle where the counter is
   // maxed out. This is combinitorial logic; the value is continuously updated.
   assign shift = count == 21'h1FFFFF;

   // Increment the counter at each clock tick; set counter to 0 on reset.
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       count <= 21'h0;
     else
       count <= count + 1;

   // Shift the state of the LEDs each time the 'shift' signal is high (should
   // be the case only one clock cycle per ~250ms). LED state has one bit set,
   // the remaining seven cleared.
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       led[7:0] <= 8'b1000_0000;
     else if (shift && left_shift)    // Move 'on' LED left one position
       led[7:0] <= led[7:0] << 1;
     else if (shift)                  // Move right
       led[7:0] <= led[7:0] >> 1;

   // Track whether we're moving left or right. When the 'on' LED reaches the
   // left-most position, clear this value. When it reaches the right-most
   // position, set it.
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       left_shift <= 1'b0;
     else if (led[7:0] == 8'b1000_0000)
       left_shift <= 1'b0;
     else if (led[7:0] == 8'b0000_0001)
       left_shift <= 1'b1;

endmodule
