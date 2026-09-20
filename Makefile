# Makefile for Verilator SystemVerilog Simulation

# Directories
RTL_DIR = rtl
TB_DIR  = tb
SIM_DIR = sim

# Source Files
RTL_SRC = $(wildcard $(RTL_DIR)/*.sv)
TB_SRC  = $(TB_DIR)/tb_top.sv

# Verilator Flags
VFLAGS = --binary -j 0 --timing --trace --Mdir $(SIM_DIR)/obj_dir

# Default Target
all: clean build run help

# Compile the design
build:
	mkdir -p $(SIM_DIR)
	verilator $(VFLAGS) $(RTL_SRC) $(TB_SRC) --top-module tb_top -o Vtb_top

# Run the simulation and log the results
run:
	./$(SIM_DIR)/obj_dir/Vtb_top | tee $(SIM_DIR)/test_results.log

# Clean compilation files
clean:
	rm -rf $(SIM_DIR)

help:
	@echo "Available targets:"
	@echo "  all   - Clean, build, and run the Verilator simulation"
	@echo "  build - Compile the SystemVerilog RTL and testbench with Verilator"
	@echo "  run   - Run the compiled simulation and save results to a log file"
	@echo "  clean - Remove all simulation and compilation files"
	@echo "  help  - Display this help message"
