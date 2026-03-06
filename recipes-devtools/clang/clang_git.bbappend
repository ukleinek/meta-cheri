require common-cheri.inc

# Can't currently build lldb for CHERI
LLDB:cheri = ""

# No ld avilable, so default to lld
PACKAGECONFIG:class-native:append = " lld"
PACKAGECONFIG:class-nativesdk:append = " lld"

# Upstream still tries to install lldb-tblgen even when LLDB builds are disabled
do_install:prepend:class-native () {
    touch ${B}${BINPATHPREFIX}/bin/lldb-tblgen
}

# No binutils available
DEPENDS:remove = "binutils"
RDEPENDS:remove = "binutils"
RRECOMMENDS:${PN}:remove = "binutils"
EXTRA_OECMAKE:remove = "-DLLVM_BINUTILS_INCDIR=${STAGING_INCDIR}"

# Undo meta-clang's multilib install:append path: stick it all in libdir
do_install:append () {

    if [ -n "${MULTILIBS}" ]; then

        if [ -n "${LLVM_LIBDIR_SUFFIX}" ]; then

            if [ -d "${D}${nonarch_libdir}/clang" ]; then

                rm -f ${D}${libdir}/clang

                mkdir -p ${D}${libdir}
                mv ${D}${nonarch_libdir}/clang ${D}${libdir}/clang
                rmdir --ignore-fail-on-non-empty ${D}${nonarch_libdir}
            fi
        fi
    fi
}
