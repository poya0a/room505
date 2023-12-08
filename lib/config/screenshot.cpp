#include <Windows.h>
#include <gdiplus.h>
#include <iostream>
#include <fstream>

#pragma comment(lib, "gdiplus.lib")

int GetEncoderClsid(const WCHAR* format, CLSID* pClsid) {
    UINT num = 0;
    UINT size = 0;
    Gdiplus::ImageCodecInfo* pImageCodecInfo = NULL;

    Gdiplus::GetImageEncodersSize(&num, &size);
    if (size == 0) return -1;

    pImageCodecInfo = (Gdiplus::ImageCodecInfo*)(malloc(size));
    if (pImageCodecInfo == NULL) return -1;

    Gdiplus::GetImageEncoders(num, size, pImageCodecInfo);

    for (UINT j = 0; j < num; ++j) {
        if (wcscmp(pImageCodecInfo[j].MimeType, format) == 0) {
            *pClsid = pImageCodecInfo[j].Clsid;
            free(pImageCodecInfo);
            return j;
        }
    }

    free(pImageCodecInfo);
    return -1;
}

int SaveBitmapAsJPG(const wchar_t* bmpPath, const wchar_t* jpgPath) {
    Gdiplus::GdiplusStartupInput gdiplusStartupInput;
    ULONG_PTR gdiplusToken;
    Gdiplus::GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);

    Gdiplus::Bitmap* bitmap = new Gdiplus::Bitmap(bmpPath, false);

    CLSID clsid;
    GetEncoderClsid(L"image/jpeg", &clsid);

    bitmap->Save(jpgPath, &clsid, NULL);

    delete bitmap;
    Gdiplus::GdiplusShutdown(gdiplusToken);

    return 0;
}

int main() {
    const wchar_t* bmpFilePath = L"C:\\path\\to\\screenshot.bmp";
    const wchar_t* jpgFilePath = L"C:\\path\\to\\screenshot.jpg";

    int result = SaveBitmapAsJPG(bmpFilePath, jpgFilePath);

    if (result == 0) {
        std::wcout << L"Successfully saved BMP as JPG!" << std::endl;
    } else {
        std::wcout << L"Failed to save BMP as JPG!" << std::endl;
    }

    return 0;
}