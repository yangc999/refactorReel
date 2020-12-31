
local SlotsConst = import("..config.SlotsConst")
local SlotsCustom = import("..config.SlotsCustom")
local DriverGear = import(".DriverGear")
local DriverProvider = import(".DriverProvider")
local DriverBearing = class("DriverBearing")

function DriverBearing:ctor(ob, evt)
    self.ob = ob
    self.evt = evt

    self.fsm = cc.load("fsm").FSM.create({
        initial = {state = "ready", event = "init", defer = true}, 
        events = {
            {name = "start", from = "ready", to = "wait"}, 
            {name = "go",  from = "wait", to = "spin"}, 
            {name = "delay", from = "spin", to = "continue"}, 
            {name = "timeout", from = "continue", to = "will"}, 
            {name = "stop", from = "spin", to = "will"}, 
            {name = "brake",  from = "will", to = "over"}, 
            {name = "bottom",  from = "over", to = "bounce"}, 
            {name = "freeze",  from = "bounce", to = "ready"}, 
        }, 
        callbacks = {
            --event
            on_init = function(fsm, event, from, to, msg)
                
            end, 
            on_start = function(fsm, event, from, to, msg)
                for _, v in ipairs(self.gearList) do
                    v.show = false
                    v.ready = false
                    v.anim = ""
                end
            end, 
            on_freeze = function(fsm, event, from, to, msg)
                self.evt:dispatchEvent({name="bearing_freeze"})
            end, 
            --state
            on_ready = function(fsm, event, from, to, msg)
                self:resetTime()
                self.updateHandler = nil
            end, 
            on_wait = function(fsm, event, from, to, msg)
                self.updateHandler = self.doWait
            end, 
            on_spin = function(fsm, event, from, to, msg)
                self.updateHandler = self.doSpin
            end, 
            on_continue = function(fsm, event, from, to, msg)
                self.updateHandler = self.doContinue
            end, 
            on_will = function(fsm, event, from, to, msg)
                self:willStop()
                fsm.brake()
            end, 
            on_leave_will = function(fsm, event, from, to, msg)
                self:begStop()
            end, 
            on_over = function(fsm, event, from, to, msg)
                self.updateHandler = self.doOver
            end, 
            on_bounce = function(fsm, event, from, to, msg)
                self.updateHandler = self.doBounce
            end, 
        }, 
    })

    --slots event


    ----------------------初始化轴承数据------------------------
        
    self.ViewType = 0               -- 呈现类型 上对齐，中对齐，下对齐
    self.idx = 0                    -- 当前一条轴承的索引,1开头，就是第一条滚轴，1，2，3，4，5等

    self.ShowVarGearN = 0           -- 当前一条轴承的实际显示齿轮个数（可动态调整）
    self.WishGearN = 0              -- 当前一条轴承的预期创建的齿轮个数（不可动态调整,比如：普通显示3个，特殊时候向上多显示2个，则为：5）
        -- * 当前一条轴承的最终创建的齿轮个数（考虑格子高度，一般比预期多创建 2*wish+2*maxLink 个）
    self.FinalGearN = 0 

    self.ViewShowColMaxGearN = 0        -- 整个版面(所有轴承中、普通模式下)的轴承的齿轮最大个数，比如每列个数 2，3，4，3，2 最大的是4个元素
    self.lineWidth = 0                  -- 表示当前滚轴的分割线的宽度

    self.ViewMaxLinkGearN = 0           -- 表示一个齿轮最大的格数，比如 有些元素是2格或者是3格

    self.height = 0                 -- 表示一个普通格子的高度
    self.width = 0                  -- 表示一个普通格子的宽度
        

    ----------------------运行数据------------------------

    self.ShowVarStopTop = 0             -- 视图按照左下角为(0,0)，这里是当前滚轴的停止位置，根据这个位置开始指定定停止的标记号
    self.ShowVarStopBottom = 0          -- 视图按照左下角为(0,0)，这里是当前滚轴的停止位置，根据这个位置开始停止动作
    self.WishTop = 0                    -- 视图的最高点: 显示个数高度+超出一个最大格数 的高度
    self.WishBottom = 0                 -- 视图的最低点: 0点以下的一个最大格数 的高度

    self.delayTime  = 0             -- 计算该滚轴开始滚动的延迟时间，比如后一个比前一个延迟多少，同时滚动设置为0
    self.moveTime   = 0             -- 计算该滚轴的运动时间，越向后的滚轴运动时间越长，这样梯度停止

    -- * 向下缓动
    self.stopDownTime   = 0         -- 计算该滚轴的停止时间，每个滚轴的停止时间一样
    self.stopDownDis    = 0
    self.stopDownDisAdd     = 0
    self.mathDown       = 1
    self.pReleaseStopDownTime   = 0     -- 动态变量

    -- * 向上缓动
    self.stopUpTime     = 0             -- 计算该滚轴的停止时间，每个滚轴的停止时间一样
    self.stopUpDis      = 0
    self.mathUp         = 1
    self.pReleaseStopUpTime     = 0     -- 动态变量

    self.pReleaseDelayTime  = 0     -- 动态变量
    self.pReleaseMoveTime   = 0     -- 动态变量
        
    ----------------------外部控制数据------------------------

    self.autoStop       = true      -- 是否自动停止模式
    self.userStop       = false     -- 是否用户手动停止
    self.msgBack        = false     -- 是否数据是否返回
    self.beforeBearingStop = false      -- 前一个齿轮是否停止
    self.turbo          = false     -- 是否处于加速模式

    ----------------------缓动数据------------------------

    self.stopTopGear = nil
    self.stopCenterGear = nil
    self.stopBottomGear = nil

    self.stopTag = 0
    self.dis = 0

    ----------------------数据------------------------

    self.gearList = nil
