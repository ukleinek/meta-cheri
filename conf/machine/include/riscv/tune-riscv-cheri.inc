require arch-riscv-cheri.inc

TUNEVALID[riscv64cheri] = "Enable 64-bit RISC-V with CHERI extension"

TUNEVALID[codasip-lux] = "Enable 64-bit RISC-V with Codasip Lux extensions (excluding CHERI)"
TUNEVALID[codasip-lux-cheri] = "Enable 64-bit RISC-V with Codasip Lux extensions (including CHERI)"

AVAILTUNES += "riscv64cheri codasip-lux codasip-lux-cheri"

TUNE_FEATURES:tune-riscv64cheri = "${TUNE_FEATURES:tune-riscv64} riscv64cheri"
TUNE_ARCH:tune-riscv64cheri = "riscv64c"
TUNE_PKGARCH:tune-riscv64cheri = "riscv64cheri"
PACKAGE_EXTRA_ARCHS:tune-riscv64cheri = "riscv64cheri"

TUNE_FEATURES:tune-codasip-lux = "${TUNE_FEATURES:tune-riscv64} codasip-lux"
TUNE_ARCH:tune-codasip-lux = "riscv64c"
TUNE_PKGARCH:tune-codasip-lux = "riscv64c"
PACKAGE_EXTRA_ARCHS:tune-codasip-lux = "riscv64c"

TUNE_FEATURES:tune-codasip-lux-cheri = "${TUNE_FEATURES:tune-riscv64} riscv64cheri codasip-lux"
TUNE_ARCH:tune-codasip-lux-cheri = "riscv64"
TUNE_PKGARCH:tune-codasip-lux-cheri = "riscv64cheri"
PACKAGE_EXTRA_ARCHS:tune-codasip-lux-cheri = "riscv64cheri"
