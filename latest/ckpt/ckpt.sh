#!/bin/bash

GEM5_PATH=/IMPICA/gem5

WORK_PATH=/work/m5_outputs

DEVS="btree linklist hashtable"

for i in ${DEVS}
do
  (
    mkdir -p ${WORK_PATH}/ckpt_${i}
    M5_PATH=/IMPICA/gem5/build/ ${GEM5_PATH}/build/ARM_${i}/gem5.opt \
      -d ${WORK_PATH}/ckpt_${i} \
      ${GEM5_PATH}/configs/example/fs.py \
      --machine-type=VExpress_EMM64 \
      -n 4 \
      --mem-size=2048MB \
      --disk-image=/aarch64-ubuntu-trusty-headless.img \
      --dtb-file=$KBLD/arch/arm64/boot/dts/aarch64_gem5_server.dtb \
      --kernel=$KBLD/vmlinux \
      --script /ckpt/hack_back_impica_ckpt.rcS \
      > ${WORK_PATH}/ckpt_${i}/out.log 2>&1
    )&
done
wait
