IMG=aarch64-ubuntu-trusty-headless.img

RUNNER=? btree_pim5

all: singularity/impica.sif

impica_base: base/Dockerfile
	cd base; sudo docker build -t impica:base .;
	touch impica_base

image/mnt:
	mkdir -p image/mnt

image/${IMG}.bz2:
	cd image; wget http://dist.gem5.org/dist/current/arm/disks/${IMG}.bz2

image/${IMG}: image/${IMG}.bz2
	pbzip2 -d -r -k -f -p32 $<

image/after.img: image/${IMG} impica_base image/install.sh | image/mnt
	cp $< $@
	cd image; ./install.sh

latest/${IMG}.bz2: image/after.img
	pbzip2 -r -k -p32 -z -f -c $< > $@

impica_latest: latest/${IMG}.bz2 latest/Dockerfile latest/scripts/ latest/ckpt
	cd latest; docker build -t impica:latest .;
	touch impica_latest

clean:
	cd image; ./umount.sh
	rm -f latest/${IMG}.bz2 impica_base impica_latest image/after.img

singularity/impica.sif: singularity/Singularity impica_latest
	cd singularity; sudo singularity build impica.sif Singularity

out:
	mkdir -p out

test: singularity/impica.sif | out
	cd out/; singularity run --writable-tmpfs `pwd`/../singularity/impica.sif "${RUNNER}"  > blah.out 2> blah.err
