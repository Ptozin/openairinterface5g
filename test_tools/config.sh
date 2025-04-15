#!/bin/bash

# --- Shared Configuration for OAI nrUE Profiling ---

# Path to the nr-uesoftmodem executable
NRUE_EXEC="../cmake_targets/ran_build/build/nr-uesoftmodem"

# Arguments for nr-uesoftmodem (defined as an array for robustness)
NRUE_ARGS=(
    --uicc0.imsi 268060000000001
    --tx_subdev "A:B"
    --rx_subdev "A:B"
    --ue-rxgain 139
    --ue-txgain 20
    --band 28
    -C 765500000
    --CO -55000000
    -r 25
    --numerology 0
    --ssb 53
    -g 3
    -q
    --usrp-args "type=b200, clock_source=external"
    --ue-fo-compensation
)

# Default duration (in seconds) to run the profiling
# Can be overridden in specific scripts if needed
DURATION=30

# Directory to store the output perf.data files
OUTPUT_DIR="$(pwd)/perf_results"

# --- End Shared Configuration ---

if [ ! -x "${NRUE_EXEC}" ]; then
    echo "Error (from config): Executable not found or not executable: ${NRUE_EXEC}"
    exit 1
fi

if ! command -v perf &> /dev/null; then
    echo "Error: perf is not installed. Please install it using:"
    echo "sudo apt install linux-perf"
    exit 1
fi


# Create output directory if it doesn't exist
# Doing it here ensures it exists for all scripts
mkdir -p "${OUTPUT_DIR}"
