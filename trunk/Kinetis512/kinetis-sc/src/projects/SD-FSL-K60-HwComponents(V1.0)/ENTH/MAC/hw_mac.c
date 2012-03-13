//============================================================================
// 文件名称：hw_mac.c                                                          
// 功能概要：以太网链路层驱动文件
// 版权所有: 苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
// 版本更新: 2011-12-16     V1.0       编写了K60的以太网驱动
//============================================================================
#include "hw_mac.h"
extern int periph_clk_khz;



//发送描述符缓冲区数组
static uint8 xENETTxDescriptors_unaligned[ ( enetNUM_TX_DESCRIPTORS * sizeof( NBUF ) ) + 16 ];
//接收描述符缓冲区数组
static uint8 xENETRxDescriptors_unaligned[ ( configNUM_ENET_RX_BUFFERS * sizeof( NBUF ) ) + 16 ];
//发送缓冲区描述符首地址
static NBUF *pxENETTxDescriptor;
//接收缓冲区描述符首地址
static NBUF *xENETRxDescriptors;
//接受缓冲区数组                                             
static uint8 ucENETRxBuffers[ ( configNUM_ENET_RX_BUFFERS * configENET_BUFFER_SIZE ) + 16 ];
static uint32 uxNextRxBuffer = 0;


//========================================================================
//函数名称：hw_mac_init                                                         
//功能概要：初始化链路层                                              
//参数说明：ucMACAddress：MAC地址                                                                                                                                     
//函数返回：无                                           
//========================================================================  
void hw_mac_init(uint8 ucMACAddress[])
{
    uint16 usData;
    //初始化缓冲区
    prvInitialiseENETBuffers();   
   
    //查询物理层自动协商的结果，根据自动协商的结果配置链路层
    usData = 0;
    mii_read(PHY_ADDRESS, PHY_STATUS, &usData );
   
    //清除单独和组地址哈希寄存器
    ENET_IALR = 0;
    ENET_IAUR = 0;
    ENET_GALR = 0xFFFFFFFF;
    ENET_GAUR = 0xFFFFFFFF;
    
    //设置MAC地址
    enet_set_address(ucMACAddress);                          
    ENET_RCR = ENET_RCR_MAX_FL(configENET_BUFFER_SIZE) //最大帧长
                              | ENET_RCR_MII_MODE_MASK //必须置1
                              | ENET_RCR_CRCFWD_MASK   //接受时取出CRC校验码
                              | ENET_RCR_RMII_MODE_MASK;//RMII模式使能   
    //清除发送寄存器
    ENET_TCR = 0;  
    //设置半双工，全双工
    if( usData & PHY_DUPLEX_STATUS )
    {
          //全双工
          ENET_RCR &= (uint16)~ENET_RCR_DRT_MASK;
          ENET_TCR |= ENET_TCR_FDEN_MASK;
    }
    else
    {
          //半双工
          ENET_RCR |= ENET_RCR_DRT_MASK;
          ENET_TCR &= (uint16)~ENET_TCR_FDEN_MASK;
    }
    //设置速度（默认100M）
    if( usData & PHY_SPEED_STATUS )
    {
          //10M
          ENET_RCR |= ENET_RCR_RMII_10T_MASK;
    }
    ENET_ECR = 0;//使用非增强型缓冲区描述符

    
    //设置接受缓冲区大小
    ENET_MRBR = (uint16) configENET_BUFFER_SIZE;      
    //接受描述符激活寄存器只想第一个接受缓冲区
    ENET_RDSR = (uint32) &( xENETRxDescriptors[ 0 ] );
    //接发送描述符激活寄存器只想第一个发送缓冲区
    ENET_TDSR = (uint32) pxENETTxDescriptor;
    //清除所有以太网中断标志
    ENET_EIR = (uint32) -1;
    
    //使能中断
    ENET_EIMR = ENET_EIR_TXF_MASK | 
                  ENET_EIMR_RXF_MASK
                | ENET_EIMR_RXB_MASK
                | ENET_EIMR_UN_MASK
                | ENET_EIMR_RL_MASK
                | ENET_EIMR_LC_MASK 
                | ENET_EIMR_BABT_MASK
                | ENET_EIMR_BABR_MASK
                | ENET_EIMR_EBERR_MASK;
    //使能以太网模块
    ENET_ECR |= ENET_ECR_ETHEREN_MASK;
    //只是有空的接受缓冲区生成
    ENET_RDAR = ENET_RDAR_RDAR_MASK;
}


