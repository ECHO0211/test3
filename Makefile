# 把最后生成的东西复制到这个目录
BLDDIR = $(shell pwd)/target/
#Boot=$(shell pwd)/target/EFI/

# 要生成的东西
TARGET = EFI/Boot/bootx64.efi kernel

# 让子Makefile知道这个变量
export BLDDIR

# 默认为debug模式
DEBUG	?= 1
ifeq ($(DEBUG), 1)
    CFLAGS += -g
endif

export CFLAGS

all: $(BLDDIR)/$(TARGET)

$(BLDDIR)/$(TARGET): $(BLDDIR)
	$(MAKE) -C bootloader
	$(MAKE) -C kernel

$(BLDDIR): 
	mkdir $(BLDDIR)

qemu:all
	qemu-system-x86_64 -bios  ~/test3/utils/OVMF.fd -drive file=fat:rw:target,format=raw
	
# 伪目标（执行 make clean 时会执行下列命令，而不判断生成的文件是否存在）
.PHONY: clean
clean:
	$(MAKE) -C bootloader clean
	$(MAKE) -C kernel clean

# 伪目标，执行 make qemu 时开启仿真器进行模拟，并启用调试模式，等待gdb连接
.PHONY: all
qemu: all
	qemu-system-x86_64 -bios utils/OVMF.fd -drive file=fat:rw:target,format=raw -gdb tcp::1234 -S -d in_asm
