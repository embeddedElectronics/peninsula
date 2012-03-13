#ifndef FAT32_H
#define FAT32_H
#include "hw_sdhc.h" 
//#include "mytype.h" //�����ض���

/*******************************************************

        +-----------------------------------------+
        |���ϵ��� ԭ������ģ�� znFAT�ļ�ϵͳ 5.01 |
        +-----------------------------------------+

  ��Դ���Ȩ�� ���� ȫȨ���У��������ã�������������֪
        �Ͻ�����������ҵĿ�ģ�Υ�߱ؾ�������Ը�
         ���ϵ��� 
             ->��Ʒ��վ http://www.znmcu.cn/
             ->��Ʒ��̳ http://bbs.znmcu.cn/
             ->��Ʒ���� http://shop.znmcu.cn/
             ->��Ʒ��ѯ QQ:987582714 MSN:yzn07@126.com
	                WW:yzn07
˵����znFAT���෽���ԣ�ȷ������ȷ�����ȶ��ԣ������ʹ�ã�
      ����bug�����֪��лл����				  
********************************************************/

#define SOC(c) (((c-pArg->FirstDirClust)*(pArg->SectorsPerClust))+pArg->FirstDirSector) // ���ڼ���صĿ�ʼ����
#define DEVS 1 //��������洢�豸�ĸ���������ֻ��1���洢�豸������SD��

//�豸��
#define SDCARD 0 //SD��
#define UDISK  1 //U��
#define CFCARD 2 //CF��
#define OTHER  3 //����
				 //����Ĵ洢�豸������������䣬��ʵ�ֶԸ���洢�豸��֧��
//-------------------------------------------

#define MAKE_FILE_TIME(h,m,s)	((((unsigned int)h)<<11)+(((unsigned int)m)<<5)+(((unsigned int)s)>>1))	/* ����ָ��ʱ������ļ�ʱ������ */
#define MAKE_FILE_DATE(y,m,d)	(((((unsigned int)y)+20)<<9)+(((unsigned int)m)<<5)+((unsigned int)d))	/* ����ָ�������յ��ļ��������� */

//DPT:������¼�ṹ����
struct PartRecord
{
 uint8 Active;         //0x80��ʾ�˷�����Ч
 uint8 StartHead;      //�����Ŀ�ʼ��ͷ
 uint8 StartCylSect[2];//��ʼ����������
 uint8 PartType;       //��������
 uint8 EndHead;        //�����Ľ���ͷ
 uint8 EndCylSect[2];  //��������������
 uint8 StartLBA[4];    //�����ĵ�һ������
 uint8 Size[4];        //�����Ĵ�С 
};

//MBR:��������������0��������������
struct PartSector
{
 uint8 PartCode[446]; //MBR����������
 struct PartRecord Part[4];   //4��������¼
 uint8 BootSectSig0;  //55
 uint8 BootSectSig1;  //AA
};


