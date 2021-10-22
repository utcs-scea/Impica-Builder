FROM impica:base
COPY aarch64-ubuntu-trusty-headless.img.bz2 /
RUN pbzip2 -d -r -p32 aarch64-ubuntu-trusty-headless.img.bz2
COPY scripts/ /scripts
RUN /scripts/ckpt.sh
