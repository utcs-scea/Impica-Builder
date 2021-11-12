#!/bin/bash

PIM_TLB_SZ=$1
shift
L1_SIZE=$1
shift
L2_SIZE=$1
shift
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

echo "${FOLDERNAME}"

echo "cd /home/pim_driver" > ${NEW_SCRIPT}
echo "./go_test.sh" >> ${NEW_SCRIPT}
cat /scripts/${SCRIPTLABEL} >> ${NEW_SCRIPT}
echo $@ >> ${NEW_SCRIPT}
echo "echo \$?" >> ${NEW_SCRIPT}
echo "/sbin/m5 exit" >> ${NEW_SCRIPT}
cp ${NEW_SCRIPT} ${RESULTS_PATH}/${U_ID}

M5_PATH=${GEM5_PATH}/build/ ${GEM5_PATH}/build/ARM/gem5.opt \
  -d ${RESULTS_PATH}/${U_ID} \
  ${GEM5_PATH}/configs/example/fs.py \
  --checkpoint-dir ${WORK_PATH}/ckpt/ \
  --machine-type=VExpress_EMM64 \
  -n 4 \
  --cpu-clock=3GHz \
  --mem-size=2048MB \
  --caches\
  --l2cache\
  --pim_tlb_num=${PIM_TLB_SZ}\
  --l2_size=${L2_SIZE}\
  --l1d_size=32kB \
  --disk-image=/aarch64-ubuntu-trusty-headless.img \
  --dtb-file=$KBLD/arch/arm64/boot/dts/aarch64_gem5_server.dtb \
  --kernel=$KBLD/vmlinux \
  --script ${NEW_SCRIPT} \
  > ${RESULTS_PATH}/${U_ID}/${U_ID}.log 2>&1

echo ${U_ID} >&2
cat ${RESULTS_PATH}/${U_ID}/${U_ID}.log >&2
cat ${RESULTS_PATH}/${U_ID}/system.terminal >&2
cat ${RESULTS_PATH}/${U_ID}/stats.txt >&2
python ${GEM5_PATH}/collect_results.py ${RESULTS_PATH}/${U_ID}/
