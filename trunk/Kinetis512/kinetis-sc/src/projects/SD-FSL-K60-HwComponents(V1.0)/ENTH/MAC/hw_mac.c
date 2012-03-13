//============================================================================
// �ļ����ƣ�hw_mac.c                                                          
// ���ܸ�Ҫ����̫����·�������ļ�
// ��Ȩ����: ���ݴ�ѧ��˼����Ƕ��ʽ����(sumcu.suda.edu.cn)
// �汾����: 2011-12-16     V1.0       ��д��K60����̫������
//============================================================================
#include "hw_mac.h"
extern int periph_clk_khz;



//��������������������
static uint8 xENETTxDescriptors_unaligned[ ( enetNUM_TX_DESCRIPTORS * sizeof( NBUF ) ) + 16 ];
//��������������������
static uint8 xENETRxDescriptors_unaligned[ ( configNUM_ENET_RX_BUFFERS * sizeof( NBUF ) ) + 16 ];
//���ͻ������������׵�ַ
static NBUF *pxENETTxDescriptor;
//���ջ������������׵�ַ
static NBUF *xENETRxDescriptors;
//���ܻ���������                                             
static uint8 ucENETRxBuffers[ ( configNUM_ENET_RX_BUFFERS * configENET_BUFFER_SIZE ) + 16 ];
static uint32 uxNextRxBuffer = 0;


//========================================================================
//�������ƣ�hw_mac_init                                                         
//���ܸ�Ҫ����ʼ����·��                                              
//����˵����ucMACAddress��MAC��ַ                                                                                                                                     
//�������أ���                                           
//========================================================================  
void hw_mac_init(uint8 ucMACAddress[])
{
    uint16 usData;
    //��ʼ��������
    prvInitialiseENETBuffers();   
   
    //��ѯ������Զ�Э�̵Ľ���������Զ�Э�̵Ľ��������·��
    usData = 0;
    mii_read(PHY_ADDRESS, PHY_STATUS, &usData );
   
    //������������ַ��ϣ�Ĵ���
    ENET_IALR = 0;
    ENET_IAUR = 0;
    ENET_GALR = 0xFFFFFFFF;
    ENET_GAUR = 0xFFFFFFFF;
    
    //����MAC��ַ
    enet_set_address(ucMACAddress);                          
    ENET_RCR = ENET_RCR_MAX_FL(configENET_BUFFER_SIZE) //���֡��
                              | ENET_RCR_MII_MODE_MASK //������1
                              | ENET_RCR_CRCFWD_MASK   //����ʱȡ��CRCУ����
                              | ENET_RCR_RMII_MODE_MASK;//RMIIģʽʹ��   
    //������ͼĴ���
    ENET_TCR = 0;  
    //���ð�˫����ȫ˫��
    if( usData & PHY_DUPLEX_STATUS )
    {
          //ȫ˫��
          ENET_RCR &= (uint16)~ENET_RCR_DRT_MASK;
          ENET_TCR |= ENET_TCR_FDEN_MASK;
    }
    else
    {
          //��˫��
          ENET_RCR |= ENET_RCR_DRT_MASK;
          ENET_TCR &= (uint16)~ENET_TCR_FDEN_MASK;
    }
    //�����ٶȣ�Ĭ��100M��
    if( usData & PHY_SPEED_STATUS )
    {
          //10M
          ENET_RCR |= ENET_RCR_RMII_10T_MASK;
    }
    ENET_ECR = 0;//ʹ�÷���ǿ�ͻ�����������

    
    //���ý��ܻ�������С
    ENET_MRBR = (uint16) configENET_BUFFER_SIZE;      
    //��������������Ĵ���ֻ���һ�����ܻ�����
    ENET_RDSR = (uint32) &( xENETRxDescriptors[ 0 ] );
    //�ӷ�������������Ĵ���ֻ���һ�����ͻ�����
    ENET_TDSR = (uint32) pxENETTxDescriptor;
    //���������̫���жϱ�־
    ENET_EIR = (uint32) -1;
    
    //ʹ���ж�
    ENET_EIMR = ENET_EIR_TXF_MASK | 
                  ENET_EIMR_RXF_MASK
                | ENET_EIMR_RXB_MASK
                | ENET_EIMR_UN_MASK
                | ENET_EIMR_RL_MASK
                | ENET_EIMR_LC_MASK 
                | ENET_EIMR_BABT_MASK
                | ENET_EIMR_BABR_MASK
                | ENET_EIMR_EBERR_MASK;
    //ʹ����̫��ģ��
    ENET_ECR |= ENET_ECR_ETHEREN_MASK;
    //ֻ���пյĽ��ܻ���������
    ENET_RDAR = ENET_RDAR_RDAR_MASK;
}


//========================================================================
//�������ƣ�hw_ethernet_send                                                         
//���ܸ�Ҫ����ʼ�����ͽ��ջ�����                                              
//����˵����ch�����ͻ�����                
//         len:�����ֽڳ���
//�������أ���                                           
//========================================================================
void hw_ethernet_send( uint8 ch[], uint16 len)
{
    //��ѯ�����õĻ�����
    while( pxENETTxDescriptor->status & TX_BD_R )
    {
    }
    //��������������ַ�ֶθ�ֵ
    pxENETTxDescriptor->data = (uint8 *)long_reverse((uint32_t)ch);		
    //�����������������ֶθ�ֵ
    pxENETTxDescriptor->length = shortlong_reverse(len);
    //���ͻ�����ֻ��һ��
    pxENETTxDescriptor->status = ( TX_BD_R | TX_BD_L | TX_BD_TC | TX_BD_W );
    //ʹ�ܷ��ͻ���������������Ĵ���
    ENET_TDAR = ENET_TDAR_TDAR_MASK;
}

