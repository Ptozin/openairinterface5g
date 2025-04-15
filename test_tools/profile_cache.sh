#!/bin/bash

CONFIG_FILE="./profile_config.sh"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# --- Script-Specific Configuration ---
OUTPUT_FILE="${OUTPUT_DIR}/perf.data.cache"
# Event to profile (e.g., cache-misses, L1-dcache-load-misses, LLC-load-misses)
PERF_EVENT="cache-misses"
# --- End Script-Specific Configuration ---

echo "Starting cache miss profiling (${PERF_EVENT}) for ${DURATION} seconds..."
echo "Executable: ${NRUE_EXEC}"
echo "Arguments: ${NRUE_ARGS[@]}"
echo "Output file: ${OUTPUT_FILE}"

sudo perf record -e "${PERF_EVENT}" -g -o "${OUTPUT_FILE}" -- \
    timeout "${DURATION}" "${NRUE_EXEC}" "${NRUE_ARGS[@]}"

status=$?
if [ $status -eq 0 ] || [ $status -eq 124 ]; then
    echo "Profiling finished."
    echo "Analyze the results using:"
    echo "sudo perf report -i ${OUTPUT_FILE}"
    echo "For detailed annotation:"
    echo "sudo perf annotate -i ${OUTPUT_FILE} [function_name]"
else
    # Check if the exit code was from the config file's executable check
    if [ $status -eq 1 ] && ! [ -x "${NRUE_EXEC}" ]; then
         echo "Profiling failed because executable was not found (checked in config)."
    else
         echo "Profiling failed with status ${status}."
    fi
fi

exit $status