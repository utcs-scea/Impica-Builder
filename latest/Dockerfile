FROM impica:base
COPY aarch64-ubuntu-trusty-headless.img.bz2 /
RUN pbzip2 -d -r -p32 aarch64-ubuntu-trusty-headless.img.bz2
COPY ckpt/ /ckpt
RUN /ckpt/ckpt.sh
COPY scripts/ /scripts
RUN mkdir -p /work
RUN mkdir -p /out
