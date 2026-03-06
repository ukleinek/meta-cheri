require common-cheri.inc

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
FILES:${PN} += "${libdir}/clang/${MAJOR_VER}.${MINOR_VER}.${PATCH_VER} \
				${libdir}/clang/${MAJOR_VER}/lib/linux/lib*${SOLIBSDEV} \
                ${libdir}/clang/${MAJOR_VER}/*.txt \
                ${libdir}/clang/${MAJOR_VER}/share/*.txt"
FILES:${PN}-staticdev += "${libdir}/clang/${MAJOR_VER}.${MINOR_VER}.${PATCH_VER}/lib/linux/*.a"
FILES:${PN}-dev += "${datadir} ${libdir}/clang/${MAJOR_VER}/lib/linux/*.syms \
                    ${libdir}/clang/${MAJOR_VER}/include \
                    ${libdir}/clang/${MAJOR_VER}/lib/linux/clang_rt.crt*.o \
                    ${libdir}/clang/${MAJOR_VER}/lib/linux/libclang_rt.asan-preinit*.a"
INSANE_SKIP:${PN} = "dev-so libdir"
INSANE_SKIP:${PN}-dbg = "libdir"
