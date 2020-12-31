
local SlotsConst = import("..config.SlotsConst")
local Reel = class("Reel", fgui.GComponent)

function Reel:ctor(ob, borderX, borderY)
    self.ob = ob
    self.borderX = borderX or 0
    self.borderY = borderY or 0

    -- self.mask = fgui.GGraph:create()
    self.mask = fgui.GComponent:create()
    self:addChild(self.mask)
    self:setMask(self.mask:displayObject())

    self.cfgVm = cc.load("mvvm").Watcher.new(self.ob)
    self.cfgVm:bind("layout_data"):apply(function(cfg)
        self:changeModel(cfg)
    end):exec()
end

function Reel:changeModel(cfg)
    self:setSize(cfg.rcWidth, cfg.rcHeight)

    local aWidth  = self.borderX
    local aHeight = self.borderY

    -- local pointArr = {}
    for i,v in ipairs(cfg.rcList) do
        local pointArr = {}
        -- v = v - 1
        local x0 = (i - 1)*cfg.rcItemWidth + (i - 2)*cfg.rcLineWidth + cfg.rcLineWidth*0.5
        local y0 = 0 --(cfg.rcHeight - v*cfg.rcItemHeight)*0.5

        if cfg.rcType == SlotsConst.SLOTS_RCTYPE.CENTER then
            y0 = (cfg.rcHeight - v*cfg.rcItemHeight)*0.5
        elseif cfg.rcType == SlotsConst.SLOTS_RCTYPE.TOP then  -- top
            y0 = (cfg.rcHeight - v*cfg.rcItemHeight)
        elseif cfg.rcType == SlotsConst.SLOTS_RCTYPE.BOTTOM then  -- bottom
            y0 = 0
        end

        local x1 = x0 + cfg.rcItemWidth + cfg.rcLineWidth
        -- local y1 = (cfg.rcHeight - v*cfg.rcItemHeight)*0.5 + v*cfg.rcItemHeight
        local y1 = y0 + v*cfg.rcItemHeight

        if i == 1 then x0 = 0 x1 = cfg.rcItemWidth + cfg.rcLineWidth*0.5 end
        if i == #cfg.rcList then x1 = x0 + cfg.rcItemWidth + cfg.rcLineWidth*0.5 end
            
        -- y1 = y1 - cfg.rcItemHeight*(cfg.SlotsLineScale - 1) -- SlotsLineScale。注意：处理“猪爷到”三行裁剪为2行
        -- y0 = y0 + cfg.rcItemHeight*(cfg.SlotsLineScale - 1)

        y1 = y1 - cfg.rcItemHeight*(1 - 1) -- SlotsLineScale。注意：处理“猪爷到”三行裁剪为2行
        y0 = y0 + cfg.rcItemHeight*(1 - 1)

        table.insert(pointArr, cc.p(x0 - aWidth, y0 - aHeight))
        table.insert(pointArr, cc.p(x1 + aWidth, y0 - aHeight))

        table.insert(pointArr, cc.p(x1 + aWidth, y1 + aHeight))
        table.insert(pointArr, cc.p(x0 - aWidth, y1 + aHeight))

        --draw rect each bearing
        local d = fgui.GGraph:create()
        local fill = cc.c4f(0, 1, 0, 1)
        local outer = cc.c4f(1, 0, 0, 1)
        d:drawPolygon(0, outer, fill, pointArr, #pointArr)
        --cocos2dx opengl reverse axis
        d:setPosition(0, cfg.rcHeight)
        self.mask:addChild(d)
    end
end

return Reel