//========================================================================
//函数名称：hw_ethernet_send                                                         
//功能概要：初始化发送接收缓冲区                                              
//参数说明：ch：发送缓冲区                
//         len:发送字节长度
//函数返回：无                                           
//========================================================================
void hw_ethernet_send( uint8 ch[], uint16 len)
{
    //查询可以用的缓冲区
    while( pxENETTxDescriptor->status & TX_BD_R )
    {
    }
    //缓冲区描述符地址字段赋值
    pxENETTxDescriptor->data = (uint8 *)long_reverse((uint32_t)ch);		
    //缓冲区描述符长度字段赋值
    pxENETTxDescriptor->length = shortlong_reverse(len);
    //发送缓冲区只有一个
    pxENETTxDescriptor->status = ( TX_BD_R | TX_BD_L | TX_BD_TC | TX_BD_W );
    //使能发送缓冲区描述符激活寄存器
    ENET_TDAR = ENET_TDAR_TDAR_MASK;
}

//========================================================================
//函数名称：hw_ethernet_receive                                                         
//功能概要：初始化发送接收缓冲区                                              
//参数说明：无                                                                                                                                     
//函数返回：无                                           
//========================================================================
uint8 hw_ethernet_receive(uint8 ch[], uint16 * len)
{	
	uint8 * RxdataAd = NULL;
	* len = 0UL;
	uxNextRxBuffer = 0; 
	while( (xENETRxDescriptors[ uxNextRxBuffer ].status & RX_BD_E)!=0 )
	{
		uxNextRxBuffer++; 
		if( uxNextRxBuffer >= configNUM_ENET_RX_BUFFERS )
		{
			uxNextRxBuffer = 0; 
			return 1;
		} 
	
	}
	* len  =  shortlong_reverse(xENETRxDescriptors[ uxNextRxBuffer ].length);
	RxdataAd =  (uint8 *)long_reverse((uint32_t)xENETRxDescriptors[ uxNextRxBuffer ].data);      
	memcpy((void *) ch,(void *)RxdataAd,* len);      
	//请缓冲区接收标志
	xENETRxDescriptors[ uxNextRxBuffer ].status |= RX_BD_E;
	ENET_RDAR = ENET_RDAR_RDAR_MASK;	
	return 0;
}








//========================================================================
//===============================内部函数=================================
//========================================================================


//========================================================================
//函数名称：prvInitialiseENETBuffers                                                         
//功能概要：初始化发送接收缓冲区                                              
//参数说明：无                                                                                                                                     
//函数返回：无                                           
//========================================================================
static void prvInitialiseENETBuffers( void )
{
	uint32 ux;
	uint8 *pcBufPointer;
    //设置指向第一个发送描述符缓冲区数组的指针
	pcBufPointer = &( xENETTxDescriptors_unaligned[ 0 ] );
    //找到第一个与16字节对齐发送缓冲区的地址
	while( ( ( uint32 ) pcBufPointer & 0x0fUL ) != 0 )
	{
		pcBufPointer++;
	}
	//发送缓冲缓冲区描述符指针指向第一个发送缓冲缓冲区描述符
	pxENETTxDescriptor = ( NBUF * ) pcBufPointer;	
	//设置指向第一个发送描述符缓冲区数组的指针
	pcBufPointer = &( xENETRxDescriptors_unaligned[ 0 ] );
	while( ( ( uint32 ) pcBufPointer & 0x0fUL ) != 0 )
	{
		pcBufPointer++;
	}
	//接收缓冲缓冲区描述符指针指向第一个接收缓冲缓冲区描述符
	xENETRxDescriptors = ( NBUF * ) pcBufPointer;
	pxENETTxDescriptor->length = 0;
	pxENETTxDescriptor->status = 0;
	
	pcBufPointer = &( ucENETRxBuffers[ 0 ] );
	//找到第一个与16字节对齐接收缓冲区的地址
	while( ( ( uint32 ) pcBufPointer & 0x0fUL ) != 0 )
	{
		pcBufPointer++;
	}
	//填充接收描述符
	for( ux = 0; ux < configNUM_ENET_RX_BUFFERS; ux++ )
	{
	    xENETRxDescriptors[ ux ].status = RX_BD_E;
	    xENETRxDescriptors[ ux ].length = 0;
	    xENETRxDescriptors[ ux ].data = (uint8 *)long_reverse((uint32_t)pcBufPointer);
	    pcBufPointer += configENET_BUFFER_SIZE;
  
	}
	//设置环结束标志
	xENETRxDescriptors[ configNUM_ENET_RX_BUFFERS - 1 ].status |= RX_BD_W;

}



