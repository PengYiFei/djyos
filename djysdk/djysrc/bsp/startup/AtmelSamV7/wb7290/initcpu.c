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
//�汾��      V1.0.0
//��ʼ�汾������ڣ�2013-05-27
//�ļ�����:  cpuʱ�ӳ�ʼ��
//����˵��:  ��
//�޶���ʷ:
//2. ...
//1. ����: 2014-01-20
//   ����: lst
//   �°汾�ţ�V1.0.0
//   �޸�˵��: �����ǳ���,������֤Ŀ��
//		��һ���������ж�ʱ���Ƿ��Ѿ�����Ĵ���
//------------------------------------------------------
#include "stdint.h"
#include "cpu_peri.h"
#include "hard-exp.h"
#include "arch_feature.h"
#include <samv7/samv71.h>
#include "core_cmFunc.h"
#include "IAP.h"
#include "cfg/Iboot_config.h"
#include "cpu_peri.h"

#ifndef __CHECK_DEVICE_DEFINES
#define __CHECK_DEVICE_DEFINES
#endif

#include "core_cm7.h"

extern   uint32_t   msp_top[ ];
extern void __set_PSP(uint32_t topOfProcStack);
extern void __set_PRIMASK(uint32_t priMask);
extern void __set_FAULTMASK(uint32_t faultMask);
extern void __set_CONTROL(uint32_t control);

extern void SysClk_Init(void);
extern void IAP_SelectLoadProgam(void);
extern char g_cIbootFlag[];

struct ScbReg volatile * const startup_scb_reg
                        = (struct ScbReg *)0xe000ed00;
void Startup_NMI(void)
{
    while(1);
}
void Startup_Hardfault(void)
{
    while(1);
}
void Init_Cpu(void);
const u32 gc_u32StartupExpTable[4] =
{
    (u32)msp_top,
    (u32)Init_Cpu,
    (u32) Startup_NMI,
    (u32) Startup_Hardfault
};
void Init_Cpu(void)
{
	__set_PSP((uint32_t)msp_top);
	__set_PRIMASK(1);
	__set_FAULTMASK(1);
	__set_CONTROL(0);

    #if (CN_CPU_OPTIONAL_FPU == 1)
        startup_scb_reg->CPACR = (3UL << 20)|(3UL << 22);    //ʹ��FPU
        startup_scb_reg->FPCCR = (1UL << 31);                //�ر�lazy stacking
    #endif
    switch(startup_scb_reg->CPUID)
    {
    }
    //�ع�
    WDT->WDT_MR = (1<<15);

    SysClk_Init();				//ϵͳ��ʱ�ӡ�����ʱ�ӡ�PLL��ʼ��


//    SDRAM_Init();				//SDRAM��ʼ��
#if (CN_CPU_OPTIONAL_CACHE == 1)
	SCB_EnableICache();			//ָ�����cacheʹ��
	SCB_EnableDCache();
#endif

	IAP_SelectLoadProgam();
}



void IAP_GpioPinInit(void)
{
	u32 count;
	const Pin iap_pin={PIO_PA28,PIOA,ID_PIOA,PIO_INPUT,PIO_DEFAULT};
	if ( (PMC->PMC_PCSR0 & ((uint32_t)1 << ID_PIOA)) != ((uint32_t)1 << ID_PIOA) )
	{
		PMC->PMC_PCER0 = 1 << ID_PIOA ;
	}
	Pio *Iap_pin=((Pio    *)0x400E0E00U);   //PIOA
	Iap_pin->PIO_IDR = PIO_PA28;
	Iap_pin->PIO_PUDR = PIO_PA28;
	Iap_pin->PIO_IFDR=PIO_PA28;
	Iap_pin->PIO_ODR=PIO_PA28;
	Iap_pin->PIO_PER=PIO_PA28;
	for(count=0;count<16000000;count++)
	{
	}
}
bool_t IAP_IsForceIboot(void)
{
	const Pin iap_pin={PIO_PA28,PIOA,ID_PIOA,PIO_INPUT,PIO_DEFAULT};
	unsigned int reg ;
	if ( (iap_pin.type == PIO_OUTPUT_0) || (iap_pin.type == PIO_OUTPUT_1) )
	{
		reg = iap_pin.pio->PIO_ODSR ;
	}
	else
	{
		reg = iap_pin.pio->PIO_PDSR ;
	}
	if ( (reg & ((1u << 28))) == 0 )
	{
		return false ;
	}
	else
	{
		return true ;
	}
}
bool_t IAP_IsRamIbootFlag(void)
{
	u8 i;
	char bootflag[8]="RunIboot";
	for(i=0;i<8;i++)
	{
		if(g_cIbootFlag[i]!=bootflag[i])
		{
			return false;
		}
	}
	return true;
}