//============================================================================
//文件名称：can.h
//功能概要：K60 CAN底层驱动程序头文件
//版权所有：苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
//版本更新：2011-12-1  V1.0   初始版本
//============================================================================

#ifndef __CAN_H__
#define __CAN_H__

//包含头文件
#include "common.h"

//宏定义

//报文缓冲IRQ号
#define CAN0_Message_buffer_irq_no 29
#define CAN1_Message_buffer_irq_no 37

//CAN通道号
#define CAN0 0
#define CAN1 1

//接收MBs索引定义
#define	FLEXCAN_RX_MB_START	8 //接收MB的开始 
#define	FLEXCAN_RX_MB_END	9 //接收MB的结尾

//发送MBs索引定义
#define FLEXCAN_TX_MB_START	10 //(FLEXCAN_RX_MB_END+1)
#define	FLEXCAN_TX_MB_END	(NUMBER_OF_MB-1)

#define swap_4bytes(ptr)	{ uint8_t	byte; \
								byte = (ptr)[0]; (ptr)[0] = (ptr)[3]; (ptr)[3]=byte; \
								byte = (ptr)[1]; (ptr)[1] = (ptr)[2]; (ptr)[2]=byte; \
							}

#define FLEXCAN_CTRL2_RFFN             (0x0F000000L)
#define FLEXCAN_CTRL2_RFFN_BIT_NO      (24)

#define FLEXCAN_set_rffn(ctrl2,rffn)	ctrl2 = ((ctrl2) & ~FLEXCAN_CTRL2_RFFN) | ((rffn & 0xF)<<FLEXCAN_CTRL2_RFFN_BIT_NO)

#define NUMBER_OF_MB 16

//CAN报文结构位定义
#define	CAN_MSG_IDE_MASK	(0x80000000L)
#define CAN_MSG_IDE_BIT_NO	(31)
#define CAN_MSG_ID_EXTENDED	(CAN_MSG_ID_MASK)
#define CAN_MSG_ID_STANDARD	(0)
#define CAN_MSG_TYPE_MASK 	(0x40000000L)
#define CAN_MSG_TYPE_BIT_NO	(30)
#define CAN_MSG_TYPE_DATA_FRAME	(CAN_MSG_TYPE_MASK)
#define CAN_MSG_TYPE_REMOTE_FRAME	(0)

//FELEX_MB_CS的位定义和宏
#define FLEXCAN_MB_CS_TIMESTAMP(x)    (((x)&0x0000FFFF)<<0)
#define FLEXCAN_MB_CS_TIMESTAMP_MASK  (0x0000FFFFL)
#define FLEXCAN_MB_CS_LENGTH(x)       (((x)&0x0000000F)<<16)
#define FLEXCAN_MB_CS_RTR             (0x00100000)
#define FLEXCAN_MB_CS_IDE             (0x00200000)
#define FLEXCAN_MB_CS_SRR             (0x00400000)
#define FLEXCAN_MB_CS_CODE(x)         (((x)&0x0000000F)<<24)
#define FLEXCAN_MB_CS_CODE_MASK	      (0x0F000000L)
#define FLEXCAN_MB_CS_DLC_MASK	      (0x000F0000L)
#define FLEXCAN_MB_CODE_RX_INACTIVE	(0)
#define FLEXCAN_MB_CODE_RX_EMPTY	(4)
#define FLEXCAN_MB_CODE_RX_FULL		(2)
#define FLEXCAN_MB_CODE_RX_OVERRUN	(6)
#define FLEXCAN_MB_CODE_RX_BUSY		(1)

#define FLEXCAN_MB_CS_IDE_BIT_NO        (21)
#define FLEXCAN_MB_CS_RTR_BIT_NO        (20)
#define FLEXCAN_MB_CS_DLC_BIT_NO        (16)

#define FLEXCAN_MB_CODE_TX_INACTIVE	        (8)
#define FLEXCAN_MB_CODE_TX_ABORT		    (9)
#define FLEXCAN_MB_CODE_TX_ONCE			    (0x0C)
#define FLEXCAN_MB_CODE_TX_RESPONSE		    (0x0A)
#define FLEXCAN_MB_CODE_TX_RESPONSE_TEMPO	(0x0E)
#define FLEXCAN_get_code(cs)				(((cs) & FLEXCAN_MB_CS_CODE_MASK)>>24)
#define FLEXCAN_get_length(cs)              (((cs) & FLEXCAN_MB_CS_DLC_MASK)>>16)