//========================================================================
//�������ƣ�hw_ethernet_receive                                                         
//���ܸ�Ҫ����ʼ�����ͽ��ջ�����                                              
//����˵������                                                                                                                                     
//�������أ���                                           
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
	//�뻺�������ձ�־
	xENETRxDescriptors[ uxNextRxBuffer ].status |= RX_BD_E;
	ENET_RDAR = ENET_RDAR_RDAR_MASK;	
	return 0;
}








//========================================================================
//===============================�ڲ�����=================================
//========================================================================


//========================================================================
//�������ƣ�prvInitialiseENETBuffers                                                         
//���ܸ�Ҫ����ʼ�����ͽ��ջ�����                                              
//����˵������                                                                                                                                     
//�������أ���                                           
//========================================================================
static void prvInitialiseENETBuffers( void )
{
	uint32 ux;
	uint8 *pcBufPointer;
    //����ָ���һ�����������������������ָ��
	pcBufPointer = &( xENETTxDescriptors_unaligned[ 0 ] );
    //�ҵ���һ����16�ֽڶ��뷢�ͻ������ĵ�ַ
	while( ( ( uint32 ) pcBufPointer & 0x0fUL ) != 0 )
	{
		pcBufPointer++;
	}
	//���ͻ��建����������ָ��ָ���һ�����ͻ��建����������
	pxENETTxDescriptor = ( NBUF * ) pcBufPointer;	
	//����ָ���һ�����������������������ָ��
	pcBufPointer = &( xENETRxDescriptors_unaligned[ 0 ] );
	while( ( ( uint32 ) pcBufPointer & 0x0fUL ) != 0 )
	{
		pcBufPointer++;
	}
	//���ջ��建����������ָ��ָ���һ�����ջ��建����������
	xENETRxDescriptors = ( NBUF * ) pcBufPointer;
	pxENETTxDescriptor->length = 0;
	pxENETTxDescriptor->status = 0;
	
	pcBufPointer = &( ucENETRxBuffers[ 0 ] );
	//�ҵ���һ����16�ֽڶ�����ջ������ĵ�ַ
	while( ( ( uint32 ) pcBufPointer & 0x0fUL ) != 0 )
	{
		pcBufPointer++;
	}
	//������������
	for( ux = 0; ux < configNUM_ENET_RX_BUFFERS; ux++ )
	{
	    xENETRxDescriptors[ ux ].status = RX_BD_E;
	    xENETRxDescriptors[ ux ].length = 0;
	    xENETRxDescriptors[ ux ].data = (uint8 *)long_reverse((uint32_t)pcBufPointer);
	    pcBufPointer += configENET_BUFFER_SIZE;
  
	}
	//���û�������־
	xENETRxDescriptors[ configNUM_ENET_RX_BUFFERS - 1 ].status |= RX_BD_W;

}



//========================================================================
//�������ƣ�enet_hash_address                                                         
//���ܸ�Ҫ��Ϊ�����ĵ�ַ���ɹ�ϣ��                                                
//����˵����addr��MAC��ַ                                                                                                                                      
//�������أ������ɹ�����0��ʧ�ܷ���1                                            
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
//�������ƣ�enet_set_address                                                         
//���ܸ�Ҫ��Ϊ�����ĵ�ַ���ɹ�ϣ��                                                
//����˵����pa��MAC��ַ                                                                                                                                      
//�������أ���                                            
//========================================================================
void enet_set_address ( const uint8 *pa)
{
    uint8 crc;
    //���������ַ
    ENET_PALR = (uint32_t)((pa[0]<<24) | (pa[1]<<16) | (pa[2]<<8) | pa[3]);
    ENET_PAUR = (uint32_t)((pa[4]<<24) | (pa[5]<<16));
    //�ڸ����ַ��ϣ�Ĵ������ø����������ַ��������ù�ϣ��
    crc = enet_hash_address(pa);
    if(crc >= 32)
        ENET_IAUR |= (uint32_t)(1 << (crc - 32));
    else
        ENET_IALR |= (uint32_t)(1 << crc);
}

//========================================================================
//�������ƣ�long_reverse                                                         
//���ܸ�Ҫ�������ʹ�С�˻���                                                
//����˵����ch��Ҫת����32λ��                                                                                                                                     
//�������أ�ת���Ľ��                                            
//========================================================================
uint32 long_reverse(uint32 ch)
{
	uint32 res;
	res = ((((uint32)(ch) & 0xff000000) >> 24) | (((uint32)(ch) & 0x00ff0000) >> 8) | \

          (((uint32)(ch) & 0x0000ff00) << 8) | (((uint32)(ch) & 0x000000ff) << 24));
          
    return res;
}

//========================================================================
//�������ƣ�long_reverse                                                         
//���ܸ�Ҫ�������ʹ�С�˻���                                                
//����˵����ch��Ҫת����32λ��                                                                                                                                     
//�������أ�ת���Ľ��                                            
//========================================================================
uint16 shortlong_reverse(uint16 ch)
{
	uint16 res;
	res = ((((uint16)(ch) & 0xff00) >> 8) | (((uint16)(ch) & 0x00ff) << 8));
	return res;
}


//========================================================================
//�������ƣ�memcpy                                                         
//���ܸ�Ҫ���ӵ�ַsrc����n�����ݵ���ַdest����ʼ��n��Ԫ��                                                
//����˵���� dest :Դ���������׵�ַ       
//          src  :Ŀ�ĵ�ַ
//�������أ�ת���Ľ��                                            
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

