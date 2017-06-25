# Default target runs simulation
all: simulate

libs    = -y rtl/ -y core/ -y $(XILINX)/verilog/src/simprims -y $(XILINX)/verilog/src/unimacro -y $(XILINX)/verilog/src/unisims
test    = test/testbench.v
bmm     = core/microblaze_mcs_v1_4.bmm
bd_bmm  = core/microblaze_mcs_v1_4_bd.bmm
elf     = src/helloworld/Debug/helloworld.elf
bit     = ise/microblaze.bit
bitcode = ise/microblaze-code.bit

# Generates memory initialization file (.mem) from firmware ELF
memory: $(bmm) $(elf)
	data2mem -bm $(bmm) -bd $(elf) -u -bx

# Generates FPGA programming file with embedded firmware
bit: bd_bmm_exists memory $(elf) $(bit) $(bd_bmm)
	data2mem -bm $(bd_bmm) -bd $(elf) -bt $(bit) -o b $(bitcode)

# Helpful household error message. Let user know if bd_bmm file is missing instead of letting data2mem throw unhelpful exception
bd_bmm_exists:
	@test -f $(bd_bmm) || echo "ERROR: $(bd_bmm) does not exist.\n\nThis probably indicates that you either a) haven't run the ISE Generate Programming File process, b) forgot to source core/microblaze_mcs_setup.tcl from the ISE Tcl Console or c) didn't generate your core under the core/ directory as instructed. Please refer to the tutorial instructions for details.\n\n"

# Removes all Makefile derived sources and files (does not remove ISE/coregen files)
clean:
	rm -f *.vcd diagram.* *.vg *.mem *.log
	rm -rf gen/

# Converts Verilog into an intermediate representation that is optimized for
# simulating.
compile: iverlog_installed memory $(test)
	-mkdir gen; true
	iverilog -o gen/testbench $(libs) $(XILINX)/verilog/src/glbl.v $(test)

# Runs a Verilog simulation of our testbench (and by extension our design)
simulate: vvp_installed compile
	vvp gen/testbench

# Loads a the Xilix .bit file on the Papilio's Spartan FPGA. Note that the .bit
# file must be created by Xilinx' ISE tool; this makefile cannot create it.
fpga: papilio_installed papilio/breathingled.bit
	sudo papilio-prog -v -f papilio/breathingled.bit


# Utility targets to check for proper tools installation
YOSYS    := $(shell command -v yosys 2> /dev/null)
IVERILOG := $(shell command -v iverilog 2> /dev/null)
VVP      := $(shell command -v vvp 2> /dev/null)
PAPILIO	 := $(shell command -v papilio-prog 2> /dev/null)

yosys_installed:
ifndef YOSYS
	$(error "Yosys verilog synthesis tool is not installed.")
endif

iverlog_installed:
ifndef IVERILOG
	$(error "Verilog compiler is not installed; try 'sudo apt install verilog'.")
endif

vvp_installed:
ifndef VVP
	$(error "VVP verilog simulation environment is not installed; try 'sudo apt install verilog'.")
endif

papilio_installed:
ifndef PAPILIO
	$(error "Papilio programmer (papilio-prog) is not installed.")
endif
