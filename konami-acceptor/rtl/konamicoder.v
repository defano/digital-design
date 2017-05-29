module konamicoder (
  digit_0,
  digit_1,
  digit_2,
  digit_3,
  state
  );

  output [6:0] digit_0;
  output [6:0] digit_1;
  output [6:0] digit_2;
  output [6:0] digit_3;
  input [3:0] state;

  wire [6:0] digit_0;
  wire [6:0] digit_1;
  wire [6:0] digit_2;
  wire [6:0] digit_3;


  // Least-significant bit is segment 'A', most significant is 'G'
  parameter char_u = 7'b0111110;
  parameter char_p = 7'b1110011;
  parameter char_d = 7'b1011110;
  parameter char_n = 7'b1010100;
  parameter char_l = 7'b0111000;
  parameter char_f = 7'b1110001;
  parameter char_r = 7'b1010000;
  parameter char_h = 7'b1110100;
  parameter char_0 = 7'b0111111;
  parameter char_1 = 7'b0000110;
  parameter char_2 = 7'b1011011;
  parameter char_9 = 7'b1101111;
  parameter char_  = 7'b1000000;

  assign digit_0 =
    (state == 4'd0) ? char_ :
    (state == 4'd1) ? char_u :
    (state == 4'd2) ? char_u :
    (state == 4'd3) ? char_d :
    (state == 4'd4) ? char_d :
    (state == 4'd5) ? char_l :
    (state == 4'd6) ? char_r :
    (state == 4'd7) ? char_l :
    (state == 4'd8) ? char_r :
    (state == 4'd9) ? char_9 : char_0;

  assign digit_1 =
    (state == 4'd0) ? char_ :
    (state == 4'd1) ? char_p :
    (state == 4'd2) ? char_p :
    (state == 4'd3) ? char_n :
    (state == 4'd4) ? char_n :
    (state == 4'd5) ? char_f :
    (state == 4'd6) ? char_h :
    (state == 4'd7) ? char_f :
    (state == 4'd8) ? char_h :
    (state == 4'd9) ? char_9 : char_0;

  assign digit_2 =
    (state == 4'd0) ? char_ :
    (state == 4'd1) ? char_ :
    (state == 4'd2) ? char_ :
    (state == 4'd3) ? char_ :
    (state == 4'd4) ? char_ :
    (state == 4'd5) ? char_ :
    (state == 4'd6) ? char_ :
    (state == 4'd7) ? char_ :
    (state == 4'd8) ? char_ :
    (state == 4'd9) ? char_9 : char_0;

  assign digit_3 =
    (state == 4'd0) ? char_ :
    (state == 4'd1) ? char_1 :
    (state == 4'd2) ? char_2 :
    (state == 4'd3) ? char_1 :
    (state == 4'd4) ? char_2 :
    (state == 4'd5) ? char_1 :
    (state == 4'd6) ? char_1 :
    (state == 4'd7) ? char_2 :
    (state == 4'd8) ? char_2 :
    (state == 4'd9) ? char_9 : char_0;

endmodule
