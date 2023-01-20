# Vulcan image

This is a custom Linux image with Vulcan components included. [Buildroot][1] is
used to configure and manage this image for various platforms like x86 or ARM.

## Development Setup

**It is REQUIRED to run these commands on a powerful Linux machine.**

First clone the repo from GitHub:

```shell
git clone --recurse-submodules git@github.com:vulcan-rs/image.git
```

Then you can make changes to the config via `make menuconfig` (this is a
terminal based config tool) or via `make xconfig` (QT based GUI).

After configuration, you can build the custom image via `make`. This will
take quite a few minutes. To boot the image locally we can use QEMU:

```shell
qemu-system-x86_64 -kernel output/images/bzImage -drive file=output/images/rootfs.ext4,if=virtio,format=raw \
  -append "rootwait root=/dev/vda console=tty1 console=ttyS0" -net nic,model=virtio -net user -accel kvm \
  -cpu host -m 1024 -serial stdio
```

[1]: https://buildroot.org/
