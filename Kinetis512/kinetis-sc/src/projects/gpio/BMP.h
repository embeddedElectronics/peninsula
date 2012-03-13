#ifndef BMP_H
#define BMP_H
#include "FAT32.h"

typedef struct tagBITMAPFILEHEADER
{
WORD bfType;  
DWORD bfSize;  
WORD bfReserved1;  
WORD bfReserved2; 
DWORD bfOffBits;
 
}BITMAPFILEHEADER;

typedef struct tagBITMAPINFOHEADER
{
DWORD biSize;     
LONG biWidth;    
LONG biHeight;    
WORD biPlanes;    
WORD biBitCount;   
DWORD biCompression;  
DWORD biSizeImage;   
LONG biXPelsPerMeter;  
LONG biYPelsPerMeter;  
DWORD biClrUsed;  
DWORD biClrImportant; 
}BITMAPINFOHEADER;

typedef struct tagRGBQUAD
{
BYTE rgbBlue;
BYTE rgbGreen;
BYTE rgbRed;
BYTE rgbReserved;
}RGBQUAD;


void InitColorTable(RGBQUAD* colorTable) ;
//void BmpBIT8Write(struct FileInfoStruct* fileInfo,UINT8* fileName,UINT8 xSize,UINT8 ySize,UINT8* imgBuf,RGBQUAD* colorTable);
#endif