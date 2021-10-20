

all: gem5_img

impica_base:
	cd base; sudo docker build -t impica:base .;

image/mnt:
	mkdir -p image/mnt

image/aarch64-ubuntu-trusty-headless.img:
	cd image; wget http://dist.gem5.org/dist/current/arm/disks/aarch64-ubuntu-trusty-headless.img.bz2
	cd image; pbzip2 -d -r -p aarch64-ubuntu-trusty-headless.img.bz2

gem5_img: impica_base image/mnt image/aarch64-ubuntu-trusty-headless.img
	cd image; ./install.sh
