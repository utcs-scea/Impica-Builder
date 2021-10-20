MNT=`pwd`/mnt
sudo mount -oloop,offset=32256 aarch64-ubuntu-trusty-headless.img $MNT
sudo mount -o bind /proc $MNT/proc
sudo mount -o bind /dev  $MNT/dev
sudo mount -o bind /sys  $MNT/sys
sudo cp /etc/resolv.conf $MNT/etc/
