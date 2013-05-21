//============================================================================
//�ļ����ƣ�hw_adc.h   
//���ܸ�Ҫ��adc����ͷ�ļ�
//��Ȩ���У����ݴ�ѧ��˼����Ƕ��ʽ����(sumcu.suda.edu.cn)
//�汾���£�2011-11-13  V1.0   ��ʼ�汾
//          2011-11-21   V1.1   �淶�Ű���
//============================================================================

#ifndef __ADC_H__
#define __ADC_H__

#include "common.h"

#define ADC0_irq_no 57
#define ADC1_irq_no 58
#define A                 0x0
#define B                 0x1

#define COCO_COMPLETE     ADC_SC1_COCO_MASK
#define COCO_NOT          0x00

//ADC �ж�: ʹ�ܻ��߽�ֹ
#define AIEN_ON           ADC_SC1_AIEN_MASK
#define AIEN_OFF          0x00

//��ֻ��ߵ���ADC����
#define DIFF_SINGLE       0x00
#define DIFF_DIFFERENTIAL ADC_SC1_DIFF_MASK


//ADC��Դ���� 
#define ADLPC_LOW         ADC_CFG1_ADLPC_MASK
#define ADLPC_NORMAL      0x00

//ʱ�ӷ�Ƶ
#define ADIV_1            0x00
#define ADIV_2            0x01
#define ADIV_4            0x02
#define ADIV_8            0x03

//������ʱ����߶̲���ʱ��
#define ADLSMP_LONG       ADC_CFG1_ADLSMP_MASK
#define ADLSMP_SHORT      0x00


//ADC����ʱ��Դѡ�� ���ߣ�����/2����altclk������ADC�����첽ʱ���Լ�������
#define ADICLK_BUS        0x00
#define ADICLK_BUS_2      0x01
#define ADICLK_ALTCLK     0x02
#define ADICLK_ADACK      0x03

//ѡ��ͨ��A��ͨ��B
#define MUXSEL_ADCB       ADC_CFG2_MUXSEL_MASK
#define MUXSEL_ADCA       0x00

//�첽ʱ�����ʹ�ܣ�ʹ�ܣ����߽�ֹ���
#define ADACKEN_ENABLED   ADC_CFG2_ADACKEN_MASK
#define ADACKEN_DISABLED  0x00

//���ٵ���ת��ʱ��
#define ADHSC_HISPEED     ADC_CFG2_ADHSC_MASK
#define ADHSC_NORMAL      0x00

//������ʱ��ѡ��20,12,6����2�������ʱ�Ӷ��ڳ�����ʱ��
#define ADLSTS_20          0x00
#define ADLSTS_12          0x01
#define ADLSTS_6           0x02
#define ADLSTS_2           0x03

//�����ӿ�����

//============================================================================
//�������ƣ�hw_adc_init
//�������أ�0 �ɹ� ��1 ʧ��
//����˵����MoudelNumber��ģ���
//���ܸ�Ҫ��AD��ʼ��
//============================================================================
uint8 hw_adc_init(int MoudelNumber);


//============================================================================
//�������ƣ�hw_adc_once
//�������أ�16λ�޷��ŵ�ADֵ
//����˵����MoudelNumber��ģ���
//               Channel��ͨ����
//              accuracy������
//���ܸ�Ҫ���ɼ�һ��һ·ģ������ADֵ    
//============================================================================
uint16 hw_adc_once(int MoudelNumber,int Channel,uint8 accuracy);

//============================================================================
//�������ƣ�hw_adc_mid
//�������أ�16λ�޷��ŵ�ADֵ 
//����˵����MoudelNumber��ģ���
//               Channel��ͨ����
//              accuracy������
//���ܸ�Ҫ����ֵ�˲���Ľ��(��Χ:0-4095) 
//============================================================================
uint16 hw_adc_mid(int MoudelNumber,int Channel,uint8 accuracy); 

//============================================================================
//�������ƣ�hw_adc_ave
//�������أ�16λ�޷��ŵ�ADֵ 
//����˵����MoudelNumber��ģ���
//               Channel��ͨ����
//              accuracy������
//                     N:��ֵ�˲�����(��Χ:0~255)
//���ܸ�Ҫ����ֵ�˲���Ľ��(��Χ:0-4095) 
//============================================================================
uint16 hw_adc_ave(int MoudelNumber,int Channel,uint8 accuracy,uint8 N); 

#endif