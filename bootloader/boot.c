#include <efi.h>
#include <efilib.h>

EFI_STATUS
efi_main(EFI_HANDLE image_handle, EFI_SYSTEM_TABLE *systab)
{
    //gnu-efi的要求，加载系统表systable
    InitializeLib(image_handle, systab);

    //调用API在屏幕上输出Hello World!
    Print(L"Hello World!\n\r");

    //按任意键后退出模拟器
    WaitForSingleEvent(systab->ConIn->WaitForKey, 0);
    gRT->ResetSystem(EfiResetShutdown, EFI_SUCCESS,
                     0, NULL);

    return EFI_SUCCESS;
}