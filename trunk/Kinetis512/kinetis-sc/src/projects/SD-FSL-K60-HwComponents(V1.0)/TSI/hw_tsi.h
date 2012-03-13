//============================================================================
//�ļ����ƣ�hw_tsi.h
//���ܸ�Ҫ��K60 tsi�ײ���������ͷ�ļ�
//��Ȩ���У����ݴ�ѧ��˼����Ƕ��ʽ����(sumcu.suda.edu.cn)
//�汾���£�2011-11-25  V1.0   ��ʼ�汾
//============================================================================

#ifndef __TSI_H__
#define __TSI_H__

    //1 ͷ�ļ�
    #include "common.h"
    #include "hw_uart.h"
    
    //2 �궨��

    //����TSIģ��
    #define TSI_ENABLE  TSI0_GENCS |=  TSI_GENCS_TSIEN_MASK
    //�ر�TSIģ��
    #define TSI_DISABLE TSI0_GENCS &= ~TSI_GENCS_TSIEN_MASK
    
    //����TSI�жϴ���ģʽ��ͬʱ�����Զ�����ɨ��  
    //TSI Vector is 99. IRQ# is 99-16=83
    #define hw_tsi_enable_interrupt do {\
                  enable_irq(83);\
                  TSI0_GENCS |= (TSI_GENCS_TSIIE_MASK|TSI_GENCS_STM_MASK);\
            } while (0)
    //����TSI�жϴ���ģʽ��ͬʱ�����Զ�����ɨ��
    #define hw_tsi_disable_interrupt do {\
                  TSI0_GENCS &= ~(TSI_GENCS_TSIIE_MASK|TSI_GENCS_STM_MASK);\
            } while (0)
//TSI�˿ڼ�������
#define TSI_PORTA_MASK   0xE000
#define TSI_PORTB_MASK   0x1FC1
#define TSI_PORTC_MASK   0x003E

//TSIͨ������
#define TSI_CH0_MASK     0x0001
#define TSI_CH1_MASK     0x0002
#define TSI_CH2_MASK     0x0004
#define TSI_CH3_MASK     0x0008
#define TSI_CH4_MASK     0x0010
#define TSI_CH5_MASK     0x0020
#define TSI_CH6_MASK     0x0040
#define TSI_CH7_MASK     0x0080
#define TSI_CH8_MASK     0x0100
#define TSI_CH9_MASK     0x0200
#define TSI_CH10_MASK    0x0400
#define TSI_CH11_MASK    0x0800
#define TSI_CH12_MASK    0x1000
#define TSI_CH13_MASK    0x2000
#define TSI_CH14_MASK    0x4000
#define TSI_CH15_MASK    0x8000
              
//TSIͨ�������Ĵ���
#define TSI_CH0_CNTR     (uint16)((TSI0_CNTR1)&0x0000FFFF)
#define TSI_CH1_CNTR     (uint16)((TSI0_CNTR1>>16)&0x0000FFFF)
#define TSI_CH2_CNTR     (uint16)((TSI0_CNTR3)&0x0000FFFF)
#define TSI_CH3_CNTR     (uint16)((TSI0_CNTR3>>16)&0x0000FFFF)
#define TSI_CH4_CNTR     (uint16)((TSI0_CNTR5)&0x0000FFFF)
#define TSI_CH5_CNTR     (uint16)((TSI0_CNTR5>>16)&0x0000FFFF)
#define TSI_CH6_CNTR     (uint16)((TSI0_CNTR7)&0x0000FFFF)
#define TSI_CH7_CNTR     (uint16)((TSI0_CNTR7>>16)&0x0000FFFF)
#define TSI_CH8_CNTR     (uint16)((TSI0_CNTR9)&0x0000FFFF)
#define TSI_CH9_CNTR     (uint16)((TSI0_CNTR9>>16)&0x0000FFFF)
#define TSI_CH10_CNTR    (uint16)((TSI0_CNTR11)&0x0000FFFF)
#define TSI_CH11_CNTR    (uint16)((TSI0_CNTR11>>16)&0x0000FFFF)
#define TSI_CH12_CNTR    (uint16)((TSI0_CNTR13)&0x0000FFFF)
#define TSI_CH13_CNTR    (uint16)((TSI0_CNTR13>>16)&0x0000FFFF)
#define TSI_CH14_CNTR    (uint16)((TSI0_CNTR15)&0x0000FFFF)
#define TSI_CH15_CNTR    (uint16)((TSI0_CNTR15>>16)&0x0000FFFF)        



//3 ��������
//============================================================================
//�������ƣ�hw_tsi_init                                                  
//���ܸ�Ҫ����ʼ��TSIģ��                                                  
//����˵����chnlIDs:16λ�޷�������                                          
//                 Ϊ1λ�Ķ�Ӧͨ��Ϊ����TSI����
//                 Ϊ0�Ķ�Ӧͨ��Ϊ������TSI����                                          
//�������أ� ��                                                               
//============================================================================
void hw_tsi_init(uint16 chnlIDs);
    
//============================================================================
//�������ƣ�hw_tsi_get_value16                                                  
//���ܸ�Ҫ����ȡָ������16��TSIͨ���ļ���ֵ                                                  
//����˵����values[]:16λ�޷������飬�����ͨ������ֵ��                                                                                    
//�������أ� Ϊһ���Ի�ȡ����TSIͨ���ļ���ֵ                                                                
//============================================================================
void hw_tsi_get_value16(uint16 values[]);


//============================================================================
//�������ƣ�hw_tsi_get_value1                                                  
//���ܸ�Ҫ����ȡָ��TSIͨ���ļ���ֵ                                                 
//����˵����chnlID:8λ�޷�������Ҫ��ȡ����ֵ��ͨ����                                                                                    
//�������أ� ����ָ��ͨ���ļ���ֵ                                                               
//============================================================================
uint16 hw_tsi_get_value1(uint8 chnlID);
    
//============================================================================
//�������ƣ�hw_tsi_set_threshold1                                                  
//���ܸ�Ҫ���趨ָ��ͨ������ֵ                                                  
//����˵����chnlID:8λ�޷�������Ҫ�趨��ͨ����                               
//            low:   �趨��ֵ����                                              
//           high:  �趨��ֵ����                                                                                      
//�������أ� ��                                                             
//============================================================================
void hw_tsi_set_threshold1(uint8 chnlID, uint16 low, uint16 high);

//============================================================================
//�������ƣ�hw_tsi_set_threshold16                                                  
//���ܸ�Ҫ���趨����16��ͨ������ֵ                                                
//����˵����chnlID:8λ�޷�������Ҫ�趨��ͨ����                               
//           lows: �趨��ֵ��������                                         
//          highs:�趨��ֵ��������                                                                                                                         
//�������أ� ��                                                             
//============================================================================
void hw_tsi_set_threshold16(uint16 lows[], uint16 highs[]);

#endif 
