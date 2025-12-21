# Optional module name: make MODULE=foo
MODULE ?= top

TESTBENCH = testbench/tb_$(MODULE).v
DESIGN_FILES = $(wildcard modules/*.v)
INCLUDE = $(wildcard include/*.vh)
SOURCES = $(TESTBENCH) $(DESIGN_FILES) $(INCLUDE)

EXEC := simulation/waveform.vvp
VCD_FILE := simulation/waveform.vcd

all: run

compile: $(SOURCES)
	iverilog -o $(EXEC) $(SOURCES)

run: compile
	vvp $(EXEC)

clean:
	rm -f $(EXEC) $(VCD_FILE)

.PHONY: all compile run clean
