#!/bin/bash

GEM5_PATH=/IMPICA/gem5

WORK_PATH=/work/m5_outputs
RESULTS_PATH=/out/m5_outputs

cd ${WORK_PATH}

THENAME=impica-bench-
FOLDERNAME=${THENAME}$1
SCRIPTLABEL=${FOLDERNAME}.sh

shift

U_ID=${FOLDERNAME}
for i in $@; do
  if [[ `echo $i | cut -c1 ` == '-' ]]
  then
    U_ID+="$i";
  else
    U_ID+="-$i";
  fi
done

mkdir -p ${WORK_PATH}/${U_ID}
mkdir -p ${RESULTS_PATH}/${U_ID}

NEW_SCRIPT=${WORK_PATH}/${U_ID}/${SCRIPTLABEL}

cp /scripts/${SCRIPTLABEL} ${NEW_SCRIPT}
echo $@ >> ${NEW_SCRIPT}
echo "echo \$?" >> ${NEW_SCRIPT}
echo "/sbin/m5 exit" >> ${NEW_SCRIPT}
cp ${NEW_SCRIPT} ${RESULTS_PATH}/${U_ID}

M5_PATH=${GEM5_PATH}/build/ ${GEM5_PATH}/build/ARM/gem5.opt \
  -d ${RESULTS_PATH}/${U_ID} \
  ${GEM5_PATH}/configs/example/fs.py \
  --restore-freom ${WORK_PATH}/ckpt/ \
  --machine-type=VExpress_EMM64 \
  -n 4 \
  --mem-size=2048MB \
  --disk-image=/aarch64-ubuntu-trusty-headless.img \
  --dtb-file=$KBLD/arch/arm64/boot/dts/aarch64_gem5_server.dtb \
  --kernel=$KBLD/vmlinux \
  --script ${NEW_SCRIPT} \
  > ${RESULTS_PATH}/${U_ID}/${U_ID}.log 2>&1

echo ${U_ID} >&2
cat ${RESULTS_PATH}/${U_ID}/${U_ID}.log >&2
cat ${RESULTS_PATH}/${U_ID}/system.terminal >&2
cat ${RESULTS_PATH}/${U_ID}/stats.txt >&2
