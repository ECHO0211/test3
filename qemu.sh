#!/bin/bash
cp target/bootx64.efi target/EFI/Boot/
 qemu-system-x86_64 -bios ~/test3/utils/OVMF.fd -drive file=fat:rw:target,format=raw