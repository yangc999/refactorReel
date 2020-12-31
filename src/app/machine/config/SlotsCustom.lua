
return {
        
    -- * 轴承的滚动数据参数

    AMI = {
        accArr              = {},   -- 初始掉落缓动步骤
        speed               = 30,   -- 匀速速度
        super               = 50,   --
        time                = 0.12, -- 滚动时间
        stopDownTime        = 0.2,  -- 滚轴向下停止时间
        stopUpTime          = 0.2,  -- 滚轴向上停止时间
        gapTime             = 0.2,  -- 滚轴之间运动时间差
        delayTime           = 0.0,  -- 滚轴开始执行的延迟时间时间 = (col)* amiDelayTime
        downParameter       = 0.2,--0.764,  -- 滚轴停止时下探的比例,该比例的单位是元素的高度一半
        upParameter         = 0.2,--0.764,  -- 滚轴停止时回弹的比例,该比例的单位是元素的高度一半
        superAddTime        = 2.0,  -- 时间加速
        quickStopTimeParameter = 2,  -- 快速停止的时间倍数参数
    },

}