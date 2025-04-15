#!/bin/bash

CONFIG_FILE="./config.sh"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# --- Script-Specific Configuration ---
PERF_DATA="${OUTPUT_DIR}/perf.data.99"
PERF_EVENT="-F 99"
PERF_SCRIPT="${OUTPUT_DIR}/perf.script"
FOLDED="${OUTPUT_DIR}/out.folded"
FLAMEGRAPH_SVG="${OUTPUT_DIR}/flamegraph.svg"
# --- End Script-Specific Configuration ---

# Check for flamegraph scripts
if ! command -v stackcollapse-perf.pl &> /dev/null || ! command -v flamegraph.pl &> /dev/null; then
    echo "Error: Flamegraph scripts not found in PATH."
    echo "Clone from https://github.com/brendangregg/Flamegraph and add to your PATH."
    exit 1
fi

echo "Starting perf record for flamegraph..."
echo "Executable: ${NRUE_EXEC}"
echo "Arguments: ${NRUE_ARGS[@]}"
echo "Output file: ${PERF_DATA}"

sudo perf record -e "${PERF_EVENT}" -g -o "${PERF_DATA}" -- \
    timeout "${DURATION}" "${NRUE_EXEC}" "${NRUE_ARGS[@]}"

status=$?
if [ $status -eq 0 ] || [ $status -eq 124 ]; then
    echo "Generating perf script..."
    sudo perf script -i "${PERF_DATA}" > "${PERF_SCRIPT}"

    echo "Collapsing stacks..."
    stackcollapse-perf.pl "${PERF_SCRIPT}" > "${FOLDED}"

    echo "Generating flamegraph SVG..."
    flamegraph.pl "${FOLDED}" > "${FLAMEGRAPH_SVG}"

    echo "Flamegraph generated at: ${FLAMEGRAPH_SVG}"
else
    if [ $status -eq 1 ] && ! [ -x "${NRUE_EXEC}" ]; then
         echo "Profiling failed because executable was not found (checked in config)."
    else
         echo "Profiling failed with status ${status}."
    fi
fi

exit $status
