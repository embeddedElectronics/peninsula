#include "FAT32.h"
#include "hw_sdhc.h"        //存储设备的扇区读写驱动，这里是SD卡
//#include "ch375.h"	   //存储设备的扇区读写驱动，这里是U盘
//#include "cf.h"
#include "string.h"

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

//全局变量定义
struct direntry idata,temp_rec;
int8 temp_dir_name[13]; 
uint32 temp_dir_cluster;
uint32 temp_last_cluster;

uint8 FAT32_Buffer[512]; //扇区数据读写缓冲区,由外部提供

extern struct FAT32_Init_Arg *pArg; //初始化参数结构体指针，用以指向某一存储设备的初始化参数结构体，由外部提供

unsigned char (*pRS)(unsigned long,unsigned char *); //指向实际存储设备的读扇区函数的函数指针，用以实现对设备的支持
unsigned char (*pWS)(unsigned long,unsigned char *); //指向实际存储设备的写扇区函数的函数指针，用以实现对设备的支持

extern unsigned char Dev_No;

/******************************************************************
 - 功能描述：znFAT的存储设备底层驱动接口，读取存储设备的addr扇区的
             512个字节的数据放入buf数据缓冲区中
 - 隶属模块：znFAT文件系统模块
 - 函数属性：内部（用于与存储设备的底层驱动对接）
 - 参数说明：addr:扇区地址
             buf:指向数据缓冲区
 - 返回说明：0表示读取扇区成功，否则失败
 - 注：这里加入了天狼星精华板上的三种存储设备，即SD卡（有效）、U盘、
       CF卡通过在程序中动态的切换不同的设备驱动，从而实现多设备(即同
	   时对多种存储设备进行操作，比如从SD卡拷贝文件到U盘等等)，不同
	   驱动的切换，只需要在程序中改变Dev_No这个全局变量的值即可
 ******************************************************************/

uint8 FAT32_ReadSector(uint32 addr,uint8 *buf) 
{
 return((uint8)disk_read(0,buf,addr,1));  //替换成实际存储器的扇区读函数，这里是SD卡扇区读函数
}

/******************************************************************
 - 功能描述：znFAT的存储设备底层驱动接口，将buf数据缓冲区中的512个
             字节的数据写入到存储设备的addr扇区中
 - 隶属模块：znFAT文件系统模块
 - 函数属性：内部（用于与存储设备的底层驱动对接）
 - 参数说明：addr:扇区地址
             buf:指向数据缓冲区
 - 返回说明：0表示读取扇区成功，否则失败
 - 注：略
 ******************************************************************/

uint8 FAT32_WriteSector(uint32 addr,uint8 *buf)
{
 return((uint8)disk_write(0,buf,addr,1)); //替换成实际存储器的扇区写函数，这里是SD卡扇区写函数
}

/******************************************************************
 - 功能描述：小端转大端，即LittleEndian车BigEndian
 - 隶属模块：znFAT文件系统模块
 - 函数属性：内部
 - 参数说明：dat:指向要转为大端的字节序列
             len:要转为大端的字节序列长度
 - 返回说明：转为大端模式后，字节序列所表达的数据
 - 注：比如：小端模式的       0x33 0x22 0x11 0x00  (低字节在前)
             转为大端模式后为 0x00 0x11 0x22 0x33  (高字节在前)
             所表达的数值为   0x00112233
             (CISC的CPU通常是小端的，所以FAT32也设计为小端，而单片机
              这种RISC的CPU，通常来说都是大端的，所以需要这个函数将字
              节的存放次序进行调整，才能得到正确的数值)
 ******************************************************************/

uint32 LE2BE(uint8 *dat,uint8 len) 
{
 uint32 temp=0;
 uint32 fact=1;
 uint8  i=0;
 for(i=0;i<len;i++)
 {
  temp+=dat[i]*fact; //将各字节乘以相应的权值后累加
  fact*=256; //更新权值
 }
 return temp;
}

/******************************************************************
 - 功能描述：将小字字符转为大写
 - 隶属模块：znFAT文件系统模块
 - 函数属性：内部
 - 参数说明：c:要转换为大写的字符            
 - 返回说明：要转换的字节的相应的大写字符
 - 注：只对小写字符有效，如果不是a~z的小写字符，将直接返回
 ******************************************************************/

int8 L2U(int8 c)
{
 if(c>='a' && c<='z') return c+'A'-'a';         
 else return c;
}

/******************************************************************
 - 功能描述：读取0扇区，检测有没有MBR(主引导记录)
 - 隶属模块：znFAT文件系统模块
 - 函数属性：内部
 - 参数说明：无     
 - 返回说明：1表示检测到MBR，0表示没有检测到MBR
 - 注：有些存储设备格式化为FAT32以后，没有MBR，则0扇区就是DBR
       如果有MBR，就需要对其进行解析，以得到DBR的扇区位置，同时MBR中
       还含分区、分区容量等信息
 ******************************************************************/

uint8 FAT32_is_MBR()
{
 uint8 result;
 FAT32_ReadSector(0,FAT32_Buffer);
 if(FAT32_Buffer[0]!=0xeb) 
 {
  result=1;
 }
 else 
 {
  result=0;
 }
 return result;
}

/***********************************************************************
 - 功能描述：得到DBR所在的扇区号(如果没有MBR，则DBR就在0扇区)
 - 隶属模块：znFAT文件系统模块
 - 函数属性：内部
 - 参数说明：无     
 - 返回说明：DBR的扇区地址
 - 注：DBR中包含了很多有用的参数信息，因此正确定位DBR扇区的位置，是极为
       重要的，后面将有专门的函数对DBR进行解析，正确解析DBR是实现FAT32的
       基础
 ***********************************************************************/

uint16 FAT32_Find_DBR()
{
 uint16 sec_dbr;
 FAT32_ReadSector(0,FAT32_Buffer);
 if(FAT32_Buffer[0]!=0xeb) 
 {
  sec_dbr=LE2BE(((((struct PartSector *)(FAT32_Buffer))->Part[0]).StartLBA),4);
 }
 else
 {
  sec_dbr=0;
 }
 return sec_dbr;
}

/***********************************************************************
 - 功能描述：获取分区的总容量
 - 隶属模块：znFAT文件系统模块
 - 函数属性：外部，使用户使用
 - 参数说明：无     
 - 返回说明：分区容量值，单位为字节
 - 注：这里得到的总容量是FAT32分区的容量，一定小于实际的物理容量
 ***********************************************************************/

uint32 FAT32_Get_Total_Size() 
{
 uint32 temp;
 FAT32_ReadSector(pArg->BPB_Sector_No,FAT32_Buffer);
 FAT32_ReadSector(pArg->BPB_Sector_No,FAT32_Buffer);
 temp=((LE2BE((((struct FAT32_BPB *)(FAT32_Buffer))->BPB_TotSec32),4)))*pArg->BytesPerSector;
 return temp;
}

/***********************************************************************
 - 功能描述：读取FSInfo获取最近的一个可用空闲簇
 - 隶属模块：znFAT文件系统模块
 - 函数属性：内部
 - 参数说明：无     
 - 返回说明：最近的一个可用空闲簇
 - 注：FAT32中的FSInfo扇区(绝对1扇区)中记录了最近的一个可用空闲簇
 ***********************************************************************/

uint32 Search_Last_Usable_Cluster()
{
 FAT32_ReadSector(1+pArg->BPB_Sector_No,FAT32_Buffer);
 return LE2BE(((struct FSInfo *)FAT32_Buffer)->Last_Cluster,4);
}

/***********************************************************************
 - 功能描述：FAT32文件系统初始化
 - 隶属模块：znFAT文件系统模块
 - 函数属性：外部，使用户使用
 - 参数说明：FAT32_Init_Arg类型的结构体指针，用于装载一些重要的参数信息，
             以备后面使用     
 - 返回说明：无
 - 注：在使用znFAT前，这个函数是必须先被调用的，将很多参数信息装入到
       arg指向的结构体中，比如扇区大小、根目录的位置、FAT表大小等等。
       这些参数绝大部分是来自于DBR的BPB中，因此此函数主要在作对DBR的参数解析
 ***********************************************************************/

