meta-cheri
----------

CHERI Architecture Layer for CHERI enabled processors

# Building from source

One can use [kas](https://kas.readthedocs.io/en/latest/) tool for building. To install either do

```shell
pip install kas
```

or install it from via your normal distribution's way, e.g.

```shell
sudo apt install kas
```

Please note that kas at version 5.2 is required, to check version see

```shell
kas --version
```

Building with `kas` is then as easy as:

```shell
kas build ./kas/qemu-riscv64-cheri-minimal-multilib.yml
```

One can also use `kas-container` to tick off all of the host dependencies required for `Yocto`, your local `DL_DIR`, `SSTATE_DIR` and `SSH` can be passed as shown

```shell
KAS_CONTAINER_IMAGE=ghcr.io/the-capable-hub/cheri-yocto:latest kas-container \
--ssh-dir <YOUR .SSH DIR> --ssh-agent \
--runtime-args "-v <YOUR YOCTO SSTATE DIR>:/build/sstate-cache \
                  -v <YOUR YOCTO DL DIR>:/build/downloads \
		          -e SSTATE_DIR=/build/sstate-cache \
                  -e DL_DIR=/build/downloads \
" \
build ./kas/qemu-riscv64-cheri-minimal-multilib.yml
```

# Running with qemu

```shell
kas shell ./kas/qemu-riscv64-cheri-minimal-multilib.yml -c 'runqemu qemuriscv64cheri nographic slirp snapshot'
```
