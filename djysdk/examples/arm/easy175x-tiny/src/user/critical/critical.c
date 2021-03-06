//----------------------------------------------------
//Copyright (C), 2004-2009,  luoshitian.
//版权所有 (C), 2004-2009,   罗侍田.
//所属模块:安全钩子
//作者:  罗侍田.
//版本：V1.0.0
//文件描述:安全钩子是必须在开机后尽可能快地执行的部分代码
//其他说明:
//修订历史:
//2. ...
//1. 日期: 2009-01-04
//   作者:  罗侍田.
//   新版本号: V1.0.0
//   修改说明: 原始版本
//------------------------------------------------------
#include "os_inc.h"
#include "cpu_peri.h"

//----配置全部IO扣--------------------------------------------------------------
//功能：除必须的外，全部配置成初始态，各功能口由相应的功能模块自行定义。
//参数：无
//返回：无
//------------------------------------------------------------------------------
void gpio_init(void)
{
}

void critical(void)
{
    gpio_init();        //建议早执行,因为硬件的初始状态可能关乎安全
}

