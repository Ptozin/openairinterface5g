#!/bin/bash

CONFIG_FILE="./config.sh"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# --- Script-Specific Configuration ---
GPROF_OUT="${OUTPUT_DIR}/gmon.out"
GPROF_REPORT="${OUTPUT_DIR}/gprof_report.txt"
# --- End Script-Specific Configuration ---

echo "NOTE: Ensure your binary is compiled with -pg for gprof support."
echo "Starting profiling with gprof..."
echo "Executable: ${NRUE_EXEC}"
echo "Arguments: ${NRUE_ARGS[@]}"
echo "Output file: ${GPROF_OUT}"

timeout "${DURATION}" "${NRUE_EXEC}" "${NRUE_ARGS[@]}"

status=$?
if [ $status -eq 0 ] || [ $status -eq 124 ]; then
    if [ -f "gmon.out" ]; then
        mv gmon.out "${GPROF_OUT}"
        gprof "${NRUE_EXEC}" "${GPROF_OUT}" > "${GPROF_REPORT}"
        echo "Profiling finished."
        echo "Report generated at: ${GPROF_REPORT}"
    else
        echo "gmon.out not found. Did you compile with -pg?"
        status=2
    fi
else
    if [ $status -eq 1 ] && ! [ -x "${NRUE_EXEC}" ]; then
         echo "Profiling failed because executable was not found (checked in config)."
    else
         echo "Profiling failed with status ${status}."
    fi
fi

exit $status
