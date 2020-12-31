
local IService = import(".IService")
local CacheService = class("CacheService", IService)
CacheService.__new = CacheService.new
CacheService.new = nil

function CacheService:getInstance()
    if not self.inst then
        self.inst = CacheService.__new()
    end
    return self.inst
end

function CacheService:ctor()
    self.ob = cc.load("mvvm").Observee:getInstance()
end

function CacheService:getCache()
    return self.ob
end

function CacheService:start()
    self.ob:active()
end

function CacheService:stop()
    self.ob:inactive()
end

--@Example
--[[
使用add,remove操作模块缓存数据
例如:
1.增加user的缓存
usr = CacheService:getCache():add({}, "user")
2.user缓存按table的方式操作
user.name = "user1"
user.id = 2
3.user缓存的改变会通过Watcher监听.bind为cache的树状结构路径,filter为结果的中间处理,apply为控件的显示调用
local vm = cc.load("mvvm").Watcher.new()
vm:bind("user.name"):filter(function(str)
    return str.."_".."CN"
end):apply(function(str)
    label:setString(str)
end):exec()
4.删除user的缓存
CacheService:getCache():remove("user")
--]]

return CacheService