//FAT32�ж�BPB�Ķ�������  һ��ռ��90���ֽ�
struct FAT32_BPB
{
 uint8 BS_jmpBoot[3];     //��תָ��            offset: 0
 uint8 BS_OEMName[8];     //                    offset: 3
 uint8 BPB_BytesPerSec[2];//ÿ�����ֽ���        offset:11
 uint8 BPB_SecPerClus[1]; //ÿ��������          offset:13
 uint8 BPB_RsvdSecCnt[2]; //����������Ŀ        offset:14
 uint8 BPB_NumFATs[1];    //�˾���FAT����       offset:16
 uint8 BPB_RootEntCnt[2]; //FAT32Ϊ0            offset:17
 uint8 BPB_TotSec16[2];   //FAT32Ϊ0            offset:19
 uint8 BPB_Media[1];      //�洢����            offset:21
 uint8 BPB_FATSz16[2];    //FAT32Ϊ0            offset:22
 uint8 BPB_SecPerTrk[2];  //�ŵ�������          offset:24
 uint8 BPB_NumHeads[2];   //��ͷ��              offset:26
 uint8 BPB_HiddSec[4];    //FAT��ǰ��������     offset:28
 uint8 BPB_TotSec32[4];   //�þ���������        offset:32
 uint8 BPB_FATSz32[4];    //һ��FAT��������     offset:36
 uint8 BPB_ExtFlags[2];   //FAT32����           offset:40
 uint8 BPB_FSVer[2];      //FAT32����           offset:42
 uint8 BPB_RootClus[4];   //��Ŀ¼�غ�          offset:44
 uint8 FSInfo[2];         //��������FSINFO������offset:48
 uint8 BPB_BkBootSec[2];  //ͨ��Ϊ6             offset:50
 uint8 BPB_Reserved[12];  //��չ��              offset:52
 uint8 BS_DrvNum[1];      //                    offset:64
 uint8 BS_Reserved1[1];   //                    offset:65
 uint8 BS_BootSig[1];     //                    offset:66
 uint8 BS_VolID[4];       //                    offset:67
 uint8 BS_FilSysType[11]; //	                offset:71
 uint8 BS_FilSysType1[8]; //"FAT32    "         offset:82
};

struct FAT32_FAT_Item
{
 uint8 Item[4];
};

struct FAT32_FAT
{
 struct FAT32_FAT_Item Items[128];
};

struct direntry 
{
 uint8 deName[8];       // �ļ��������㲿���Կո񲹳�
 uint8 deExtension[3]; 	// ��չ�������㲿���Կո񲹳�
 uint8 deAttributes;   	// �ļ�����
 uint8 deLowerCase;    	// 0
 uint8 deCHundredth;   	// ����
 uint8 deCTime[2];     	// ����ʱ��
 uint8 deCDate[2];     	// ��������
 uint8 deADate[2];     	// ��������
 uint8 deHighClust[2];  // ��ʼ�صĸ���
 uint8 deMTime[2];     	// ������޸�ʱ��
 uint8 deMDate[2];     	// ������޸�����
 uint8 deLowCluster[2]; 	// ��ʼ�صĵ���
 uint8 deFileSize[4];      // �ļ���С 
};

//FAT32��ʼ��ʱ��ʼ����װ�����½ṹ����
struct FAT32_Init_Arg
{
 uint8 DEV_No;

 uint8 BPB_Sector_No;   //BPB����������
 uint32 Total_Size;      //���̵�������

 uint32 FirstDirClust;   //��Ŀ¼�Ŀ�ʼ��
 uint32  BytesPerSector;	//ÿ���������ֽ���
 uint32  FATsectors;      //FAT����ռ������
 uint32  SectorsPerClust;	 //ÿ�ص�������
 uint32 FirstFATSector;	 //��һ��FAT����������
 uint32 FirstDirSector;	 //��һ��Ŀ¼��������
};

struct Date
{
 uint16 year;
 uint8 month;
 uint8 day;
};

struct Time
{
 uint8 hour;
 uint8 min;
 uint8 sec;
};

// Stuctures
struct FileInfoStruct
{
 uint8  FileName[12];       //�ļ���
 uint32  FileStartCluster;   //�ļ��Ŀ�ʼ��

 uint32  FileCurCluster;
 uint32  FileSize;	    //�ļ��ĵ�ǰ��
 uint32  FileCurSector;	    //�ļ��ĵ�ǰ����
 uint16   FileCurPos;         //�ļ��ڵ�ǰ�����е�λ��
 uint32  FileCurOffset;	    //�ļ��ĵ�ǰƫ����
 uint32  Rec_Sec;            //�ļ����ļ�/Ŀ¼�����ڵ�����
 uint16   nRec;               //�ļ����ļ�/Ŀ¼�����������е�λ��

 uint8  FileAttr;	    //�ļ�����				
 struct Time    FileCreateTime;	    //�ļ��Ĵ���ʱ��
 struct Date    FileCreateDate;	    //�ļ��Ĵ�������
 struct Time    FileMTime;          //�ļ����޸�ʱ��
 struct Date    FileMDate;          //�ļ����޸�����
 struct Date	FileADate;          //�ļ��ķ�������

};

