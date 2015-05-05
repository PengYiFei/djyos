//----------------------------------------------------
// Copyright (c) 2014, SHENZHEN PENGRUI SOFT CO LTD. All rights reserved.

// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:

// 1. Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//-----------------------------------------------------------------------------
// Copyright (c) 2014 ����Ȩ�����������������޹�˾���С�����Ȩ�˱���һ��Ȩ����
//
// �����Ȩ�����ʹ���߷������������������£�����ʹ����ʹ�ü���ɢ����
// ������װԭʼ�뼰����λ��ִ����ʽ��Ȩ�������۴˰�װ�Ƿ񾭸�����Ȼ��
//
// 1. ���ڱ�����Դ�������ɢ�������뱣�������İ�Ȩ���桢�������б�����
//    ������������������
// 2. ���ڱ��׼�����λ��ִ����ʽ����ɢ���������������ļ��Լ�������������
//    ��ɢ����װ�е�ý�鷽ʽ����������֮��Ȩ���桢�������б����Լ�����
//    ������������

// �����������������Ǳ�������Ȩ�������Լ�����������״��"as is"���ṩ��
// ��������װ�����κ���ʾ��Ĭʾ֮�������Σ������������ھ��������Լ��ض�Ŀ
// �ĵ�������ΪĬʾ�Ե�������Ȩ�����˼�������֮�����ߣ������κ�������
// ���۳�����κ��������塢���۴�����Ϊ���Լ��ϵ���޹�ʧ������������Υ
// Լ֮��Ȩ��������ʧ������ԭ��ȣ����𣬶����κ���ʹ�ñ�������װ��������
// �κ�ֱ���ԡ�����ԡ�ż���ԡ������ԡ��ͷ��Ի��κν�����𺦣�����������
// �������Ʒ������֮���á�ʹ����ʧ��������ʧ��������ʧ��ҵ���жϵȵȣ���
// �����κ����Σ����ڸ���ʹ���ѻ���ǰ��֪���ܻ���ɴ����𺦵���������Ȼ��
//-----------------------------------------------------------------------------
//����ģ��:  CPU��ʼ��
 //���ߣ�     lst
 //�汾��      V1.1.0
 //�ļ�����:  CPU��ʼ�������û������ʵ�ֵĲ���
//����˵��:  ��
//�޶���ʷ:
 //2. ����: 2009-10-30
 //  ����: lst
//  �°汾�ţ�V1.1.0
 //  �޸�˵��: ���ڴ��ʱ����C���Գ�ʼ��
 //1. ����: 2009-03-10
 //  ����: lst
 //   �°汾�ţ�V1.0.0
 //  �޸�˵��: s3c2440��ԭʼ�汾
 //------------------------------------------------------

#define R1_M    (1<<0)
#define R1_A    (1<<1)
#define R1_C    (1<<2)
#define R1_W    (1<<3)
#define R1_Z    (1<<11)
#define R1_I    (1<<12)
#define R1_V    (1<<13)
#define R1_RR   (1<<14)
#define R1_VE   (1<<24)
#define R1_nF   (1<<30)
#define R1_iA   (1<<31)


.cpu	arm920t
.fpu	softvfp
.file	"initcpu.S"

#include "arm_mode_s_file.h"
.section .text._start, "ax", %progbits
.align  2
.global _start
_start:        /* ��λ������ַ */

    mrs     r0, cpsr                  /* ȡCPSR */
    bic     r0, r0, #SF_MODEMASK   /* ��ģʽλ */
    orr     r1, r0, #(SF_SVCMODE|SF_IRQ_BIT|SF_FIQ_BIT)    /* ����Ϊ����̬������ֹ�ж� */
	msr		cpsr,r1

    ldr     r0,=WTCON           /* ��ֹ���Ź� */
    ldr     r1,=0x0
    str     r1,[r0]

    ldr		r0,=R1_I|R1_C|R1_V
    mcr     p15, 0, r0, c1, c0, 0
	

/* ��ʼ��ջָ�� */
    mrs     r0, cpsr
    bic     r0, r0, #SF_MODEMASK

    orr		r0, r0, #SF_IRQ_BIT|SF_FIQ_BIT

    orr     r1, r0, #SF_UNDEFMODE
    msr     cpsr_cxsf, r1
    ldr     sp, =undef_top

    orr     r1, r0, #SF_ABORTMODE
    msr     cpsr_cxsf, r1
    ldr     sp, =abort_top

    orr     r1, r0, #SF_IRQMODE
    msr     cpsr_cxsf, r1
    ldr     sp, =irq_top

    orr     r1, r0, #SF_FIQMODE
    msr     cpsr_cxsf, r1
    ldr     sp, =fiq_top

    orr     r1, r0, #SF_SVCMODE
    msr     cpsr_cxsf, r1
    ldr     sp, =svc_top

    orr     r1, r0, #SF_SYSMODE
    msr     cpsr_cxsf, r1
      
    ldr		sp,=0x40000400 /*SDRAM������ʹ�ã���ʱʹ���ڲ�SRAM��ΪStack.*/
	
    bl		Init_CpuClk
    bl      Mem_BusInit

    ldr		r0,=R1_I
    mcr     p15, 0, r0, c1, c0, 0
    
    ldr     sp, =usr_top	
       
    bl		MMU_Init

    ldr		r0,=R1_M|R1_I|R1_C|R1_V
    mcr     p15, 0, r0, c1, c0, 0
	nop
	nop
	nop
	nop
	ldr		r0,=0xFFFF0000
	ldr		r1,=isr_vector
	ldr		r2,=isr_vector_end
copy_isr:
	ldmia	r1!,{r4-r7}
	stmia	r0!,{r4-r7}
	cmp		r1,r2
	bcc		copy_isr
	nop
	nop
    bl      Load_Preload


.end
