PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}compilerlibs = "compiler-rt"

PREFERRED_VERSION_cross-localedef = "1.0"
PREFERRED_VERSION_cross-localedef-native = "1.0"

# Don't want to build anything on the target with gcc
BASE_DEFAULT_DEPS:remove:class-target = "virtual/${HOST_PREFIX}gcc"

TOOLCHAIN = "clang"

# Use meta-clang to provide llvm rather than core
PREFERRED_PROVIDER_llvm = "clang"
PREFERRED_PROVIDER_llvm-native = "clang-native"
PREFERRED_PROVIDER_nativesdk-llvm = "nativesdk-clang"
PROVIDES:pn-clang = "llvm"
PROVIDES:pn-clang-native = "llvm-native"
PROVIDES:pn-nativesdk-clang = "nativesdk-llvm"

# Too many places where Yocto uses gcc/binutils to mean C toolchain
PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}binutils = "clang-cross-${TARGET_ARCH}"
PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}gcc = "clang-cross-${TARGET_ARCH}"
PROVIDES:pn-clang-cross-${TARGET_ARCH} = "virtual/${TARGET_PREFIX}binutils"
PROVIDES:pn-clang-cross-${TARGET_ARCH} = "virtual/${TARGET_PREFIX}gcc"

# Upstream poky has switched to librsvg 2.52.0 (or later) which use
# rust, so use the last version which didn't need rust.
PREFERRED_VERSION_librsvg = "2.40.21"

# We are rebuilding the linux header files from the kernel source, so
# this needs to match the kernel version.
LINUXLIBCVERSION = "6.18.0+git"

# Include clang in SDK
CLANGSDK = "1"

# MACHINE_FEATURES (after careful consideration) we don't want included
# qemu user mode isn't supported for CHERI builds
MACHINE_FEATURES_BACKFILL_CONSIDERED += "qemu-usermode"

# Get crtbegin/end from compiler-rt
PACKAGECONFIG:append:pn-compiler-rt = " crt"

# We need to force the use of LLVM lld for Cheri builds
DISTRO_FEATURES:append = " ld-is-lld"

TC_CXX_RUNTIME="llvm"

# Not only is this unnecessary for cheri, it generates a warning
# telling you this, which causes problems with some configure scripts.
SECURITY_STACK_PROTECTOR = ""

# Remove gcc runtime-libraries from the SDK
RDEPENDS:packagegroup-core-standalone-sdk-target:remove = "libgcc"
RDEPENDS:packagegroup-core-standalone-sdk-target:remove = "libgcc-dev"
RDEPENDS:packagegroup-core-standalone-sdk-target:remove = "libatomic"
RDEPENDS:packagegroup-core-standalone-sdk-target:remove = "libatomic-dev"
RDEPENDS:packagegroup-core-standalone-sdk-target:remove = "libstdc++"
RDEPENDS:packagegroup-core-standalone-sdk-target:remove = "libstdc++-dev"

# Remove the requirement for python3.
# This needs to be before the recipe is read (and in particular it can't
# be in a .bbappend file), otherwise the
#    inherit ... python3targetconfig
# will be evaluated using the current value of PACKAGECONFIG not the
# final one.
PACKAGECONFIG:remove:pn-libxml2:class-target:cheri = "python"

# libzstd's pointer arithmetics produces unrepresentable addresses
# there's no simple way to fix this
SKIP_RECIPE[zstd] ?= "libzstd has not been adapted for cheri yet"

# Can't currently build python for CHERI
SKIP_RECIPE[python3] ?= "python has not been adapted for cheri yet"

# Prevent building gcc, binutils and glibc, which we can't currently
# do for CHERI.
SKIP_RECIPE[gcc] = "not adapted for CHERI yet"
SKIP_RECIPE[gcc-cross-riscv64] = "not adapted for CHERI yet"
SKIP_RECIPE[gcc-canadian] = "not adapted for CHERI yet"
SKIP_RECIPE[gcc-crosssdk] = "not adapted for CHERI yet"
SKIP_RECIPE[gcc-runtime] = "not adapted for CHERI yet"
SKIP_RECIPE[gcc-sanitizers] = "not adapted for CHERI yet"
SKIP_RECIPE[libgcc] = "not adapted for CHERI yet"
SKIP_RECIPE[libgcc-initial] = "not adapted for CHERI yet"
SKIP_RECIPE[libgfortran] = "not adapted for CHERI yet"

SKIP_RECIPE[binutils] = "not adapted for CHERI yet"
SKIP_RECIPE[binutils-cross-riscv64] = "not adapted for CHERI yet"
SKIP_RECIPE[binutils-cross-canadian] = "not adapted for CHERI yet"
SKIP_RECIPE[binutils-crosssdk] = "not adapted for CHERI yet"
SKIP_RECIPE[binutils-cross-testsuite] = "not adapted for CHERI yet"

# cross-localedef-native is normally built from glibc. However poky generates
# lots of dependencies on it which would be hard to remove. So we provide
# a dummy implementation to keep these dependencies happy.
# SKIP_RECIPE[cross-localedef-native] = "not adapted for CHERI yet"
SKIP_RECIPE[glibc] = "not adapted for CHERI yet"
SKIP_RECIPE[glibc-locale] = "not adapted for CHERI yet"
SKIP_RECIPE[glibc-mtrace] = "not adapted for CHERI yet"
SKIP_RECIPE[glibc-scripts] = "not adapted for CHERI yet"
SKIP_RECIPE[glibc-testsuite] = "not adapted for CHERI yet"
