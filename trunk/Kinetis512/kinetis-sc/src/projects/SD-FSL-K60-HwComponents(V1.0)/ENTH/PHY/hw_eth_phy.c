

//����ͷ�ļ�
#include "hw_eth_phy.h"


//�ڲ���������
void mii_init(uint16 sys_clk_mhz);
int mii_write(uint16 phy_addr, uint16 reg_addr, uint16 data);
int mii_read(uint16 phy_addr, uint16 reg_addr, uint16 *data);
void Delay(uint32 time);

//����ϵͳ����ʱ��


//========================================================================
//�������ƣ�hw_phy_init                                                         
//���ܸ�Ҫ����ʼ��EPHYģ��                                                
//����˵����sys_clk_mhz:ϵͳʱ��Ƶ�� (MHz)                                                                                                 
//�������أ������ɹ�����0��ʧ�ܷ���1                                            
//========================================================================
uint8  hw_phy_init(uint16 sys_clk_mhz)
{
	uint16 usData;	
	uint32 timeout; 
	uint16 settings = 0;
	//ʹ����̫��ʱ��
	SIM_SCGC2 |= SIM_SCGC2_ENET_MASK;
	//��ֹMPU
	MPU_CESR = 0;         
	//��λ��̫��ģ�飬���ʹ��λ
	ENET_ECR = ENET_ECR_RESET_MASK;
	//�ȴ�8��ʱ�����ڣ��ȴ���λ���
	for( usData = 0; usData < 10; usData++ )
	{
		asm( "NOP" );
	}  
	//��ʼ��MII�ӿ�
	mii_init(sys_clk_mhz/1000);       
	//ʹ���ж�
	set_irq_priority (76, 6);
	enable_irq(76);//�����ж�
	set_irq_priority (77, 6);
	enable_irq(77);//�����ж�
	/*set_irq_priority (78, 6);
	enable_irq(78);//�����ж� */       
        
	//ʹ���ⲿ�ӿ��ź�
	PORTB_PCR0  = PORT_PCR_MUX(4);//GPIO;//RMII0_MDIO/MII0_MDIO
	PORTB_PCR1  = PORT_PCR_MUX(4);//GPIO;//RMII0_MDC/MII0_MDC		
	PORTA_PCR14 = PORT_PCR_MUX(4);//RMII0_CRS_DV/MII0_RXDV
	//PORTA_PCR5  = PORT_PCR_MUX(4);//RMII0_RXER/MII0_RXER
	PORTA_PCR12 = PORT_PCR_MUX(4);//RMII0_RXD1/MII0_RXD1
	PORTA_PCR13 = PORT_PCR_MUX(4);//RMII0_RXD0/MII0_RXD0
	PORTA_PCR15 = PORT_PCR_MUX(4);//RMII0_TXEN/MII0_TXEN
	PORTA_PCR16 = PORT_PCR_MUX(4);//RMII0_TXD0/MII0_TXD0
	PORTA_PCR17 = PORT_PCR_MUX(4);//RMII0_TXD1/MII0_TXD1

	//�ȴ�������շ���׼������
	do
	{
		Delay( enetLINK_DELAY );
		usData = 0xffff;
		mii_read( PHY_ADDRESS, PHY_PHYIDR1, &usData );
        
	} while( usData == 0xffff );
	//��ʼ�Զ�Э��                                                                                                                PHY��λ              PHY�Զ�Э��ʹ��
	mii_write(PHY_ADDRESS, PHY_BMCR, ( PHY_BMCR_AN_RESTART | PHY_BMCR_AN_ENABLE ) );
	//�ȴ��Զ�Э�����
	do
	{
		Delay( enetLINK_DELAY );
		mii_read( PHY_ADDRESS, PHY_BMSR, &usData );
	} while( !( usData & PHY_BMSR_AN_COMPLETE ) );
	
	//��ʱ���ȴ���ʼ���ȶ�
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
//�������ƣ�hw_eth_phy_LinkState                                                         
//���ܸ�Ҫ����������Ƿ�������                                              
//����˵����phy_addr:EPHY�豸��ַ                                                                                                 
//�������أ������ɹ�����0��ʧ�ܷ���1                                            
//========================================================================
uint8 hw_eth_phy_LinkState(uint16 phy_addr)
{
     uint16 reg = 0;
    //1.��ȡ��������״̬
    while((mii_read(phy_addr, PHY_BMSR, &reg)));
    //2.�ж��Ƿ�����
    if( reg & 0x0004 )
       return 1;
    else
       return 0;
}


//========================================================================
//===============================�ڲ�����=================================
//========================================================================



//========================================================================
//�������ƣ�mii_init()                                                         
//���ܸ�Ҫ����ʼ��MII�ӿڿ�����                                                
//����˵����sys_clk_mhz:ϵͳʱ��Ƶ�� (MHz)                                                                                                 
//�������أ� ��                                            
//========================================================================

void mii_init(uint16 sys_clk_mhz)
{
    ENET_MSCR  = 0 | ENET_MSCR_MII_SPEED((2*sys_clk_mhz/5)+1);
}




//========================================================================
//�������ƣ�mii_write                                                         
//���ܸ�Ҫ��дֵ��PHY��MII�Ĵ���                                                
//����˵����phy_addr:EPHY�豸��ַ                                        
//         reg_addr:MII�Ĵ�����ַ                                       
//         data:��Ҫд�뵽MII�Ĵ����е�ֵ                                                                                                    
//�������أ������ɹ�����0��ʧ�ܷ���1                                            
//========================================================================
int mii_write(uint16 phy_addr, uint16 reg_addr, uint16 data)
{
	int timeout;
	//��MII�жϱ�־
	ENET_EIR = ENET_EIR_MII_MASK;
	//��ʼ��MII����д
	ENET_MMFR = 0
				| ENET_MMFR_ST(0x01)
				| ENET_MMFR_OP(0x01)
				| ENET_MMFR_PA(phy_addr)
				| ENET_MMFR_RA(reg_addr)
				| ENET_MMFR_TA(0x02)
				| ENET_MMFR_DATA(data);
	//��ѯMII�ж�
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
//�������ƣ�mii_read                                                         
//���ܸ�Ҫ����ȡPHY��MII�Ĵ�����ֵ                                                 
//����˵����phy_addr:EPHY�豸��ַ                                        
//         reg_addr:MII�Ĵ�����ַ                                       
//         data:��Ҫд�뵽MII�Ĵ����е�ֵ ָ��                                                                                                   
//�������أ������ɹ�����0��ʧ�ܷ���1                                             
//========================================================================
int mii_read(uint16 phy_addr, uint16 reg_addr, uint16 *data)
{
	int timeout;

	//��MII�жϱ�־
	ENET_EIR = ENET_EIR_MII_MASK;

	//��ʼ��MII�����
	ENET_MMFR = 0
						| ENET_MMFR_ST(0x01)
						| ENET_MMFR_OP(0x2)
						| ENET_MMFR_PA(phy_addr)
						| ENET_MMFR_RA(reg_addr)
						| ENET_MMFR_TA(0x02);

	//��ѯMII�ж�
	for (timeout = 0; timeout < MII_TIMEOUT; timeout++)
	{
		if (ENET_EIR & ENET_EIR_MII_MASK)
			break;
	}
   	if(timeout == MII_TIMEOUT) 
		return 1;
	//��MII�жϱ�־
	ENET_EIR = ENET_EIR_MII_MASK;
	//���ض�ȡ��MII�Ĵ�������
	*data = ENET_MMFR & 0x0000FFFF;

	return 0;
}

//========================================================================
//�������ƣ�Delay                                                         
//���ܸ�Ҫ����ʱ                                                
//����˵����time: ��ʱʱ��                                                                                                  
//�������أ� ��                                            
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
