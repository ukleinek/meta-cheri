# Add absolute path - alternative is to just install to ${libdir}
do_install:append:virtclass-multilib-lib64i() {
    for i in libncurses libncursesw; do
        f=${D}${libdir}/$i.so
        if [ -f "$f" ]; then
            sed -i "s|INPUT(|INPUT(${base_libdir}/|g" $f
        fi
    done
}
