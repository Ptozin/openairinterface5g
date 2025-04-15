#!/bin/bash

CONFIG_FILE="./config.sh"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# --- Script-Specific Configuration ---
CPPCHECK_REPORT="${OUTPUT_DIR}/cppcheck_report.txt"
CPPCHECK_ARGS="--enable=all --inconclusive --std=c99"
SRC_DIR="src"
# --- End Script-Specific Configuration ---

if ! command -v cppcheck &> /dev/null; then
    echo "Error: cppcheck is not installed. Please install it using:"
    echo "sudo apt install cppcheck"
    exit 1
fi

echo "Running cppcheck static analysis..."
echo "Source directory: ${SRC_DIR}"
echo "Output file: ${CPPCHECK_REPORT}"

cppcheck ${CPPCHECK_ARGS} "${SRC_DIR}" 2> "${CPPCHECK_REPORT}"

status=$?
if [ $status -eq 0 ]; then
    echo "cppcheck analysis complete."
    echo "Report generated at: ${CPPCHECK_REPORT}"
else
    echo "cppcheck finished with warnings or errors. See report at: ${CPPCHECK_REPORT}"
fi

exit $status
