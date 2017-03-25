module rx(
   clk,
   reset_,
   sample,
   rx,
   rx_enable,
   rxdata);

   input        clk;
   input        reset_;
   input        sample;         // Pulse at "sample rate" (16x baud frequency)
   input        rx;             // Serial RX data from FTDI USB chip
   output       rx_enable;      // Set high for one clock when rxdata is ready
   output [7:0] rxdata;         // Deserialized byte received

   wire 	rx_stop;
   wire 	rx_enable;
   
   reg [2:0] 	state;
   reg [3:0] 	sample_cnt;
   reg [3:0] 	rxpos; 	
   reg [7:0] 	rxdata;

   // Indicates rxdata is ready (when STOP bit has finished being sampled)
   assign rx_enable = state == ST_RXSTOP && rx_stop;

   // End of stop bit; either when sample count saturates, or rx goes to
   // 0 at least halfway through the expected sample period
   assign rx_stop = sample_cnt == 4'hf || (!rx && sample_cnt > 4'h8);

   // End of bit period
   assign sample_done = sample_cnt == 4'hf;

   // Moment when data is sampled; halfway through bit period
   assign sample_en = sample_cnt == 4'h8;
   
   parameter ST_IDLE    = 2'd0;
   parameter ST_RXSTART = 2'd1;
   parameter ST_RXDATA  = 2'd2;
   parameter ST_RXSTOP  = 2'd3;

   // State machine
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       state <= ST_IDLE;
     else if (state == ST_IDLE && !rx)
       state <= ST_RXSTART;
     else if (state == ST_RXSTART && sample && sample_done)
       state <= ST_RXDATA;
     else if (state == ST_RXDATA && rxpos == 4'd8 && sample_done)
       state <= ST_RXSTOP;
     else if (state == ST_RXSTOP && rx_stop)
       state <= ST_IDLE;

   // Sample counter
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       sample_cnt <= 4'h0;
     else if (sample && state == ST_IDLE)
       sample_cnt <= 4'h0;
     else if (sample && (state == ST_RXSTART && (!rx || sample_cnt != 4'h0)))
       sample_cnt <= sample_cnt + 4'h1;
     else if (sample && state == ST_RXSTART && sample_done)
       sample_cnt <= 4'h0;
     else if (sample && (state == ST_RXDATA || state == ST_RXSTOP))
       sample_cnt <= sample_cnt + 4'h1;

   // Rx data bit position (which bit in the byte are we sampling)
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       rxpos <= 4'h0;
     else if (sample && state == ST_RXSTART)
       rxpos <= 4'h0;
     else if (sample && state == ST_RXDATA && sample_en)
       rxpos <= rxpos + 4'h1;

   // Deserialized data
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       rxdata <= 8'h0;
     else if (sample && sample_en)
       rxdata[rxpos[2:0]] <= rx;
      
endmodule
