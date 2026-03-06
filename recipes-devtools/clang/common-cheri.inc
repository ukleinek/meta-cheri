BASEURI = "git://${META_CHERI_LLVM_PROJECT_REPO};protocol=${META_CHERI_LLVM_PROJECT_PROTOCOL};branch=${META_CHERI_LLVM_PROJECT_BRANCH};destsuffix=cherillvm-${RELEASE}"
SOURCEDIR = "cherillvm-${RELEASE}"
SRCREV ?= "${AUTOREV}"
ERROR_QA:remove = "version-going-backwards"

FILESEXTRAPATHS:prepend := "${THISDIR}/clang:"
SRC_URI += " \
    file://morello_clang_h.patch \
"

# Remove this patch: one can set -resource-dir from the command line args
SRC_URI:remove = "${@' \
file://0009-clang-Look-inside-the-target-sysroot-for-compiler-ru.patch \
' if d.getVar('MULTILIBS') else ''}"

MAJOR_VER = "19"
MINOR_VER = "0"
PATCH_VER = "0"
