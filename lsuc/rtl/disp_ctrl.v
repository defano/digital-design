module disp_ctrl (
   clk,
   reset_,
   segments_,
   digit_enable_,
   addr,
   cs,
   req,
   rnw,
   wr_data,
   rd_data,
   rdy);

   input        clk;
   input        reset_;
   output [6:0] segments_;        // 7-segment display segments (active low)
   output [3:0] digit_enable_;    // Which digit(s) are being controlled

   // Local address bus
   input  [7:0] addr;
   input        cs;
   input        req;
   inout        rnw;
   input  [7:0] wr_data;
   output [7:0] rd_data;
   output       rdy;

   reg [3:0]   digit_display_mode;
   reg [6:0]   digit_0_value;
   reg [6:0]   digit_1_value;
   reg [6:0]   digit_2_value;
   reg [6:0]   digit_3_value;

   reg         rdy;
   reg [7:0]   rd_data;

   wire [6:0]   segments_;
   wire [3:0]   digit_enable_;

   wire [6:0]   digit_0_segments;
   wire [6:0]   digit_1_segments;
   wire [6:0]   digit_2_segments;
   wire [6:0]   digit_3_segments;

   wire [6:0]   digit_0;
   wire [6:0]   digit_1;
   wire [6:0]   digit_2;
   wire [6:0]   digit_3;

   wire         wr_enable;
   wire         rd_enable;

   // Software addressable registers
   parameter REG_DIGIT_0_MODE  = 8'd0;
   parameter REG_DIGIT_0_VALUE = 8'd1;
   parameter REG_DIGIT_1_MODE  = 8'd2;
   parameter REG_DIGIT_1_VALUE = 8'd3;
   parameter REG_DIGIT_2_MODE  = 8'd4;
   parameter REG_DIGIT_2_VALUE = 8'd5;
   parameter REG_DIGIT_3_MODE  = 8'd6;
   parameter REG_DIGIT_3_VALUE = 8'd7;

   assign wr_enable = cs && !rnw && req;
   assign rd_enable = cs && rnw && req;

   // Digit 0 display value
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       digit_0_value <= 7'h0;
     else if (wr_enable && addr == REG_DIGIT_0_VALUE)
       digit_0_value <= wr_data[6:0];

   // Digit 1 display value
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       digit_1_value <= 7'h0;
     else if (wr_enable && addr == REG_DIGIT_1_VALUE)
       digit_1_value <= wr_data[6:0];

   // Digit 2 display value
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       digit_2_value <= 7'h0;
     else if (wr_enable && addr == REG_DIGIT_2_VALUE)
       digit_2_value <= wr_data[6:0];

   // Digit 3 display value
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       digit_3_value <= 7'h0;
     else if (wr_enable && addr == REG_DIGIT_3_VALUE)
       digit_3_value <= wr_data[6:0];

   // Write digital display mode.
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       digit_display_mode <= 4'h0;
     else if (wr_enable && addr == REG_DIGIT_0_MODE)
       digit_display_mode[0] <= wr_data[0];
     else if (wr_enable && addr == REG_DIGIT_1_MODE)
       digit_display_mode[1] <= wr_data[1];
     else if (wr_enable && addr == REG_DIGIT_2_MODE)
       digit_display_mode[2] <= wr_data[2];
     else if (wr_enable && addr == REG_DIGIT_3_MODE)
       digit_display_mode[3] <= wr_data[3];

   // Register readback
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       rd_data <= 8'h00;
     else if (rd_enable)
       rd_data <= (addr == REG_DIGIT_0_VALUE) ? {1'h0, digit_0_value} :
                  (addr == REG_DIGIT_1_VALUE) ? {1'h0, digit_1_value} :
                  (addr == REG_DIGIT_2_VALUE) ? {1'h0, digit_2_value} :
                  (addr == REG_DIGIT_3_VALUE) ? {1'h0, digit_3_value} :
                  (addr == REG_DIGIT_0_MODE)  ? {7'h0, digit_display_mode[0]} :
                  (addr == REG_DIGIT_1_MODE)  ? {7'h0, digit_display_mode[1]} :
                  (addr == REG_DIGIT_2_MODE)  ? {7'h0, digit_display_mode[2]} :
                  (addr == REG_DIGIT_3_MODE)  ? {7'h0, digit_display_mode[3]} :
                  8'h00;

   // Readback ready generation
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       rdy <= 1'b0;
     else
       rdy <= req;

   // Binary coded decimal to 7-segment display coders
   bcdcoder digit0_coder (
     .segment(digit_0_segments),
     .bcd(digit_0_value[3:0])
   );

   bcdcoder digit1_coder (
     .segment(digit_1_segments),
     .bcd(digit_1_value[3:0])
   );

   bcdcoder digit2_coder (
     .segment(digit_2_segments),
     .bcd(digit_2_value[3:0])
   );

   bcdcoder digit3_coder (
     .segment(digit_3_segments),
     .bcd(digit_3_value[3:0])
   );

   // When display mode is 1, the interpret digit value as raw segment enables;
   // otherwise, assume digit value is BCD (display a number between 0..9)
   assign digit_0 = digit_display_mode[0] ? digit_0_value[6:0] : digit_0_segments;
   assign digit_1 = digit_display_mode[1] ? digit_1_value[6:0] : digit_1_segments;
   assign digit_2 = digit_display_mode[2] ? digit_2_value[6:0] : digit_2_segments;
   assign digit_3 = digit_display_mode[3] ? digit_3_value[6:0] : digit_3_segments;

   // Display driver instantiation
   displaydriver displaydriver (
     .clk(clk),
     .reset_(reset_),
     .digit_0(digit_0),
     .digit_1(digit_1),
     .digit_2(digit_2),
     .digit_3(digit_3),
     .segment_(segments_),
     .digit_enable_(digit_enable_)
   );

endmodule
