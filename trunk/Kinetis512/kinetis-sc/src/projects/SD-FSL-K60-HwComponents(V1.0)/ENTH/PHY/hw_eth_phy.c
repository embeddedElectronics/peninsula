

//包含头文件
#include "hw_eth_phy.h"


//内部函数声明
void mii_init(uint16 sys_clk_mhz);
int mii_write(uint16 phy_addr, uint16 reg_addr, uint16 data);
int mii_read(uint16 phy_addr, uint16 reg_addr, uint16 *data);
void Delay(uint32 time);

//引用系统总线时钟


//========================================================================
//函数名称：hw_phy_init                                                         
//功能概要：初始化EPHY模块                                                
//参数说明：sys_clk_mhz:系统时钟频率 (MHz)                                                                                                 
//函数返回：操作成功返回0，失败返回1                                            
//========================================================================
uint8  hw_phy_init(uint16 sys_clk_mhz)
{
	uint16 usData;	
	uint32 timeout; 
	uint16 settings = 0;
	//使能以太网时钟
	SIM_SCGC2 |= SIM_SCGC2_ENET_MASK;
	//禁止MPU
	MPU_CESR = 0;         
	//复位以太网模块，清除使能位
	ENET_ECR = ENET_ECR_RESET_MASK;
	//等待8个时钟周期，等待复位完成
	for( usData = 0; usData < 10; usData++ )
	{
		asm( "NOP" );
	}  
	//初始化MII接口
	mii_init(sys_clk_mhz/1000);       
	//使能中断
	set_irq_priority (76, 6);
	enable_irq(76);//发送中断
	set_irq_priority (77, 6);
	enable_irq(77);//接收中断
	/*set_irq_priority (78, 6);
	enable_irq(78);//错误中断 */       
        
	//使能外部接口信号
	PORTB_PCR0  = PORT_PCR_MUX(4);//GPIO;//RMII0_MDIO/MII0_MDIO
	PORTB_PCR1  = PORT_PCR_MUX(4);//GPIO;//RMII0_MDC/MII0_MDC		
	PORTA_PCR14 = PORT_PCR_MUX(4);//RMII0_CRS_DV/MII0_RXDV
	//PORTA_PCR5  = PORT_PCR_MUX(4);//RMII0_RXER/MII0_RXER
	PORTA_PCR12 = PORT_PCR_MUX(4);//RMII0_RXD1/MII0_RXD1
	PORTA_PCR13 = PORT_PCR_MUX(4);//RMII0_RXD0/MII0_RXD0
	PORTA_PCR15 = PORT_PCR_MUX(4);//RMII0_TXEN/MII0_TXEN
	PORTA_PCR16 = PORT_PCR_MUX(4);//RMII0_TXD0/MII0_TXD0
	PORTA_PCR17 = PORT_PCR_MUX(4);//RMII0_TXD1/MII0_TXD1

	//等待物理层收发器准备就绪
	do
	{
		Delay( enetLINK_DELAY );
		usData = 0xffff;
		mii_read( PHY_ADDRESS, PHY_PHYIDR1, &usData );
        
	} while( usData == 0xffff );
	//开始自动协商                                                                                                                PHY复位              PHY自动协商使能
	mii_write(PHY_ADDRESS, PHY_BMCR, ( PHY_BMCR_AN_RESTART | PHY_BMCR_AN_ENABLE ) );
	//等待自动协商完成
	do
	{
		Delay( enetLINK_DELAY );
		mii_read( PHY_ADDRESS, PHY_BMSR, &usData );
	} while( !( usData & PHY_BMSR_AN_COMPLETE ) );
	
	//延时，等待初始化稳定
    for (timeout = 0; timeout < MII_LINK_TIMEOUT; ++timeout)
    {
        if (mii_read(PHY_ADDRESS, PHY_BMSR, &settings))
            return 1;
        else 
        	return 0;
        if (settings & PHY_BMSR_LINK )
            break;
    }  
    if(timeout==MII_LINK_TIMEOUT)
    	return 1;
    
    return 0;
}
//========================================================================
//函数名称：hw_eth_phy_LinkState                                                         
//功能概要：检测网络是否已连接                                              
//参数说明：phy_addr:EPHY设备地址                                                                                                 
//函数返回：操作成功返回0，失败返回1                                            
//========================================================================
uint8 hw_eth_phy_LinkState(uint16 phy_addr)
{
     uint16 reg = 0;
    //1.读取网络连接状态
    while((mii_read(phy_addr, PHY_BMSR, &reg)));
    //2.判断是否连接
    if( reg & 0x0004 )
       return 1;
    else
       return 0;
}


