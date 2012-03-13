//============================================================================
// 文件名称：hw_mac.h                                                          
// 功能概要：以太网链路层驱动头文件
// 版权所有: 苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
// 版本更新: 2011-12-16     V1.0       编写了K60的以太网驱动
//============================================================================
#ifndef __MAC_H__
#define __MAC_H__
#include "common.h"
#include "hw_eth_phy.h"
//#include "intrinsics.h"
typedef struct
{
	uint16 status;	     //控制和状态     
	uint16 length;	     //发送长度   
	uint8  *data;	     //缓冲区地址      
} NBUF;



//PHY控制寄存器2相关定义
#define PHY_STATUS								    ( 0x1F )
#define PHY_DUPLEX_STATUS							( 4<<2 )
#define PHY_SPEED_STATUS							( 1<<2 )


 

//发送缓冲区描述符个数
#define enetNUM_TX_DESCRIPTORS					    ( 1 )






#define configNUM_ENET_RX_BUFFERS	8
#define configENET_BUFFER_SIZE		1520
#define configUSE_MII_MODE          0
#define configETHERNET_INPUT_TASK_STACK_SIZE ( 320 )
#define configETHERNET_INPUT_TASK_PRIORITY ( configMAX_PRIORITIES - 1 )




// ----------------------------------------------------------------------
// 发送缓冲区描述符位定义
// ----------------------------------------------------------------------
#define TX_BD_R			0x0080
#define TX_BD_TO1		0x0040
#define TX_BD_W			0x0020
#define TX_BD_TO2		0x0010
#define TX_BD_L			0x0008
#define TX_BD_TC		0x0004
#define TX_BD_ABC		0x0002

// ----------------------------------------------------------------------
// 增强型的发送缓冲区描述符位定义
// ----------------------------------------------------------------------
#define TX_BD_INT       0x00000040 
#define TX_BD_TS        0x00000020 
#define TX_BD_PINS      0x00000010 
#define TX_BD_IINS      0x00000008 
#define TX_BD_TXE       0x00800000 
#define TX_BD_UE        0x00200000 
#define TX_BD_EE        0x00100000
#define TX_BD_FE        0x00080000 
#define TX_BD_LCE       0x00040000 
#define TX_BD_OE        0x00020000 
#define TX_BD_TSE       0x00010000 

#define TX_BD_BDU       0x00000080    

// ----------------------------------------------------------------------
// 接收缓冲区描述符位定义
// ----------------------------------------------------------------------


#define RX_BD_E			0x0080
#define RX_BD_R01		0x0040
#define RX_BD_W			0x0020
#define RX_BD_R02		0x0010
#define RX_BD_L			0x0008
#define RX_BD_M			0x0001
#define RX_BD_BC		0x8000
#define RX_BD_MC		0x4000
#define RX_BD_LG		0x2000
#define RX_BD_NO		0x1000
#define RX_BD_CR		0x0400
#define RX_BD_OV		0x0200
#define RX_BD_TR		0x0100

// ----------------------------------------------------------------------
// 增强型的接收缓冲区描述符位定义
// ----------------------------------------------------------------------
#define RX_BD_ME               0x00000080    
#define RX_BD_PE               0x00000004    
#define RX_BD_CE               0x00000002    
#define RX_BD_UC               0x00000001    
#define RX_BD_INT              0x00008000    
#define RX_BD_ICE              0x20000000    
#define RX_BD_PCR              0x10000000    
#define RX_BD_VLAN             0x04000000    
#define RX_BD_IPV6             0x02000000    
#define RX_BD_FRAG             0x01000000    
#define RX_BD_BDU              0x00000080    


//内部函数声明
void prvInitialiseENETBuffers();
void enet_set_address ( const uint8 *pa);
uint32 long_reverse(uint32 ch);
uint16 shortlong_reverse(uint16 ch);
void * memcpy (void *dest, const void *src, unsigned n);



//========================================================================
//函数名称：hw_mac_init                                                         
//功能概要：初始化链路层                                              
//参数说明：ucMACAddress：MAC地址                                                                                                                                     
//函数返回：无                                           
//========================================================================  
void hw_mac_init(uint8 ucMACAddress[]);


//========================================================================
//函数名称：hw_ethernet_send                                                         
//功能概要：初始化发送接收缓冲区                                              
//参数说明：ch：发送缓冲区                
//         len:发送字节长度
//函数返回：无                                           
//========================================================================
void hw_ethernet_send( uint8 ch[], uint16 len);

//========================================================================
//函数名称：hw_ethernet_receive                                                         
//功能概要：初始化发送接收缓冲区                                              
//参数说明：无                                                                                                                                     
//函数返回：无                                           
//========================================================================
uint8 hw_ethernet_receive(uint8 ch[], uint16 * len);

#endif
