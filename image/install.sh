MNT=`pwd`/mnt
PWD=`pwd`
sudo mount -oloop,offset=32256 aarch64-ubuntu-trusty-headless.img $MNT
test -d $MNT/home/pim_driver || sudo docker run -v $MNT/home:/out impica:base cp -r /IMPICA/pim_driver/ out/
test -d $MNT/home/workloads || sudo docker run -v $MNT/home:/out impica:base cp -r /IMPICA/workloads/ out/
test -d $MNT/hack_back_ckpt.rcS || sudo docker run -v $MNT:/out impica:base cp /IMPICA/gem5/configs/boot/hack_back_ckpt.rcS out/
sudo chmod +x $MNT/hack_back_ckpt.rcS
test -d $MNT/etc/init/hack_back.conf || sudo cp hack_back.conf $MNT/etc/init/
sudo mount -o bind /proc $MNT/proc
sudo mount -o bind /dev  $MNT/dev
sudo mount -o bind /sys  $MNT/sys
sudo cp /etc/resolv.conf $MNT/etc/
sudo chroot $MNT /bin/bash -c "for i in \`ls -d /home/workloads/*\`; do cd \$i && mkdir -p obj && make -j32 & done; wait"
./umount.sh
