# Default target runs simulation
all: waveform

MODULES=$(wildcard rtl/*.v)
TEST=test/testbench.vt

# Removes all derived sources and files
clean:
	rm -f *.vcd 
	rm -rf gen/

# Converts Verilog into an intermediate representation that is optimized for
# simulating.
gen/testbench: iverlog_installed $(MODULES) $(TEST)
	-mkdir gen; true
	iverilog -o gen/testbench $(TEST) $(MODULES)

# Runs a Verilog simulation of our testbench (and by extension our design)
waveform: vvp_installed gen/testbench
	vvp gen/testbench

# Utility targets to check for proper tools installation
IVERILOG := $(shell command -v iverilog 2> /dev/null)
VVP      := $(shell command -v vvp 2> /dev/null)

iverlog_installed:
ifndef IVERILOG
	$(error "Verilog compiler is not installed; try 'sudo apt install verilog'.")
endif

vvp_installed:
ifndef VVP
	$(error "VVP verilog simulation environment is not installed; try 'sudo apt install verilog'.")
endif
