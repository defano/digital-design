module uart_ctrl (
   clk,
   reset_,
   tx,
   rx,
   addr,
   cs,
   req,
   rnw,
   wr_data,
   rd_data,
   rdy);

   input        clk;
   input        reset_;
   output       tx;         // Transmit to host computer
   input        rx;         // Receive from host computer

   // Local IO bus
   input  [7:0] addr;
   input        cs;
   input        req;
   inout        rnw;
   input  [7:0] wr_data;
   output [7:0] rd_data;
   output       rdy;

   reg          rdy;
   reg  [7:0]   rd_data;

   wire         wr_enable;
   wire         rd_enable;

   reg          tx_enable;
   reg  [7:0]   tx_data;
   reg  [7:0]   rx_data_reg;
   reg  [15:0]  tx_count;
   reg  [15:0]  rx_count;

   wire         tx_ready;
   wire [7:0]   rx_data;
   reg          rx_ready;

   // Software addressable registers
   parameter TX_BYTE_REG        = 8'd0;
   parameter TX_BYTE_RDY_REG    = 8'd1;
   parameter RX_BYTE_REG        = 8'd2;
   parameter RX_BYTE_RDY_REG    = 8'd3;
   parameter TX_BYTE_CNT_HI_REG = 8'd4;
   parameter TX_BYTE_CNT_LO_REG = 8'd5;
   parameter RX_BYTE_CNT_HI_REG = 8'd6;
   parameter RX_BYTE_CNT_LO_REG = 8'd7;

   assign wr_enable = cs && !rnw && req;
   assign rd_enable = cs && rnw && req;

   // Transmit data register
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       tx_data <= 8'd0;
     else if (wr_enable && addr == TX_BYTE_REG)
       tx_data <= wr_data;

   // Transmit enable generation
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       tx_enable <= 1'b0;
     else if (wr_enable && addr == TX_BYTE_REG)
       tx_enable <= 1'b1;
     else
       tx_enable <= 1'b0;

   // Receive data register
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       rx_data_reg <= 8'h00;
     else if (rx_enable)
       rx_data_reg <= rx_data;

   // Receive ready readback
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       rx_ready <= 1'b0;
     else if (wr_enable && addr == RX_BYTE_RDY_REG)
       rx_ready <= 1'b0;
     else if (rx_enable)
       rx_ready <= 1'b1;

   // Transmit byte count
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       tx_count <= 16'd0;
     else if (tx_enable)
       tx_count <= tx_count + 16'd1;

   // Receive byte count
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       rx_count <= 16'd0;
     else if (rx_enable)
       rx_count <= rx_count + 16'd1;

   // Register readback
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       rd_data <= 8'd0;
     else if (rd_enable)
       rd_data <= (addr == TX_BYTE_RDY_REG)    ? {7'd0, tx_ready} :
                  (addr == TX_BYTE_REG)        ? tx_data :
                  (addr == RX_BYTE_REG)        ? rx_data_reg :
                  (addr == RX_BYTE_RDY_REG)    ? {7'd0, rx_ready} :
                  (addr == TX_BYTE_CNT_HI_REG) ? tx_count[15:8] :
                  (addr == TX_BYTE_CNT_LO_REG) ? tx_count[7:0] :
                  (addr == RX_BYTE_CNT_HI_REG) ? rx_count[15:8] :
                  (addr == RX_BYTE_CNT_LO_REG) ? rx_count[7:0] :
                  8'd0;

   // Module ready generation
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       rdy <= 1'b0;
     else
       rdy <= req;

    // UART instantiation
    uart uart(
      .clk32(clk),
      .reset_(reset_),
      .rx(rx),
      .tx(tx),
      .txdata(tx_data),
      .rxdata(rx_data),
      .rx_enable(rx_enable),
      .tx_enable(tx_enable),
      .tx_ready(tx_ready)
    );

endmodule
