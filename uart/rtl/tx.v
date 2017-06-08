module tx (
    clk,
    reset_,
    baud,
    txdata,
    tx_enable,
    tx_ready,	   
    tx);

   input       clk;
   input       reset_;    
   input       baud;       // Baud enable
   input [7:0] txdata;     // Parallel data to transmit
   input       tx_enable;  // When asserted, txdata is sampled for transmission
   output      tx_ready;   // Asserted when transmit complete (ready for next byte)
   output      tx;         // Serial transmit data

   reg 	       tx;
   reg [1:0]   state;
   reg [7:0]   txdata_sampled;
   reg [2:0]   txpos;   
   
   // Transmitter states
   parameter ST_IDLE    = 2'd0;
   parameter ST_TXSTART = 2'd1;
   parameter ST_TXDATA  = 2'd2;
   parameter ST_TXSTOP  = 2'd3;

   assign tx_ready = state == ST_IDLE;   
   
   // State machine
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       state <= ST_IDLE;
     else if (state == ST_IDLE && tx_enable)
       state <= ST_TXSTART;
     else if (state == ST_TXSTART && baud)
       state <= ST_TXDATA;
     else if (state == ST_TXDATA && baud && txpos == 3'd7)
       state <= ST_TXSTOP;
     else if (state == ST_TXSTOP && baud)
       state <= ST_IDLE;

   // Serial transmit data
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       tx <= 1'b1;
     else if (state == ST_TXSTART && baud)
       tx <= 1'b0;
     else if (state == ST_TXDATA && baud)
       tx <= txdata_sampled[txpos];
     else if (state == ST_TXSTOP && baud)
       tx <= 1'b1;

   // Transmit position (bit of txdata being sent)
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       txpos <= 3'd0;
     else if (state == ST_IDLE)
       txpos <= 3'd0;     
     else if (state == ST_TXDATA && baud)
       txpos <= txpos + 3'd1;

   // Local copy of txdata
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       txdata_sampled <= 8'h0;
     else if (tx_enable && tx_ready)
       txdata_sampled <= txdata;
      
endmodule
