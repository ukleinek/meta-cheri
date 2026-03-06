require common-cheri.inc

# meta-clang compiler-rt is adding dependencies on gcc libraries, but we do not
# build them
DEPENDS:remove = "libgcc"
DEPENDS:remove:class-target = "gcc-runtime"

# Remove circular dependency.
# compiler-rt needs header files from libc, but not libc.a itself, while
# musl needs compiler-rt.a to link libc.so.
# This doens't appear to be a problem for newlib, so only make the change
# for musl.
DEPENDS:remove:class-target:libc-musl = "virtual/${MLPREFIX}libc"
DEPENDS:append:class-target:libc-musl = " musl-initial"

# meta-clang sets these to point to libgcc (the comment says its to avoid a circular
# dependency). However that doesn't help us. Fortunatly it is sufficent (with the change
# to OECMAKE_SOURCEPATH below) to disable standard libs entirely.
UNWINDLIB:class-target:toolchain-clang = "-nostdlib"
COMPILER_RT:class-target:toolchain-clang = "-nostdlib"

# Use compiler-rt as the cmake source path
# This has the effect of building compiler-rt standalone, and avoids a number
# of top level cmake tests which requre a runtime library.
OECMAKE_SOURCEPATH = "${S}/compiler-rt"

# Because we are skipping the top level configuration, need to override
# some default values
EXTRA_OECMAKE:append = " \
    -DCOMPILER_RT_INSTALL_PATH=${libdir}/clang/${MAJOR_VER} \
    -DCOMPILER_RT_BUILTINS_HIDE_SYMBOLS=off \
"

# Disable use of eh_frame
# Setting this flag disables calls to __register_frame_info() in
# crtbegin.c, which it turns out do nothing anyway, and gets rid
# of the warnings about __EH_FRAME_LIST__ at link time.
EXTRA_OECMAKE:append = " \
    -DCOMPILER_RT_CRT_USE_EH_FRAME_REGISTRY=OFF \
"

EXTRA_OECMAKE:append = " \
    --trace \
"

# meta-clang has this but commented out
PROVIDES:append:class-target = "\
        virtual/${TARGET_PREFIX}compilerlibs \
        libgcc \
        libgcc-initial \
        libgcc-dev \
        libgcc-initial-dev \
        "

# Adding libatomic to a baremetal build breaks it, as it appears
# __builtin_memcpy() still expands to a call to memcpy(), but the
# code is linked with -nostdlib to avoid needing libc.
# So for now only enable it for musl (i.e. poky) builds.
EXTRA_OECMAKE:append:libc-musl = " -DCOMPILER_RT_BUILD_STANDALONE_LIBATOMIC=ON"

COMPATIBLE_HOST = "${HOST_SYS}"

# Undo meta-clang's multilib install:append path and stick it all in ${libdir}
do_install:append () {

    if [ -n "${MULTILIBS}" ]; then

        if [ -n "${LLVM_LIBDIR_SUFFIX}" ]; then

            if [ -d "${D}${nonarch_libdir}/clang" ]; then

                mkdir -p ${D}${libdir}/clang

                mv ${D}${nonarch_libdir}/clang/${MAJOR_VER}.${MINOR_VER}.${PATCH_VER} ${D}${libdir}/clang/${MAJOR_VER}.${MINOR_VER}.${PATCH_VER}

                rmdir --ignore-fail-on-non-empty ${D}${nonarch_libdir}/clang ${D}${nonarch_libdir}
            fi
        fi
    fi
}

# The files now live in ${libdir}
FILES:${PN}:append:virtclass-multilib-lib64i = " \
${libdir}/clang/${MAJOR_VER}.${MINOR_VER}.${PATCH_VER}/lib/linux/lib*${SOLIBSDEV} \
${libdir}/clang/${MAJOR_VER}.${MINOR_VER}.${PATCH_VER}/*.txt \
${libdir}/clang/${MAJOR_VER}.${MINOR_VER}.${PATCH_VER}/share/*.txt"

FILES:${PN}-staticdev:append:virtclass-multilib-lib64i = " ${libdir}/clang/${MAJOR_VER}.${MINOR_VER}.${PATCH_VER}/lib/linux/*.a"

FILES:${PN}-dev:append:virtclass-multilib-lib64i = " ${datadir} ${libdir}/clang/${MAJOR_VER}.${MINOR_VER}.${PATCH_VER}/lib/linux/*.syms \
                    ${libdir}/clang/${MAJOR_VER}.${MINOR_VER}.${PATCH_VER}/include \
                    ${libdir}/clang/${MAJOR_VER}.${MINOR_VER}.${PATCH_VER}/lib/linux/clang_rt.crt*.o \
                    ${libdir}/clang/${MAJOR_VER}.${MINOR_VER}.${PATCH_VER}/lib/linux/libclang_rt.asan-preinit*.a"



# Copy headers to the resource-dir as well as we now set the resource-dir
# variable explicitly and point it to ${libdir}
do_install:append:class-target () {

    if [ -n "${MULTILIBS}" ]; then

        install -d ${D}$${libdir}/clang/${MAJOR_VER}.${MINOR_VER}.${PATCH_VER}

        if [ -d "${STAGING_DIR_NATIVE}${nonarch_libdir}/clang/${MAJOR_VER}/include" ]; then

            cp -rf ${STAGING_DIR_NATIVE}${nonarch_libdir}/clang/${MAJOR_VER}/include ${D}${libdir}/clang/${MAJOR_VER}.${MINOR_VER}.${PATCH_VER}/
        fi
    fi
}

FILES:${PN}-dev += " \
    ${libdir}/clang/${MAJOR_VER}.${MINOR_VER}.${PATCH_VER}/include/* \
"
