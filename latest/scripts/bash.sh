#!/bin/bash

GEM5_PATH=/IMPICA/gem5

WORK_PATH=/work/m5_outputs
RESULTS_PATH=/out/m5_outputs

cd ${WORK_PATH}

U_ID=bash

mkdir -p ${WORK_PATH}/${U_ID}
mkdir -p ${RESULTS_PATH}/${U_ID}

M5_PATH=${GEM5_PATH}/build/ ${GEM5_PATH}/build/ARM/gem5.opt \
  -d ${RESULTS_PATH}/${U_ID} \
  ${GEM5_PATH}/configs/example/fs.py \
  --checkpoint-dir ${WORK_PATH}/ckpt/ \
  --machine-type=VExpress_EMM64 \
  -n 4 \
  --mem-size=2048MB \
  --disk-image=/aarch64-ubuntu-trusty-headless.img \
  --dtb-file=$KBLD/arch/arm64/boot/dts/aarch64_gem5_server.dtb \
  --kernel=$KBLD/vmlinux \
  > ${RESULTS_PATH}/${U_ID}/${U_ID}.log 2>&1