void FAT32_Init()
{
 struct FAT32_BPB *bpb;

 bpb=(struct FAT32_BPB *)(FAT32_Buffer);               //将数据缓冲区指针转为struct FAT32_BPB 型指针

 pArg->DEV_No=Dev_No; //装入设备号

 pArg->BPB_Sector_No   =FAT32_Find_DBR();               //FAT32_FindBPB()可以返回BPB所在的扇区号
 pArg->BPB_Sector_No   =FAT32_Find_DBR();               //FAT32_FindBPB()可以返回BPB所在的扇区号
 pArg->Total_Size      =FAT32_Get_Total_Size();         //FAT32_Get_Total_Size()可以返回磁盘的总容量，单位是字节

 pArg->FATsectors      =LE2BE((bpb->BPB_FATSz32)    ,4);//装入FAT表占用的扇区数到FATsectors中
 pArg->FirstDirClust   =LE2BE((bpb->BPB_RootClus)   ,4);//装入根目录簇号到FirstDirClust中
 pArg->BytesPerSector  =LE2BE((bpb->BPB_BytesPerSec),2);//装入每扇区字节数到BytesPerSector中
 pArg->SectorsPerClust =LE2BE((bpb->BPB_SecPerClus) ,1);//装入每簇扇区数到SectorsPerClust 中
 pArg->FirstFATSector  =LE2BE((bpb->BPB_RsvdSecCnt) ,2)+pArg->BPB_Sector_No;//装入第一个FAT表扇区号到FirstFATSector 中
 pArg->FirstDirSector  =(pArg->FirstFATSector)+(bpb->BPB_NumFATs[0])*(pArg->FATsectors); //装入第一个目录扇区到FirstDirSector中
 
 pArg->Total_Size      =FAT32_Get_Total_Size();         //FAT32_Get_Total_Size()可以返回磁盘的总容量，单位是兆
 
 temp_last_cluster=Search_Last_Usable_Cluster();
}

/***********************************************************************
 - 功能描述：获取剩余容量
 - 隶属模块：znFAT文件系统模块
 - 函数属性：外部，使用户使用
 - 参数说明：无    
 - 返回说明：剩余容量，单位字节
 - 注：从FSInfo中读取空闲簇数，而从计算得到剩余的容量，单位字节
 ***********************************************************************/

uint32 FAT32_Get_Remain_Cap()
{
 FAT32_ReadSector(1+pArg->BPB_Sector_No,FAT32_Buffer);
 if(((struct FSInfo *)FAT32_Buffer)->Free_Cluster[0]==0xff 
 && ((struct FSInfo *)FAT32_Buffer)->Free_Cluster[1]==0xff 
 && ((struct FSInfo *)FAT32_Buffer)->Free_Cluster[2]==0xff 
 && ((struct FSInfo *)FAT32_Buffer)->Free_Cluster[3]==0xff)
 return pArg->Total_Size;
 else
 return LE2BE(((struct FSInfo *)FAT32_Buffer)->Free_Cluster,4)*pArg->SectorsPerClust*pArg->BytesPerSector; 
}

/***********************************************************************
 - 功能描述：更新FSInfo中的可用空闲簇的数量
 - 隶属模块：znFAT文件系统模块
 - 函数属性：内部
 - 参数说明：PlusOrMinus:可用空闲簇数加1或减1    
 - 返回说明：无
 - 注：创建文件、追加数据、删除文件等操作都可能会使可用的空闲簇数变化
       要及时更新
 ***********************************************************************/

void FAT32_Update_FSInfo_Free_Clu(uint32 PlusOrMinus)
{
 uint32 Free_Clu=0;
 FAT32_ReadSector(1+pArg->BPB_Sector_No,FAT32_Buffer);

 Free_Clu=(FAT32_Get_Remain_Cap())/(pArg->SectorsPerClust*pArg->BytesPerSector);

 if(PlusOrMinus) Free_Clu++;
 else Free_Clu--;

 ((struct FSInfo *)FAT32_Buffer)->Free_Cluster[0]=((unsigned char *)&Free_Clu)[0]; 
 ((struct FSInfo *)FAT32_Buffer)->Free_Cluster[1]=((unsigned char *)&Free_Clu)[1];
 ((struct FSInfo *)FAT32_Buffer)->Free_Cluster[2]=((unsigned char *)&Free_Clu)[2];
 ((struct FSInfo *)FAT32_Buffer)->Free_Cluster[3]=((unsigned char *)&Free_Clu)[3];
 FAT32_WriteSector(1+pArg->BPB_Sector_No,FAT32_Buffer);   
}

/***********************************************************************
 - 功能描述：更新FSInfo中的下一个可用空闲簇的簇号
 - 隶属模块：znFAT文件系统模块
 - 函数属性：内部
 - 参数说明：Last_Clu:将要更新到FSInfo中的下一个可用空闲簇的簇号    
 - 返回说明：无
 - 注：FSInfo中的下一个可用空闲簇号可以给文件系统一个参考，直接告诉文件系统
       下一个可用的空闲簇在什么地方
 ***********************************************************************/

void FAT32_Update_FSInfo_Last_Clu(uint32 Last_Clu)
{
 FAT32_ReadSector(1+pArg->BPB_Sector_No,FAT32_Buffer);  
 ((struct FSInfo *)FAT32_Buffer)->Last_Cluster[0]=((unsigned char *)&Last_Clu)[0]; 
 ((struct FSInfo *)FAT32_Buffer)->Last_Cluster[1]=((unsigned char *)&Last_Clu)[1];
 ((struct FSInfo *)FAT32_Buffer)->Last_Cluster[2]=((unsigned char *)&Last_Clu)[2];
 ((struct FSInfo *)FAT32_Buffer)->Last_Cluster[3]=((unsigned char *)&Last_Clu)[3];
 FAT32_WriteSector(1+pArg->BPB_Sector_No,FAT32_Buffer);
}

/***********************************************************************
 - 功能描述：获得下一个簇的簇号
 - 隶属模块：znFAT文件系统模块
 - 函数属性：内部
 - 参数说明：LastCluster:基准簇号  
 - 返回说明：LastClutster的下一簇的簇号
 - 注：获得下一簇的簇号，就是凭借FAT表中所记录的簇链关系来实现的
 ***********************************************************************/

uint32 FAT32_GetNextCluster(uint32 LastCluster)
{
 uint32 temp;
 struct FAT32_FAT *pFAT;
 struct FAT32_FAT_Item *pFAT_Item;
 temp=((LastCluster/128)+pArg->FirstFATSector);
 FAT32_ReadSector(temp,FAT32_Buffer);
 pFAT=(struct FAT32_FAT *)FAT32_Buffer;
 pFAT_Item=&((pFAT->Items)[LastCluster%128]);
 return LE2BE((uint8 *)pFAT_Item,4);
}

/***********************************************************************
 - 功能描述：比较目录名
 - 隶属模块：znFAT文件系统模块
 - 函数属性：内部
 - 参数说明：a:指向目录名1的指针
             b:指向目录名2的指针
 - 返回说明：如果两个目录名相同就返回1，否则为0
 ***********************************************************************/

uint8 Compare_Dir_Name(int8 *a,int8 *b)
{
 uint8 i;
 for(i=0;i<8;i++)
 {
  if(a[i]!=b[i]) return 0;
 }
 return 1;
}

/***********************************************************************
 - 功能描述：文件名匹配(支持带*?通配符的文件名的匹配)
 - 隶属模块：znFAT文件系统模块
 - 函数属性：内部
 - 参数说明：pat:源文件名，可以含*或?通配符 如 *.txt 或 A?.mp3等等
             name:目标文件名
 - 返回说明：如果两个文件名匹配就返回1，否则为0
 - 注：关于通配文件名匹配，有这样的例子，比如 A*.txt 与 ABC.txt是匹配的
   同时与 ABCDE.txt也是匹配的。此功能在文件枚举中将会用到，用来匹配
   文件名符合一定条件的文件
 ***********************************************************************/

uint8 FilenameMatch(int8 *pat,int8 *name)
{
 int16 match,ndone;
 int8 *cpp,*cpn;
 cpp=pat;
 cpn=name;
 match=1;
 ndone=1;
 while(ndone)
 {
  switch (*cpp)
  {
   case '*':
            cpp++;
            cpn=strchr(cpn,*cpp);
            if(cpn==NULL)
            {
             cpn=name;
             while(*cpn) cpn++;
            }
            break;
   case '?':
            cpp++;
            cpn++;
            break;
   case 0:
            if(*cpn!=0)
            match=0;
            ndone=0;
            break;
   default:
            if((*cpp)==(*cpn))
            {
             cpp++;
             cpn++;
            }
            else
            {
             match=0;
             ndone=0;
            }
            break;
  }
 }
 return(match);
}

/***********************************************************************
 - 功能描述：FAT32的文件目录项的文件名字段(8个字节)，转为普通的文件名
             如：ABC     MP3 将转为 ABC.MP3
 - 隶属模块：znFAT文件系统模块
 - 函数属性：内部
 - 参数说明：dName：指向文件目录项的文件名字段的指针
             pName：指向转换完成后的文件名
 - 返回说明：无
 - 注：此函数配合上面的FilenameMatch函数，就可以实现对文件名通配匹配
 ***********************************************************************/

