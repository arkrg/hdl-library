# ==============================================================================
# Build & Simulation Makefile
# ==============================================================================

TOP ?= $(notdir $(CURDIR))
TEST ?= base_test

TB         := tb_$(TOP)
SIM_ARGS   := 

PKG_FILES  := $(wildcard pkg/*_pkg.sv)
TB_FILES   := $(wildcard tb/$(TB).sv)
RTL_FILES  := $(wildcard rtl/*.v rtl/*.sv)
BUILD_DIR  := ./build/$(TB)

.PHONY: all run compile sim wave clean

all: compile sim wave

run: compile sim

debug: 
	@echo $(PKG_FILES)

compile:
	@mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && xvlog -sv  $(addprefix ../../, $(PKG_FILES) $(RTL_FILES) $(TB_FILES))
	cd $(BUILD_DIR) && xelab $(TB) -debug typical  -log compile.log -s $(TB)_snapshot

sim:
	cd $(BUILD_DIR) && xsim $(TB)_snapshot -R $(SIM_ARGS) 

wave:
		gtkwave $(BUILD_DIR)/*.vcd & 

clean:
	rm -rf $(BUILD_DIR)
