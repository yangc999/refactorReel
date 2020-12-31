
local SlotsConst = import("..config.SlotsConst")
local DriverProvider = import("..driver.DriverProvider")
local ImgCell = class("ImgCell", fgui.GComponent)

function ImgCell:ctor(ob, col, row)
    self.ob = ob
    self.col = col
    self.row = row

    self:setPivot(0.5, 0.5, true)

    self.imgLoader = fgui.GLoader:create()
    self.imgLoader:setPivot(0.5, 0.5, true)
    self.imgLoader:setAlign(cc.TEXT_ALIGNMENT_CENTER)
    self.imgLoader:setVerticalAlign(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    self:addChild(self.imgLoader)

    --axis test
    -- local d = fgui.GGraph:create()
    -- local fill = cc.c4f(0, 1, 0, 1)
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
        self.imgLoader:setX(width/2)
        self:setWidth(width)
    end):exec()

    self.heightVm = cc.load("mvvm").Watcher.new(self.ob)
    self.heightVm:bind(string.format("%s.height", root)):apply(function(height)
        self.imgLoader:setY(height/2)
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

    self.imgVm = cc.load("mvvm").Watcher.new(self.ob)
    self.imgVm:bind(string.format("%s.element", root)):filter(function(idx)
        return string.format("ui://Icon/slots_%d", idx)
    end):apply(function(url)
        self.imgLoader:setURL(url)
    end):exec()
end

function ImgCell:iconZorder(ntype, unitNum)
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

return ImgCell