void FAT32_toFileName(char *dName,char *pName)
{
 int8 i=7,j=0,k=0;
 while(dName[i--]==' ');
 for(j=0;j<i+2;j++) pName[j]=L2U(dName[j]);
 pName[j++]='.';
 i=10;
 while(dName[i--]==' ');
 k=j+i-6;
 i=0;
 for(;j<k;j++) pName[j]=dName[8+(i++)];
 pName[j]=0; 
}

/***********************************************************************
 - 功能描述：将字符串中的小写字符都转为大写字符
 - 隶属模块：znFAT文件系统模块
 - 函数属性：内部
 - 参数说明：str：指向待转换的字符串
 - 返回说明：无
 - 注：短文件名的情况下，文件名中的字符其实都是大写字符，为了方便，将文件
       名都转为大写
 ***********************************************************************/

void Str2Up(char *str)
{
 unsigned char len=strlen(str),i;
 for(i=0;i<len;i++)
 {
  str[i]=L2U(str[i]); 
 } 
}

/**************************************************************************
 - 功能描述：进入一个目录
 - 隶属模块：znFAT文件系统模块
 - 函数属性：外部，使用户使用
 - 参数说明：path:目录的路径 形如："\\dir1\\dir2\\" ，最后一定是以\\结束 
 - 返回说明：返回目录的开始簇号，如果进入目录失败，比如目录不存在，则返回0
 - 注：此函数由后面的FAT32_Open_File等函数调用，用来实现打开任意目录下的文件
       不建议用户调用
 **************************************************************************/

uint32 FAT32_Enter_Dir(int8 *path)
{
 uint32 Cur_Clust,sec_temp,iSec,iDir,Old_Clust;
 uint8 i=1,counter=0,flag=0;
 struct direntry *pDir;
 int8 name[20];

 Cur_Clust=pArg->FirstDirClust;
 if(path[1]==0 && path[0]=='\\') return Cur_Clust;
 else
 {
  while(path[i]!=0)
  {
   if(path[i]=='\\')
   {
    for(;counter<8;counter++)
	{
	 name[counter]=' ';
	}
	name[counter]=0;
	counter=0;
	
	do
	{
	 sec_temp=(SOC(Cur_Clust));
	 for(iSec=sec_temp;iSec<sec_temp+pArg->SectorsPerClust;iSec++)
	 {
	  FAT32_ReadSector(iSec,FAT32_Buffer);
	  for(iDir=0;iDir<pArg->BytesPerSector;iDir+=sizeof(struct direntry))
      {
       pDir=((struct direntry *)(FAT32_Buffer+iDir));
	   if(Compare_Dir_Name(pDir->deName,name))
	   {
	    flag=1;
		Cur_Clust=LE2BE(pDir->deLowCluster,2)+LE2BE(pDir->deHighClust,2)*65536;
		iDir=pArg->BytesPerSector;
		iSec=sec_temp+pArg->SectorsPerClust;
	   } 
	  }
	 }
	 Old_Clust=Cur_Clust;
	}while(!flag && (Cur_Clust=FAT32_GetNextCluster(Cur_Clust))!=0x0fffffff);
	if(!flag) 
	{
	 temp_dir_cluster=Old_Clust;
	 strcpy(temp_dir_name,name);
	 flag=0;
	 return 0;
	}
	flag=0; 
   }
   else
   {
    name[counter++]=(L2U(path[i]));
   }
   i++;
  }
 }
 name[counter]=0; 
 flag=1;
 temp_dir_cluster=Cur_Clust;
 strcpy(temp_dir_name,name);
 return Cur_Clust;
}

/**************************************************************************
 - 功能描述：打开一个文件(支持文件名通配，如 A*.txt 或 *.*)
 - 隶属模块：znFAT文件系统模块
 - 函数属性：外部，使用户使用
 - 参数说明：pfi: FileInfoStruct类型的结构体指针，用来装载文件的参数信息
              比如文件的大小、文件的名称、文件的开始簇等等，以备后面使用
             filepath: 文件的路径，支持任意层目录 比如
              "\\dir1\\dir2\\dir3\\....\\test.txt"
			 item：在文件名中有通配符*或?的情况下，实现与之匹配的文件并非
			 一个，item就是打开的文件的项数，比如符合通配条件的文件有6个，
			 如果item=3，那么此函数就会打开这6个文件中按顺序排号为3的那个
			 文件(item编号从0开始)
 - 返回说明：0：成功 1：文件不存在 2：目录不存在
 - 注：打开文件不成功有很多原因，比如文件不存在、文件的某一级目录不存在
       通配情况下满足条件的文件项数小于item的值等等
	   通常情况下，文件名中没有通配符，item的值我们取0就可以了
 **************************************************************************/

uint8 FAT32_Open_File(struct FileInfoStruct *pfi,int8 *filepath,unsigned long item)
{
 uint32 Cur_Clust,sec_temp,iSec,iFile,iItem=0;
 uint8 flag=0,index=0,i=0;
 struct direntry *pFile;
 int8 temp_file_name[13];
 while(filepath[i]!=0)
 {
  if(filepath[i]=='\\') index=i;
  i++;
 }

 if(Cur_Clust=FAT32_Enter_Dir(filepath))
 {
  Str2Up(temp_dir_name);
 do
 { 
  sec_temp=SOC(Cur_Clust);
  for(iSec=sec_temp;iSec<sec_temp+pArg->SectorsPerClust;iSec++)
  {	
   FAT32_ReadSector(iSec,FAT32_Buffer);
   for(iFile=0;iFile<pArg->BytesPerSector;iFile+=sizeof(struct direntry))
   {
    pFile=((struct direntry *)(FAT32_Buffer+iFile));
	FAT32_toFileName(pFile->deName,temp_file_name);
	if(FilenameMatch(temp_dir_name,temp_file_name) && pFile->deName[0]!=0xe5 && pFile->deAttributes&0x20) //匹配文件名
	{
	 if(item==iItem)
	 {	 
	 flag=1;
     Cur_Clust=LE2BE(pFile->deLowCluster,2)+LE2BE(pFile->deHighClust,2)*65536;

     pfi->FileSize=LE2BE(pFile->deFileSize,4);
	 strcpy(pfi->FileName,temp_file_name);
	 pfi->FileStartCluster=LE2BE(pFile->deLowCluster,2)+LE2BE(pFile->deHighClust,2)*65536;
	 pfi->FileCurCluster=pfi->FileStartCluster;
	 pfi->FileCurSector=SOC(pfi->FileStartCluster);
	 pfi->FileCurPos=0;
	 pfi->FileCurOffset=0;
	 pfi->Rec_Sec=iSec;
	 pfi->nRec=iFile;

	 pfi->FileAttr=pFile->deAttributes;
	 sec_temp=LE2BE(pFile->deCTime,2);
	 (pfi->FileCreateTime).sec=(sec_temp&0x001f)*2;
	 (pfi->FileCreateTime).min=((sec_temp>>5)&0x003f);
	 (pfi->FileCreateTime).hour=((sec_temp>>11)&0x001f);
	 sec_temp=LE2BE(pFile->deCDate,2);
	 (pfi->FileCreateDate).day=((sec_temp)&0x001f);
	 (pfi->FileCreateDate).month=((sec_temp>>5)&0x000f);
	 (pfi->FileCreateDate).year=((sec_temp>>9)&0x007f)+1980;

	 sec_temp=LE2BE(pFile->deMTime,2);
	 (pfi->FileMTime).sec=(sec_temp&0x001f)*2;
	 (pfi->FileMTime).min=((sec_temp>>5)&0x003f);
	 (pfi->FileMTime).hour=((sec_temp>>11)&0x001f);
	 sec_temp=LE2BE(pFile->deMDate,2);
	 (pfi->FileMDate).day=((sec_temp)&0x001f);
	 (pfi->FileMDate).month=((sec_temp>>5)&0x000f);
	 (pfi->FileMDate).year=((sec_temp>>9)&0x007f)+1980;

	 sec_temp=LE2BE(pFile->deADate,2);
	 (pfi->FileADate).day=((sec_temp)&0x001f);
	 (pfi->FileADate).month=((sec_temp>>5)&0x000f);
	 (pfi->FileADate).year=((sec_temp>>9)&0x007f)+1980;
	    
	 iFile=pArg->BytesPerSector;
	 iSec=sec_temp+pArg->SectorsPerClust;
	 }
	 else
	 {
	  iItem++;
	 }
	} 
   }
  }
 }while(!flag && (Cur_Clust=FAT32_GetNextCluster(Cur_Clust))!=0x0fffffff);
 if(!flag) 
 {
  return 1;
 }
 return 0;
 }
 else
 {
  return 2; 
 }
}

