//============================================================================
//�ļ����ƣ�hw_hscmp.c
//���ܸ�Ҫ��K60 �Ƚ����ײ����������ļ�
//��Ȩ���У����ݴ�ѧ��˼����Ƕ��ʽ����(sumcu.suda.edu.cn)
//�汾���£�2011-11-25  V1.0   ��ʼ�汾
//============================================================================
#include "hw_cmp.h"



//============================================================================
//�������ƣ�hw_cmp_init
//��������     ��
//����˵����MoudleNumber: �Ƚ���ģ���
//         reference:�ο���ѹѡ��  0=VDDA 3.3V 1=VREF 1.2V
//         plusChannel: ���Ƚ�ͨ����
//         minusChannel�����Ƚ�ͨ����
//���ܸ�Ҫ��CMPģ���ʼ��
//============================================================================
void hw_cmp_init(int MoudleNumber,uint8 reference,uint8 plusChannel,uint8 minusChannel)
{
	    //ͨ����ȡģ���ѡ��Ƚ�����ַ
		CMP_MemMapPtr cmpch = hw_cmp_get_base_address(MoudleNumber);
		//ʹ�ܱȽ�ģ��ʱ��
		SIM_SCGC4 |=SIM_SCGC4_CMP_MASK;
				
		//��ʼ���Ĵ���
		CMP_CR0_REG(cmpch) = 0;
		CMP_CR1_REG(cmpch) = 0;
		CMP_FPR_REG(cmpch) = 0;
		//��������˱�־����жϱ�־
		CMP_SCR_REG(cmpch) = 0x06;  
		CMP_DACCR_REG(cmpch) = 0;
		CMP_MUXCR_REG(cmpch) = 0;
		
		//���üĴ���
		//���ˣ�������ʱ��ֹ
		CMP_CR0_REG(cmpch) = 0x00;  
		//����ģʽ�����ٱȽϣ��޹��������������Ž�ֹ
		CMP_CR1_REG(cmpch) = 0x15;  
		//���˽�ֹ
		CMP_FPR_REG(cmpch) = 0x00; 
		//ʹ�������غ��½����жϣ����־λ
		CMP_SCR_REG(cmpch) = 0x1E;  
		
		
		if(reference==0)//�ο���ѹѡ��VDD3.3V
		{		
			//6λ�ο�DACʹ�ܣ�ѡ��VDD��ΪDAC�ο���ѹ
			CMP_DACCR_REG(cmpch) |= 0xC0;
		}
		else//�ο���ѹѡ��VREF OUT 1.2V
		{
			//6λ�ο�DACʹ�ܣ�ѡ��VREF��ΪDAC�ο���
			CMP_DACCR_REG(cmpch) |= 0x80;
		}
		
		
		CMP_MUXCR_REG(cmpch) |= 0xC0;//������������ʹ��
		
		
		//ѡ������ͨ��
		//��ͨ��ѡ��ģ��7ΪDAC���
		if(plusChannel>7)
			plusChannel = 7;
		if(plusChannel<0)
			plusChannel = 0;
		CMP_MUXCR_REG(cmpch) |= CMP_MUXCR_PSEL(plusChannel);
				
		//��ͨ��ѡ��ģ��7ΪDAC���
		if(minusChannel>7)
			minusChannel = 7;
		if(minusChannel<0)
			minusChannel = 0;
		CMP_MUXCR_REG(cmpch) |= CMP_MUXCR_MSEL(minusChannel);	
		
		
		//ʹ���������
		CMP_CR1_REG(cmpch) |= CMP_CR1_OPE_MASK; 
		
		
		//ѡ���������
		if(cmpch == cmpch0)
		{
			//ʹ��PTC5ΪHSCMP0����Ƚ�����
			PORTC_PCR5=PORT_PCR_MUX(6);  
		}
		else if(cmpch == cmpch1)
		{
			//ʹ��PTC4ΪHSCMP1����Ƚ�����
			PORTC_PCR4=PORT_PCR_MUX(6); 
		}
		else
		{
			//ʹ��PTB22ΪHSCMP2����Ƚ�����
			PORTB_PCR22=PORT_PCR_MUX(6); 
		}
}


//============================================================================
//�������ƣ�hw_dac_set_value
//�������أ���
//����˵����MoudleNumber: �Ƚ���ģ���
//         value: dac�����ת��ֵ
//���ܸ�Ҫ�����Ƚ��С�
//============================================================================
void hw_dac_set_value(int MoudleNumber,uint8 value)
{
	 //ͨ����ȡģ���ѡ��Ƚ�����ַ
	 CMP_MemMapPtr cmpch = hw_cmp_get_base_address(MoudleNumber);
	 CMP_DACCR_REG(cmpch) |= CMP_DACCR_VOSEL(value);
}



//============================================================================
//�������ƣ�hw_enable_cmp_int
//�������أ���
//����˵����MoudleNumber: �Ƚ���ģ���
//���ܸ�Ҫ�����Ƚ��С�
//============================================================================
void hw_enable_cmp_int(int MoudleNumber)
{
	//ͨ����ȡģ���ѡ��Ƚ�����ַ
	 CMP_MemMapPtr cmpch = hw_cmp_get_base_address(MoudleNumber);
	//����cmp�����ж�,�������½��ؾ�����
	 CMP_SCR_REG(cmpch)|=  CMP_SCR_IEF_MASK  | CMP_SCR_IER_MASK; 
	 enable_irq(CMP0irq + MoudleNumber);   
	 CMP0_SCR |= CMP_SCR_CFR_MASK; //���־
	 CMP0_SCR |= CMP_SCR_CFF_MASK; //���־
	
}

//============================================================================
//�������ƣ�hw_disable_cmp_int
//�������أ���
//����˵����MoudleNumber: �Ƚ���ģ���
//���ܸ�Ҫ���رȽ��ж�
//============================================================================
void hw_disable_cmp_int(int MoudleNumber)
{
	//ͨ����ȡģ���ѡ��Ƚ�����ַ
    CMP_MemMapPtr cmpch = hw_cmp_get_base_address(MoudleNumber);
	//�ر�cmp�����ж�,�������½��ؾ��ر�
	CMP_SCR_REG(cmpch)&=(~CMP_SCR_IEF_MASK) | (~CMP_SCR_IER_MASK );   
	//�ؽ������ŵ�IRQ�ж�
	disable_irq(CMP0irq + MoudleNumber);
	
}

//============================================================================
//�������ƣ�hw_cmp_get_base_address  
//�������أ��Ƚ���ģ��Ļ�ֵַ                                                 
//����˵����MoudleNumber:ģ���      
//���ܸ�Ҫ����ȡ�Ƚ�ģ��Ļ�ַ   
                                                              
//============================================================================
CMP_MemMapPtr hw_cmp_get_base_address(uint8 MoudleNumber)
{
	switch(MoudleNumber)
	{
	case 0:
		return CMP0_BASE_PTR;
		break;
	case 1:
		return CMP1_BASE_PTR;
		break;
	case 2:
		return CMP2_BASE_PTR;
		break;
	}
}

