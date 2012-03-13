//============================================================================
//�ļ����ƣ�hw_dac.h
//���ܸ�Ҫ��K60 DAC�ײ���������ͷ�ļ�
//��Ȩ���У����ݴ�ѧ��˼����Ƕ��ʽ����(sumcu.suda.edu.cn)
//���¼�¼��2011-11-17   V1.0    ��ʼ�汾
//============================================================================

#ifndef _DAC_H 
#define _DAC_H 

//1 ͷ�ļ�
#include "common.h"    //����������Ϣͷ�ļ�

//2 �궨��
#define DAC0_irq_no     81            //DAC 0ͨ���жϺ�
#define DAC1_irq_no     82            //DAC 1ͨ���жϺ�



// 2.2 DAC���ƼĴ���0 λ���� 
#define DAC_DISABLE   0x00                            //��ֹDAC
#define DAC_ENABLE    DAC_C0_DACEN_MASK               //ʹ��DAC

#define DAC_SEL_VREFO  0x00                           //�ο���ѹ1ѡ��
#define DAC_SEL_VDDA   DAC_C0_DACRFS_MASK             //�ο���ѹ2ѡ��

#define DAC_SEL_PDB_HW_TRIG  0x00                     //Ӳ������
#define DAC_SEL_SW_TRIG  DAC_C0_DACTRGSEL_MASK        //�������

#define DAC_SW_TRIG_STOP 0x00                         //������Ч
#define DAC_SW_TRIG_NEXT  DAC_C0_DACSWTRG_MASK        //������Ч

#define DAC_HP_MODE  0x00                             //�߹���ģʽ
#define DAC_LP_MODE  DAC_C0_LPEN_MASK                 //�͹���ģʽ  

#define DAC_BFWM_INT_DISABLE  0x00                    //��ֹ��������ж�
#define DAC_BFWM_INT_ENABLE   DAC_C0_DACBWIEN_MASK    //ʹ�ܻ�������ж�

#define DAC_BFT_PTR_INT_DISABLE 0x00                  //��ֹ�����ȡ��ָ�����
#define DAC_BFT_PTR_INT_ENABLE DAC_C0_DACBTIEN_MASK   //ʹ�ܻ����ȡ��ָ�����

#define DAC_BFB_PTR_INT_DISABLE 0x00                  //��ֹ�����ȡ��ָ�����
#define DAC_BFB_PTR_INT_ENABLE DAC_C0_DACBBIEN_MASK   //ʹ�ܻ����ȡ��ָ�����

// 2.3 DAC���ƼĴ���1 λ����
#define DAC_DMA_DISABLE  0x00                         //��ֹDMA
#define DAC_DMA_ENABLE DAC_C1_DMAEN_MASK              //ʹ��DMA

#define DAC_BFWM_1WORD  DAC_C1_DACBFWM(0)             //1word  �������ѡ��λ
#define DAC_BFWM_2WORDS DAC_C1_DACBFWM(1)             //2words �������ѡ��λ
#define DAC_BFWM_3WORDS DAC_C1_DACBFWM(2)             //3words �������ѡ��λ 
#define DAC_BFWM_4WORDS DAC_C1_DACBFWM(3)             //4words �������ѡ��λ

#define DAC_BF_NORMAL_MODE DAC_C1_DACBFMD(0)          //����ģʽ����
#define DAC_BF_SWING_MODE DAC_C1_DACBFMD(1)           //��תģʽ����
#define DAC_BF_ONE_TIME_MODE DAC_C1_DACBFMD(2)        //����ɨ��ģʽ����

#define DAC_BF_DISABLE 0x00                           //��ֹ����
#define DAC_BF_ENABLE DAC_C1_DACBFEN_MASK             //ʹ�ܻ���

//2.4 DAC���ƼĴ���2λ���� 
#define DAC_SET_PTR_AT_BF(x) DAC_C2_DACBFRP(x)        //�����ȡָ��
#define DAC_SET_PTR_UP_LIMIT(x) DAC_C2_DACBFUP(x)     //��������

//3 �����ӿ�����

//============================================================================
//�������ƣ�hw_dac_init
//�������أ���
//����˵����ModelNumber��ͨ����0��1��                         
//         VreReference���ο���ѹѡ��0=1.75V��1=3V��
//���ܸ�Ҫ����ʼ��DACģ���趨��
//============================================================================
void hw_dac_init(uint8 ModelNumber,uint8 VreReference);

//============================================================================
//�������ƣ�hw_dac_convert
//�������أ�DAC��ɱ�־��0=���ʧ�ܣ�1=��ɳɹ� 
//����˵����ModelNumber: ͨ����0��1
//          VReference: �ο���ѹת��ֵ  ��Χ��0~4095��
//���ܸ�Ҫ��ִ��DACת����
//============================================================================ 
uint8 hw_dac_convert(uint8 ModelNumber, uint16 VReference);


//============================================================================
//�������ƣ�hw_dac_set_buffer
//�������أ����õĻ�������Сֵ
//����˵����dacx_base_ptr��DACx��ָ��      
//          dacindex
//          buffval      ��������ֵ
//���ܸ�Ҫ������DACx������
//============================================================================
int hw_dac_set_buffer(DAC_MemMapPtr dacx_base_ptr, uint8 dacindex, int buffval);


//============================================================================
//�������ƣ�hw_dac_set
//�������أ���
//����˵����dacx_base_ptr��DACx��ָ��
//                VrefSel��      �ο���ѹ
//���ܸ�Ҫ��DAC�������   
//============================================================================  
void hw_dac_set(DAC_MemMapPtr dacx_base_ptr, uint8 VrefSel);

#endif 