/**************************************************************************
 - 功能描述：文件定位
 - 隶属模块：znFAT文件系统模块
 - 函数属性：外部，使用户使用
 - 参数说明：pfi:FileInfoStruct类型的结构体指针，用于装载文件参数信息，文件
             定位后，pfi所指向的结构体中的相关参数就被更新了，比如文件的当前
             扇区，文件当前扇区中的位置，文件的当前偏移量等等，以备后面使用
             offset:要定位的偏移量，如果offset大于文件的大小，则定位到文件的
             末尾
 - 返回说明：文件定位成功返回0，否则为1
 - 注：此函数被下面的FAT32_Read_File调用，用于实现从指定位置读取数据，不建议
       用户直接调用些函数
 **************************************************************************/

uint8 FAT32_Seek_File(struct FileInfoStruct *pfi,uint32 offset)
{
 uint32 i,temp;

if(offset<=pfi->FileSize)
{ 
 if(offset==pfi->FileCurOffset)
 {
  pfi->FileCurPos%=pArg->BytesPerSector;
  return 1;  
 }
 if(offset<pfi->FileCurOffset) 
 {
  pfi->FileCurCluster=pfi->FileStartCluster;
  pfi->FileCurSector=SOC(pfi->FileCurCluster);
  pfi->FileCurPos=0;
  pfi->FileCurOffset=0;
 } 
 if((offset-pfi->FileCurOffset)>=(pArg->BytesPerSector-pfi->FileCurPos))	 //目标偏移量与文件当前偏移量所差的字节数不小于文件在当前扇区中的位置到扇区末尾的字节数
 {
  pfi->FileCurOffset+=(pArg->BytesPerSector-pfi->FileCurPos);
  pfi->FileCurPos=0;
  if(pfi->FileCurSector-SOC(pfi->FileCurCluster)==(pArg->SectorsPerClust-1))
  {
   pfi->FileCurCluster=FAT32_GetNextCluster(pfi->FileCurCluster);
   pfi->FileCurSector=SOC(pfi->FileCurCluster);
  }
  else
  {
   pfi->FileCurSector++; 
  }
 }
 else
 {
  pfi->FileCurPos=(pfi->FileCurPos+offset-pfi->FileCurOffset)%pArg->BytesPerSector;
  pfi->FileCurOffset=offset;
  return 1;
 }
 temp=SOC(pfi->FileCurCluster);
 if((offset-(pfi->FileCurOffset))/pArg->BytesPerSector+(pfi->FileCurSector-temp)>(pArg->SectorsPerClust-1))
 {
  pfi->FileCurOffset+=(((pArg->SectorsPerClust)-(pfi->FileCurSector-(SOC(pfi->FileCurCluster))))*pArg->BytesPerSector);
  pfi->FileCurCluster=FAT32_GetNextCluster(pfi->FileCurCluster);
  pfi->FileCurSector=SOC(pfi->FileCurCluster);
  pfi->FileCurPos=0;
 }
 else
 {
  pfi->FileCurSector+=(offset-pfi->FileCurOffset)/pArg->BytesPerSector;
  pfi->FileCurPos=(offset-pfi->FileCurOffset)%pArg->BytesPerSector;
  pfi->FileCurOffset=offset;
  return 1;
 }

 temp=(offset-pfi->FileCurOffset)/(pArg->BytesPerSector*pArg->SectorsPerClust);
 for(i=0;i<temp;i++)
 {
  pfi->FileCurCluster=FAT32_GetNextCluster(pfi->FileCurCluster);
 }
 pfi->FileCurOffset+=(temp*(pArg->BytesPerSector*pArg->SectorsPerClust));
 pfi->FileCurSector=(SOC(pfi->FileCurCluster))+(offset-pfi->FileCurOffset)/pArg->BytesPerSector;
 pfi->FileCurPos=((offset-pfi->FileCurOffset))%pArg->BytesPerSector;
 pfi->FileCurOffset=offset;
}
else
{
 return 1;
}
 return 0;
}

/**************************************************************************
 - 功能描述：从文件的某一个位置处，读取一定长度的数据，放入数据缓冲区中
 - 隶属模块：znFAT文件系统模块
 - 函数属性：外部，使用户使用
 - 参数说明：pfi:FileInfoStruct类型的结构体指针，用于装载文件参数信息，文件
             读取的过程中，此结构体中的相关参数会更新，比如文件的当前偏移量、
             文件的当前扇区，文件的当前簇等等
             offset:要定位的偏移量，要小于文件的大小 
             len:要读取的数据的长度，如果len+offset大于文件的大小，则实际读
             取的数据量是从offset开始到文件结束
             pbuf:数据缓冲区
 - 返回说明：读取到的实际的数据长度，如果读取失败，比如指定的偏移量大于了文件
             大小，则返回0
 - 注：在读取一个文件的数据前，必须先将该文件用FAT32_Open_File打开
 **************************************************************************/

uint32 FAT32_Read_File(struct FileInfoStruct *pfi,uint32 offset,uint32 len,uint8 *pbuf)
{
 uint32 i,j,k,temp;
 uint32 counter=0;
 if(offset<pfi->FileSize)
 {
  if(offset+len>pfi->FileSize) len=pfi->FileSize-offset;
  FAT32_Seek_File(pfi,offset);
  
  FAT32_ReadSector(pfi->FileCurSector,FAT32_Buffer);
  for(i=pfi->FileCurPos;i<pArg->BytesPerSector;i++)
  {
   if(counter>=len) 
   {
     return len;
   }
   pbuf[counter]=FAT32_Buffer[i];
   counter++;
   pfi->FileCurPos++;
   pfi->FileCurOffset++;
  }
  if(pfi->FileCurSector-(SOC(pfi->FileCurCluster))!=(pArg->SectorsPerClust-1))
  {
   for(j=pfi->FileCurSector+1;j<(SOC(pfi->FileCurCluster))+pArg->SectorsPerClust;j++)
   {
    FAT32_ReadSector(j,FAT32_Buffer);
    pfi->FileCurSector=j;
    for(i=0;i<pArg->BytesPerSector;i++)
    {
     if(counter>=len)
     {
       return len;
     }
     pbuf[counter]=FAT32_Buffer[i];
     counter++;
     pfi->FileCurPos++;
     pfi->FileCurOffset++;
    }
   }
  } 
  temp=(len-counter)/(pArg->BytesPerSector*pArg->SectorsPerClust);
  for(k=0;k<temp;k++)
  {
   pfi->FileCurCluster=FAT32_GetNextCluster(pfi->FileCurCluster);
   for(j=(SOC(pfi->FileCurCluster));j<(SOC(pfi->FileCurCluster))+pArg->SectorsPerClust;j++)
   {
    FAT32_ReadSector(j,FAT32_Buffer);
    pfi->FileCurSector=j;
    for(i=0;i<pArg->BytesPerSector;i++)
    {
     if(counter>=len)  
 	 {
       return len;
     }
     pbuf[counter]=FAT32_Buffer[i];
     counter++;
     pfi->FileCurOffset++;
	 pfi->FileCurPos++;
	 pfi->FileCurPos%=pArg->BytesPerSector;
    } 
   }    
  }
  pfi->FileCurCluster=FAT32_GetNextCluster(pfi->FileCurCluster);
  temp=(SOC(pfi->FileCurCluster))+((len-counter)/pArg->BytesPerSector);
  pfi->FileCurSector=(SOC(pfi->FileCurCluster));
  for(j=(SOC(pfi->FileCurCluster));j<temp;j++)
  {
   FAT32_ReadSector(j,FAT32_Buffer);
   pfi->FileCurSector=j;
   for(i=0;i<pArg->BytesPerSector;i++)
   {
    if(counter>=len) 
    {
      return len;
    }
    pbuf[counter]=FAT32_Buffer[i];
    counter++;
    pfi->FileCurPos++;
    pfi->FileCurPos%=pArg->BytesPerSector;
    pfi->FileCurOffset++;
   }   
  }
  pfi->FileCurSector=j;
  FAT32_ReadSector(pfi->FileCurSector,FAT32_Buffer);
  temp=len-counter;
  for(i=0;i<temp;i++)
  {
   if(counter>=len) 
   {
     return len;
   }
   pbuf[counter]=FAT32_Buffer[i];
   counter++;
   pfi->FileCurPos++;
   pfi->FileCurPos%=pArg->BytesPerSector;
   pfi->FileCurOffset++;  
  }
 }
 else
 {
  len=0;
 }
 return len;
}

