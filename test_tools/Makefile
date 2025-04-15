# Makefile for OAI nrUE Profiling with Perf

# Use bash as the shell
SHELL := /bin/bash

# Command for privilege escalation
SUDO := sudo

# Shared configuration script
CONFIG_SCRIPT := config.sh

# Profiling scripts
PROFILE_CPU_SCRIPT := profile_cpu.sh
PROFILE_STATS_SCRIPT := profile_stats.sh
PROFILE_CACHE_SCRIPT := profile_cache.sh
PROFILE_BRANCH_SCRIPT := profile_branch.sh
PROFILE_OFFCPU_SCRIPT := profile_offcpu.sh
CALLGRIND := callgrind.sh
GPROF := gprof.sh
FLAME_GRAPH := flamegraph.sh
CPP_CHECK := cppcheck.sh

# Output directory (should match the one in profile_config.sh)
# We read it from the config file to be sure
# Use . instead of source for POSIX compliance in Makefiles
OUTPUT_DIR := $(shell source $(CONFIG_SCRIPT); echo $$OUTPUT_DIR)

# Expected output data files
PERF_DATA_CPU := $(OUTPUT_DIR)/perf.data.cpu
PERF_DATA_CACHE := $(OUTPUT_DIR)/perf.data.cache
PERF_DATA_BRANCH := $(OUTPUT_DIR)/perf.data.branch
PERF_DATA_OFFCPU := $(OUTPUT_DIR)/perf.data.offcpu
CALLGRIND_DATA := $(OUTPUT_DIR)/callgrind.out
GPROF_DATA := $(OUTPUT_DIR)/gprof_report.txt
FLAME_GRAPH_DATA := $(OUTPUT_DIR)/flamegraph.svg
CPP_CHECK_DATA := $(OUTPUT_DIR)/cppcheck_report.txt

# Phony targets don't represent files
.PHONY: all help \
        profile-cpu profile-stats profile-cache profile-branch profile-offcpu profile-all callgrind gprof \
		report-cpu report-cache report-branch report-offcpu report-callgrind report-gprof \
        clean

# Default target: Show help message
all: help

# Target to show help message
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Installation:"
	@echo "  make install     	- Install required packages and scripts"
	@echo "Profiling Targets (run with sudo):"
	@echo "  profile-cpu      	- Run CPU hotspot profiling (${PROFILE_CPU_SCRIPT})"
	@echo "  profile-stats    	- Run microarchitecture statistics collection (${PROFILE_STATS_SCRIPT})"
	@echo "  profile-cache    	- Run cache miss profiling (${PROFILE_CACHE_SCRIPT})"
	@echo "  profile-branch   	- Run branch misprediction profiling (${PROFILE_BRANCH_SCRIPT})"
	@echo "  profile-offcpu   	- Run off-CPU/wait time profiling (${PROFILE_OFFCPU_SCRIPT})"
	@echo "  profile-all      	- Run all profiling targets sequentially"
	@echo "  callgrind        	- Run callgrind profiling (${CALLGRIND})"
	@echo "  gprof            	- Run gprof profiling (${GPROF})"
	@echo "  flamegraph        	- Run perf profiling with Flamegraph for visualization (${FLAME_GRAPH})"
	@echo ""
	@echo "Reporting Targets (run with sudo, require corresponding profile run first):"
	@echo "  report-cpu       	- View CPU hotspot results (perf report -i $(OUTPUT_DIR)/perf.data.cpu)"
	@echo "  report-cache     	- View cache miss results (perf report -i $(OUTPUT_DIR)/perf.data.cache)"
	@echo "  report-branch    	- View branch misprediction results (perf report -i $(OUTPUT_DIR)/perf.data.branch)"
	@echo "  report-offcpu    	- View off-CPU results (perf script -i $(OUTPUT_DIR)/perf.data.offcpu | less)"
	@echo "  report-callgrind  	- View callgrind results (callgrind_annotate $(OUTPUT_DIR)/callgrind.out)"
	@echo "  report-gprof    	- View gprof results (gprof $(OUTPUT_DIR)/gprof_report.txt | less)"
	@echo "  report-flamegraph	- Open Flamegraph generated SVG (${FLAME_GRAPH_DATA})"
	@echo ""
	@echo "Other Targets:"
	@echo "  clean            	- Remove generated perf data (${OUTPUT_DIR})"
	@echo "  help             	- Show this help message"

# --- Profiling Targets ---

install:
	./install.sh

profile-cpu: $(PROFILE_CPU_SCRIPT)
	@echo "==> Running CPU Profiling..."
	$(SUDO) ./$(PROFILE_CPU_SCRIPT)

profile-stats: $(PROFILE_STATS_SCRIPT)
	@echo "==> Running Statistics Collection..."
	$(SUDO) ./$(PROFILE_STATS_SCRIPT)

profile-cache: $(PROFILE_CACHE_SCRIPT)
	@echo "==> Running Cache Miss Profiling..."
	$(SUDO) ./$(PROFILE_CACHE_SCRIPT)

