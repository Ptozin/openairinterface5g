#!/bin/bash
set -e
set -x

# In case of error, remove the temporary container.
trap 'sudo docker rm -f "${TEMP_CONTAINER}" >/dev/null' ERR

IMAGE_NAME="ran-build:local"
TEMP_CONTAINER="extract_oai_nr_ue"

# Create a temporary container without starting it.
echo "Creating temporary container from image ${IMAGE_NAME}..."
sudo docker create --name "${TEMP_CONTAINER}" "${IMAGE_NAME}" >/dev/null


echo "Copying nr-uesoftmodem binary..."
docker cp ${TEMP_CONTAINER}:/oai-ran/cmake_targets/ran_build/build-cross/nr-uesoftmodem ./

libs=(
  #"liboai_eth_transpro.so"
  # <-- This library is UHD essentially, so I guess i simply need to copy it -->
  #"liboai_usrpdevif.so"
  "librfsimulator.so"
  "libcoding.so"
  "libparams_libconfig.so"
  "libdfts.so"
  "libldpc.so"
  "libldpc_optim.so"
  "libldpc_optim8seg.so"
  "libldpc_orig.so"
  "libparams_yaml.so"
)

echo "Copying shared libraries..."
for lib in "${libs[@]}"; do
  echo "  - Copying ${lib}"
  docker cp "${TEMP_CONTAINER}:/oai-ran/cmake_targets/ran_build/build-cross/${lib}" ./
done

echo "Removing temporary container..."
sudo docker rm "${TEMP_CONTAINER}" >/dev/null

echo "Extraction complete. Artifacts are available in ${OUTPUT_DIR}."
