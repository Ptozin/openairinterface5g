#!/bin/bash

CONFIG_FILE="./config.sh"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# --- Script-Specific Configuration ---
CLANG_TIDY_REPORT="${OUTPUT_DIR}/clang_tidy_report.txt"
SRC_DIR="src"
BUILD_DIR="build"
# --- End Script-Specific Configuration ---

if ! command -v clang-tidy &> /dev/null; then
    echo "Error: clang-tidy is not installed. Please install it using:"
    echo "sudo apt install clang-tidy"
    exit 1
fi

if [ ! -d "${BUILD_DIR}" ]; then
    echo "Error: Build directory not found: ${BUILD_DIR}"
    echo "clang-tidy requires a compilation database (compile_commands.json)."
    echo "You can generate it with CMake using:"
    echo "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .."
    exit 1
fi

if [ ! -f "${BUILD_DIR}/compile_commands.json" ]; then
    echo "Error: compile_commands.json not found in ${BUILD_DIR}."
    exit 1
fi

echo "Running clang-tidy static analysis..."
echo "Source directory: ${SRC_DIR}"
echo "Build directory: ${BUILD_DIR}"
echo "Output file: ${CLANG_TIDY_REPORT}"

find "${SRC_DIR}" -name '*.c' -o -name '*.cpp' | \
    xargs clang-tidy -p "${BUILD_DIR}" > "${CLANG_TIDY_REPORT}" 2>&1

status=$?
if [ $status -eq 0 ]; then
    echo "clang-tidy analysis complete."
    echo "Report generated at: ${CLANG_TIDY_REPORT}"
else
    echo "clang-tidy finished with warnings or errors. See report at: ${CLANG_TIDY_REPORT}"
fi

exit $status
