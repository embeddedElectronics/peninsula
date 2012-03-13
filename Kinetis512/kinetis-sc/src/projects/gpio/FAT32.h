#ifndef FAT32_H
#define FAT32_H
#include "hw_sdhc.h" 
//#include "mytype.h" //类型重定义

/*******************************************************

        +-----------------------------------------+
        |振南电子 原创程序模块 znFAT文件系统 5.01 |
        +-----------------------------------------+

  此源码版权属 振南 全权享有，如欲引用，敬请署名并告知
        严禁随意用于商业目的，违者必究，后果自负
         振南电子 
             ->产品网站 http://www.znmcu.cn/
             ->产品论坛 http://bbs.znmcu.cn/
             ->产品网店 http://shop.znmcu.cn/
             ->产品咨询 QQ:987582714 MSN:yzn07@126.com
	                WW:yzn07
说明：znFAT经多方测试，确保其正确性与稳定性，请放心使用，
      如有bug敬请告知，谢谢！！				  
********************************************************/

#define SOC(c) (((c-pArg->FirstDirClust)*(pArg->SectorsPerClust))+pArg->FirstDirSector) // 用于计算簇的开始扇区
#define DEVS 1 //这里表明存储设备的个数，这里只有1个存储设备，就是SD卡

//设备表
#define SDCARD 0 //SD卡
#define UDISK  1 //U盘
#define CFCARD 2 //CF卡
#define OTHER  3 //其它
				 //这里的存储设备表，可以灵活扩充，以实现对更多存储设备的支持
//-------------------------------------------

#define MAKE_FILE_TIME(h,m,s)	((((unsigned int)h)<<11)+(((unsigned int)m)<<5)+(((unsigned int)s)>>1))	/* 生成指定时分秒的文件时间数据 */
#define MAKE_FILE_DATE(y,m,d)	(((((unsigned int)y)+20)<<9)+(((unsigned int)m)<<5)+((unsigned int)d))	/* 生成指定年月日的文件日期数据 */

//DPT:分区记录结构如下
struct PartRecord
{
 uint8 Active;         //0x80表示此分区有效
 uint8 StartHead;      //分区的开始磁头
 uint8 StartCylSect[2];//开始柱面与扇区
 uint8 PartType;       //分区类型
 uint8 EndHead;        //分区的结束头
 uint8 EndCylSect[2];  //结束柱面与扇区
 uint8 StartLBA[4];    //分区的第一个扇区
 uint8 Size[4];        //分区的大小 
};

//MBR:分区扇区（绝对0扇区）定义如下
struct PartSector
{
 uint8 PartCode[446]; //MBR的引导程序
 struct PartRecord Part[4];   //4个分区记录
 uint8 BootSectSig0;  //55
 uint8 BootSectSig1;  //AA
};


//FAT32中对BPB的定义如下  一共占用90个字节
struct FAT32_BPB
{
 uint8 BS_jmpBoot[3];     //跳转指令            offset: 0
 uint8 BS_OEMName[8];     //                    offset: 3
 uint8 BPB_BytesPerSec[2];//每扇区字节数        offset:11
 uint8 BPB_SecPerClus[1]; //每簇扇区数          offset:13
 uint8 BPB_RsvdSecCnt[2]; //保留扇区数目        offset:14
 uint8 BPB_NumFATs[1];    //此卷中FAT表数       offset:16
 uint8 BPB_RootEntCnt[2]; //FAT32为0            offset:17
 uint8 BPB_TotSec16[2];   //FAT32为0            offset:19
 uint8 BPB_Media[1];      //存储介质            offset:21
 uint8 BPB_FATSz16[2];    //FAT32为0            offset:22
 uint8 BPB_SecPerTrk[2];  //磁道扇区数          offset:24
 uint8 BPB_NumHeads[2];   //磁头数              offset:26
 uint8 BPB_HiddSec[4];    //FAT区前隐扇区数     offset:28
 uint8 BPB_TotSec32[4];   //该卷总扇区数        offset:32
 uint8 BPB_FATSz32[4];    //一个FAT表扇区数     offset:36
 uint8 BPB_ExtFlags[2];   //FAT32特有           offset:40
 uint8 BPB_FSVer[2];      //FAT32特有           offset:42
 uint8 BPB_RootClus[4];   //根目录簇号          offset:44
 uint8 FSInfo[2];         //保留扇区FSINFO扇区数offset:48
 uint8 BPB_BkBootSec[2];  //通常为6             offset:50
 uint8 BPB_Reserved[12];  //扩展用              offset:52
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
 uint8 deName[8];       // 文件名，不足部分以空格补充
 uint8 deExtension[3]; 	// 扩展名，不足部分以空格补充
 uint8 deAttributes;   	// 文件属性
 uint8 deLowerCase;    	// 0
 uint8 deCHundredth;   	// 世纪
 uint8 deCTime[2];     	// 创建时间
 uint8 deCDate[2];     	// 创建日期
 uint8 deADate[2];     	// 访问日期
 uint8 deHighClust[2];  // 开始簇的高字
 uint8 deMTime[2];     	// 最近的修改时间
 uint8 deMDate[2];     	// 最近的修改日期
 uint8 deLowCluster[2]; 	// 开始簇的低字
 uint8 deFileSize[4];      // 文件大小 
};

