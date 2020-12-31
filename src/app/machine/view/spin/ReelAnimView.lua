
local AnimCell = import("...component.AnimCell")
local Reel = import("...component.Reel")
local DriverProvider = import("...driver.DriverProvider")
local ReelAnimView = class("ReelAnimView", fgui.GComponent)

function ReelAnimView:ctor(ob)
    self.ob = ob

    self:setPivot(0.5, 0.5, true)

    local dataSource = DriverProvider:getInstance()
    self.reel = Reel.new(self.ob, dataSource.sdata.viewAnimClipLeftAndRight, dataSource.sdata.viewAnimClipTopAndBottom)
    self:addChild(self.reel)

    self.cfgVm = cc.load("mvvm").Watcher.new(self.ob)
    self.cfgVm:bind("layout_data"):apply(function(cfg)
        self:setSize(cfg.rcWidth, cfg.rcHeight)
    end):exec()
end

function ReelAnimView:initCell()
    local source = self.ob:get("slots_data")
    for i, v in ipairs(source) do
        -- * 创建每个滚动条所属的真实元素
        for j, _ in ipairs(v) do
            local item = AnimCell.new(self.ob, i, j)
            self.reel:addChild(item)
        end
    end
end

function ReelAnimView:hideAnim()
    -- self.reel:
end

function ReelAnimView:showAnim()
    -- self.reel:
end

return ReelAnimView