//========================================================================
//===============================内部函数=================================
//========================================================================



//========================================================================
//函数名称：mii_init()                                                         
//功能概要：初始化MII接口控制器                                                
//参数说明：sys_clk_mhz:系统时钟频率 (MHz)                                                                                                 
//函数返回： 无                                            
//========================================================================

void mii_init(uint16 sys_clk_mhz)
{
    ENET_MSCR  = 0 | ENET_MSCR_MII_SPEED((2*sys_clk_mhz/5)+1);
}




//========================================================================
//函数名称：mii_write                                                         
//功能概要：写值到PHY中MII寄存器                                                
//参数说明：phy_addr:EPHY设备地址                                        
//         reg_addr:MII寄存器地址                                       
//         data:需要写入到MII寄存器中的值                                                                                                    
//函数返回：操作成功返回0，失败返回1                                            
//========================================================================
int mii_write(uint16 phy_addr, uint16 reg_addr, uint16 data)
{
	int timeout;
	//请MII中断标志
	ENET_EIR = ENET_EIR_MII_MASK;
	//初始化MII管理写
	ENET_MMFR = 0
				| ENET_MMFR_ST(0x01)
				| ENET_MMFR_OP(0x01)
				| ENET_MMFR_PA(phy_addr)
				| ENET_MMFR_RA(reg_addr)
				| ENET_MMFR_TA(0x02)
				| ENET_MMFR_DATA(data);
	//查询MII中断
	for (timeout = 0; timeout < MII_TIMEOUT; timeout++)
	{
		if (ENET_EIR  & ENET_EIR_MII_MASK)
		break;
	}
	if(timeout == MII_TIMEOUT) 
		return 1;
	ENET_EIR = ENET_EIR_MII_MASK;
	return 0;
}

//========================================================================
//函数名称：mii_read                                                         
//功能概要：读取PHY中MII寄存器的值                                                 
//参数说明：phy_addr:EPHY设备地址                                        
//         reg_addr:MII寄存器地址                                       
//         data:需要写入到MII寄存器中的值 指针                                                                                                   
//函数返回：操作成功返回0，失败返回1                                             
//========================================================================
int mii_read(uint16 phy_addr, uint16 reg_addr, uint16 *data)
{
	int timeout;

	//请MII中断标志
	ENET_EIR = ENET_EIR_MII_MASK;

	//初始化MII管理读
	ENET_MMFR = 0
						| ENET_MMFR_ST(0x01)
						| ENET_MMFR_OP(0x2)
						| ENET_MMFR_PA(phy_addr)
						| ENET_MMFR_RA(reg_addr)
						| ENET_MMFR_TA(0x02);

	//查询MII中断
	for (timeout = 0; timeout < MII_TIMEOUT; timeout++)
	{
		if (ENET_EIR & ENET_EIR_MII_MASK)
			break;
	}
   	if(timeout == MII_TIMEOUT) 
		return 1;
	//清MII中断标志
	ENET_EIR = ENET_EIR_MII_MASK;
	//返回读取的MII寄存器数据
	*data = ENET_MMFR & 0x0000FFFF;

	return 0;
}

//========================================================================
//函数名称：Delay                                                         
//功能概要：延时                                                
//参数说明：time: 延时时间                                                                                                  
//函数返回： 无                                            
//========================================================================
void Delay(uint32 time)
{
    uint32 i = 0,j = 0;
    
    for(i = 0;i < time;i++)
    {
        for(j = 0;j < 50000;j++)
        {
        }
    }
}
