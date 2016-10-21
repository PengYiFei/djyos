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
//����ģ��:  �쳣ģ��
//���ߣ�     lst
//�汾��      V1.00
//��ʼ�汾������ڣ�2009-08-30
//�ļ�����:  ϵͳ�쳣ģ���еĻ�ಿ��
//����˵��:  ��
//�޶���ʷ:
//2. ����: 2013-05-24
//   �޸���: ����
//   ˵��: ֱ�ӰѴ��뿽��һ��,����cortex-m4�Ķ�Ӧ����
//1. ����:
//   ����:
//   �°汾�ţ�
//   �޸�˵��:
//------------------------------------------------------


.syntax         unified
.cpu            cortex-m7
//.fpu            fpv4-sp-d16 //���嵽IDE����
.thumb
.file   "hard-exps.S"

//���첽�ź�ʹ�ܲ��������ȣ����������л��лָ��첽�źżĴ�����ͬ��ʹ���첽�ź�
.macro restore_asyn_signal_reg
    bl Int_ContactAsynSignal
.endm




/**** ������������ ****/
.text
.align 2
.global default_handler
.thumb
.thumb_func
default_handler:
    b       default_handler

.global HardExp_NmiHandler
.thumb_set HardExp_NmiHandler, default_handler

/*
@ ------------------------------------------------------------------------------
@ ����:�����쳣ʱ�����ֳ��ͻָ��ֳ��Ĺ�����ѹջR4-R11,sp,�����ѹջs16-s31���������쳣
@      ��������handler���������쳣������������fpu_used���ֳ���ջ����ʼ��ַ�Բ�������ʽ
@      ���ݵ��쳣������
@ �������쳣��������ַ
@ ------------------------------------------------------------------------------
*/
.text
.align 2
.global exp_status_handler
.thumb
.thumb_func
exp_status_handler:
    TST     LR,#0x4
    ITE     EQ
    MRSEQ   R1,MSP              /* ��ʹ�õ�������ջ���ʰ�MSP��ֵȡ�� */
    MRSNE   R1,PSP

    ADD     R2,R1,#32           /* R2�д洢���Ƿ����쳣ʱ��ջָ��*/

    STMFD   R1!,{R4-R11}        /* ����R4-R11�����жϵ�ջ*/
    STMFD   R1!,{R2}            /* ѹջ�����쳣ʱ��ջָ��*/

    TST     R14,#0x10
    ITTTE   EQ
    ADDEQ   R2,#72
    MOVEQ   R0,#1
    VSTMDBEQ R1!,{S16-S31}
    MOVNE   R0,#0

    TST     LR,#0x4
    ITE     EQ
    MSREQ   MSP,R1              /* ��ʹ�õ�������ջ���ʰ�MSP��ֵȡ�� */
    MSRNE   PSP,R1

    PUSH    {R0,LR}             /* ��������ֵ��������Ҫ�õ� */

    BLX     R3

    POP     {R0,LR}
    TST     LR,#0x4
    ITE     EQ
    MRSEQ   R0,MSP              /* ��ʹ�õ�������ջ���ʰ�MSP��ֵȡ�� */
    MRSNE   R0,PSP

    TST     R14,#0x10
    IT      EQ
    VLDMIAEQ R0!,{S16-S31}

    LDMFD   R0!,{R2}
    LDMFD   R0!,{R4-R11}

    TST     LR,#0x4
    ITE     EQ
    MSREQ   MSP,R0              /* ��ʹ�õ�������ջ���ʰ�MSP��ֵȡ�� */
    MSRNE   PSP,R0

    BX      LR

/*
@ ------------------------------------------------------------------------------
@ ����:Hard�쳣�����������쳣ʱ���ں˻��Զ�����R0-R3,R12,lr,pc,xpsr,�ڻ���� Ϊ�˱�
@      ���ֳ����Ὣʣ�µ�R4-R11ѹջ��Ӳ���쳣�����������쳣����
@ ����:��
@ ------------------------------------------------------------------------------
*/
.text
.align 2
.global HardExp_HardfaultHandler
.thumb
.thumb_func
HardExp_HardfaultHandler:
    LDR     R3,=Exp_HardFaultHandler
    B       exp_status_handler