end

function DriverBearing:initData(cfg)
    self.ViewType               = cfg.viewType
    self.idx                    = cfg.index
    self.ShowVarGearN           = cfg.show
    self.WishGearN              = cfg.wish
    self.ViewShowColMaxGearN    = cfg.row
    self.ViewMaxLinkGearN       = cfg.cellMaxNum
    self.width                  = cfg.cellWidth
    self.height                 = cfg.cellHeight
    self.lineWidth              = cfg.lineWidth

    self.ob[self.idx] = {}
    self.gearList = self.ob[self.idx]

    -- * 计算
    self.FinalGearN = self.WishGearN*2 + self.ViewMaxLinkGearN*2
        
    if self.ViewType == SlotsConst.VIEW_TYPE.CENTER then -- center
        self.ShowVarStopBottom  = (self.ViewShowColMaxGearN - self.ShowVarGearN)*self.height*0.5 + self.height*0.5
        self.ShowVarStopTop     = (self.ViewShowColMaxGearN - self.ShowVarGearN)*self.height*0.5 + self.height*0.5 + (self.ShowVarGearN - 1)*self.height
        self.WishBottom         = (self.ViewShowColMaxGearN - self.WishGearN)*self.height*0.5 - (self.ViewMaxLinkGearN)*self.height
        self.WishTop            = (self.ViewShowColMaxGearN - self.WishGearN)*self.height*0.5 + (self.FinalGearN - self.ViewMaxLinkGearN)*self.height 
    elseif self.ViewType == SlotsConst.VIEW_TYPE.TOP then  -- top
        self.ShowVarStopBottom  = (self.ViewShowColMaxGearN)*self.height - self.height*0.5 - (self.ShowVarGearN - 1)*self.height
        self.ShowVarStopTop     = (self.ViewShowColMaxGearN)*self.height - self.height*0.5
        self.WishBottom         = (self.ViewShowColMaxGearN + self.ViewMaxLinkGearN)*self.height - (self.FinalGearN)*self.height
        self.WishTop            = (self.ViewShowColMaxGearN + 1)*self.height
    elseif self.ViewType == SlotsConst.VIEW_TYPE.BOTTOM then  -- bottom
        self.ShowVarStopBottom  = self.height*0.5
        self.ShowVarStopTop     = self.height*0.5 + (self.ShowVarGearN - 1)*self.height
        self.WishBottom         = -(self.ViewMaxLinkGearN)*self.height
        self.WishTop            = (self.FinalGearN - self.ViewMaxLinkGearN)*self.height
    end

    self.delayTime  = (self.idx - 1)*SlotsCustom.AMI.delayTime
    self.moveTime   = SlotsCustom.AMI.time + (self.idx - 1)*SlotsCustom.AMI.gapTime

    self:createGear()

    self.fsm.init()
end

