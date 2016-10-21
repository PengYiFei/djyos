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
// Copyright (C) 2012-2020 ��԰�̱��Զ������޹�˾ All Rights Reserved
// �ļ���     ��board.c
// ģ������: �����ز��ֳ�ʼ�������õ�
// ģ��汾: V1.00
// ������Ա: HM
// ����ʱ��: 5/11.2015
// =============================================================================

#include "stdint.h"
#include "stddef.h"
#include "os.h"
#include "cpu_peri.h"


// =============================================================================
// ���ܣ����ݾ���İ�����ô��ڵ�GPIO�����Ź��ܣ�����������أ����Ըú������ڸ��ļ���CPU
//      ��������ֱ�ӵ��øú�������ʼ�����ڵ�GPIO����
//      ��Ҫ����GPIO�˿ںʹ���ʱ��ʹ�ܡ�GPIO���á���ӳ�䡢ʱ�ӵ�
// ��������
// ���أ�true
// =============================================================================
bool_t Board_UartGpioInit(u8 SerialNo)
{
    GPIO_PowerOn(1);
    switch(SerialNo)
    {
    case CN_UART0:
        GPIO_CfgPinFunc(0,2,1);
        GPIO_CfgPinFunc(0,3,1);
        break;
    case CN_UART1:
        GPIO_CfgPinFunc(2,0,2);
        GPIO_CfgPinFunc(2,1,2);
        break;
//    case CN_UART2:
//        GPIO_CfgPinFunc(0,10,1);
//        GPIO_CfgPinFunc(0,11,1);
//        break;
    case CN_UART3:
        GPIO_CfgPinFunc(4,28,3);
        GPIO_CfgPinFunc(4,29,3);
        break;
    default:
        return false;
    }
    return true;
}

// =============================================================================
// ���ܣ�485ͨ��ʱ��˫������Ϊ���ͣ���GPIO�����ã����ǰ�˫�����˺����ɿ���
// ���������ں�
// ���أ���
// =============================================================================
void Board_UartHalfDuplexSend(u8 SerialNo)
{

}

// =============================================================================
// ���ܣ�485ͨ��ʱ��˫������Ϊ���գ���GPIO�����ã����ǰ�˫�����˺����ɿ���
// ���������ں�
// ���أ���
// =============================================================================
void Board_UartHalfDuplexRecv(u8 SerialNo)
{

}

// =============================================================================
// ���ܣ�Board_AdcGpioInit�����й�CPU�Դ�ADC0������GPIO��ʼ��
// ���������ں�
// ���أ���
// =============================================================================
void Board_AdcGpioInit(void)
{
	GPIO_CfgPinFunc(0,25,1);
	GPIO_CfgPinFunc(0,26,1);
	GPIO_CfgPinFunc(1,30,3);

	GPIO_CfgPinMode(0,25,CN_GPIO_MODE_OD_NOPULL);
	GPIO_CfgPinMode(0,26,CN_GPIO_MODE_OD_NOPULL);
	GPIO_CfgPinMode(1,30,CN_GPIO_MODE_OD_NOPULL);
}

