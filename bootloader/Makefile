CC			= 	gcc
LD			= 	ld
OBJCOPY		= 	objcopy

ARCH        = 	x86_64

GNUEFIDIR   = 	./gnu-efi

CFLAGS		+= 	-Wno-error=pragmas -Wall -Wextra -Werror \
  			  	-mno-red-zone -mno-avx \
  				-fpic -fshort-wchar -fno-strict-aliasing -ffreestanding -fno-stack-protector -fno-stack-check -fno-merge-all-constants \
  				-DCONFIG_x86_64 -DGNU_EFI_USE_MS_ABI -maccumulate-outgoing-args

CFLAGS		+=	-Ignu-efi/inc -Ignu-efi/inc/x86_64 -Ignu-efi/inc/protocol

CPPFLAGS	+= 	-D__KERNEL__
CRTOBJS		= 	$(GNUEFIDIR)/$(ARCH)/gnuefi/crt0-efi-$(ARCH).o

LDSCRIPT	= 	$(GNUEFIDIR)/gnuefi/elf_$(ARCH)_efi.lds
LDFLAGS		+=	-nostdlib --warn-common --no-undefined --fatal-warnings --build-id=sha1
LDFLAGS		+= 	-shared -Bsymbolic -L$(GNUEFIDIR)/$(ARCH)/lib -L$(GNUEFIDIR)/$(ARCH)/gnuefi $(CRTOBJS)

LOADLIBES	+= 	-lefi -lgnuefi
LDFLAGS	    += 	-T $(LDSCRIPT)

$(BLDDIR)	?=	.

TARGET 		= 	$(BLDDIR)/bootx64.efi

FORMAT		:= 	--target efi-app-$(ARCH)

all: $(CRTOBJS) $(TARGET)

$(CRTOBJS):
	$(MAKE) -C gnu-efi

%.o: %.c
	$(CC) $(INCDIR) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

bootloader.so: *.o
	$(LD) $(LDFLAGS) $^ -o $@ $(LOADLIBES)

$(TARGET): bootloader.so
	$(OBJCOPY) -j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel \
		    -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
		    -j .reloc $(FORMAT) $< $@

.PHONY: clean
clean:
	rm -f $(TARGET) *~ *.o *.so
#	$(MAKE) -C gnu-efi clean

