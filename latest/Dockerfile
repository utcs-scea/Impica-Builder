FROM impica:base
COPY aarch64-ubuntu-trusty-headless.img.bz2 /
RUN pbzip2 -d -r -p32 aarch64-ubuntu-trusty-headless.img.bz2
CMD make -C gem5/util/term
#CMD cd /IMPICA/gem5 && \
#  M5_PATH=/IMPICA/gem5/build/ ./build/ARM/gem5.opt \
#  configs/example/fs.py \
#  --machine-type=VExpress_EMM64 \
#  -n 4 \
#  --mem-size=2048MB \
#  --disk-image=/aarch64-ubuntu-trusty-headless.img \
#  --dtb-file=$KBLD/arch/arm64/boot/dts/aarch64_gem5_server.dtb \
#  --kernel=$KBLD/vmlinux
