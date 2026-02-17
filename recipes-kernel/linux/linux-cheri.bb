DESCRIPTION = "Cheri Linux Kernel"
SECTION = "kernel"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

inherit kernel
inherit kernel-yocto
inherit kernel-clang

KCONF_AUDIT_LEVEL ?= "2"
CONF_BSP_AUDIT_LEVEL ?= "3"
KMETA_AUDIT ?= "yes"

KERNEL_VERSION_SANITY_SKIP = "1"

SRCREV = "${AUTOREV}"
PV = "${LINUX_VERSION}+git${SRCPV}"
ERROR_QA:remove = "version-going-backwards"

SRC_URI = " \
    git://${META_CHERI_LINUX_REPO};protocol=${META_CHERI_LINUX_PROTOCOL};branch=${META_CHERI_LINUX_BRANCH} \
"

LINUX_VERSION ?= "6.18.0"
LINUX_VERSION_EXTENSION:append = "-cheri"

KCONFIG_MODE="--alldefconfig"

KBUILD_DEFCONFIG ?= "qemu_riscv64cheripc_defconfig"

COMPATIBLE_MACHINE = "^qemu.*cheri$"

# Keep kernel_configcheck task happy when it calls symbol_why.py
CLANG_FLAGS:toolchain-clang = "-fintegrated-as"
export CLANG_FLAGS

KERNEL_FEATURES:remove = "features/debug/printk.scc"
KERNEL_FEATURES:remove = "features/kernel-sample/kernel-sample.scc"
KERNEL_FEATURES:remove = "features/taskstats/taskstats.scc"
KERNEL_FEATURES:remove = "cfg/fs/vfat.scc"
