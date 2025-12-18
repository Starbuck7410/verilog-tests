TESTBENCH := testbench/tb_top.v
DESIGN_FILES := $(wildcard modules/*.v)
INCLUDE := $(wildcard include/*.vh)
SOURCES := $(TESTBENCH) $(DESIGN_FILES) $(INCLUDE)
EXEC = simulation/waveform.vvp

# Set this to the file in "include/params.vh"
VCD_FILE = simulation/waveform.vcd

all: run

compile: $(SOURCES)
	iverilog -o $(EXEC) $(SOURCES)

run: compile
	vvp $(EXEC)

clean:
	rm -f $(EXEC) $(VCD_FILE)

.PHONY: clean