//========================================================================
//函数名称：enet_hash_address                                                         
//功能概要：为给定的地址生成哈希表                                                
//参数说明：addr：MAC地址                                                                                                                                      
//函数返回：操作成功返回0，失败返回1                                            
//========================================================================
uint8 enet_hash_address(const uint8* addr)
{
	uint32_t crc;
	uint8 byte;
	int i, j;
	
	crc = 0xFFFFFFFF;
	for(i=0; i<6; ++i)
	{
		byte = addr[i];
	for(j=0; j<8; ++j)
	{
		if((byte & 0x01)^(crc & 0x01))
	{
		crc >>= 1;
		crc = crc ^ 0xEDB88320;
	}
	else
		crc >>= 1;
		byte >>= 1;
	}
	}
	return (uint8)(crc >> 26);
}


//========================================================================
//函数名称：enet_set_address                                                         
//功能概要：为给定的地址生成哈希表                                                
//参数说明：pa：MAC地址                                                                                                                                      
//函数返回：无                                            
//========================================================================
void enet_set_address ( const uint8 *pa)
{
    uint8 crc;
    //设置物理地址
    ENET_PALR = (uint32_t)((pa[0]<<24) | (pa[1]<<16) | (pa[2]<<8) | pa[3]);
    ENET_PAUR = (uint32_t)((pa[4]<<24) | (pa[5]<<16));
    //在个体地址哈希寄存器中用给定的物理地址计算和设置哈希表
    crc = enet_hash_address(pa);
    if(crc >= 32)
        ENET_IAUR |= (uint32_t)(1 << (crc - 32));
    else
        ENET_IALR |= (uint32_t)(1 << crc);
}

//========================================================================
//函数名称：long_reverse                                                         
//功能概要：长整型大小端互换                                                
//参数说明：ch：要转换的32位数                                                                                                                                     
//函数返回：转换的结果                                            
//========================================================================
uint32 long_reverse(uint32 ch)
{
	uint32 res;
	res = ((((uint32)(ch) & 0xff000000) >> 24) | (((uint32)(ch) & 0x00ff0000) >> 8) | \

          (((uint32)(ch) & 0x0000ff00) << 8) | (((uint32)(ch) & 0x000000ff) << 24));
          
    return res;
}

//========================================================================
//函数名称：long_reverse                                                         
//功能概要：短整型大小端互换                                                
//参数说明：ch：要转换的32位数                                                                                                                                     
//函数返回：转换的结果                                            
//========================================================================
uint16 shortlong_reverse(uint16 ch)
{
	uint16 res;
	res = ((((uint16)(ch) & 0xff00) >> 8) | (((uint16)(ch) & 0x00ff) << 8));
	return res;
}


//========================================================================
//函数名称：memcpy                                                         
//功能概要：从地址src复制n个数据到地址dest处开始的n单元中                                                
//参数说明： dest :源数据所在首地址       
//          src  :目的地址
//函数返回：转换的结果                                            
//========================================================================
void * memcpy (void *dest, const void *src, unsigned n)
{
    uint8 *dbp = (uint8 *)dest;
    uint8 *sbp = (uint8 *)src;

    if ((dest != NULL) && (src != NULL) && (n > 0))
    {
      while (n--)
            *dbp++ = *sbp++;
    }
    return dest;
}

