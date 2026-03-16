FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = " \
    git://${META_CHERI_MUSL_REPO};protocol=${META_CHERI_MUSL_PROTOCOL};branch=${META_CHERI_MUSL_BRANCH} \
"
BASEVER = "1.2.0"
SRCREV = "${AUTOREV}"
PV = "${BASEVER}+git${SRCPV}"
ERROR_QA:remove = "version-going-backwards"

LIC_FILES_CHKSUM = "file://COPYRIGHT;md5=b03f1cc25363d094011f8f4fd8bcfb68"

DEPENDS:remove = "libgcc-initial"
DEPENDS:append = " virtual/${TARGET_PREFIX}compilerlibs"
DEPENDS:remove = "libssp-nonshared"

RDEPENDS:${PN}-dev:remove = "libssp-nonshared-staticdev"


SRC_URI += "\
              file://0001-Makefile-use-MUSL_LDSO_ARCH-variable-across-the-stac.patch \
            "

# musl Makefile uses
#   STRIP  = $(CROSS_COMPILE)strip
# which is the bfd strip, which fails with:
#   riscv64-codasip-linux-musl-strip: lib/libc.so.striped: not enough room for program headers, try linking with -N
# so force the use of llvm strip
EXTRA_OEMAKE += "STRIP=${STRIP}"

# override MUSL_LDSO_ARCH to match TUNE_PKGARCH
MUSL_LDSO_ARCH = "${TUNE_PKGARCH}"
# pass it to musl makefile to use for generating the dynamic linker symlink
# so that all of the files that end up in /usr/lib and /usr/etc are matched and
# driven by the one same variable - which is not the case currently.
EXTRA_OEMAKE += "MUSL_LDSO_ARCH=${MUSL_LDSO_ARCH}"

# musl builds with -nostdlib and -ffreestanding, so cannot access
# cheri_init_globals_bw.h directly. Copy it into the build for now
do_compile:prepend() {
  touch x.c
  $CC $CFLAGS --verbose -c x.c > log 2>&1
  for p in `sed -n '/include <...> search starts here/,/End of search list/s/^ //p' log` ; do
    echo $p
    c=$p/cheri_init_globals_bw.h
    [ -f "$c" ] && cp "$c" ${S}/include
    c=$p/cheri_init_globals.h
    [ -f "$c" ] && cp "$c" ${S}/include
  done
}

# musl installs stropts.h (support for STREAMS) which Linux doesn't support
# It also has a prototype for ioctl() which causes problems with clang.
# Rather than fix it, just remove it.
do_install:append() {
  find ${D}${includedir} -name stropts.h -exec rm {} \;

  # Because we specify --sysroot when cross compiling, $sysroot/usr/include
  # ends up on the include search path before the compiler's own
  # $sysroot-native/usr/lib/clang/15.0.0/include which causes problems with
  # files such as stddef.h where we want the compiler version (for ptraddr_t
  # for example).
  # So delete the musl provided headers and rely on the compiler provided
  # ones.
  # Note we leave a couple in place (inttypes.h, limits.h) because the
  # compiler provided ones are incomplete and would rely on picking up the
  # system provided ones using #include_next, but this doesn't work because
  # the include path ordering is wrong.
  for h in float iso646 stdalign stdarg stdbool stddef stdint stdnoreturn tgmath ; do
    rm ${D}${includedir}/$h.h
  done

  rm ${D}/usr/share/revisions.txt
  rmdir ${D}/usr/share/
}