/*
@ ------------------------------------------------------------------------------
@ ����:MEM �쳣�����������쳣ʱ���ں˻��Զ�����R0-R3,R12,lr,pc,xpsr,�ڻ���� Ϊ�˱�
@      ���ֳ����Ὣʣ�µ�R4-R11ѹջ��һ��������MPU�������µķ���Υ��������쳣
@ ����:��
@ ------------------------------------------------------------------------------
*/
.text
.align 2
.global HardExp_MemfaultHandler
.thumb
.thumb_func
HardExp_MemfaultHandler:
    LDR     R3,=Exp_MemManageFaultHandler
    B       exp_status_handler

/*
@ ------------------------------------------------------------------------------
@ ����:BusFault�����������쳣ʱ���ں˻��Զ�����R0-R3,R12,lr,pc,xpsr,�ڻ���� Ϊ�˱�
@      ���ֳ����Ὣʣ�µ�R4-R11ѹջ
@ ����:��
@ ------------------------------------------------------------------------------
*/
.text
.align 2
.global HardExp_BusfaultHandler
.thumb
.thumb_func
HardExp_BusfaultHandler:
    LDR     R3,=Exp_BusFaultHandler
    B       exp_status_handler

/*
@ ------------------------------------------------------------------------------
@ ����:Debug�쳣�����������쳣ʱ���ں˻��Զ�����R0-R3,R12,lr,pc,xpsr,�ڻ���� Ϊ�˱�
@      ���ֳ����Ὣʣ�µ�R4-R11ѹջ
@ ����:��
@ ------------------------------------------------------------------------------
*/
.text
.align 2
.global HardExp_DbgHandler
.thumb
.thumb_func
HardExp_DbgHandler:
    b       HardExp_DbgHandler

.text
.align 2
.global HardExp_PendsvHandler
.thumb
.thumb_func
HardExp_PendsvHandler:
    b       HardExp_PendsvHandler

/*
@ ------------------------------------------------------------------------------
@ ����:USAGE FAULT �쳣�����������쳣ʱ���ں˻��Զ�����R0-R3,R12,lr,pc,xpsr,�ڻ��
@      �� Ϊ�˱����ֳ����Ὣʣ�µ�R4-R11ѹջ�����ջ�����ε�������
@ ����:R0�б����˷����쳣ʱ��ջ�������ֳ�
@ ------------------------------------------------------------------------------
*/
.text
.align 2
.global HardExp_UsagefaultHandler
.thumb
.thumb_func
HardExp_UsagefaultHandler:
    LDR     R3,=Exp_UsageFaultHandler
    B       exp_status_handler
/*
@ ------------------------------------------------------------------------------
@ ����:SYSTICK �쳣�����������쳣ʱ���ں˻��Զ�����R0-R3,R12,lr,pc,xpsr,�ڻ��
@      �� Ϊ�˱����ֳ����Ὣʣ�µ�R4-R11ѹջ�����������غ󣬻ָ��ֳ���������
@ ����:��
@ ------------------------------------------------------------------------------
*/
.text
.align 2
.global HardExp_SystickHandler
.thumb
.thumb_func
HardExp_SystickHandler:
    PUSH    {R0,LR}             /* r0ֻ��Ϊ������ջָ��8�ֽڶ��������� */
    LDR     R0,=0xe000e010
    LDR     R0,[R0]
    MRS     R0,psp

    TST     R14, #0x10          /* ����EXC_RETURN�ı���4 */
    IT      EQ                  /* ���Ϊ0 */
    VSTMDBEQ R0!,{S16-S31}      /* �ֶ�ѹջFPU�Ĵ��� */

    STMFD   R0!,{r4-r11}        /* �����Ĵ���,�Լ����ص�ַ */
    STMFD   R0!,{R14}
    MSR     PSP,R0
    BL      Exp_SystickTickHandler
    POP     {R0,LR}
    mrs     R0,PSP

    LDMFD   R0!,{R14}
    LDMFD   R0!,{R4-R11}

    TST     R14, #0x10          /* ����EXC_RETURN�ı���4 */
    IT      EQ                  /* ���Ϊ0 */
    VLDMIAEQ R0!,{S16-S31}      /* �ֶ�ѹջFPU�Ĵ��� */

    MSR     PSP,R0
    BX      LR

