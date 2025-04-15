#!/bin/bash

CONFIG_FILE="./config.sh"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# --- Script-Specific Configuration ---
OUTPUT_FILE="${OUTPUT_DIR}/callgrind.out"
# --- End Script-Specific Configuration ---

echo "Starting profiling with Valgrind Callgrind..."
echo "Executable: ${NRUE_EXEC}"
echo "Arguments: ${NRUE_ARGS[@]}"
echo "Output file: ${OUTPUT_FILE}"

valgrind --tool=callgrind --callgrind-out-file="${OUTPUT_FILE}" \
    timeout "${DURATION}" "${NRUE_EXEC}" "${NRUE_ARGS[@]}"

status=$?
if [ $status -eq 0 ] || [ $status -eq 124 ]; then
    echo "Profiling finished."
    echo "Analyze the results using:"
    echo "callgrind_annotate ${OUTPUT_FILE}"
    echo "Or visualize with KCachegrind:"
    echo "kcachegrind ${OUTPUT_FILE}"
else
    if [ $status -eq 1 ] && ! [ -x "${NRUE_EXEC}" ]; then
         echo "Profiling failed because executable was not found (checked in config)."
    else
         echo "Profiling failed with status ${status}."
    fi
fi

exit $status