/**************************************************************************
 - 功能描述：从文件某一位置读取一定长度的数据，由pfun所指向的函数来处理
 - 隶属模块：znFAT文件系统模块
 - 函数属性：外部，使用户使用
 - 参数说明：pfi:FileInfoStruct类型的结构体指针，用于装载文件参数信息，文件
             读取的过程中，此结构体中的相关参数会更新，比如文件的当前偏移量、
             文件的当前扇区，文件的当前簇等等
             offset:要定位的偏移量，要小于文件的大小 
             len:要读取的数据的长度，如果len+offset大于文件的大小，则实际读
             取的数据量是从offset开始到文件结束
             pfun:对读取的数据的处理函数，pfun指向处理函数，这样可以灵活的
             配置数据如何去处理，比如是放在缓冲区中，还是把数据通过串口发送
             出去，只需要pfun去指向相应的处理函数可以了
 - 返回说明：读取到的实际的数据长度，如果读取失败，比如指定的偏移量大于了文件
             大小，则返回0
 - 注：在读取一个文件的数据前，必须先将该文件用FAT32_Open_File打开
 **************************************************************************/
/*
uint32 FAT32_Read_FileX(struct FileInfoStruct *pfi,uint32 offset,uint32 len,void (*pfun)(uint8))
{
 uint32 i,j,k,temp;
 uint32 counter=0;
 if(offset<pfi->FileSize)
 {
  if(offset+len>pfi->FileSize) len=pfi->FileSize-offset;
  FAT32_Seek_File(pfi,offset);
  
  FAT32_ReadSector(pfi->FileCurSector,FAT32_Buffer);
  for(i=pfi->FileCurPos;i<pArg->BytesPerSector;i++)
  {
   if(counter>=len) 
   {
     return len;
   }
   (*pfun)(FAT32_Buffer[i]);
   counter++;
   pfi->FileCurPos++;
   pfi->FileCurOffset++;
  }
  if(pfi->FileCurSector-(SOC(pfi->FileCurCluster))!=(pArg->SectorsPerClust-1))
  {
   for(j=pfi->FileCurSector+1;j<(SOC(pfi->FileCurCluster))+pArg->SectorsPerClust;j++)
   {
    FAT32_ReadSector(j,FAT32_Buffer);
    pfi->FileCurSector=j;
    for(i=0;i<pArg->BytesPerSector;i++)
    {
     if(counter>=len)
     {
       return len;
     }
     (*pfun)(FAT32_Buffer[i]);
     counter++;
     pfi->FileCurPos++;
     pfi->FileCurOffset++;
    }
   }
  } 
  temp=(len-counter)/(pArg->BytesPerSector*pArg->SectorsPerClust);
  for(k=0;k<temp;k++)
  {
   pfi->FileCurCluster=FAT32_GetNextCluster(pfi->FileCurCluster);
   for(j=(SOC(pfi->FileCurCluster));j<(SOC(pfi->FileCurCluster))+pArg->SectorsPerClust;j++)
   {
    FAT32_ReadSector(j,FAT32_Buffer);
    pfi->FileCurSector=j;
    for(i=0;i<pArg->BytesPerSector;i++)
    {
     if(counter>=len)  
 	 {
       return len;
     }
     (*pfun)(FAT32_Buffer[i]);
     counter++;
     pfi->FileCurOffset++;
	 pfi->FileCurPos++;
	 pfi->FileCurPos%=pArg->BytesPerSector;
    } 
   }    
  }
  pfi->FileCurCluster=FAT32_GetNextCluster(pfi->FileCurCluster);
  temp=(SOC(pfi->FileCurCluster))+((len-counter)/pArg->BytesPerSector);
  pfi->FileCurSector=(SOC(pfi->FileCurCluster));
  for(j=(SOC(pfi->FileCurCluster));j<temp;j++)
  {
   FAT32_ReadSector(j,FAT32_Buffer);
   pfi->FileCurSector=j;
   for(i=0;i<pArg->BytesPerSector;i++)
   {
    if(counter>=len) 
    {
      return len;
    }
    (*pfun)(FAT32_Buffer[i]);
    counter++;
    pfi->FileCurPos++;
    pfi->FileCurPos%=pArg->BytesPerSector;
    pfi->FileCurOffset++;
   }   
  }
  pfi->FileCurSector=j;
  FAT32_ReadSector(pfi->FileCurSector,FAT32_Buffer);
  temp=len-counter;
  for(i=0;i<temp;i++)
  {
   if(counter>=len) 
   {
     return len;
   }
   (*pfun)(FAT32_Buffer[i]);
   counter++;
   pfi->FileCurPos++;
   pfi->FileCurPos%=pArg->BytesPerSector;
   pfi->FileCurOffset++;  
  }
 }
 else
 {
  len=0;
 }
 return len;
}
*/
/**************************************************************************
 - 功能描述：寻找可用的空闲簇
 - 隶属模块：znFAT文件系统模块
 - 函数属性：内部
 - 参数说明：无
 - 返回说明：如果找到了空闲簇，返回空闲簇的簇号，否则返回0
 - 注：寻找空闲簇是创建目录/文件以及向文件写入数据的基础，它如果能很快的寻
       找到空闲簇，那么创建目录/文件以及向文件写入数据这些操作也会比较快。
       所以我们绝不会从最开始的簇依次去寻找，而是使用了二分搜索的算法，以达
       到较好的效果。如果空闲簇没有找到，很有可能就说明存储设备已经没有空间
       了
 **************************************************************************/

uint32 FAT32_Find_Free_Clust(unsigned char flag)
{
 uint32 iClu,iSec;
 struct FAT32_FAT *pFAT;
 for(iSec=pArg->FirstFATSector+temp_last_cluster/128;iSec<pArg->FirstFATSector+pArg->FATsectors;iSec++)
 {
  FAT32_ReadSector(iSec,FAT32_Buffer);
  pFAT=(struct FAT32_FAT *)FAT32_Buffer;
  for(iClu=0;iClu<pArg->BytesPerSector/4;iClu++)
  {
   if(LE2BE((uint8 *)(&((pFAT->Items))[iClu]),4)==0)
   {
    if(!flag)
	{
	 FAT32_Update_FSInfo_Free_Clu(0);
	 temp_last_cluster=128*(iSec-pArg->FirstFATSector)+iClu;	   
     return temp_last_cluster;
	}
	else
	{
	 FAT32_Update_FSInfo_Last_Clu(128*(iSec-pArg->FirstFATSector)+iClu);
	 return 128*(iSec-pArg->FirstFATSector)+iClu;
	}
   }
  }
 }
 return 0;
}

/**************************************************************************
 - 功能描述：填充文件/目录项
 - 隶属模块：znFAT文件系统模块
 - 函数属性：内部
 - 参数说明：prec:指向一个direntry类型的结构体，它的结构就是FAT32中文件/
             目录项的结构
             name:文件或目录的名称
             is_dir:指示这个文件/目录项是文件还是目录，分别用来实现文件、
             目录的创建 1表示创建目录 0表示创建文件
 - 返回说明：无
 - 注：这里创建文件或目录的方法是，先将文件或目录的信息填充到一个结构体中，
       然后再将这个结构体的数据写入到存储设备的相应的扇区的相应位置上去，这
       样就完成了文件或目录的创建。
       在填充文件或目录的信息时，文件或目录的首簇并没有填进去，而是全0
 **************************************************************************/

void Fill_Rec_Inf(struct direntry *prec,int8 *name,uint8 is_dir,uint8 *ptd)
{
 uint8 i=0,len=0;
 uint16 temp;

 if(is_dir)
 {
  len=strlen(name);
  if(len>8)
  {
   for(i=0;i<6;i++)
   {
    (prec->deName)[i]=L2U(name[i]);
   }
   (prec->deName)[6]='~';
   (prec->deName)[7]='1';
  }
  else
  {
   for(i=0;i<len;i++)
   {
    (prec->deName)[i]=L2U(name[i]);
   }
   for(;i<8;i++)
   {
    (prec->deName)[i]=' ';
   }
  }
  for(i=0;i<3;i++)
  {
   (prec->deExtension)[i]=' ';
  }
 }
 else
 {
  while(name[len]!='.' && name[len]!=0) len++;
  if(len>8)
  {
   for(i=0;i<6;i++)
   {
    (prec->deName)[i]=L2U(name[i]);
   }
   (prec->deName)[6]='~';
   (prec->deName)[7]='1';
  }
  else
  {
   for(i=0;i<len;i++)
   {
    (prec->deName)[i]=L2U(name[i]);
   }
   for(;i<8;i++)
   {
    (prec->deName)[i]=' ';
   }
  }
  if(name[len]==0)
  {
   for(i=0;i<3;i++)
   {
    (prec->deExtension)[i]=' ';
   }
  }
  else
  {
   for(i=0;i<3;i++)
   {
    (prec->deExtension)[i]=' ';
   }
   len++;
   i=0;
   while(name[len]!=0)
   {
    (prec->deExtension)[i++]=L2U(name[len]);
	len++;
   }
  }
 }
 if(is_dir)
  (prec->deAttributes)=0x10;
 else
  (prec->deAttributes)=0x20;
 
 temp=MAKE_FILE_TIME(ptd[3],ptd[4],ptd[5]);
 (prec->deCTime)[0]=temp;
 (prec->deCTime)[1]=temp>>8;
 temp=MAKE_FILE_DATE(ptd[0],ptd[1],ptd[2]);
 (prec->deCDate)[0]=temp;
 (prec->deCDate)[1]=temp>>8;

 (prec->deLowerCase)=0;
 (prec->deHighClust)[0]=0;
 (prec->deHighClust)[1]=0;
 (prec->deLowCluster)[0]=0;
 (prec->deLowCluster)[1]=0;
 for(i=0;i<4;i++)
 {
  (prec->deFileSize)[i]=0;
 }				
}

