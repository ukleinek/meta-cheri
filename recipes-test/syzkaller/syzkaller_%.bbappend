# allow riscv64 over what is defined in meta-openembedded's syzkaller_git.bb
COMPATIBLE_HOST = "(x86_64|i.86|arm|aarch64|riscv64).*-linux"
