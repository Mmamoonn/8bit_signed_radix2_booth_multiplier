# Makefile for Verilator Simulation with SVA & Coverage

# Directories
RTL_DIR = rtl
TB_DIR  = tb
SIM_DIR = sim

# Source Files
RTL_SRC = $(wildcard $(RTL_DIR)/*.sv)

# Verilator Flags (--coverage enables structural and functional coverage)
VFLAGS = --binary -j 0 --timing --trace --coverage --Mdir $(SIM_DIR)/obj_dir

# Default Target
all: clean build_top run_top coverage help

# Compile and Run Top-Level Multiplier (with coverage)
build_top:
	mkdir -p $(SIM_DIR)
	verilator $(VFLAGS) $(RTL_SRC) $(TB_DIR)/tb_top.sv --top-module tb_top -o Vtb_top

run_top:
	./$(SIM_DIR)/obj_dir/Vtb_top | tee $(SIM_DIR)/test_results.log

# Compile and Run Isolated FSM Testbench
fsm_test:
	mkdir -p $(SIM_DIR)
	verilator $(VFLAGS) $(RTL_DIR)/controller.sv $(TB_DIR)/tb_controller.sv --top-module tb_controller -o Vtb_controller
	./$(SIM_DIR)/obj_dir/Vtb_controller

# Generate human-readable coverage reports
coverage:
	verilator_coverage --annotate $(SIM_DIR)/annotated logs/coverage.dat
	@echo "Coverage annotated source files generated in sim/annotated/"

# Clean compilation files
clean:
	rm -rf $(SIM_DIR) logs
	
help:
	@echo "Available targets:"
	@echo "  all       - Clean, build, run the top-level simulation, and generate coverage"
	@echo "  build_top - Compile the top-level multiplier testbench with Verilator"
	@echo "  run_top   - Run the compiled top-level multiplier simulation and save results"
	@echo "  fsm_test  - Compile and run the isolated FSM/controller testbench"
	@echo "  coverage  - Generate annotated Verilator coverage reports"
	@echo "  clean     - Remove simulation and coverage build artifacts"
	@echo "  help      - Display this help message"