/**************************************************************************
 - 功能描述：更新FAT表
 - 隶属模块：znFAT文件系统模块
 - 函数属性：内部
 - 参数说明：cluster:要更新的簇项号
             dat:要将相应的簇项更新为dat
 - 返回说明：无
 - 注：在向文件写入了数据后，需要对FAT表进行更表，以表明新数据的簇链关系 
       删除文件的时候，也需要将该文件的簇项进行清除，销毁文件的簇链关系
 **************************************************************************/

void FAT32_Modify_FAT(uint32 cluster,uint32 dat)
{
 FAT32_ReadSector(pArg->FirstFATSector+(cluster*4/pArg->BytesPerSector),FAT32_Buffer);
 FAT32_Buffer[((cluster*4)%pArg->BytesPerSector)+0]=dat&0x000000ff;
 FAT32_Buffer[((cluster*4)%pArg->BytesPerSector)+1]=(dat&0x0000ff00)>>8;
 FAT32_Buffer[((cluster*4)%pArg->BytesPerSector)+2]=(dat&0x00ff0000)>>16;
 FAT32_Buffer[((cluster*4)%pArg->BytesPerSector)+3]=(dat&0xff000000)>>24;
 FAT32_WriteSector(pArg->FirstFATSector+(cluster*4/pArg->BytesPerSector),FAT32_Buffer);

 FAT32_ReadSector(pArg->FirstFATSector+pArg->FATsectors+(cluster*4/pArg->BytesPerSector),FAT32_Buffer);
 FAT32_Buffer[((cluster*4)%pArg->BytesPerSector)+0]=dat&0x000000ff;
 FAT32_Buffer[((cluster*4)%pArg->BytesPerSector)+1]=(dat&0x0000ff00)>>8;
 FAT32_Buffer[((cluster*4)%pArg->BytesPerSector)+2]=(dat&0x00ff0000)>>16;
 FAT32_Buffer[((cluster*4)%pArg->BytesPerSector)+3]=(dat&0xff000000)>>24;
 FAT32_WriteSector(pArg->FirstFATSector+pArg->FATsectors+(cluster*4/pArg->BytesPerSector),FAT32_Buffer); 
}

/**************************************************************************
 - 功能描述：清空某个簇的所有扇区，填充0
 - 隶属模块：znFAT文件系统模块
 - 函数属性：内部
 - 参数说明：cluster:要清空的簇的簇号
 - 返回说明：无
 **************************************************************************/

void FAT32_Empty_Cluster(uint32 Cluster)
{
 uint32 iSec;
 uint16 i;
 for(i=0;i<pArg->BytesPerSector;i++)
 {
  FAT32_Buffer[i]=0;
 }
 for(iSec=SOC(Cluster);iSec<SOC(Cluster)+pArg->SectorsPerClust;iSec++)
 {
  FAT32_WriteSector(iSec,FAT32_Buffer);
 }
}

/**************************************************************************
 - 功能描述：在存储设备中创建一个文件/目录项
 - 隶属模块：znFAT文件系统模块
 - 函数属性：内部
 - 参数说明：pfi:指向FileInfoStruct类型的结构体，用于装载刚创建的文件的信息
                 也就是说，如果创建的是目录，则此结构体不会被更新
             cluster:在cluster这个簇中创建文件/目录项，用于实现在任意目录下
                 创建文件或目录，可以通过FAT32_Enter_Dir来获取某一个目录的开
                 始簇
             name:文件/目录的名称
             is_dir:指示要创建的是文件还是目录，文件与目录的创建方法是不同的
                 1表示创建目录 0表示创建文件
 - 返回说明：成功返回1，失败返回-1
 **************************************************************************/

int8 FAT32_Create_Rec(struct FileInfoStruct *pfi,uint32 cluster,int8 *name,uint8 is_dir,uint8 *ptd)
{
 uint32 iSec,iRec,temp_sec,temp_clu,new_clu,i,old_clu;
 uint8 flag=0;
 uint16 temp_Rec;
 struct direntry *pRec;
 Fill_Rec_Inf(&temp_rec,name,is_dir,ptd);
 do
 {
  old_clu=cluster;
  temp_sec=SOC(cluster);
  for(iSec=temp_sec;iSec<temp_sec+pArg->SectorsPerClust;iSec++)
  {
   FAT32_ReadSector(iSec,FAT32_Buffer);
   for(iRec=0;iRec<pArg->BytesPerSector;iRec+=sizeof(struct direntry))
   {
    pRec=(struct direntry *)(FAT32_Buffer+iRec);
	if((pRec->deName)[0]==0)
	{
	 flag=1;
	 if(is_dir)
	 {
	  if(!(new_clu=FAT32_Find_Free_Clust(0))) return -1;
	  FAT32_Modify_FAT(new_clu,0x0fffffff);
	  (temp_rec.deHighClust)[0]=(new_clu&0x00ff0000)>>16;
      (temp_rec.deHighClust)[1]=(new_clu&0xff000000)>>24;
      (temp_rec.deLowCluster)[0]=(new_clu&0x000000ff);
      (temp_rec.deLowCluster)[1]=(new_clu&0x0000ff00)>>8;
	 }
	 FAT32_ReadSector(iSec,FAT32_Buffer);
	 for(i=0;i<sizeof(struct direntry);i++)
	 {
	  ((uint8 *)pRec)[i]=((uint8 *)(&temp_rec))[i];
	 }
	 FAT32_WriteSector(iSec,FAT32_Buffer);
	 temp_sec=iSec;
	 temp_Rec=iRec;
	 iRec=pArg->BytesPerSector;
	 iSec=temp_sec+pArg->SectorsPerClust;
	}
   }
  }
 }while(!flag && (cluster=FAT32_GetNextCluster(cluster))!=0x0fffffff);
 if(!flag)
 {
  if(!(temp_clu=FAT32_Find_Free_Clust(0))) return -1;
  FAT32_Modify_FAT(temp_clu,0x0fffffff);
  FAT32_Modify_FAT(old_clu,temp_clu);
  temp_sec=SOC(temp_clu);
  temp_Rec=0;
  FAT32_ReadSector(temp_sec,FAT32_Buffer);
  if(is_dir)
  {
   if(!(new_clu=FAT32_Find_Free_Clust(0))) return -1;
   FAT32_Modify_FAT(new_clu,0x0fffffff);
   FAT32_ReadSector(temp_sec,FAT32_Buffer);
   (temp_rec.deHighClust)[0]=(new_clu&0x00ff0000)>>16;
   (temp_rec.deHighClust)[1]=(new_clu&0xff000000)>>24;
   (temp_rec.deLowCluster)[0]=(new_clu&0x000000ff);
   (temp_rec.deLowCluster)[1]=(new_clu&0x0000ff00)>>8;
  }
  for(i=0;i<sizeof(struct direntry);i++)
  {
   FAT32_Buffer[i]=((uint8 *)(&temp_rec))[i]; 
  }
  FAT32_WriteSector(temp_sec,FAT32_Buffer);
 }
 if(is_dir)
 {
  FAT32_Empty_Cluster(new_clu);

  Fill_Rec_Inf(&temp_rec,".",1,ptd);
  (temp_rec.deHighClust)[0]=(new_clu&0x00ff0000)>>16;
  (temp_rec.deHighClust)[1]=(new_clu&0xff000000)>>24;
  (temp_rec.deLowCluster)[0]=(new_clu&0x000000ff);
  (temp_rec.deLowCluster)[1]=(new_clu&0x0000ff00)>>8;
  for(i=0;i<sizeof(struct direntry);i++)
  {
   FAT32_Buffer[i]=((uint8 *)(&temp_rec))[i]; 
  }
  Fill_Rec_Inf(&temp_rec,"..",1,ptd);
  if(cluster==pArg->FirstDirClust)
  {
   (temp_rec.deHighClust)[0]=0;
   (temp_rec.deHighClust)[1]=0;
   (temp_rec.deLowCluster)[0]=0;
   (temp_rec.deLowCluster)[1]=0;
  }
  else
  {
   (temp_rec.deHighClust)[0]=(cluster&0x00ff0000)>>16;
   (temp_rec.deHighClust)[1]=(cluster&0xff000000)>>24;
   (temp_rec.deLowCluster)[0]=(cluster&0x000000ff);
   (temp_rec.deLowCluster)[1]=(cluster&0x0000ff00)>>8;
  }
    
  for(i=sizeof(struct direntry);i<2*sizeof(struct direntry);i++)
  {
   FAT32_Buffer[i]=((uint8 *)(&temp_rec))[i-sizeof(struct direntry)]; 
  }
  for(;i<pArg->BytesPerSector;i++)
  {
   FAT32_Buffer[i]=0;
  }		
  temp_sec=SOC(new_clu);
  FAT32_WriteSector(temp_sec,FAT32_Buffer);
 }
 else
 {
  strcpy(pfi->FileName,name);
  pfi->FileStartCluster=0;
  pfi->FileCurCluster=0;
  pfi->FileSize=0;
  pfi->FileCurSector=0;
  pfi->FileCurPos=0;
  pfi->FileCurOffset=0;
  pfi->Rec_Sec=temp_sec;
  pfi->nRec=temp_Rec;

  pfi->FileAttr=temp_rec.deAttributes;
 }
 FAT32_Find_Free_Clust(1);
 return 1;
}

