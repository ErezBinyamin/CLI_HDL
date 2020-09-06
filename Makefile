# Configurable variables - Can be overridden in enviroment
SOURCE?=$(shell bash get_dep_list.sh)
STOP_TIME?=10000ns
SIM_DIR?=out
SRC_DIR?=work
TST_DIR?=tst
WRK_DIR=$(SIM_DIR)
GHDL=ghdl
GHDLFLAGS=--workdir=$(WRK_DIR) --std=02 --ieee=synopsys --warn-unused -fexplicit
GTK=gtkwave
GTKFLAGS=--tcl_init init.tcl

# Rules
test: all $(TESTBENCH:.vhd=.vcd)
	$(GTK) $(GTKFLAGS) $(TESTBENCH:.vhd=.vcd)

# Syntax check and compile
%.o : %.vhd
	$(GHDL) -s $(GHDLFLAGS) $<
	$(GHDL) -a $(GHDLFLAGS) $<

# Run simulation
%.vcd: %.o
	$(GHDL) -r $(GHDLFLAGS) $(*F) --vcd=$@ --stop-time=$(STOP_TIME)

# Compile all source
all: $(shell echo $(SOURCE) | sed 's/\.vhd/\.o/g') 

# Clean output artifacts
clean:
	rm -f $(TST_DIR)/*.vcd
	rm -f $(SIM_DIR)/*
