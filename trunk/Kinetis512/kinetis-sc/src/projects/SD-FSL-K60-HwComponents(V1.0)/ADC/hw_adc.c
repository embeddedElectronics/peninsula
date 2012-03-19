//============================================================================
//�ļ����ƣ�hw_adc.c  
//���ܸ�Ҫ��adc����Դ�ļ�
//��Ȩ���У����ݴ�ѧ��˼����Ƕ��ʽ����(sumcu.suda.edu.cn)
//�汾���£�2011-11-13  V1.0   ��ʼ�汾
//          2011-11-21   V1.1   �淶�Ű���
//============================================================================

#include "hw_adc.h"

//============================================================================
//�������ƣ�hw_adc_init
//�������أ�0 �ɹ� ��1 ʧ��
//����˵����MoudelNumber��ģ���
//���ܸ�Ҫ��AD��ʼ��
//============================================================================
uint8 hw_adc_init(int MoudelNumber)
{
    if(MoudelNumber == 0)//ģ��0
    {
    	//��ADC0ģ��ʱ��
        SIM_SCGC6 |= (SIM_SCGC6_ADC0_MASK );
    }
    else if(MoudelNumber == 1)//ģ��1
    {      
    	//��ADC1ģ��ʱ��
        SIM_SCGC3 |= (SIM_SCGC3_ADC1_MASK );
    }
    else
    {
        return 0;
    }
    
    return 1;
}



//============================================================================
//�������ƣ�hw_ad_once
//�������أ�16λ�޷��ŵ�ADֵ 
//����˵����MoudelNumber��ģ���
//               Channel��ͨ����
//              accuracy������
//���ܸ�Ҫ���ɼ�һ��һ·ģ������ADֵ    
//============================================================================
uint16 hw_adc_once(int MoudelNumber,int Channel,uint8 accuracy)//�ɼ�ĳ·ģ������ADֵ
{
		uint16 result = 0;
		uint8 ADCCfg1Mode = 0;
		ADC_MemMapPtr ADCMoudel;//����ADCģ���ַָ��
				
		switch(accuracy)
		{
			 case 8:
			   ADCCfg1Mode = 0x00;
			   break;
			 case 12:
			   ADCCfg1Mode = 0x01;
			   break;
			 case 10:
			   ADCCfg1Mode = 0x02;
			   break;
			 case 16:
			   ADCCfg1Mode = 0x03;
			   break;
			 default:
			   ADCCfg1Mode = 0x00;
		}
		
		
		if(MoudelNumber==0)//ѡ��ADCģ��0
		{
		   ADCMoudel = ADC0_BASE_PTR;
		}
		else               //ѡ��ADCģ��1
		{
		   ADCMoudel = ADC1_BASE_PTR;
		}
		
		//����������Դģʽ������ʱ�ӣ�����ʱ��4��Ƶ��������ʱ��ʹ�ܣ����þ���
		ADC_CFG1_REG(ADCMoudel) = ADLPC_NORMAL
								 | ADC_CFG1_ADIV(ADIV_4)
								 | ADLSMP_LONG
								 | ADC_CFG1_MODE(ADCCfg1Mode)
								 | ADC_CFG1_ADICLK(ADICLK_BUS);
		   
		//���ý�ֹ�첽ʱ��ʹ�������ADxxatͨ��ѡ�񣬸������ã�������ʱ��   
		ADC_CFG2_REG(ADCMoudel)  =    MUXSEL_ADCA
								 | ADACKEN_DISABLED
								 | ADHSC_HISPEED
								 | ADC_CFG2_ADLSTS(ADLSTS_20) ;
								
		//����ͨ����
		ADC_SC1_REG(ADCMoudel,A) = AIEN_ON | DIFF_SINGLE | ADC_SC1_ADCH(Channel);
	    //�ȴ�ת�����
    	while (( ADC_SC1_REG(ADCMoudel,A) & ADC_SC1_COCO_MASK ) != ADC_SC1_COCO_MASK)
		{

		}
	    //��ȡת�����
		result = ADC_R_REG(ADCMoudel,A);       
		//��ADCת����ɱ�־
		ADC_SC1_REG(ADCMoudel,A) &= ~ADC_SC1_COCO_MASK;

    return result;
}

//============================================================================
//�������ƣ�hw_ad_mid
//�������أ�16λ�޷��ŵ�ADֵ 
//����˵����MoudelNumber��ģ���
//               Channel��ͨ����
//              accuracy������
//���ܸ�Ҫ����ֵ�˲���Ľ��(��Χ:0-4095) 
//============================================================================
uint16 hw_adc_mid(int MoudelNumber,int Channel,uint8 accuracy) 
{
	uint16 i,j,k,tmp;
	//1.ȡ3��A/Dת�����
	i = hw_adc_once(MoudelNumber,Channel,accuracy);
	j = hw_adc_once(MoudelNumber,Channel,accuracy);
	k = hw_adc_once(MoudelNumber,Channel,accuracy);
	//2.ȡ��ֵ
	if (i > j)
	{
		tmp = i; i = j; j = tmp;
	}
	if (k > j) 
	  tmp = j;
	else if(k > i) 
	  tmp = k;
    else 
      tmp = i;
	return tmp;
}

//============================================================================
//�������ƣ�hw_ad_ave
//�������أ�16λ�޷��ŵ�ADֵ 
//����˵����MoudelNumber��ģ���
//               Channel��ͨ����
//              accuracy������
//                     N:��ֵ�˲�����(��Χ:0~255)
//���ܸ�Ҫ����ֵ�˲���Ľ��(��Χ:0-4095) 
//============================================================================
uint16 hw_adc_ave(int MoudelNumber,int Channel,uint8 accuracy,uint8 N) 
{
	uint32 tmp = 0;
	uint8  i;
    for(i = 0; i < N; i++)
		tmp += hw_adc_mid(MoudelNumber,Channel,accuracy);
	tmp = tmp / N; 
    return (uint16)tmp;
}