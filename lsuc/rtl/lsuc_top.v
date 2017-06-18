module lsuc_top (
     clk,
     reset_,
     led,
     switches,
     segment_,
     digit_enable_,
     up_,
     down_,
     left_,
     right_,
     tx,
     rx);

   input        clk;
   input        reset_;
   output [7:0] led;            // LogicSmart LEDs
   input  [6:0] switches;       // LogicSmart toggle switches (first one is tied to reset)
   output [6:0] segment_;       // Seven segment display segments
   output [3:0] digit_enable_;  // Seven segment display digit enable
   input        up_;            // D-pad up key
   input        down_;          // D-pad down key
   input        left_;          // D-pad left key
   input        right_;         // D-pad right key
   output       tx;             // UART transmit (to host computer)
   input        rx;             // UART receive (from host computer)

   // Top-level module for the LogicStart Microcontroller; instantiates all
   // submodules and connects them together (provides no other logic).

   wire         clk;
   wire         reset_;
   wire [31:0]  mcs_addr;
   wire         mcs_ready;
   wire [31:0]  mcs_wr_data;
   wire         mcs_wr_enable;
   wire [31:0]  mcs_rd_data;
   wire         mcs_rd_enable;
   wire [3:0]   mcs_byte_enable;
   wire [7:0]   addr;
   wire         req;
   wire [7:0]   wr_data;
   wire         rnw;
   wire         gpio_cs;
   wire [7:0]   gpio_rd_data;
   wire         gpio_rdy;
   wire         disp_cs;
   wire [7:0]   disp_rd_data;
   wire         disp_rdy;
   wire         uart_cs;
   wire [7:0]   uart_rd_data;
   wire         uart_rdy;

   // Bus controller instantiation ("distributes" MicroBlaze IO bus to local modules)
   bus_arb bus_arb (
     .clk(clk),
     .reset_(reset_),
     .mcs_addr(mcs_addr),
     .mcs_ready(mcs_ready),
     .mcs_wr_data(mcs_wr_data),
     .mcs_wr_enable(mcs_wr_enable),
     .mcs_rd_data(mcs_rd_data),
     .mcs_rd_enable(mcs_rd_enable),
     .mcs_byte_enable(mcs_byte_enable),
     .addr(addr),
     .req(req),
     .rnw(rnw),
     .wr_data(wr_data),
     .gpio_cs(gpio_cs),
     .gpio_rd_data(gpio_rd_data),
     .gpio_rdy(gpio_rdy),
     .disp_cs(disp_cs),
     .disp_rd_data(disp_rd_data),
     .disp_rdy(disp_rdy),
     .uart_cs(uart_cs),
     .uart_rd_data(uart_rd_data),
     .uart_rdy(uart_rdy)
   );

   // GPIO control module (provides software interface to leds, switches and d-pad)
   gpio_ctrl gpio_ctrl (
     .clk(clk),
     .reset_(reset_),
     .leds(led),
     .switches(switches),
     .up(~up_),
     .down(~down_),
     .left(~left_),
     .right(~right_),
     .addr(addr),
     .cs(gpio_cs),
     .req(req),
     .rnw(rnw),
     .wr_data(wr_data),
     .rd_data(gpio_rd_data),
     .rdy(gpio_rdy)
   );

   // Display control module (provides software interface to 7-segment display)
   disp_ctrl disp_ctrl (
     .clk(clk),
     .reset_(reset_),
     .segments_(segment_),
     .digit_enable_(digit_enable_),
     .addr(addr),
     .cs(disp_cs),
     .req(req),
     .rnw(rnw),
     .wr_data(wr_data),
     .rd_data(disp_rd_data),
     .rdy(disp_rdy)
   );

   // UART control module (provides software interface to UART)
   uart_ctrl uart_ctrl (
     .clk(clk),
     .reset_(reset_),
     .tx(tx),
     .rx(rx),
     .addr(addr),
     .cs(uart_cs),
     .req(req),
     .rnw(rnw),
     .wr_data(wr_data),
     .rd_data(uart_rd_data),
     .rdy(uart_rdy)
   );

   // Xilinx MicroBlaze CPU core
   microblaze_mcs_v1_4 mcs_0 (
     .Clk(clk),                        // input Clk
     .Reset(~reset_),                  // input Reset
     .IO_Addr_Strobe(),                // output IO_Addr_Strobe
     .IO_Read_Strobe(mcs_rd_enable),   // output IO_Read_Strobe
     .IO_Write_Strobe(mcs_wr_enable),  // output IO_Write_Strobe
     .IO_Address(mcs_addr),            // output [31 : 0] IO_Address
     .IO_Byte_Enable(mcs_byte_enable), // output [3 : 0] IO_Byte_Enable
     .IO_Write_Data(mcs_wr_data),      // output [31 : 0] IO_Write_Data
     .IO_Read_Data(mcs_rd_data),       // input [31 : 0] IO_Read_Data
     .IO_Ready(mcs_ready)              // input IO_Ready
   );

endmodule
