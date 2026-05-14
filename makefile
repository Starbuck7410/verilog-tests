# Module name: make MODULE=foo
MODULE ?= top

# Inputs
TESTBENCH = testbench/tb_$(MODULE).v   # Format that connects module to testbench
DESIGN_FILES = $(wildcard modules/*.v)
INCLUDE = $(wildcard include/*.vh)
SOURCES = $(TESTBENCH) $(DESIGN_FILES) $(INCLUDE)

# Outputs
SIMUL_DIR := simulation
EXEC := $(SIMUL_DIR)/$(MODULE).vvp
VCD_FILE := $(SIMUL_DIR)/$(MODULE).vcd

all: run

$(SIMUL_DIR):
	mkdir -p $(SIMUL_DIR)

compile: $(SOURCES) | $(SIMUL_DIR)
	iverilog -o $(EXEC) $(SOURCES) -DDUMP_FILE_NAME=\"$(VCD_FILE)\"

run: compile | $(SIMUL_DIR)
	vvp $(EXEC)

clean:
	rm -f $(EXEC) $(SIMUL_DIR)

.PHONY: all compile run clean




