module bus_arb (
   clk,
   reset_,
   mcs_addr,
   mcs_ready,
   mcs_wr_data,
   mcs_wr_enable,
   mcs_rd_data,
   mcs_rd_enable,
   mcs_byte_enable,
   addr,
   rnw,
   req,
   wr_data,
   gpio_cs,
   gpio_rd_data,
   gpio_rdy,
   disp_cs,
   disp_rd_data,
   disp_rdy,
   uart_cs,
   uart_rd_data,
   uart_rdy);

   input         clk;
   input         reset_;

   // Bus controller to distribute MicroBlaze IO bus to our own hardware modules.
   // This circuit decodes the address bus and generates module-independent
   // bus control signals to each hardware module (like display, uart, gpio)
   // and provides a ready timeout function to prevent the CPU from waiting
   // indefinitely for a response (as would be the case if software tried to
   // access an unmapped memory location).

   // MicroBlaze IO Bus
   input  [31:0] mcs_addr;          // Address from MicroBlaze
   output        mcs_ready;         // Request complete indicator to MicroBlaze
   input  [31:0] mcs_wr_data;       // Write data from MicroBlaze
   input         mcs_wr_enable;     // Write enable from MicroBlaze
   output [31:0] mcs_rd_data;       // Read data from hardware
   input         mcs_rd_enable;     // Read enable from MicroBlaze
   input  [3:0]  mcs_byte_enable;   // Which byte(s) in 32-bit longword are being accessed

   // Local IO Bus
   output [7:0]  addr;              // Address to lsuc module
   output        rnw;               // Read, not write, indicator
   output        req;               // Bus request
   output [7:0]  wr_data;           // Write data to lsuc module
   output        gpio_cs;           // GPIO module chip select
   input  [7:0]  gpio_rd_data;      // Read data from GPIO module
   input         gpio_rdy;          // Ready indicator from GPIO module
   output        disp_cs;           // Display module chip select
   input  [7:0]  disp_rd_data;      // Read data from display module
   input         disp_rdy;          // Ready indicator from display module
   output        uart_cs;           // UART module chip select
   input  [7:0]  uart_rd_data;      // Read data from UART module
   input         uart_rdy;          // Ready indicator from UART module

   reg    [31:0] mcs_rd_data;
   reg             mcs_ready;
   reg    [9:0]  req_timeout_ctr;

   assign addr    = mcs_addr[7:0];
   assign rnw     = ~mcs_wr_enable;
   assign req     = mcs_rd_enable || mcs_wr_enable;
   assign wr_data = mcs_wr_data[7:0];

   // Top-level memory mapping
   assign gpio_cs = mcs_addr[31:28] == 4'hc;    // GPIO module mapped to 0x4000_00xx addresses
   assign disp_cs = mcs_addr[31:28] == 4'hd;    // Display module mapped to 0x4000_00xx addresses
   assign uart_cs = mcs_addr[31:28] == 4'he;    // UART module mapped to 0x4000_00xx addresses

   // Readback generation
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       mcs_rd_data <= 32'h0000_0000;
     else if (rnw && gpio_cs && gpio_rdy)
       mcs_rd_data <= {4{gpio_rd_data}};
     else if (rnw && disp_cs && disp_rdy)
       mcs_rd_data <= {4{disp_rd_data}};
     else if (rnw && uart_cs && uart_rdy)
       mcs_rd_data <= {4{uart_rd_data}};

   // Request ready generation
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       mcs_ready <= 1'b0;
     else if (gpio_cs)
       mcs_ready <= gpio_rdy;
     else if (disp_cs)
       mcs_ready <= disp_rdy;
     else if (uart_cs)
       mcs_ready <= uart_rdy;
     else
       mcs_ready <= &req_timeout_ctr;

   // Request timeout generation (prevents CPU from locking if no harware responds to request)
   always@ (posedge clk or negedge reset_)
     if (!reset_)
       req_timeout_ctr <= 10'd0;
     else if (mcs_ready)
       req_timeout_ctr <= 10'd0;
     else if (req)
       req_timeout_ctr <= 10'd1;
     else if (req_timeout_ctr != 10'd0)
       req_timeout_ctr <= req_timeout_ctr + 10'd1;

endmodule
