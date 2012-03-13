/******************************************************************************
* File:    isr.h
* Purpose: Define interrupt service routines referenced by the vector table.
* Note: Only "vectors.c" should include this header file.
******************************************************************************/

#ifndef __ISR_H
#define __ISR_H 1


/* Example */
#undef    VECTOR_084
#define   VECTOR_084  PIT0_ISR

#undef    VECTOR_085
#define   VECTOR_085 PIT1_ISR

#undef    VECTOR_086
#define   VECTOR_086 PIT2_ISR

#undef    VECTOR_087
#define   VECTOR_087 PIT3_ISR


#undef    VECTOR_103
#define   VECTOR_103  ISR_PTA


#undef    VECTOR_106
#define   VECTOR_106  ISR_PTD


extern void PIT0_ISR(void);
extern void PIT1_ISR(void);
extern void PIT2_ISR(void);
extern void PIT3_ISR(void);

extern void ISR_PTA();
extern void ISR_PTD();
// ISR(s) are defined in your project directory.


#endif  //__ISR_H

/* End of "isr.h" */
