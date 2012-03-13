//============================================================================
//�ļ����ƣ�common.h
//���ܸ�Ҫ��������оƬ�Ĵ���ӳ��ͷ�ļ������ͺ궨���
//��Ȩ���У����ݴ�ѧ��˼����Ƕ��ʽ����(sumcu.suda.edu.cn)
//���¼�¼��2011-11-13   V1.0     ��ʼ�汾
//         2011-12-20   V1.1     �淶�Ű�
//============================================================================


#ifndef _COMMON_H_
#define _COMMON_H_

//1 ͷ�ļ�
#include "MK60N512VMD100.h"   //�Ĵ���ӳ��ͷ�ļ�

//2 �궨��
//2.1 �洢���εĺ궨��
#pragma define_section relocate_code ".relocate_code" ".relocate_code" ".relocate_code" far_abs RX
#pragma define_section relocate_data ".relocate_data" ".relocate_data" ".relocate_data" RW
#pragma define_section relocate_const ".relocate_const" ".relocate_const" ".relocate_const" far_abs R
#define __relocate_code__   __declspec(relocate_code)
#define __relocate_data__   __declspec(relocate_data)
#define __relocate_const__  __declspec(relocate_const)

//2.2 �����жϵĺ궨��
#define ARM_INTERRUPT_LEVEL_BITS          4   //�ж����ȼ��궨��
#define EnableInterrupts  asm(" CPSIE i");    //�����ж�
#define DisableInterrupts asm(" CPSID i");    //�����ж�

//2.3 ��λ����λ����üĴ���һλ��״̬
#define BSET(bit,Register)  ((Register)|= (1<<(bit)))    //�üĴ�����һλ
#define BCLR(bit,Register)  ((Register) &= ~(1<<(bit)))  //��Ĵ�����һλ
#define BGET(bit,Register)  (((Register) >> (bit)) & 1)  //��üĴ���һλ��״̬

//2.2 ���ͱ����궨��
typedef unsigned char         uint8;  // �޷���8λ�����ֽ�
typedef unsigned short int    uint16; // �޷���16λ������
typedef unsigned long int     uint32; // �޷���32λ��������

typedef volatile uint8        vuint8;  // ���Ż��޷���8λ�����ֽ�
typedef volatile uint16       vuint16; // ���Ż��޷���16λ������
typedef volatile uint32       vuint32; // ���Ż��޷���32λ��������

typedef signed char           int8;   // �з���8λ��
typedef short int             int16;  // �з���16λ��
typedef int                   int32;  // �з���32λ��

typedef volatile int8         vint8;  // ���Ż��з���8λ��
typedef volatile int16        vint16; // ���Ż��з���16λ��
typedef volatile int32        vint32; // ���Ż��з���32λ��

typedef unsigned char     BYTE;  		/*unsigned 8 bit definition */
typedef unsigned short    WORD; 		/*unsigned 16 bit definition*/
typedef unsigned long     DWORD; 		/*unsigned 32 bit definition*/
typedef long int    	  LONG;  		/*signed 32 bit definition*/

#define NULL (void *)0
#define FALSE        0
#define TRUE         1


#endif 
