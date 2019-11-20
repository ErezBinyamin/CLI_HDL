#!/bin/bash
SIM_DIR=sim
SRC_DIR=work
#TST_BCH=tst/MultiplierTB.vhd
SIM_FILE=sim
GTK_FILE=gtk.vcdgz
STOP_TIME=500ns

# Code from
# http://www.armadeus.org/wiki/index.php?title=How_to_make_a_VHDL_design_in_Ubuntu/Debian

simulate() {
	# 1. Syntax check
	ghdl -i --ieee=synopsys --warn-no-vital-generic --workdir=${SIM_DIR} --work=${SRC_DIR} ${SRC_DIR}/*.vhd
	# 2. Compile
	if [ $? -eq 0 ]
	then
		ghdl -m --ieee=synopsys --warn-no-vital-generic --workdir=${SIM_DIR} --work=${SRC_DIR} ${SIM_FILE}
	else
		return 1
	fi
	# 3. Generate simulation
	if [ $? -eq 0 ]
	then
		./${SIM_FILE} --stop-time=${STOP_TIME} --vcdgz=${GTK_FILE}
	else
		return 1
	fi
	# 4. Run simulation
	if [ $? -eq 0 ]
	then
		gunzip --stdout ${GTK_FILE} | gtkwave --vcd
	else
		return 1
	fi
}

simulate ${@}
