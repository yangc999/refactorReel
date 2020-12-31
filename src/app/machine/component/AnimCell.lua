
local SlotsConst = import("..config.SlotsConst")
local DriverProvider = import("..driver.DriverProvider")
local AnimCell = class("AnimCell", fgui.GComponent)

function AnimCell:ctor(ob, col, row)
    self.ob = ob
    self.col = col
    self.row = row

    self:setPivot(0.5, 0.5, true)

    self.animLoader = fgui.GLoader3D:create()
    self.animLoader:setPivot(0.5, 0.5, true)
    self.animLoader:setAlign(cc.TEXT_ALIGNMENT_CENTER)
    self.animLoader:setVerticalAlign(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    self:addChild(self.animLoader)

    --axis test
    -- local d = fgui.GGraph:create()
    -- local fill = cc.c4f(0, 1, 1, 1)
    -- local outer = cc.c4f(1, 0, 0, 1)
    -- d:drawRect(10, 10, 0, outer, fill)
    -- self:addChild(d)

    local root = string.format("slots_data.@%d.@%d", col, row)

    self.xVm = cc.load("mvvm").Watcher.new(self.ob)
    self.xVm:bind(string.format("%s.posx", root)):apply(function(x)
        self:setX(x)
    end):exec()

    self.yVm = cc.load("mvvm").Watcher.new(self.ob)
    self.yVm:bind(string.format("%s.posy", root)):apply(function(y)
        local height = self.ob:get("layout_data").rcHeight
        self:setY(height-y)
    end):exec()

    self.widthVm = cc.load("mvvm").Watcher.new(self.ob)
    self.widthVm:bind(string.format("%s.width", root)):apply(function(width)
        self.animLoader:setX(width/2)
        self:setWidth(width)
    end):exec()

    self.heightVm = cc.load("mvvm").Watcher.new(self.ob)
    self.heightVm:bind(string.format("%s.height", root)):apply(function(height)
        self.animLoader:setY(height/2)
        self:setHeight(height)
    end):exec()

    self.zorderVm = cc.load("mvvm").Watcher.new(self.ob)
    self.zorderVm:bind(string.format("%s.zorder", root), string.format("%s.element", root)):filter(function(zorder, element)
        local dataSource = DriverProvider:getInstance()
        local prototype
        for _, v in ipairs(dataSource.sdata.elementUnitList) do
            if v.id == element then
                prototype = v
            end
        end
        local priority = self:iconZorder(prototype.type)
        return zorder + priority
    end):apply(function(zorder)
        self:setSortingOrder(zorder)
    end):exec()

    self.animVm = cc.load("mvvm").Watcher.new(self.ob)
    self.animVm:bind(string.format("%s.element", root)):filter(function(idx)
        return string.format("ui://Icon/slots_%d_anim", idx)
    end):apply(function(url)
        self.animLoader:setURL(url)
    end):exec()

    self.playVm = cc.load("mvvm").Watcher.new(self.ob)
    self.playVm:bind(string.format("%s.anim", root)):apply(function(name)
        self.animLoader:setAnimationName(name)
    end):exec()

    self.visVm = cc.load("mvvm").Watcher.new(self.ob)
    self.visVm:bind(string.format("%s.show", root), string.format("%s.ready", root)):filter(function(visable, ready)
        return visable and ready
    end):apply(function(flag)
        self.animLoader:setVisible(flag)
    end):exec()
end

function AnimCell:iconZorder(ntype, unitNum)
    if ntype == SlotsConst.SLOTS_ELEMENT_TYPE.normal then
        return SlotsConst.SLOTS_ELEMENT_ZORDER.low
    elseif ntype == SlotsConst.SLOTS_ELEMENT_TYPE.important then
        -- if unitNum and unitNum >= 2 then -- 多于2个格子的重要元素被认为特殊层级
        --  return SlotsConst.SLOTS_ELEMENT_ZORDER.normalS
        -- end
        return SlotsConst.SLOTS_ELEMENT_ZORDER.hight
    elseif ntype == SlotsConst.SLOTS_ELEMENT_TYPE.wild then
        return SlotsConst.SLOTS_ELEMENT_ZORDER.wild
    elseif ntype == SlotsConst.SLOTS_ELEMENT_TYPE.bonus then
        return SlotsConst.SLOTS_ELEMENT_ZORDER.bonus
    elseif ntype == SlotsConst.SLOTS_ELEMENT_TYPE.scatter or 
           ntype == SlotsConst.SLOTS_ELEMENT_TYPE.scatterX or 
           ntype == SlotsConst.SLOTS_ELEMENT_TYPE.scatterXX or
           ntype == SlotsConst.SLOTS_ELEMENT_TYPE.scatterXXX or 
           ntype == SlotsConst.SLOTS_ELEMENT_TYPE.scatterXXXX then
        return SlotsConst.SLOTS_ELEMENT_ZORDER.scatter
    end
    return 0
end

return AnimCell