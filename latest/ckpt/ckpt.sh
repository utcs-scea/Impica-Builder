#!/bin/bash

GEM5_PATH=/IMPICA/gem5

WORK_PATH=/work/m5_outputs

U_ID=`date +"%d%b%Y%Z%H%M"`

mkdir -p ${WORK_PATH}/${U_ID}

M5_PATH=/IMPICA/gem5/build/ ${GEM5_PATH}/build/ARM/gem5.opt \
  -d ${WORK_PATH}/${U_ID} \
  ${GEM5_PATH}/configs/example/fs.py \
  --machine-type=VExpress_EMM64 \
  -n 4 \
  --mem-size=2048MB \
  --disk-image=/aarch64-ubuntu-trusty-headless.img \
  --dtb-file=$KBLD/arch/arm64/boot/dts/aarch64_gem5_server.dtb \
  --kernel=$KBLD/vmlinux \
  --script /ckpt/hack_back_impica_ckpt.rcS \
  | tee ${WORK_PATH}/${U_ID}/${U_ID}.log

mkdir -p ${WORK_PATH}/ckpt
rm -rf ${WORK_PATH}/ckpt
mv ${WORK_PATH}/${U_ID} ${WORK_PATH}/ckpt
