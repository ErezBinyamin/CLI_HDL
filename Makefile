# Configurable variables
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
all: BIST_MAC
test1: FULL_ADD_TEST 
test2: MULTIPLY_TEST
test3: MAC_UNIT_TEST
test4: BIST_MAC_TEST

# Generic Targets
%.o : %.vhd
	$(GHDL) -s $(GHDLFLAGS) $<
	$(GHDL) -a $(GHDLFLAGS) $<

%.vcd: %.o
	$(GHDL) -r $(GHDLFLAGS) $(*F) --vcd=$@ --stop-time=$(STOP_TIME)

# Elaboration Targets
FULL_ADD: $(SRC_DIR)/Full_Adder_1bit.o $(SRC_DIR)/Full_Adder_Nbit.o
MULTIPLY: FULL_ADD $(SRC_DIR)/Multiplier.o
MAC_UNIT: MULTIPLY $(SRC_DIR)/MAC.o
BIST_MAC: FULL_ADD MULTIPLY MAC_UNIT $(SRC_DIR)/LFSR.o $(SRC_DIR)/MISR.o $(SRC_DIR)/BIST_MAC.o

# Test Targets
FULL_ADD_TEST: FULL_ADD $(TST_DIR)/Full_Adder_Nbit_TB.vcd 
	$(GTK) $(GTKFLAGS) $(TST_DIR)/Full_Adder_Nbit_TB.vcd
MULTIPLY_TEST: MULTIPLY $(TST_DIR)/Multiplier_TB.vcd
	$(GTK) $(GTKFLAGS) $(TST_DIR)/Multiplier_TB.vcd
MAC_UNIT_TEST: MAC_UNIT $(TST_DIR)/MAC_TB.vcd
	$(GTK) $(GTKFLAGS) $(TST_DIR)/MAC_TB.vcd
BIST_MAC_TEST: BIST_MAC $(TST_DIR)/BIST_MAC_TB.vcd
	$(GTK) $(GTKFLAGS) $(TST_DIR)/BIST_MAC_TB.vcd


# Clean Rule
clean:
	rm -f $(TST_DIR)/*.vcd
	rm -f $(SIM_DIR)/*
