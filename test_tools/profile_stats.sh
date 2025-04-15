#!/bin/bash

CONFIG_FILE="./config.sh"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: Configuration file not found: $CONFIG_FILE"
    exit 1
fi

echo "Starting microarchitecture statistics collection..."
echo "Executable: ${NRUE_EXEC}"
echo "Arguments: ${NRUE_ARGS[@]}"
echo "Collection limited to ${DURATION} seconds."
echo "Note: Output will be displayed in the terminal."

sudo perf stat -e cycles,instructions,cache-references,cache-misses,branch-instructions,branch-misses -- \
    timeout "${DURATION}" "${NRUE_EXEC}" "${NRUE_ARGS[@]}"

status=$?
if [ $status -eq 0 ] || [ $status -eq 124 ]; then
    echo "Statistics collection finished."
else
    # Check if the exit code was from the config file's executable check
    if [ $status -eq 1 ] && ! [ -x "${NRUE_EXEC}" ]; then
         echo "Statistics collection failed because executable was not found (checked in config)."
    else
         echo "Statistics collection failed with status ${status}."
    fi
fi

exit $status