function DriverBearing:createGear()
    local dataSource = DriverProvider:getInstance()
    local finalGearN = self.FinalGearN
    for i=1, finalGearN do
        local gear = DriverGear.new()
        gear.tag        = i                     -- 标记一个最小单元格序号
        gear.width      = self.width            -- 标记一个最小单元宽度
        gear.height     = self.height           -- 标记一个最小单元高度
        gear.maxLink    = 1                     -- 标记一个本单元格的个数
        gear.posx       = self.width*0.5 + (self.idx - 1)*self.width + (self.idx - 1)*self.lineWidth -- 标记一个本单元格的x位置
        gear.posy       = self:gearY(finalGearN, i)     -- 标记一个本单元格的y位置
        gear.zorder     = i + (self.idx - 1)*self.FinalGearN   -- 标记一个本单元格的层级
        gear.row        = i                     -- 标记一个本单元格的横序号
        gear.col        = self.idx              -- 标记一个本单元格的竖序号
        gear.element    = dataSource.sdata.elementInitList[self.idx][i]

        table.insert(self.gearList, gear)
    end
end

function DriverBearing:resetCount()
    self.pReleaseMoveTime       = self.moveTime
end

function DriverBearing:resetTime()
    self.stopDownTime           = SlotsCustom.AMI.stopDownTime
    self.stopDownDis            = 0
    self.stopDownDisAdd         = 0
    self.mathDown               = 1
    self.pReleaseStopDownTime   = self.stopDownTime

    self.stopUpTime             = SlotsCustom.AMI.stopUpTime
    self.stopUpDis              = 0
    self.mathUp                 = 1
    self.pReleaseStopUpTime     = self.stopUpTime

    self.pReleaseDelayTime      = self.delayTime
    self.pReleaseMoveTime       = self.moveTime
end

function DriverBearing:gearY(finalGearN, row)
    local posY = (finalGearN - row - self.ViewMaxLinkGearN)*self.height + self.height*0.5
    if self.ViewType == SlotsConst.VIEW_TYPE.CENTER then
        posY = posY + (self.ViewShowColMaxGearN - self.WishGearN)*self.height*0.5
    elseif self.ViewType == SlotsConst.VIEW_TYPE.TOP then  -- top
        posY = (self.ViewShowColMaxGearN + self.ViewMaxLinkGearN - row)*self.height + self.height*0.5
    elseif self.ViewType == SlotsConst.VIEW_TYPE.BOTTOM then  -- bottom
    end
    return posY
end

function DriverBearing:tryStop()
    if self.fsm.current == "spin" then
        if self.pReleaseMoveTime > 0 then
            self.fsm.delay()
        else
            self.fsm.stop()
        end
    end
end

function DriverBearing:update(dt)
    if self.updateHandler then
        self:updateHandler(dt)
    end
end

function DriverBearing:doWait(dt)
    if self.pReleaseDelayTime > 0 then 
        self.pReleaseDelayTime = self.pReleaseDelayTime - dt
    else
        self.fsm.go()
    end
end

function DriverBearing:doSpin(dt)
    self.pReleaseMoveTime = self.pReleaseMoveTime - dt
    self:move()
end

function DriverBearing:doContinue(dt)
    self.pReleaseMoveTime = self.pReleaseMoveTime - dt
    self:move()
    if self.pReleaseMoveTime <= 0 then
        self.fsm.timeout()
    end
end

function DriverBearing:doOver(dt)
    if self.pReleaseStopDownTime > 0 then
        self.pReleaseStopDownTime = self.pReleaseStopDownTime - dt

        if self.pReleaseStopDownTime <= 0 then
            self.pReleaseStopDownTime = 0
        end

        local downTime = self.pReleaseStopDownTime/self.stopDownTime

        -- local resDown = 1 - math.sin(math.acos(downTime))
        -- resDown = math.pow(resDown, 0.8)

        -- local resDown=math.pow(downTime,2.5)
        local resDown = math.pow(downTime, 1.5)
        self.dis = (self.mathDown - resDown)*self.stopDownDis
        self.mathDown = resDown

        -- if (self.stopDownDisAdd + self.dis) >= self.stopUpDis then
        --  self.dis = self.stopUpDis - self.stopDownDisAdd

        --  self.pReleaseStopDownTime = 0
        --  self.stopDownDisAdd = 0
        -- else
        --  self.stopDownDisAdd = self.stopDownDisAdd + self.dis
        -- end
        if (self.stopDownDisAdd + self.dis) >= self.stopDownDis then
            self.dis = self.stopDownDis - self.stopDownDisAdd

            self.pReleaseStopDownTime = 0
            self.stopDownDisAdd = 0
        else
            self.stopDownDisAdd = self.stopDownDisAdd + self.dis
        end

        self:moveList(self.dis)
        
        if self.stopCenterGear ~= nil then
            if (self.stopCenterGear.posy - (self.ShowVarStopBottom + (self.ShowVarStopTop - self.ShowVarStopBottom)*0.6)) <= 0 then
                self.stopCenterGear = nil
                -- 通知下一个滚轴可以停止了
                self.evt:dispatchEvent({name="bearing_next", idx=self.idx})
            end
        end

        if self.stopBottomGear ~= nil then
            if (self.stopBottomGear.posy - self.ShowVarStopBottom) <= 0 then
                self.stopBottomGear = nil
                -- 这里是一个滚轴接近停止，用于通知播放特殊出现的动画，如：scatter
                for _, v in ipairs(self.gearList) do
                    v.show = true
                    v.anim = "ami1"
                end
            end
        end
    else
        self.fsm.bottom()
    end