/**************************************************************************
 - 功能描述：向某一个文件追加数据
 - 隶属模块：znFAT文件系统模块
 - 函数属性：外部，使用户使用
 - 参数说明：pfi:指向FileInfoStruct类型的结构体，用于装载刚创建的文件的信息
             len:要追加的数据长度
             pbuf:指向数据缓冲区的指针
 - 返回说明：成功返回实际写入的数据长度，失败返回0
 - 注：追加数据失败很有可能是存储设备已经没有空间了，也就是找不到空闲簇了
 **************************************************************************/

uint32 FAT32_Add_Dat(struct FileInfoStruct *pfi,uint32 len,uint8 *pbuf)
{
 uint32 i=0,counter=0,iSec,iClu;
 uint32 temp_sub,temp_file_size,new_clu,temp_sec;
 struct direntry *prec;
 if(len>0)
 {
  FAT32_ReadSector(pfi->Rec_Sec,FAT32_Buffer);
  prec=(struct direntry *)(FAT32_Buffer+pfi->nRec);
  temp_file_size=LE2BE((prec->deFileSize),4);
  if(!temp_file_size)
  {   
   if(!(new_clu=FAT32_Find_Free_Clust(0))) return 0;
   FAT32_Modify_FAT(new_clu,0x0fffffff);
   pfi->FileStartCluster=new_clu;
   pfi->FileCurCluster=pfi->FileStartCluster;
   pfi->FileSize=0;
   pfi->FileCurSector=SOC(pfi->FileCurCluster);
   pfi->FileCurPos=0;
   pfi->FileCurOffset=0;
   FAT32_ReadSector(pfi->Rec_Sec,FAT32_Buffer);
   (prec->deHighClust)[0]=(new_clu&0x00ff0000)>>16;
   (prec->deHighClust)[1]=(new_clu&0xff000000)>>24;
   (prec->deLowCluster)[0]=(new_clu&0x000000ff);
   (prec->deLowCluster)[1]=(new_clu&0x0000ff00)>>8;
   FAT32_WriteSector(pfi->Rec_Sec,FAT32_Buffer);
  }
  else
  {
   if(!(temp_file_size%(pArg->SectorsPerClust*pArg->BytesPerSector))) //在簇的最末尾临界地方，需要寻找新簇
   {
    FAT32_Seek_File(pfi,pfi->FileSize-1);
    if(!(new_clu=FAT32_Find_Free_Clust(0))) return 0;
	FAT32_Modify_FAT(pfi->FileCurCluster,new_clu);
    FAT32_Modify_FAT(new_clu,0x0fffffff);     
   }
   FAT32_Seek_File(pfi,pfi->FileSize);
  }

  iSec=pfi->FileCurSector;

  FAT32_ReadSector(iSec,FAT32_Buffer);
  for(i=pfi->FileCurPos;i<pArg->BytesPerSector;i++)
  {
   FAT32_Buffer[i]=pbuf[counter];
   counter++;
   if(counter>=len) 
   {
    iSec=pfi->FileCurSector;
    goto end;
   }
  }
  FAT32_WriteSector(pfi->FileCurSector,FAT32_Buffer); //数据接缝  
  
  if(pfi->FileCurSector-(SOC(pfi->FileCurCluster))<(pArg->SectorsPerClust-1)) //判断是不是一个簇的最后一个扇区,先将当前簇所有扇区填满 
  {
   for(iSec=pfi->FileCurSector+1;iSec<=(SOC(pfi->FileCurCluster)+pArg->SectorsPerClust-1);iSec++)
   {
    for(i=0;i<pArg->BytesPerSector;i++)
    {
	 FAT32_Buffer[i]=pbuf[counter];
	 counter++;
     if(counter>=len) 
	 {
	  goto end;
	 }
    }
    FAT32_WriteSector(iSec,FAT32_Buffer);
   }
  }
  
  temp_sub=len-counter;
  for(iClu=0;iClu<temp_sub/(pArg->SectorsPerClust*pArg->BytesPerSector);iClu++)
  {
   if(!(new_clu=FAT32_Find_Free_Clust(0))) return 0;
   FAT32_Modify_FAT(pfi->FileCurCluster,new_clu);
   FAT32_Modify_FAT(new_clu,0x0fffffff);
   pfi->FileCurCluster=new_clu;

   temp_sec=SOC(new_clu);
   for(iSec=temp_sec;iSec<temp_sec+pArg->SectorsPerClust;iSec++)
   {
    for(i=0;i<pArg->BytesPerSector;i++)
	{
   	 FAT32_Buffer[i]=pbuf[counter];
	 counter++;
	} 
	FAT32_WriteSector(iSec,FAT32_Buffer);
   }
  }

  temp_sub=len-counter;
  if(temp_sub)
  {
   if(!(new_clu=FAT32_Find_Free_Clust(0))) return 0;
   FAT32_Modify_FAT(pfi->FileCurCluster,new_clu);
   FAT32_Modify_FAT(new_clu,0x0fffffff);
   pfi->FileCurCluster=new_clu;
   temp_sec=SOC(new_clu);
   for(iSec=temp_sec;iSec<temp_sec+temp_sub/pArg->BytesPerSector;iSec++)
   {
    for(i=0;i<pArg->BytesPerSector;i++)
	{
   	 FAT32_Buffer[i]=pbuf[counter];
	 counter++;
	} 
	FAT32_WriteSector(iSec,FAT32_Buffer);    
   }   
  }

  temp_sub=len-counter;
  if(temp_sub)
  {
   for(i=0;i<pArg->BytesPerSector;i++)
   {
   	FAT32_Buffer[i]=pbuf[counter];
	counter++;
   } 
   FAT32_WriteSector(iSec,FAT32_Buffer);   
  }
end:
  FAT32_WriteSector(iSec,FAT32_Buffer);
  FAT32_ReadSector(pfi->Rec_Sec,FAT32_Buffer);
  (((struct direntry *)(FAT32_Buffer+pfi->nRec))->deFileSize)[0]=((temp_file_size+len)&0x000000ff);
  (((struct direntry *)(FAT32_Buffer+pfi->nRec))->deFileSize)[1]=((temp_file_size+len)&0x0000ff00)>>8;
  (((struct direntry *)(FAT32_Buffer+pfi->nRec))->deFileSize)[2]=((temp_file_size+len)&0x00ff0000)>>16;
  (((struct direntry *)(FAT32_Buffer+pfi->nRec))->deFileSize)[3]=((temp_file_size+len)&0xff000000)>>24;
  FAT32_WriteSector(pfi->Rec_Sec,FAT32_Buffer);

  pfi->FileSize=(temp_file_size+len);
  pfi->FileCurSector=(pfi->FileSize%pArg->BytesPerSector)?iSec:iSec+1;
  pfi->FileCurPos=pfi->FileSize%pArg->BytesPerSector;
  pfi->FileCurOffset=pfi->FileSize;
 }
 FAT32_Find_Free_Clust(1);
 return len;
}

/**************************************************************************
 - 功能描述：创建目录(支持任意层目录创建)
 - 隶属模块：znFAT文件系统模块
 - 函数属性：外部，使用户使用
 - 参数说明：pfi:无用
             dirpath:目录路径 比如 "\\dir1\\dir2\\dir3\\....\\dirn\\"
             最后必须是\\结束
 - 返回说明：成功返回0，失败返回1
 - 注：如果中间某一级目录不存在，比如上面的这个路径中dir3不存在，那么此函数会
       创建这个目录，然后再继续去创建更深层的目录
       创建目录失败有可能是因为存储设备空间不足
 **************************************************************************/

