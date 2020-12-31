
local ImgCell = import("...component.ImgCell")
local Reel = import("...component.Reel")
local ReelView = class("ReelView", fgui.GComponent)

function ReelView:ctor(ob)
    self.ob = ob

    self:setPivot(0.5, 0.5, true)

    self.reel = Reel.new(self.ob)
    self:addChild(self.reel)

    self.cfgVm = cc.load("mvvm").Watcher.new(self.ob)
    self.cfgVm:bind("layout_data"):apply(function(cfg)
        self:setSize(cfg.rcWidth, cfg.rcHeight)
        
        --test background
        local d = fgui.GGraph:create()
        local fill = cc.c4f(1, 1, 0, 1)
        local outer = cc.c4f(1, 0, 0, 1)
        d:drawRect(cfg.rcWidth, cfg.rcHeight, 0, outer, fill)
        self.reel:addChild(d)
    end):exec()
end

function ReelView:initCell()
    local source = self.ob:get("slots_data")
    for i, v in ipairs(source) do
        -- * 创建每个滚动条所属的真实元素
        for j, _ in ipairs(v) do
            local item = ImgCell.new(self.ob, i, j)
            self.reel:addChild(item)
        end
    end
end

return ReelView