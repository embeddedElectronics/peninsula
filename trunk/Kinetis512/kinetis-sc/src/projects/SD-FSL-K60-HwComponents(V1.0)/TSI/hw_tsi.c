//============================================================================
//�ļ����ƣ�hw_tsi.c
//���ܸ�Ҫ��K60 tsi�ײ����������ļ�
//��Ȩ���У����ݴ�ѧ��˼����Ƕ��ʽ����(sumcu.suda.edu.cn)
//�汾���£�2011-11-25  V1.0   ��ʼ�汾
//============================================================================

#include "hw_tsi.h"

//============================================================================
//�������ƣ�hw_tsi_init                                                  
//���ܸ�Ҫ����ʼ��TSIģ��                                                  
//����˵����chnlIDs:16λ�޷�������                                          
//                 Ϊ1λ�Ķ�Ӧͨ��Ϊ����TSI����
//                 Ϊ0�Ķ�Ӧͨ��Ϊ������TSI����                                          
//�������أ� ��                                                               
//============================================================================
void hw_tsi_init(uint16 chnlIDs)
{
	//����TSIģ��ʱ��  
    SIM_SCGC5 |= (SIM_SCGC5_TSI_MASK); 

    //�趨TSI�Ĺ�������,Ĭ��δ����TSI�ж�,�������ɨ��
    TSI0_GENCS |= ((TSI_GENCS_NSCN(10))      //��ÿ��TSI�缫ɨ��������趨���˴���Ϊ10��
                  |(TSI_GENCS_PS(3)))      //��ɨ��Ƶ�ʵ�Ԥ��Ƶ�趨���˴���Ϊ2^3
                  |(TSI_GENCS_TSIIE_MASK) ;  //����TSI�ж�
    
    TSI0_SCANC |= ((TSI_SCANC_EXTCHRG(3))    //�ⲿ����������ѡ���趨���˴���Ϊ4uA
                  |(TSI_SCANC_REFCHRG(31))   //�ο�ʱ�ӳ���·ѡ���趨���˴���Ϊ32uA
                  |(TSI_SCANC_DELVOL(7))     //������ѹѡ���趨���˴���Ϊ600mV
                  |(TSI_SCANC_SMOD(0))       //�趨ɨ��ģ�����˴��趨Ϊ����ɨ��
                  |(TSI_SCANC_AMPSC(0)));    //����ģʽԤ��Ƶ���˴��趨ֵΪ1��������Ƶ
   
    //���Ź���ʹ��
    TSI0_PEN |= chnlIDs;
 
    //TSI����ʹ��
    TSI0_GENCS |= (TSI_GENCS_TSIEN_MASK);
}


//============================================================================
//�������ƣ�hw_tsi_get_value16                                                  
//���ܸ�Ҫ����ȡָ������16��TSIͨ���ļ���ֵ                                                  
//����˵����values[]:16λ�޷������飬�����ͨ������ֵ��                                                                                    
//�������أ� Ϊһ���Ի�ȡ����TSIͨ���ļ���ֵ                                                                
//============================================================================
void hw_tsi_get_value16(uint16 values[])
{
	//����һ���������ɨ��
    TSI0_GENCS |= TSI_GENCS_SWTS_MASK;
    //�ȴ�ɨ�����    
    while(!TSI0_GENCS&TSI_GENCS_EOSF_MASK){};
        
    //��ȡ�����Ĵ����е�ֵ
    values[0]  = TSI_CH0_CNTR;
    values[1]  = TSI_CH1_CNTR;
    values[2]  = TSI_CH2_CNTR;
    values[3]  = TSI_CH3_CNTR;
    values[4]  = TSI_CH4_CNTR;
    values[5]  = TSI_CH5_CNTR;
    values[6]  = TSI_CH6_CNTR;
    values[7]  = TSI_CH7_CNTR;
    values[8]  = TSI_CH8_CNTR;
    values[9]  = TSI_CH9_CNTR;
    values[10] = TSI_CH10_CNTR;
    values[11] = TSI_CH11_CNTR;
    values[12] = TSI_CH12_CNTR;
    values[13] = TSI_CH13_CNTR;
    values[14] = TSI_CH14_CNTR;
    values[15] = TSI_CH15_CNTR;
 
    TSI0_GENCS |= TSI_GENCS_OUTRGF_MASK; //�峬����Χ��־λ
    TSI0_GENCS |= TSI_GENCS_EOSF_MASK;  //��ɨ�������־λ
    TSI0_STATUS = 0xFFFFFFFF;  //��״̬λ
    
}


//============================================================================
//�������ƣ�hw_tsi_get_value1                                                  
//���ܸ�Ҫ����ȡָ��TSIͨ���ļ���ֵ                                                 
//����˵����chnlID:8λ�޷�������Ҫ��ȡ����ֵ��ͨ����                                                                                    
//�������أ� ����ָ��ͨ���ļ���ֵ                                                               
//============================================================================
uint16 hw_tsi_get_value1(uint8 chnlID)
{
    uint16 values[16];
    
    if (chnlID >15) 
    {
        chnlID = 15;
    }
    
    hw_tsi_get_value16(values);
    
    return values[chnlID];
}


//============================================================================
//�������ƣ�hw_tsi_set_threshold1                                                  
//���ܸ�Ҫ���趨ָ��ͨ������ֵ                                                  
//����˵����chnlID:8λ�޷�������Ҫ�趨��ͨ����                               
//            low:   �趨��ֵ����                                              
//           high:  �趨��ֵ����                                                                                      
//�������أ� ��                                                             
//============================================================================

void hw_tsi_set_threshold1(uint8 chnlID, uint16 low, uint16 high)
{
    uint32 thresholdValue;
    
    thresholdValue = low;
    thresholdValue = (thresholdValue<<16)|high;
    TSI_THRESHLD_REG(TSI0_BASE_PTR, chnlID) = thresholdValue;
}
//============================================================================
//�������ƣ�hw_tsi_set_threshold16                                                  
//���ܸ�Ҫ���趨����16��ͨ������ֵ                                                
//����˵����chnlID:8λ�޷�������Ҫ�趨��ͨ����                               
//           lows: �趨��ֵ��������                                         
//          highs:�趨��ֵ��������                                                                                                                         
//�������أ� ��                                                             
//============================================================================
void hw_tsi_set_threshold16(uint16 lows[], uint16 highs[])
{
    uint8 i;
    for (i = 0; i < 16; i++)
    {
        hw_tsi_set_threshold1(i, lows[i], highs[i]);
    }
}


