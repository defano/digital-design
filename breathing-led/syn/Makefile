PROJECT=breathingled
UCF=../papilio/papilio-pro.ucf

TARGET_DEVICE=xc6slx9-tqg144-2

all: bit

# Synthesize the design to a gate-level netlist (for educational purposes only; has no
# effect on creating an FPGA programming file).
netlist:
	yosys -s synthesize.ys

papilio: ../papilio/$(PROJECT).bit
	sudo papilio-prog -v -f ../papilio/$(PROJECT).bit

# Synthesize design using Xilinx Synthesis Technology (XST)
xst: 
	-mkdir xst
	-mkdir xst/projnav.tmp
	xst -intstyle ise -ifn $(PROJECT).xst -ofn $(PROJECT).syr

# Create Xilinx Native Database (internal representation) 
ngd: xst
	ngdbuild -intstyle ise -dd _ngo -nt timestamp -uc $(UCF) -p $(TARGET_DEVICE) $(PROJECT).ngc $(PROJECT).ngd

# Map logical design to physical device
map: ngd
	map -intstyle ise -p $(TARGET_DEVICE) -w -logic_opt off -ol high -t 1 -xt 0 -register_duplication off -r 4 -global_opt off -mt off -ir off -pr off -lc off -power off -o $(PROJECT)_map.ncd $(PROJECT).ngd $(PROJECT).pcf

# Place and route elements
par: map
	par -w -intstyle ise -ol high -mt off $(PROJECT)_map.ncd $(PROJECT).ncd $(PROJECT).pcf

# Timing report and circuit evaluation (verify design meets timing)
trace: par
	trce -intstyle ise -v 3 -s 2 -n 3 -fastpaths -xml $(PROJECT).twx $(PROJECT).ncd -o $(PROJECT).twr $(PROJECT).pcf

# Generate programming file
bit: trace
	touch $(PROJECT).ut
	bitgen -intstyle ise -f $(PROJECT).ut $(PROJECT).ncd
	cp $(PROJECT).bit ../papilio/$(PROJECT).bit

clean:
	-rm -rf _ngo
	-rm -rf xlnx_auto_0_xdb
	-rm -rf _xmsgs
	-rm -rf xst
	-rm *.svg *.vg *.dot *.xwbt *.bgn *.bit *.ut *.log *.drc *.syr *.ngd *.html *.xrpt *.bld *.lso *.map *.mrp *.ngm *.ncd *.ngc *.ngr *.pad *.csv *.txt *.par *.pcf *.ptwx *.twr *.twx *unroutes *.xml *.xpi 
