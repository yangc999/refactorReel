
local SlotsConst = import("..config.SlotsConst")
local SlotsConfig = import("..config.SlotsConfig")
local DriverProvider = class("DriverProvider")
DriverProvider.__new = DriverProvider.new
DriverProvider.new = nil

function DriverProvider:getInstance()
    if not self.inst then
        self.inst = DriverProvider.__new()
    end
    return self.inst
end

function DriverProvider:ctor()
    ---- * 配置
    self.cfgData = {}
    ---- * 机台基本构成数据
    self.sdata = {}
    ---- * 公共的base数据模块
    self.base = {}
    ---- * 独特的feature数据
    self.feature = {}

    -- self.str = f_freespin_struct

    -- * 机台基本构成数据
    self.sdata.id = 0
    self.sdata.name = ""
    self.sdata.viewType = 0

    self.sdata.row          = 0     -- 最大行数
    self.sdata.col          = 0     -- 最大列数
    self.sdata.rcList       = {}    -- 滚轴行列数据列表
    self.sdata.rcListWish   = {}    -- 滚轴行列数据列表 预期的
    self.sdata.rowWidth     = 0     -- 滚轴总宽度
    self.sdata.colHight     = 0     -- 滚轴总高度
    self.sdata.lineWidth    = 0     -- 分割线宽度
    self.sdata.cellWidth    = 0     -- 每个cell的宽度
    self.sdata.cellHeight   = 0     -- 每个cell的高度
    self.sdata.cellMaxNum   = 0     -- 单个sprite占用的最大格数

    self.sdata.elementUnitList = {}   -- 一个机台所有元素的数据信息
    self.sdata.elementInitList = {}   -- 一个机台初始化页面
    self.sdata.rollerList = {}   -- 一个机台假滚轴

    self.sdata.viewAnimClipLeftAndRight = 0
    self.sdata.viewAnimClipTopAndBottom = 0

    -- test
    self.sdata.trueStrips        = {{2,51,81},{51,81,71},{1,71,1,2,51},{71,1,51,2,51},{71,51,1,81,71}}
    
    -- -- * slots机台的下注默认信息块
    self.sdata.sbet = {}
    self.sdata.sbet.sbetIdx    = 1
    self.sdata.sbet.sbetIdxMin = 1
    self.sdata.sbet.sbetIdxMax = 1
    self.sdata.sbet.sbetList   = {}
    self.sdata.sbet.sbetChips  = 100000
    self.sdata.sbet.sbetExt    = {}        -- 扩展数据，特殊情况下使用



    -- * svr传过来的spin结果包含2部分：base和feature

    -- -- * 公共的base数据模块
    self.base.betIdx            = 0
    self.base.betExt            = {}
    self.base.winChips          = SlotsConst.SLOTS_WIN_TYPE.NORMAL
    self.base.totalChips        = 0
    self.base.winType           = 0
    self.base.trueStrips        = {{71,2,4,81,5}, {71,2,4,81,5}, {71,2,4,81,5}, {71,2,4,81,5}, {71,2,4,81,5}}
    self.base.trueStripsExt     = {}
    self.base.lines             = {}

    -- * feature 每次svr传过来的feature的标准结构
    -- * 基本规则如下：
    -- * 1，允许同时中两个feature
    -- * 2，在一个feature中允许中另外的feature
    self.isFeature = false

    self:buildCfgData()
end

function DriverProvider:buildCfgData()
    self.sdata.id = SlotsConfig.slotsId
    self.sdata.name = SlotsConfig.slotsName
    self.sdata.viewType = SlotsConfig.viewAlignmentType

    self.sdata.row          = 3     -- 最大行数
    self.sdata.col          = 5     -- 最大列数
    self.sdata.rcList       = SlotsConfig.rcList    -- 滚轴行列数据列表
    self.sdata.rcListWish   = SlotsConfig.rcWishList    -- 滚轴行列数据列表 预期的
    self.sdata.rowWidth     = SlotsConfig.viewWidth     -- 滚轴总宽度
    self.sdata.colHight     = SlotsConfig.viewHeight     -- 滚轴总高度
    self.sdata.lineWidth    = SlotsConfig.viewLineWidth     -- 分割线宽度
    self.sdata.cellWidth    = 158     -- 每个cell的宽度
    self.sdata.cellHeight   = 108     -- 每个cell的高度
    self.sdata.cellMaxNum   = 1     -- 单个sprite占用的最大格数

    self.sdata.elementUnitList = SlotsConfig.elementArr -- 一个机台所有元素的数据信息

    self.sdata.viewAnimClipLeftAndRight = SlotsConfig.viewAnimClipLeftAndRight
    self.sdata.viewAnimClipTopAndBottom = SlotsConfig.viewAnimClipTopAndBottom

    self.sdata.elementInitList  = SlotsConfig.initArr
    self.sdata.rollerList       = SlotsConfig.rollerArr
end

function DriverProvider:reelClippingCfg()
    local cfg = {}
    cfg.rcList          = self.sdata.rcList
    cfg.rcType          = self.sdata.viewType
    cfg.rcLineWidth     = self.sdata.lineWidth
    cfg.rcItemWidth     = self.sdata.cellWidth
    cfg.rcItemHeight    = self.sdata.cellHeight
    cfg.rcWidth         = self.sdata.rowWidth
    cfg.rcHeight        = self.sdata.colHight
    return cfg
end

function DriverProvider:defaultSlotsByRC(col, row)
    if not self.sdata.elementInitList[col] or not self.sdata.elementInitList[col][row] then
    end
    return self.sdata.elementInitList[col][row]
end

function DriverProvider:elementById(slotsId)
    for i,unit in ipairs(self.sdata.elementUnitList) do
        if unit.id == slotsId then
            return unit
        end
    end
end

return DriverProvider