profile-branch: $(PROFILE_BRANCH_SCRIPT)
	@echo "==> Running Branch Miss Profiling..."
	$(SUDO) ./$(PROFILE_BRANCH_SCRIPT)

profile-offcpu: $(PROFILE_OFFCPU_SCRIPT)
	@echo "==> Running Off-CPU Profiling..."
	$(SUDO) ./$(PROFILE_OFFCPU_SCRIPT)

profile-all: profile-cpu profile-stats profile-cache profile-branch profile-offcpu
	@echo "==> All profiling runs completed."

callgrind: $(CALLGRIND)
	@echo "==> Running Callgrind..."
	$(SUDO) ./$(CALLGRIND)

gprof:
	@echo "==> Running gprof..."
	$(SUDO) ./$(GPROF)

flamegraph:
	@echo "==> Running Perf Profiling with Flamegraph for visualization..."
	$(SUDO) ./$(FLAME_GRAPH)

cppcheck:
	@echo "==> Running Cppcheck..."
	$(SUDO) ./$(CPP_CHECK)

# --- Reporting Targets ---

# Check if the perf.data file exists before trying to report
report-cpu:
	@if [ ! -f "$(PERF_DATA_CPU)" ]; then \
		echo "Error: Perf data file not found: $(PERF_DATA_CPU)"; \
		echo "Run 'make profile-cpu' first."; \
		exit 1; \
	fi
	@echo "==> Reporting CPU Profile (${PERF_DATA_CPU})..."
	$(SUDO) perf report -i $(PERF_DATA_CPU)

report-cache:
	@if [ ! -f "$(PERF_DATA_CACHE)" ]; then \
		echo "Error: Perf data file not found: $(PERF_DATA_CACHE)"; \
		echo "Run 'make profile-cache' first."; \
		exit 1; \
	fi
	@echo "==> Reporting Cache Profile (${PERF_DATA_CACHE})..."
	$(SUDO) perf report -i $(PERF_DATA_CACHE)

report-branch:
	@if [ ! -f "$(PERF_DATA_BRANCH)" ]; then \
		echo "Error: Perf data file not found: $(PERF_DATA_BRANCH)"; \
		echo "Run 'make profile-branch' first."; \
		exit 1; \
	fi
	@echo "==> Reporting Branch Profile (${PERF_DATA_BRANCH})..."
	$(SUDO) perf report -i $(PERF_DATA_BRANCH)

report-offcpu:
	@if [ ! -f "$(PERF_DATA_OFFCPU)" ]; then \
		echo "Error: Perf data file not found: $(PERF_DATA_OFFCPU)"; \
		echo "Run 'make profile-offcpu' first."; \
		exit 1; \
	fi
	@echo "==> Reporting Off-CPU Profile (${PERF_DATA_OFFCPU}). Use Q to quit less."
	$(SUDO) perf script -i $(PERF_DATA_OFFCPU) | less

report-callgrind:
	@if [ ! -f "$(CALLGRIND_DATA)" ]; then \
		echo "Error: Callgrind data file not found: $(CALLGRIND_DATA)"; \
		echo "Run 'make callgrind' first."; \
		exit 1; \
	fi
	@echo "==> Reporting Callgrind Profile (${CALLGRIND_DATA})..."
	$(SUDO) callgrind_annotate $(CALLGRIND_DATA) --inclusive=yes --tree=both --auto=yes --show=all

report-gprof:
	@if [ ! -f "$(GPROF_DATA)" ]; then \
		echo "Error: Gprof data file not found: $(GPROF_DATA)"; \
		echo "Run 'make gprof' first."; \
		exit 1; \
	fi
	@echo "==> Reporting Gprof Profile (${GPROF_DATA})..."
	$(SUDO) gprof $(GPROF_DATA) | less

report-flamegraph:
	@if [ ! -f "$(FLAME_GRAPH_DATA)" ]; then \
		echo "Error: Flamegraph data file not found: $(FLAME_GRAPH_DATA)"; \
		echo "Run 'make flamegraph' first."; \
		exit 1; \
	fi
	@echo "==> Opening Flamegraph Generated SVG (${FLAME_GRAPH_DATA})..."
	$(SUDO) open $(FLAME_GRAPH_DATA)

report-cppcheck:
	@if [ ! -f "$(CPP_CHECK_DATA)" ]; then \
		echo "Error: Cppcheck data file not found: $(CPP_CHECK_DATA)"; \
		echo "Run 'make cppcheck' first."; \
		exit 1; \
	fi
	@echo "==> Reporting Cppcheck Profile (${CPP_CHECK_DATA})..."
	$(SUDO) less $(CPP_CHECK_DATA)

# --- Cleanup Target ---

clean:
	@echo "==> Cleaning up generated perf data..."
	rm -rf $(OUTPUT_DIR)
	@echo "Removed $(OUTPUT_DIR)/"