struct FSInfo //FAT32���ļ�ϵͳ��Ϣ�ṹ
{
 uint8 Head[4];
 uint8 Resv1[480];
 uint8 Sign[4];
 uint8 Free_Cluster[4];
 uint8 Last_Cluster[4];
 uint8 Resv2[14];
 uint8 Tail[2];
};

uint8 FAT32_ReadSector(uint32 addr,uint8 *buf); //znFAT����ײ�洢�豸�������ӿڣ���ȡ����
uint8 FAT32_WriteSector(uint32 addr,uint8 *buf);//znFAT����ײ�洢�豸�������ӿڣ�д������

uint32 LE2BE(uint8 *dat,uint8 len); //С��ת���

uint8 FAT32_is_MBR(); //�Ƿ����MBR
void FAT32_Analysis_DPT(); //����DPT�ṹ
uint16 FAT32_Find_DBR(); //��λDBR

uint32 FAT32_Get_Total_Size(); //��ȡ������
void FAT32_Init(); //�ļ�ϵͳ��ʼ��

uint32 Search_Last_Usable_Cluster(); //�ӻ�ȡFSInfo�е���һ�����ÿ��д�
uint32 FAT32_Get_Remain_Cap(); //��ȡʣ������

void FAT32_Update_FSInfo_Free_Clu(uint32 PlusOrMinus); //����FSInfo�Ŀ��дص�����
void FAT32_Update_FSInfo_Last_Clu(uint32 Last_Clu); //����FSInfo����һ�����ÿ��д�

uint32 FAT32_GetNextCluster(uint32 LastCluster); //��ȡ��һ����
uint32 FAT32_Enter_Dir(int8 *path); //����Ŀ¼
uint8 FAT32_Open_File(struct FileInfoStruct *pfi,int8 *filepath,uint32 item); //���ļ���֧��ͨ��
uint8 FAT32_Seek_File(struct FileInfoStruct *pfi,uint32 offset); //�ļ���λ 
uint32 FAT32_Read_File(struct FileInfoStruct *pfi,uint32 offset,uint32 len,uint8 *pbuf); //��ȡ�ļ�����
uint32 FAT32_Read_FileX(struct FileInfoStruct *pfi,uint32 offset,uint32 len,void (*pfun)(uint8)); //��ȡ�ļ����ݲ��������ݴ���
uint32 FAT32_Find_Free_Clust(unsigned char flag);	//Ѱ����һ�����õĿ��д�
int8 FAT32_Create_Rec(struct FileInfoStruct *pfi,uint32 cluster,int8 *name,uint8 is_dir,uint8 *ptd); //�����ļ�/Ŀ¼��
uint32 FAT32_Add_Dat(struct FileInfoStruct *pfi,uint32 len,uint8 *pbuf); //���ļ�׷������
uint8 FAT32_Create_Dir(struct FileInfoStruct *pfi,int8 *dirpath,uint8 *ptd); //����Ŀ¼��֧�ִ���ʱ��
uint8 FAT32_Create_File(struct FileInfoStruct *pfi,int8 *filepath,uint8 *ptd); //�����ļ���֧�ִ���ʱ��
uint8 FAT32_Del_File(int8 *filepath); //ɾ���ļ�
unsigned char FAT32_XCopy_File(struct FAT32_Init_Arg *pArg1,struct FAT32_Init_Arg *pArg2,int8 *sfilename,int8 *tfilename,uint8 *file_buf,uint32 buf_size,unsigned char *pt); //�ļ�������֧�ֶ��豸���ļ�����
uint8 FAT32_File_Close(struct FileInfoStruct *pfi); //�ļ��ر�
uint8 FAT32_Rename_File(int8 *filename,int8 *newfilename); //�ļ�������
uint8 FAT32_New_File(struct FileInfoStruct *pfi,int8 *filepath,uint8 *ptd);

#endif