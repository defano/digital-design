# Default target runs simulation
all: simulate

# Removes all derived sources and files
clean:
	rm -f *.vcd gen/* diagram.* seven-segment.netlist.v

# Converts Verilog into an intermediate representation that is optimized for
# simulating.
compile: iverlog_installed rtl/seven-segment.v rtl/display-driver.v rtl/bcd-coder.v test/testbench.vt
	iverilog -o gen/testbench test/testbench.vt rtl/seven-segment.v rtl/display-driver.v rtl/bcd-coder.v

# Runs a Verilog simulation of our testbench (and by extension our design)
simulate: vvp_installed compile
	vvp gen/testbench

# Synthesizes the design to a Verilog netlist consisting only of the logic gates
# and flip-flops defined in the .lib files inside the cells directory
synthesize: yosys_installed
	yosys -s syn/synthesize.ys

# Loads a the Xilix .bit file on the Papilio's Spartan FPGA. Note that the .bit
# file must be created by Xilinx' ISE tool; this makefile cannot create it.
fpga: papilio_installed papilio/seven_segment.bit
	sudo papilio-prog -v -f papilio/seven_segment.bit


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