/*
@ ------------------------------------------------------------------------------
@ ����:SVC���� �쳣������SVC�쳣��Ҫ�������߳��л�������Ҫ�����߳��л�ʱ��ʹ��SVCָ��
@      ������Ӧ�Ĳ������ݵ��쳣���쳣����SVC���ж�SVC����
@ ����:SVC��
@ -------------------------------------------------------------------------------
*/
.text
.align 2
.global HardExp_SvcHandler
.thumb
.thumb_func
HardExp_SvcHandler:
//����SVCʱ��M4�Զ�ѹջ��,����svc 0 and svc 1��
//svcΪ0ʱ����svc_handler���뱣���ֳ�����Ϊ�ڽ���ʱ�Ѿ����ֳ������˻����뱣���ֳ�����μ�
//cpus.S__asm_start_thread��ĺ�����sp�Ѿ�����Ϊnew_vm��ջ��
//svcΪ1ʱ����ʾ�����߳�֮����л�������豣���ֳ�����Ӧ__asm_start_thread
    PUSH    {LR}
    restore_asyn_signal_reg
    POP     {LR}
    TST     LR,#0x4             /* ����EXC_RETURN�ı���2 */
    ITE     EQ                  /* ���Ϊ0 */
    MRSEQ   R0,MSP              /* ��ʹ�õ�������ջ���ʰ�MSP��ֵȡ�� */
    MRSNE   R0,PSP              /* ����, ʹ�õ��ǽ��̶�ջ���ʰ�PSP��ֵȡ�� */

    LDR     R2,[R0,#24]         /* ��ջ�ж�ȡPC��ֵ */
    LDRB    R2,[R2,#-2]         /* ��SVCָ���ж�ȡ�������ŵ�R2 */
    CMP     R2,#1               /* svc��Ϊ 1,ֻ��һ��SVC����Ҫѹջ */
    ITTEE   EQ
    LDREQ   R2,[R0]             /* ����new_vmջ�������ݴ���R2*/
    LDREQ   R2,[R2]
    ADDNE   R2,R0,#36
    BNE     svc_switch          /* Ŀǰֻ֧��0��svc���� */

    TST     R14, #0x10          /* ����EXC_RETURN�ı���4 */
    IT      EQ                  /* ���Ϊ0 */
    VSTMDBEQ R0!,{S16-S31}      /* �ֶ�ѹջFPU�Ĵ��� */
    STMFD   R0!,{R4-R11}        /* �ֶ�ѹջ�ں˼Ĵ�����ѹջR14��Ϊ���´�����ʱ��ѯ�Ƿ���pop FPU�Ĵ��� */
    STMFD   R0!,{R14}

    STR     R0, [R1]            /* �������̵߳�old_vm->stack */

svc_switch:                     /* svcΪ0ʱ��ֻ�赯�����̼߳���*/
    LDMFD   R2!,{R14}           /* ��R14�пɵ�֪�Ƿ���pop FPU�Ĵ��� */
    LDMFD   R2!,{R4-R11}        /* �ֹ�����r4-r11 */

    TST     R14, #0x10          /* ����EXC_RETURN�ı���4 */
    IT      EQ                  /* ���Ϊ0 */
    VLDMIAEQ R2!,{S16-S31}      /* �ֶ�ѹջFPU�Ĵ��� */
    MSR     PSP,R2              /* pspָ�������������� */

    BX      LR                  /* ���أ�ʵ�ʵ����Ľ��Ǵ����������� */
.end