//FAT32初始化时初始参数装入如下结构体中
struct FAT32_Init_Arg
{
 uint8 DEV_No;

 uint8 BPB_Sector_No;   //BPB所在扇区号
 uint32 Total_Size;      //磁盘的总容量

 uint32 FirstDirClust;   //根目录的开始簇
 uint32  BytesPerSector;	//每个扇区的字节数
 uint32  FATsectors;      //FAT表所占扇区数
 uint32  SectorsPerClust;	 //每簇的扇区数
 uint32 FirstFATSector;	 //第一个FAT表所在扇区
 uint32 FirstDirSector;	 //第一个目录所在扇区
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
 uint8  FileName[12];       //文件名
 uint32  FileStartCluster;   //文件的开始簇

 uint32  FileCurCluster;
 uint32  FileSize;	    //文件的当前簇
 uint32  FileCurSector;	    //文件的当前扇区
 uint16   FileCurPos;         //文件在当前扇区中的位置
 uint32  FileCurOffset;	    //文件的当前偏移量
 uint32  Rec_Sec;            //文件的文件/目录项所在的扇区
 uint16   nRec;               //文件的文件/目录项所在扇区中的位置

 uint8  FileAttr;	    //文件属性				
 struct Time    FileCreateTime;	    //文件的创建时间
 struct Date    FileCreateDate;	    //文件的创建日期
 struct Time    FileMTime;          //文件的修改时间
 struct Date    FileMDate;          //文件的修改日期
 struct Date	FileADate;          //文件的访问日期

};

struct FSInfo //FAT32的文件系统信息结构
{
 uint8 Head[4];
 uint8 Resv1[480];
 uint8 Sign[4];
 uint8 Free_Cluster[4];
 uint8 Last_Cluster[4];
 uint8 Resv2[14];
 uint8 Tail[2];
};

uint8 FAT32_ReadSector(uint32 addr,uint8 *buf); //znFAT的与底层存储设备的驱动接口，读取扇区
uint8 FAT32_WriteSector(uint32 addr,uint8 *buf);//znFAT的与底层存储设备的驱动接口，写入扇区

uint32 LE2BE(uint8 *dat,uint8 len); //小端转大端

uint8 FAT32_is_MBR(); //是否存在MBR
void FAT32_Analysis_DPT(); //分析DPT结构
uint16 FAT32_Find_DBR(); //定位DBR

uint32 FAT32_Get_Total_Size(); //获取总容量
void FAT32_Init(); //文件系统初始化

uint32 Search_Last_Usable_Cluster(); //从获取FSInfo中的下一个可用空闲簇
uint32 FAT32_Get_Remain_Cap(); //获取剩余容量

void FAT32_Update_FSInfo_Free_Clu(uint32 PlusOrMinus); //更新FSInfo的空闲簇的数量
void FAT32_Update_FSInfo_Last_Clu(uint32 Last_Clu); //更新FSInfo的下一个可用空闲簇

uint32 FAT32_GetNextCluster(uint32 LastCluster); //获取下一个簇
uint32 FAT32_Enter_Dir(int8 *path); //进入目录
uint8 FAT32_Open_File(struct FileInfoStruct *pfi,int8 *filepath,uint32 item); //打开文件，支持通配
uint8 FAT32_Seek_File(struct FileInfoStruct *pfi,uint32 offset); //文件定位 
uint32 FAT32_Read_File(struct FileInfoStruct *pfi,uint32 offset,uint32 len,uint8 *pbuf); //读取文件数据
uint32 FAT32_Read_FileX(struct FileInfoStruct *pfi,uint32 offset,uint32 len,void (*pfun)(uint8)); //读取文件数据并进行数据处理
uint32 FAT32_Find_Free_Clust(unsigned char flag);	//寻找下一个可用的空闲簇
int8 FAT32_Create_Rec(struct FileInfoStruct *pfi,uint32 cluster,int8 *name,uint8 is_dir,uint8 *ptd); //构建文件/目录项
uint32 FAT32_Add_Dat(struct FileInfoStruct *pfi,uint32 len,uint8 *pbuf); //向文件追加数据
uint8 FAT32_Create_Dir(struct FileInfoStruct *pfi,int8 *dirpath,uint8 *ptd); //创建目录，支持创建时间
uint8 FAT32_Create_File(struct FileInfoStruct *pfi,int8 *filepath,uint8 *ptd); //创建文件，支持创建时间
uint8 FAT32_Del_File(int8 *filepath); //删除文件
unsigned char FAT32_XCopy_File(struct FAT32_Init_Arg *pArg1,struct FAT32_Init_Arg *pArg2,int8 *sfilename,int8 *tfilename,uint8 *file_buf,uint32 buf_size,unsigned char *pt); //文件拷贝，支持多设备中文件互拷
uint8 FAT32_File_Close(struct FileInfoStruct *pfi); //文件关闭
uint8 FAT32_Rename_File(int8 *filename,int8 *newfilename); //文件重命名
uint8 FAT32_New_File(struct FileInfoStruct *pfi,int8 *filepath,uint8 *ptd);

#endif