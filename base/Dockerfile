FROM ubuntu:16.04
RUN apt-get -y update && \
    apt-get -y install \
    libncurses5-dev \
    gcc \
    make \
    git \
    exuberant-ctags \
    bc \
    libssl-dev \
    python-dev \
    scons \
    m4 \
    build-essential \
    g++ \
    swig \
    zlib1g-dev \
    git \
    libgoogle-perftools-dev\
    protobuf-compiler\
    libprotobuf-dev \
    pbzip2\
    binutils-aarch64-linux-gnu \
    gcc-4.9-aarch64-linux-gnu

#Get things
RUN git clone https://github.com/CMU-SAFARI/IMPICA.git

#Prepare IMPICA-gem5
RUN sed -i '1111s/^/\#/' IMPICA/gem5/src/SConscript
RUN sed -i '1212s/^/    for target in ccflags.keys():\n        ccflags[target] += ["-std=c++11"]\n/' IMPICA/gem5/src/SConscript
RUN cp IMPICA/gem5/build_opts/ARM IMPICA/gem5/build_opts/ARM.gem5.opt
RUN cd IMPICA/gem5 && scons -j32 PIM_DEVICE=btree build/ARM/gem5.opt

#Install KBLD
ENV KBLD=/IMPICA/linux-aarch64-gem5-20140821/
RUN ln -s /usr/bin/aarch64-linux-gnu-gcc-4.9 /usr/bin/aarch64-linux-gnu-gcc
RUN cp /IMPICA/linux-aarch64-gem5-20140821/arch/arm64/configs/gem5_defconfig $KBLD/.config
RUN cd $KBLD && make -j32 ARCH=arm64 O=$KBLD CROSS_COMPILE=aarch64-linux-gnu- oldconfig
RUN cd $KBLD && make -j32 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- V=1

#Install IMPICA
RUN cd /IMPICA/pim_driver && make

#Prepare necessary bootloaders
RUN cd /IMPICA/gem5/system/arm/aarch64_bootloader/ && \
  make
RUN mkdir -p /IMPICA/gem5/build/binaries
RUN ln -s /IMPICA/gem5/system/arm/aarch64_bootloader/boot_emm.arm64 /IMPICA/gem5/build/binaries/boot_emm.arm64
