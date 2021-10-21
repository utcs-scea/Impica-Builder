all: impica_latest

impica_base: base/Dockerfile
	cd base; sudo docker build -t impica:base .;
	touch impica_base

image/mnt:
	mkdir -p image/mnt

image/aarch64-ubuntu-trusty-headless.img.bz2:
	cd image; wget http://dist.gem5.org/dist/current/arm/disks/aarch64-ubuntu-trusty-headless.img.bz2

image/aarch64-ubuntu-trusty-headless.img: image/aarch64-ubuntu-trusty-headless.img.bz2
	pbzip2 -d -r -k -p32 $<

latest/aarch64-ubuntu-trusty-headless.img.bz2: image/aarch64-ubuntu-trusty-headless.img image/mnt impica_base
	cd image; ./install.sh
	pbzip2 -r -k -p32 -z -f -c $< > $@

impica_latest: latest/aarch64-ubuntu-trusty-headless.img.bz2 latest/Dockerfile
	cd latest; docker build -t impica:latest .;
	touch impica_latest
