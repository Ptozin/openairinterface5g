#!/bin/bash

CONFIG_FILE="./profile_config.sh"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# --- Script-Specific Configuration ---
OUTPUT_FILE="${OUTPUT_DIR}/perf.data.offcpu"
# --- End Script-Specific Configuration ---

echo "Starting Off-CPU/Wait time profiling for ${DURATION} seconds..."
echo "Executable: ${NRUE_EXEC}"
echo "Arguments: ${NRUE_ARGS[@]}"
echo "Output file: ${OUTPUT_FILE}"
echo "NOTE: Requires appropriate kernel config and perf version."

sudo perf record -e sched:sched_stat_sleep -e sched:sched_switch \
                 -e sched:sched_process_exit -g -o "${OUTPUT_FILE}" -- \
    timeout "${DURATION}" "${NRUE_EXEC}" "${NRUE_ARGS[@]}"

status=$?
if [ $status -eq 0 ] || [ $status -eq 124 ]; then
    echo "Profiling finished."
    echo "Analyze the results using specialized scripts or:"
    echo "sudo perf script -i ${OUTPUT_FILE} | less"
    echo "(Consider using Brendan Gregg's perf-tools 'offcputime.py' for easier analysis)"
else
    # Check if the exit code was from the config file's executable check
    if [ $status -eq 1 ] && ! [ -x "${NRUE_EXEC}" ]; then
         echo "Profiling failed because executable was not found (checked in config)."
    else
         echo "Profiling failed with status ${status}."
    fi
fi

exit $status
