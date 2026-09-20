# Makefile for Verilator SystemVerilog Simulation

# Directories
RTL_DIR = rtl
TB_DIR  = tb
SIM_DIR = sim

# Source Files
RTL_SRC = $(wildcard $(RTL_DIR)/*.sv)
TB_SRC  = $(TB_DIR)/tb_top.sv

VFLAGS = --binary -j 0 --timing --trace --Mdir $(SIM_DIR)/obj_dir

# Default Target
all: clean build run

# Compile the design
build:
	mkdir -p $(SIM_DIR)
	verilator $(VFLAGS) $(RTL_SRC) $(TB_SRC) --top-module tb_top -o Vtb_top

# Run the simulation
run:
	./$(SIM_DIR)/obj_dir/Vtb_top

# Clean compilation files
clean:
	rm -rf $(SIM_DIR)