uint8 FAT32_Create_Dir(struct FileInfoStruct *pfi,int8 *dirpath,uint8 *ptd)
{
 while(!FAT32_Enter_Dir(dirpath))
 {
  if(FAT32_Create_Rec(pfi,temp_dir_cluster,temp_dir_name,1,ptd)==-1)
  {
   return 1;
  }
 }
 return 0;
}

/**************************************************************************
 - 功能描述：创建文件(支持任意层目录创建)
 - 隶属模块：znFAT文件系统模块
 - 函数属性：外部，使用户使用
 - 参数说明：pfi:一个指向FileInfoStruct类型的结构体的指针，用来装载新创建的
             文件信息，因此新创建的文件不用再打开就可以直接来操作
             filepath:文件路径 比如 "\\dir1\\dir2\\dir3\\....\\dirn\\test.txt"
 - 返回说明：0：成功 1：文件已存在 2：创建文件目录失败 3：创建文件失败
 - 注：如果文件路径中某一个中间目录不存在，那么此函数会创建这个目录，再继续
       去创建更深层的目录，一直到最后把文件创建完成。
       创建文件失败有可能是因为存储设备空间不足，或是此文件已经存在
 **************************************************************************/

uint8 FAT32_Create_File(struct FileInfoStruct *pfi,int8 *filepath,uint8 *ptd)
{
 if(FAT32_Open_File(pfi,filepath,0))
 {
  if(!FAT32_Create_Dir(pfi,filepath,ptd))
  {
   if(FAT32_Create_Rec(pfi,temp_dir_cluster,temp_dir_name,0,ptd)==-1)
   {
    return 3;
   }    
  }
  else
  {
   return 2;   
  }
 }
 else
 {
  return 1;
 }
 return 0;
}

/**************************************************************************
 - 功能描述：删除文件(支持任意层目录)
 - 隶属模块：znFAT文件系统模块
 - 函数属性：外部，使用户使用
 - 参数说明：filepath:文件路径 比如 "\\dir1\\dir2\\dir3\\....\\dirn\\test.txt"
 - 返回说明：1:文件或目录路径不存在 0:成功
 - 注：删除后的文件的FAT表中的簇链关系完全被破坏
 **************************************************************************/

uint8 FAT32_Del_File(int8 *filepath)
{
 uint32 cur_clu,next_clu;
 struct FileInfoStruct fi;
 
 if(FAT32_Open_File(&fi,filepath,0))
 {
  return 1;
 }
 FAT32_ReadSector(fi.Rec_Sec,FAT32_Buffer);
 *(FAT32_Buffer+fi.nRec)=0xe5;
 FAT32_WriteSector(fi.Rec_Sec,FAT32_Buffer);
 
 if(cur_clu=fi.FileStartCluster)
 {
  if(cur_clu<Search_Last_Usable_Cluster()) 
   FAT32_Update_FSInfo_Last_Clu(cur_clu);
  FAT32_Update_FSInfo_Free_Clu(1);
  next_clu=FAT32_GetNextCluster(cur_clu);
  while(next_clu!=0x0fffffff)
  {
   FAT32_Update_FSInfo_Free_Clu(1);
   FAT32_Modify_FAT(cur_clu,0x00000000);
   cur_clu=next_clu;
   next_clu=FAT32_GetNextCluster(cur_clu);
  }
  FAT32_Modify_FAT(cur_clu,0x00000000);
 }
 return 0;
}

/**************************************************************************
 - 功能描述：文件拷贝(源文件路径与目标文件路径均支持任意深层目录，并且支持
             文件名通配)
 - 隶属模块：znFAT文件系统模块
 - 函数属性：外部，使用户使用
 - 参数说明：pArg1:是源文件所在的存储设备的初始参数结构体的指针
             pArg2:是目标文件所在的存储设备的初始参数结构体的指针
             sfilename:源文件路径，也就是拷贝操作的数据源
             tfilename:目标文件路径，也就是数据最终到写入的文件
                       比如 "\\dir1\\dir2\\dir3\\....\\dirn\\test.txt" 
             file_buf:拷贝过程中要用到的数据缓冲区，此缓冲区容量越大，
                      拷贝速度越快
             buf_size:数据缓冲区的大小 
 - 返回说明：1:目录文件创建失败 2:源文件打开打败 0:成功
 - 注：此函数支持多设备之间的文件拷贝，pArg1与pArg2引入了源存储设备与目的
       存储设备的初始参数信息，从而可以同时对两个存储设备进行操作。
	   znFAT 5.01版开始支持多设备，多设备间的相互数据拷贝是最典型的应用
 **************************************************************************/

unsigned char FAT32_XCopy_File(struct FAT32_Init_Arg *pArg1,struct FAT32_Init_Arg *pArg2,int8 *sfilename,int8 *tfilename,uint8 *file_buf,uint32 buf_size,unsigned char *pt)
{
 struct FileInfoStruct FileInfo2,FileInfo1;
 uint32 i;

 Dev_No=pArg2->DEV_No;
 pArg=pArg2;
 if(FAT32_Create_File(&FileInfo1,tfilename,pt)) return 1;
 Dev_No=pArg1->DEV_No;
 pArg=pArg1;
 if(FAT32_Open_File(&FileInfo2,sfilename,0)) return 2;

 for(i=0;i<FileInfo2.FileSize/buf_size;i++)
 {
  Dev_No=pArg1->DEV_No;
  pArg=pArg1;
  FAT32_Read_File(&FileInfo2,i*buf_size,buf_size,file_buf);
  Dev_No=pArg2->DEV_No;
  pArg=pArg2;
  FAT32_Add_Dat(&FileInfo1,buf_size,file_buf);
 }

 Dev_No=pArg1->DEV_No;
 pArg=pArg1; 
 FAT32_Read_File(&FileInfo2,i*buf_size,FileInfo2.FileSize%buf_size,file_buf);
 Dev_No=pArg2->DEV_No;
 pArg=pArg2;
 FAT32_Add_Dat(&FileInfo1,FileInfo2.FileSize%buf_size,file_buf);

 return 0;
}

/**************************************************************************
 - 功能描述：文件重命名
 - 隶属模块：znFAT文件系统模块
 - 函数属性：外部，使用户使用
 - 参数说明：filename:将要重命名的源文件的路径 如\a.txt
             newfilename:目标文件名 如b.txt (注目标文件名是单纯的文件名，
			 不含路径)
 - 返回说明：1:源文件打开打败 0:成功
 - 注：无
 **************************************************************************/

uint8 FAT32_Rename_File(int8 *filename,int8 *newfilename)
{
 struct FileInfoStruct fi;
 uint8 i=0,j=0;
 if(FAT32_Open_File(&fi,filename,0)) return 1; //文件打开失败
 FAT32_ReadSector(fi.Rec_Sec,FAT32_Buffer);
 for(i=0;i<11;i++) (FAT32_Buffer+fi.nRec)[i]=0x20;
 i=0;
 while(newfilename[i]!='.')
 {
  (FAT32_Buffer+fi.nRec)[i]=L2U(newfilename[i]);
  i++;
 }
 i++;
 while(newfilename[i])
 {
  (FAT32_Buffer+fi.nRec+8)[j]=L2U(newfilename[i]);
  i++;j++;
 }
 FAT32_WriteSector(fi.Rec_Sec,FAT32_Buffer);
 return 0;
}

/**************************************************************************
 - 功能描述：文件关闭
 - 隶属模块：znFAT文件系统模块
 - 函数属性：外部，使用户使用
 - 参数说明：pfi:指向当前打开的文件的文件信息结构
 - 返回说明：0:成功
 - 注：无
 **************************************************************************/

uint8 FAT32_File_Close(struct FileInfoStruct *pfi)
{
 uint16 i=0;							
 for(i=0;i<sizeof(struct FileInfoStruct);i++)
 {
  ((uint8 *)pfi)[i]=0;
 }
 return 0;
}
/**************************************************************************
 - 功能描述：文件新建
 - 隶属模块：FAT文件系统模块
 - 函数属性：外部，使用户使用
 - 参数说明：pfi:一个指向FileInfoStruct类型的结构体的指针，用来装载新创建的
             文件信息，因此新创建的文件不用再打开就可以直接来操作
             filepath:文件路径 比如 "\\dir1\\dir2\\dir3\\....\\dirn\\test.txt"
 - 返回说明：0：成功 1：文件已存在,重新创建 2：创建文件目录失败 3：创建文件失败
 - 注：无
 **************************************************************************/
 uint8 FAT32_New_File(struct FileInfoStruct *pfi,int8 *filepath,uint8 *ptd){
  uint8 result;
  result=FAT32_Create_File(pfi,filepath,ptd);
  if(result!=0){
    
    if(result==1){
      
      FAT32_Del_File(filepath);
      FAT32_Create_File(pfi,filepath,ptd);
      return 1;
    }
    else
      return result;
  }else
    return 0;
 }