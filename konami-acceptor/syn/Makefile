PROJECT=konami
UCF=../papilio/papilio-pro.ucf

TARGET_DEVICE=xc6slx9-tqg144-2

all: bit

# Synthesize the design to a gate-level netlist (for educational purposes only; has no
# effect on creating an FPGA programming file).
netlist: yosys_installed
	yosys -s synthesize.ys

# Loads the programming file onto the Papilio Pro hardware
papilio: ../papilio/$(PROJECT).bit
	sudo papilio-prog -v -f ../papilio/$(PROJECT).bit

# Synthesize design using Xilinx Synthesis Technology (XST)
xst: xst_installed
	-mkdir xst
	-mkdir xst/projnav.tmp
	xst -intstyle ise -ifn $(PROJECT).xst -ofn $(PROJECT).syr

# Create Xilinx Native Database (internal representation)
ngd: ngdbuild_installed xst
	ngdbuild -intstyle ise -dd _ngo -nt timestamp -uc $(UCF) -p $(TARGET_DEVICE) $(PROJECT).ngc $(PROJECT).ngd

# Map logical design to physical device
map: map_installed ngd
	map -intstyle ise -p $(TARGET_DEVICE) -w -logic_opt off -ol high -t 1 -xt 0 -register_duplication off -r 4 -global_opt off -mt off -ir off -pr off -lc off -power off -o $(PROJECT)_map.ncd $(PROJECT).ngd $(PROJECT).pcf

# Place and route elements
par: par_installed map
	par -w -intstyle ise -ol high -mt off $(PROJECT)_map.ncd $(PROJECT).ncd $(PROJECT).pcf

# Timing report and circuit evaluation (verify design meets timing)
trace: trace_installed par
	trce -intstyle ise -v 3 -s 2 -n 3 -fastpaths -xml $(PROJECT).twx $(PROJECT).ncd -o $(PROJECT).twr $(PROJECT).pcf

# Generate programming file
bit: bitgen_installed trace
	touch $(PROJECT).ut
	bitgen -intstyle ise -f $(PROJECT).ut $(PROJECT).ncd
	cp $(PROJECT).bit ../papilio/$(PROJECT).bit

# Remove all derived sources
clean:
	-rm -rf _ngo
	-rm -rf xlnx_auto_0_xdb
	-rm -rf _xmsgs
	-rm -rf xst
	-rm *.svg *.vg *.dot *.xwbt *.bgn *.bit *.ut *.log *.drc *.syr *.ngd *.html *.xrpt *.bld *.lso *.map *.mrp *.ngm *.ncd *.ngc *.ngr *.pad *.csv *.txt *.par *.pcf *.ptwx *.twr *.twx *unroutes *.xml *.xpi


# Utility targets to check for proper tools installation
BITGEN    := $(shell command -v bitgen 2> /dev/null)
TRACE     := $(shell command -v trce 2> /dev/null)
PAR       := $(shell command -v par 2> /dev/null)
MAP       := $(shell command -v map 2> /dev/null)
NGDBUILD  := $(shell command -v ngdbuild 2> /dev/null)
XST       := $(shell command -v xst 2> /dev/null)
YOSYS     := $(shell command -v yosys 2> /dev/null)
PAPILIO   := $(shell command -v papilio-prog 2> /dev/null)

bitgen_installed:
ifndef BITGEN
        $(error "Xilinx bitgen tool not installed; see setup instructions at https://github.com/defano/digital-design.")
endif

trace_installed:
ifndef TRACE
        $(error "Xilinx trce tool not installed; see setup instructions at https://github.com/defano/digital-design.")
endif

par_installed:
ifndef PAR
        $(error "Xilinx par tool not installed; see setup instructions at https://github.com/defano/digital-design.")
endif

map_installed:
ifndef MAP
        $(error "Xilinx map tool not installed; see setup instructions at https://github.com/defano/digital-design.")
endif

ngdbuild_installed:
ifndef NGDBUILD
        $(error "Xilinx ngdbuild tool not installed; see setup instructions at https://github.com/defano/digital-design.")
endif

xst_installed:
ifndef XST
        $(error "Xilinx xst tool not installed; see setup instructions at https://github.com/defano/digital-design.")
endif

yosys_installed:
ifndef YOSYS
        $(error "Yosys Verilog synthesis tool is not installed.")
endif

papilio_installed:
ifndef PAPILIO
	$(error "Papilio programmer (papilio-prog) is not installed.")
endif
