module bcdcoder (
  segment,
  bcd
  );

  output [6:0] segment;
  input [3:0] bcd;

  // Least-significant bit is segment 'A', most significant is 'G'
  parameter char_0 = 7'b0111111;
  parameter char_1 = 7'b0000110;
  parameter char_2 = 7'b1011011;
  parameter char_3 = 7'b1001111;
  parameter char_4 = 7'b1100110;
  parameter char_5 = 7'b1101101;
  parameter char_6 = 7'b1111101;
  parameter char_7 = 7'b0000111;
  parameter char_8 = 7'b1111111;
  parameter char_9 = 7'b1101111;
  parameter char_  = 7'b1000000; 

  assign segment =
    (bcd == 4'd0) ? char_0 :
    (bcd == 4'd1) ? char_1 :
    (bcd == 4'd2) ? char_2 :
    (bcd == 4'd3) ? char_3 :
    (bcd == 4'd4) ? char_4 :
    (bcd == 4'd5) ? char_5 :
    (bcd == 4'd6) ? char_6 :
    (bcd == 4'd7) ? char_7 :
    (bcd == 4'd8) ? char_8 :
    (bcd == 4'd9) ? char_9 :
      char_;

endmodule
