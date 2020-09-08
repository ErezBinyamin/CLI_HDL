# Configurable variables - Can be overridden in enviroment
TOOLS=tools
SIM_DIR?=out
SRC_DIR?=work
TST_DIR?=tst
WRK_DIR=$(SIM_DIR)
SOURCE?=$(shell bash $(TOOLS)/get_dep_list.sh)
RTL_SOURCE=$(SIM_DIR)/rtl.dot
RTL_OUT=$(SIM_DIR)/rtl.png
STOP_TIME?=10000ns
GHDL=ghdl
GHDLFLAGS=--workdir=$(WRK_DIR) --std=02 --ieee=synopsys --warn-unused -fexplicit
GTK=gtkwave
GTKFLAGS=--tcl_init tools/init.tcl

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

# Compile dotfiles into pngs
%.png: %.dot
	dot -Tpng $< -o $@

# Compile all source
all: $(shell echo $(SOURCE) | sed 's/\.vhd/\.o/g')

# Generate RTL diagram
dot_template:
	$(shell bash $(TOOLS)/vhdl_2_dot.sh > $(RTL_SOURCE))
dot: $(RTL_OUT)
	xdg-open $(RTL_OUT)

# Clean output artifacts
clean:
	rm -f $(TST_DIR)/*.vcd
	rm -f $(SIM_DIR)/*.png
	rm -f $(SIM_DIR)/*.cf