//FLEXCAN_MB_ID的位定义和宏
#define FLEXCAN_MB_ID_STD_MASK		   (0x1FFC0000L)
#define FLEXCAN_MB_ID_EXT_MASK		   (0x1FFFFFFFL)
#define FLEXCAN_MB_ID_IDEXT(x)        (((x)&0x0003FFFF)<<0)
#define FLEXCAN_MB_ID_IDSTD(x)        (((x)&0x000007FF)<<18)
#define FLEXCAN_MB_ID_PRIO(x)         (((x)&0x00000007)<<29)
#define FLEXCAN_MB_ID_PRIO_BIT_NO	  (29)
#define FLEXCAN_MB_ID_STD_BIT_NO	  (18)
#define FLEXCAN_MB_ID_EXT_BIT_NO	  (0)

//FLEXCAN_MB_WORD0的位定义和宏
#define FLEXCAN_MB_WORD0_DATA3(x)     (((x)&0x000000FF)<<0)
#define FLEXCAN_MB_WORD0_DATA2(x)     (((x)&0x000000FF)<<8)
#define FLEXCAN_MB_WORD0_DATA1(x)     (((x)&0x000000FF)<<16)
#define FLEXCAN_MB_WORD0_DATA0(x)     (((x)&0x000000FF)<<24)

//FLEXCAN_MB_WORD1的位定义和宏
#define FLEXCAN_MB_WORD1_DATA7(x)     (((x)&0x000000FF)<<0)
#define FLEXCAN_MB_WORD1_DATA6(x)     (((x)&0x000000FF)<<8)
#define FLEXCAN_MB_WORD1_DATA5(x)     (((x)&0x000000FF)<<16)
#define FLEXCAN_MB_WORD1_DATA4(x)     (((x)&0x000000FF)<<24)



//============================================================================
//函数名称：CANInit
//函数返回：0：成功；1：失败
//参数说明：
//          CANChannel：模块号
//		   baudrateKHz: 波特率
//            selfLoop: 模式选择(1=回环模式；0=正常模式)
//              idMask: ID过滤(1=ID过滤；0=ID不过滤)
//功能概要：CAN初始化
//============================================================================
uint8 CANInit(uint8 CANChannel,uint32 baudrateKHz,uint8 selfLoop,uint8 idMask);

//============================================================================
//函数名称：CANSendData
//函数返回：0：成功，1：失败
//参数说明：CANChannel：模块号         
//                iMB：缓冲区号
//			       id: ID号
//			   length：数据长度
//			   Data[8]:发送数据缓冲区
//功能概要：发送数据
//============================================================================
uint8 CANSendData(uint8 CANChannel,uint16 iMB, uint32 id,uint8 length,uint8 Data[]);

//============================================================================
//函数名称：CANRecData
//函数返回：0：成功，1：失败
//参数说明：CANChannel：CAN模块号
//                iMB：缓冲区号
//			       id:ID号
//			   lenght：数据长度
//			  Data[8]:和接收数据缓冲区
//功能概要：接收数据
//============================================================================
uint8 CANRecData(uint8 CANChannel,uint16 iMB, uint32 *id,uint8 *Datalenght,uint8 Data[]);

//============================================================================
//函数名称：CANEnableRXBuff
//函数返回：无
//参数说明： CANChannel：模块号
//                 iMB：缓冲区号
//                  id：id号
//          CANChannel:CAN模块号
//功能概要：使能接收缓冲区
//============================================================================
void CANEnableRXBuff(uint8 CANChannel,uint16 iMB, uint32 id);

//============================================================================
//函数名称：EnableCANInterrupt
//函数返回：无
//参数说明：iMB:缓冲区号
//          CANChannel:CAN模块号
//功能概要：使能缓冲区接收和发送中断
//============================================================================
void EnableCANInterrupt(uint8 CANChannel,uint16 iMB);

//============================================================================
//函数名称：DisableCANInterrupt
//函数返回：无
//参数说明：iMB:缓冲区号
//         CANChannel:CAN模块号
//功能概要：禁止缓冲区接收和发送中断
//============================================================================
void DisableCANInterrupt(uint8 CANChannel,uint16 iMB);

//============================================================================
//函数名称：CANGetFlag
//函数返回：无
//参数说明：iMB:缓冲区号
//功能概要：获得缓冲区中断标志
//============================================================================
uint32 CANGetFlag(uint8 channel,uint16 iMB);
//============================================================================
//函数名称：CANClearFlag
//函数返回：无
//参数说明：iMB:缓冲区号
//功能概要：清缓冲区中断标志
//============================================================================
void CANClearFlag(uint8 channel,uint16 iMB);

#endif 
