//============================================================================
//�ļ����ƣ�hw_dac.c
//���ܸ�Ҫ��K60 DAC�ײ����������ļ�
//��Ȩ���У����ݴ�ѧ��˼����Ƕ��ʽ����(sumcu.suda.edu.cn)
//���¼�¼��2011-11-17   V1.0    ��ʼ�汾
//============================================================================

#include "hw_dac.h"               //����DAC��������ͷ�ļ�   

//============================================================================
//�������ƣ�hw_dac_init
//�������أ���
//����˵����ModelNumber��ͨ����0��1��                         
//         RefVoltage���ο���ѹѡ��0=1.2V��1=3.3V��
//���ܸ�Ҫ����ʼ��DACģ���趨��
//============================================================================
void hw_dac_init(uint8 ModelNumber,uint8 RefVoltage)
{
    uint8 VreRF = DAC_SEL_VREFO;
    if(RefVoltage == 1)
    {
        VreRF =  DAC_SEL_VDDA;                  //3.3V 
    }
    
    if(ModelNumber == 0)
    {
        SIM_SCGC2 |= SIM_SCGC2_DAC0_MASK ;      //ʹ��DAC 0               
        hw_dac_set(DAC0_BASE_PTR,VreRF);
    }
    else
    {
        SIM_SCGC2 |= SIM_SCGC2_DAC1_MASK ;      //ʹ��DAC 1
        hw_dac_set(DAC1_BASE_PTR,VreRF);
    }
}
    
//============================================================================
//�������ƣ�hw_dac_convert
//�������أ�DAC��ɱ�־��0=���ʧ�ܣ�1=��ɳɹ� 
//����˵����ModelNumber: ͨ����0��1
//         VReference: �ο���ѹת��ֵ  ��Χ��0~4095��
//���ܸ�Ҫ��ִ��DACת����
//============================================================================   
uint8 hw_dac_convert(uint8 ModelNumber, uint16 VReference)
{
    if(0 == ModelNumber)
    {
        if(VReference != hw_dac_set_buffer(DAC0_BASE_PTR, 0, VReference))
        {
            return 0;
        }
    }
    else if(1 == ModelNumber)
    {
        if(VReference != hw_dac_set_buffer(DAC1_BASE_PTR, 0, VReference))
        {
            return 0;
        } 
    }
    else 
    {
        return 0;
    }  
    return 1;
}
  

//�ڲ�����

//============================================================================
//�������ƣ�hw_dac_set_buffer
//�������أ����õĻ�������Сֵ
//����˵����dacx_base_ptr��DACx��ָ��      
//          dacindex    ����������
//          buffval      ��������ֵ
//���ܸ�Ҫ������DACx������
//============================================================================ 
int hw_dac_set_buffer( DAC_MemMapPtr dacx_base_ptr, uint8 dacindex, int buffval)
{
    int temp = 0; 
    //���û��������ֽ�
    DAC_DATL_REG(dacx_base_ptr, dacindex)  =   (buffval&0x0ff); 
    //���û��������ֽ�
    DAC_DATH_REG(dacx_base_ptr, dacindex)  =   (buffval&0xf00) >>8;                                
    temp =( DAC_DATL_REG(dacx_base_ptr, dacindex)|( DAC_DATH_REG(dacx_base_ptr, dacindex)<<8));   
    return temp ;
}


    
//============================================================================
//�������ƣ�hw_dac_set
//�������أ���
//����˵����dacx_base_ptr��DACx��ָ��
//                VrefSel��      �ο���ѹ
//���ܸ�Ҫ������DACģ��   
//============================================================================  
void hw_dac_set(DAC_MemMapPtr dacx_base_ptr, uint8 VrefSel)
{
	 //����DAC_C0�Ĵ���
     DAC_C0_REG(dacx_base_ptr)  = (
                                   DAC_BFB_PTR_INT_DISABLE|//�������õ��жϽ�ֹ            
                                   DAC_BFT_PTR_INT_DISABLE|//�������ö��жϽ�ֹ              
                                   DAC_BFWM_INT_DISABLE   |//ˮӡ�жϽ�ֹ           
                                   DAC_HP_MODE            |//�߹���ģʽ          
                                   DAC_SW_TRIG_STOP       |//������Ч          
                                   DAC_SEL_SW_TRIG        |//ѡ���������      
                                   VrefSel                |//ѡ��ο���ѹ         
                                   DAC_ENABLE              //ʹ��DAC0ģ�� 
                                   );  
    //���ѡ����VREFO��Ϊ�ο���ѹ
    if ( VrefSel == DAC_SEL_VREFO )
    {
    	//����VREFģ��ʱ��
		SIM_SCGC4 |= SIM_SCGC4_VREF_MASK ;
		VREF_SC = 0x81 ;      
		//�ȴ��ڲ���ѹ�ο��ȶ�
		while (!(VREF_SC & VREF_SC_VREFST_MASK))
		{
		} 
    }
	 //����DAC_C1�Ĵ���
     DAC_C1_REG(dacx_base_ptr)= ( 
                                 DAC_BF_DISABLE           |//DAC��������ֹ              
                                 DAC_BF_NORMAL_MODE       |//DACѡ����ѡ����������ģʽ         
                                 DAC_BFWM_1WORD           |//DAC������ˮӡѡ��1�ֽ�
                                 DAC_DMA_DISABLE           //DMA��ֹ
                                 ) ;
     //����DAC_C2�Ĵ���
     DAC_C2_REG(dacx_base_ptr) = DAC_SET_PTR_AT_BF(0)     | //���û�������ָ��ָ��0
								 DAC_SET_PTR_UP_LIMIT(0x0f);//���û���������Ϊ15
}
    

