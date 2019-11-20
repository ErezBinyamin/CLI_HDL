#!/bin/bash
SIM_DIR=sim
SRC_DIR=work

ghdl -i --ieee=synopsys --warn-no-vital-generic --workdir=${SIM_DIR} --work=${SRC_DIR} ${SRC_DIR}/*.vhd
