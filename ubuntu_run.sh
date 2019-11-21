#!/bin/bash
SIM=sim
SRC_DIR=work
TST_DIR=tst
GTK_FILE=${SIM}/gtk.vcd
UUT=Full_Adder_1bit_tb

#SRC="${SRC_DIR}/* ${TST}/*"
SRC="${SRC_DIR}/Full_Adder_1bit.vhd ${TST_DIR}/Full_Adder_1bit_TB.vhd"
simulate() {
	# 1. Syntax check
	ghdl -s --workdir=${SIM} ${SRC} || return 1
	# 2. Compile
	ghdl -a --workdir=${SIM} ${SRC} || return 1
	# 3. Generate simulation
	ghdl -r --workdir=${SIM} ${UUT} --vcd=${GTK_FILE} || return 1
	# 4. Run simulation
	gtkwave ${GTK_FILE}
}

simulate ${@} || echo "FAILED"
