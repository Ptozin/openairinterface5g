#!/bin/bash

CONFIG_FILE="./profile_config.sh"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: Configuration file not found: $CONFIG_FILE"
    exit 1
fi

OUTPUT_FILE="${OUTPUT_DIR}/perf.data.cpu"

echo "Starting CPU profiling for ${DURATION} seconds..."
echo "Executable: ${NRUE_EXEC}"
echo "Arguments: ${NRUE_ARGS}"
echo "Output file: ${OUTPUT_FILE}"

sudo perf record -g -o "${OUTPUT_FILE}" -- \
    timeout "${DURATION}" "${NRUE_EXEC}" ${NRUE_ARGS}

# Check if perf record was successful (timeout returns 124 if command times out)
status=$?
if [ $status -eq 0 ] || [ $status -eq 124 ]; then
    echo "Profiling finished."
    echo "Analyze the results using:"
    echo "sudo perf report -i ${OUTPUT_FILE}"
else
    echo "Profiling failed with status ${status}."
fi

exit $status
