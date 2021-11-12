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


#Install KBLD
COPY IMPICA/linux-aarch64-gem5-20140821 /IMPICA/linux-aarch64-gem5-20140821

ENV KBLD=/IMPICA/linux-aarch64-gem5-20140821/
RUN ln -s /usr/bin/aarch64-linux-gnu-gcc-4.9 /usr/bin/aarch64-linux-gnu-gcc && \
  cp /IMPICA/linux-aarch64-gem5-20140821/arch/arm64/configs/gem5_defconfig $KBLD/.config && \
  cd $KBLD && make -j32 ARCH=arm64 O=$KBLD CROSS_COMPILE=aarch64-linux-gnu- oldconfig && \
  cd $KBLD && make -j32 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- V=1

COPY IMPICA/pim_driver /IMPICA/pim_driver/

#Install IMPICA
RUN cd /IMPICA/pim_driver && make

#Prepare IMPICA-gem5
COPY IMPICA/gem5 /IMPICA/gem5/

RUN cd IMPICA/gem5 &&\
  scons -j32 build/ARM_btree/gem5.opt build/ARM_hashtable/gem5.opt build/ARM_linklist/gem5.opt && \
  cd /IMPICA/gem5/system/arm/aarch64_bootloader/ && \
  make && mkdir -p /IMPICA/gem5/build/binaries && \
  ln -s /IMPICA/gem5/system/arm/aarch64_bootloader/boot_emm.arm64 /IMPICA/gem5/build/binaries/boot_emm.arm64

COPY IMPICA/workloads /IMPICA/workloads
