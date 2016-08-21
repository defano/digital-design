YOSYS    := $(shell command -v yosys 2> /dev/null)
IVERILOG := $(shell command -v iverilog 2> /dev/null)
VVP      := $(shell command -v vvp 2> /dev/null)

all: simulate

compile: iverlog_installed rtl/blinker.v test/testbench.vt
	iverilog -o gen/testbench test/testbench.vt rtl/blinker.v

simulate: vvp_installed compile
	vvp gen/testbench

synthesize:
	yosys -s syn/synthesize.ys

clean:
	rm -f *.vcd gen/* diagram.* blinker_netlist.v

yosys_installed:
ifndef YOSYS
	$(error "Yosys Verilog Synthesis tool is not installed.")
endif

iverlog_installed:
ifndef IVERILOG
	$(error "Verilog compiler is not installed; try 'brew install icarus-verilog'.")
endif

vvp_installed:
ifndef VVP
	$(error "VVP Verilog simulation environment is not installed; try 'brew install icarus-verilog'.")
endif