end

function DriverBearing:doBounce(dt)
    self.pReleaseStopUpTime = self.pReleaseStopUpTime - dt

    if self.pReleaseStopUpTime <= 0 then
        self.pReleaseStopUpTime = 0
    end

    local upTime = self.pReleaseStopUpTime/self.stopUpTime

    -- local resUp = math.sin(math.acos(1-upTime))
    -- resUp = math.pow(resUp, 2)
    local resUp = 1-math.pow(1-upTime,1.2)

    -- local resUp = math.pow(upTime, 3)
    self.dis = (self.mathUp - resUp)*self.stopUpDis
    self.mathUp = resUp

    self:moveList(-self.dis)

    if self.pReleaseStopUpTime == 0 then
        self.fsm.freeze()
    end
end

function DriverBearing:move()
    self.dis = SlotsCustom.AMI.speed
    
    if self.turbo == true then
        self.dis = SlotsCustom.AMI.super
    end

    self:moveList(self.dis)
end

function DriverBearing:moveList(dis)
    for _, v in ipairs(self.gearList) do
        self:moveCell(v, dis)
    end
end

function DriverBearing:moveCell(cell, dis)
    local posY = cell.posy - dis
    if posY > self.WishTop then
        posY = posY - self.WishTop + self.WishBottom
    elseif posY < self.WishBottom then
        posY = self.WishTop - (self.WishBottom - posY)
        -- 遇到这种情况，就是最下面的一个元素已经被移动到最上面了，就要重新排列层级问题
        local tag = cell.tag
        for _, v in ipairs(self.gearList) do
            v.zorder = (v.tag-tag+self.FinalGearN)%self.FinalGearN+1
        end
    end
    cell.posy = posY
end

function DriverBearing:willStop()
    local wishTop = self.WishTop
    -- 查找停止的规则，最接近上面停止位置规则
    for i, cell in ipairs(self.gearList) do
        if cell.posy > self.ShowVarStopTop and cell.posy < wishTop then
            wishTop = cell.posy
            self.stopTag = cell.tag
            self.stopTopGear    = cell
            self.stopCenterGear = cell
            self.stopBottomGear = cell
        end
    end
end

function DriverBearing:begStop()
    local isStop = false
    local subDis = 0

    if self.stopTopGear then
        isStop = true
        subDis = self.stopTopGear.posy - self.ShowVarStopTop
        self.stopDownDis = self.height*SlotsCustom.AMI.downParameter + (self.ShowVarGearN - 1)*self.height
        self.stopUpDis   = self.height*SlotsCustom.AMI.upParameter
        self.stopTopGear = nil
    end

    if not isStop then
        self:moveList(self.dis)
    else
        self:moveList(subDis)
        local showList = {}
        for i=1, self.ShowVarGearN do
            local tag = (self.stopTag - i + 1 + self.FinalGearN)%(self.FinalGearN)
            if tag == 0 then
                tag = self.FinalGearN
            end
            -- local tag = (self.stopTag-i+self.FinalGearN)%self.FinalGearN+1
            table.insert(showList, 1, tag)
        end
        self:swapElement(showList)
    end
end

function DriverBearing:swapElement(showList)
    local dataSource = DriverProvider:getInstance()
    for idx, tag in ipairs(showList) do
        local cell = self.gearList[tag]
        cell.element = dataSource.sdata.trueStrips[self.idx][idx]
        cell.ready = true
    end
end

function DriverBearing:dispose()
    self.ob = nil
    self.evt = nil
    self.gearList = nil
end

return DriverBearing