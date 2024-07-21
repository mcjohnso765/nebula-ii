##############################################################################
# Runing the simulations
##############################################################################

BUILD = sim_build

# Running simulations with iVerilog
#g flag enables sv support
%.vvp: %_tb.sv
	iverilog -Ttyp -DFUNCTIONAL -DSIM -DUSE_POWER_PINS -DUNIT_DELAY=#1 \
	-g2012 \
	-f$(USER_PROJECT_VERILOG)/includes/includes.rtl.caravel_user_project -o $@ $<

%.vcd: %.vvp
	vvp  $<
	mv $@ RTL-$@
	rm -f $<


# Create file that lists the RTL code and testbench files to compile
.PHONY: source_files
source_files:
	sed "s:\$$(USER_PROJECT_VERILOG):$(USER_PROJECT_VERILOG):g" \
	$(USER_PROJECT_VERILOG)/includes/includes.rtl.caravel_user_project > files.f

# Run source simulations with VCS and DVE
.PHONY: sim-source-%
sim-source-%: %_tb.sv source_files
	mkdir -p ./$(BUILD)
	vcs -sverilog -lca -debug_access+all -Mdir=$(BUILD)/csrc -o $(BUILD)/simv -f files.f \
	$(USER_PROJECT_VERILOG)/dv/tb_macros.vh $<
	rm -f files.f
	./$(BUILD)/simv -gui -suppress=ASLR_DETECTED_INFO &


# ---- Clean ----
clean:
	rm  -rf *.vvp *.log *.vcd *.vpd *.lst *.key *.f $(BUILD)/ DVEfiles/ .restartSimSession.tcl.old

.PHONY: clean hex all