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
GTKFLAGS=--tcl_init tools/init.tcl --optimize --slider-zoom --wish

# -- ALL --
all: $(SOURCE:.vhd=.o)

# Syntax check and compile
%.o : %.vhd
	$(GHDL) -s $(GHDLFLAGS) $<
	$(GHDL) -a $(GHDLFLAGS) $<
	touch $@

# -- TEST --
test: all $(TESTBENCH:.vhd=.vcd)
	$(GTK) $(GTKFLAGS) $(TESTBENCH:.vhd=.vcd)

# Run simulation
%.vcd: %.o
	$(GHDL) -r $(GHDLFLAGS) $(*F) --vcd=$@ --stop-time=$(STOP_TIME)

# -- RTL --
rtl_template:
	[ -f $(RTL_SOURCE) ] || bash $(TOOLS)/vhdl_2_dot.sh > $(RTL_SOURCE)
rtl: rtl_template $(RTL_OUT)
	xdg-open $(RTL_OUT)

# Compile dotfiles into pngs
%.png: %.dot
	dot -Tpng $< -o $@

# -- CLEAN --
clean:
	rm -f $(TST_DIR)/*.vcd
	rm -f $(TST_DIR)/*.fst
	rm -f $(SIM_DIR)/*.png
	rm -f $(SIM_DIR)/*.cf
	find -type f -name *.o -exec rm -rf {} \;
