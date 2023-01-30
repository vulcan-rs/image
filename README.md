# Vulcan image

This is a custom Linux image with Vulcan components included. [Buildroot][1] is used to configure and manage this image
for various platforms like x86 or ARM.

## Development Setup

**It is REQUIRED to run these commands on a powerful Linux machine.**

First clone the repo from GitHub:

```shell
git clone --recurse-submodules git@github.com:vulcan-rs/image.git
```

### Dependencies

> See [here][4]

There are a few required dependencies to use Buildroot and build a custom Linux image. These can be installed (on Arch)
via:

```shell
yay -S which sed make binutils diffutils gcc bash patch gzip bzip2 perl tar cpio unzip rsync file bc findutils
```

Then you can make changes to the config via `make menuconfig` (this is a terminal based config tool) or via
`make xconfig` (QT based GUI).

### ccache

> See [here][2]

Enable ccache in the build options. The cache directory is defined by `BR2_CCACHE_DIR` with a default value of
`$HOME/.buildroot-ccache`.

### External tree

> See [here][3]

The first time we call `make menuconfig` or `make xconfig` we need to pass `BR2_EXTERNAL` with either an absolute or
relative path. This repo uses a relative path: `../external`. So the initial command looks like this:

```shell
make BR2_EXTERNAL=.. menuconfig
```

All subsequent `make` calls will use this path automatically in the `.br2-external.mk` file. To create the defconfig, we
can call this command in the output directory:

```shell
cd output
make savedefconfig
```

---

After configuration, you can build the custom image via `make`. This will take quite a few minutes.

```shell
make BR2_EXTERNAL=../external 0=../output vulcan_x86_64_defconfig
```

To boot the image locally we can use QEMU:

```shell
qemu-system-x86_64 -kernel output/images/bzImage -drive file=output/images/rootfs.ext4,if=virtio,format=raw \
  -append "rootwait root=/dev/vda console=tty1 console=ttyS0" -net nic,model=virtio -net user -accel kvm \
  -cpu host -m 1024 -serial stdio
```

[1]: https://buildroot.org/
[2]: https://buildroot.org/downloads/manual/manual.html#ccache
[3]: https://buildroot.org/downloads/manual/manual.html#outside-br-custom
[4]: https://buildroot.org/downloads/manual/manual.html#requirement-mandatory
