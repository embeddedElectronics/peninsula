#include "BMP.h"
#include "FAT32.h"
unsigned char *pBmpBuf;//读入图像数据的指针
int bmpWidth;//图像的宽
int bmpHeight;//图像的高
int biBitCount;//图像类型，每像素位数

BITMAPFILEHEADER fileHead;
BITMAPINFOHEADER head;
uint8 create_Time[6]={0x09,0x07,0x0d,0x0d,0x14,0x0f};  //创建时间貌似修改了没有用
void InitColorTable(RGBQUAD* colorTable) {
  uint16 i;
  for (i=0;i<256;i++)
	{
		colorTable[i].rgbBlue=i;
		colorTable[i].rgbGreen=i;
		colorTable[i].rgbRed=i;
		colorTable[i].rgbReserved=0;
	} 
}
void BmpBIT8Write(/*struct FileInfoStruct* fileInfo,*/uint8* fileName,uint8 xSize,uint8 ySize,uint8* imgBuf,RGBQUAD* colorTable){
  struct FileInfoStruct fileInfo;
  uint8 CreateTime[6]={0x09,0x07,0x0d,0x0d,0x14,0x0f};
  uint8 fhead[]={0x42,0x4D,0xF6,0x16,00,00,00,00,00,0x00, //每行十个数字
  0x36,0x04,00,00,0x28,00,00,00,0x50,0x00,
  00,00,0x46,00,00,00,0x01,00,0x08,00,
  00,00,00,00,0xC0,0x12,00,00,00,00,
  00,00,00,00,00,00,00,00,00,00,
  00,00,00,00};
  uint8 fileSize,imgSize;
  fileSize=xSize*ySize+54+1024;
  imgSize=xSize*ySize;
  fhead[2]=fileSize&0x00FF;
  fhead[3]=(fileSize>>2)&0x00FF;
  fhead[18]=xSize;
  fhead[22]=ySize;
  fhead[34]=imgSize&0x00FF;
  fhead[35]=(imgSize>>2)&0x00FF;
  FAT32_Create_File(&fileInfo,fileName,CreateTime);
  FAT32_Add_Dat(&fileInfo,sizeof(fhead),fhead);
  //FAT32_Add_Dat(&fileInfo,sizeof(colorTable),(uint8*)colorTable);
  FAT32_Add_Dat(&fileInfo,sizeof(imgBuf),imgBuf);  
}