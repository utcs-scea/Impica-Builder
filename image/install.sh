MNT=`pwd`/mnt
sudo mount -oloop,offset=32256 aarch64-ubuntu-trusty-headless.img $MNT
sudo docker run -v $MNT/home:/out impica:base cp -r /IMPICA/pim_driver/ out/
sudo docker run -v $MNT/home:/out impica:base cp -r /IMPICA/workloads/ out/
sudo mount -o bind /proc $MNT/proc
sudo mount -o bind /dev  $MNT/dev
sudo mount -o bind /sys  $MNT/sys
sudo cp /etc/resolv.conf $MNT/etc/
sudo chroot $MNT /bin/bash -c "for i in \`ls -d /home/workloads/*\`; do cd \$i && mkdir -p obj && make -j32 & done; wait"
./umount.sh
