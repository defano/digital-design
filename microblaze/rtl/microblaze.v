module microblaze (clk, reset_, led);

  input  clk, reset_;
  output [7:0] led;

	wire reset;
	wire [31:0] tr_instruction;
	wire        tr_valid_instruction;
	wire [31:0] tr_pc;
	wire 	      tr_reg_write;
	wire [4:0]  tr_reg_addr;
	wire [14:0] tr_msr_reg;
	wire [31:0] tr_new_reg_val;
	wire        tr_jump_taken;
	wire        tr_delay_slot;
	wire [31:0] tr_data_addr;
	wire        tr_data_access;
	wire        tr_data_read;
	wire        tr_data_write;
	wire [31:0] tr_data_write_val;
	wire [3:0]  tr_data_byte_en;
	wire        tr_halted;

	// **GOTCHA** Reset on MCS is active high, not active low!
	assign reset = ~reset_;

	microblaze_mcs_v1_4 mcs_0 (
	  .Clk(clk),      // input 32Mhz clk
	  .Reset(reset),  // input **active high** reset
	  .GPO1(led),     // output [7:0] GPO1

	  // Trace bus connections: for waveform debugging, only
	  .Trace_Instruction(tr_instruction),
	  .Trace_Valid_Instr(tr_valid_instruction),
	  .Trace_PC(tr_pc),
	  .Trace_Reg_Write(tr_reg_write),
	  .Trace_Reg_Addr(tr_reg_addr),
	  .Trace_MSR_Reg(tr_msr_reg),
	  .Trace_New_Reg_Value(tr_new_reg_val),
	  .Trace_Jump_Taken(tr_jump_taken),
	  .Trace_Delay_Slot(tr_delay_slot),
	  .Trace_Data_Address(tr_data_addr),
	  .Trace_Data_Access(tr_data_access),
	  .Trace_Data_Read(tr_data_read),
	  .Trace_Data_Write(tr_data_write),
	  .Trace_Data_Write_Value(tr_data_write_val),
	  .Trace_Data_Byte_Enable(tr_data_byte_en),
	  .Trace_MB_Halted(tr_halted)
	);

endmodule
