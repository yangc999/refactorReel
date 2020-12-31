
local Observee = class("Observee")
Observee.__new = Observee.new
Observee.new = nil

function Observee:getInstance()
    if not self.inst then
        self.inst = Observee.__new()
    end
    return self.inst
end

function Observee:ctor(tag)
    self.tag = tag or "#"
    self.maps = self:walk({}, self.tag)
end

function Observee:setDebug(flag)
    self.debug = flag
    if self.evtBus then
        self.evtBus:setDebug(self.debug)
    end
end

function Observee:active()
    self.evtBus = cc.load("event").new()
    self.evtBus:bind(self)
    self.evtBus:setDebug(self.debug)
    return self
end

function Observee:inactive()
    if self.evtBus then
        self.evtBus:unbind(self)
    end
    return self
end

function Observee:emmit(evt, old, new)
    if self.dispatchEvent then
        self:dispatchEvent({name=evt, old=old, new=new})
    end
end

function Observee:walk(obj, tag)
    local mt = {
        __len = function(t)
            local ele = rawget(t, "__ele")
            return #ele
        end, 
        __pairs = function(t, k)
            return function(tbl, key)
                local ele = rawget(tbl, "__ele")
                return next(ele, key)
            end, t, nil
        end, 
        __index = function(t, k)
            local ele = rawget(t, "__ele")
            return rawget(ele, k)
        end, 
        __newindex = function(t, k, v)
            if not type(k) == "number" and not type(k) == "string" 
            and type(v) == "function" and type(v) == "thread" and type(v) == "userdata" then
                print("invalid data format")
                return
            end
            local evt = rawget(t, "__tag")
            if type(k) == "number" then
                evt = evt..".@"..tostring(k)
            else
                evt = evt.."."..k
            end
            local add = v
            if type(v) == "table" then
                add = self:walk(v, evt)
            end
            local ele = rawget(t, "__ele")
            local oldValue = rawget(ele, k)
            if oldValue ~= add then
                self:emmit(evt, oldValue, add)
                rawset(ele, k, add)
            end
        end
    }
    local new = {__ele={},__tag=tag}
    setmetatable(new, mt)
    for k, v in pairs(obj) do
        local add = v
        if type(v) == "table" then
            add = self:walk(v)
        end
        local ele = rawget(new, "__ele")
        rawset(ele, k, add)
    end
    return new
end

function Observee:add(obj, tag)
    if not tag then
        print("invalid tag")
        return
    end
    local ntag = self.tag.."."..tag
    local add = self:walk(obj, ntag)
    local ele = rawget(self.maps, "__ele")
    rawset(ele, tag, add)
    return self.maps[tag]
end

function Observee:remove(tag)
    local ele = rawget(self.maps, "__ele")
    rawset(ele, tag, nil)
end

function Observee:set(value, tag)
    local paths = string.split(tag, ".")
    for i, v in ipairs(paths) do
        if string.sub(v, 1, 1) == "@" then
            local n = tonumber(string.sub(v, 2))
            if n then
                paths[i] = n
            end
        end
    end
    local obj = self.maps 
    for i, v in ipairs(paths) do
        if obj[v] ~= nil then
            if i == #paths then
                obj[v] = value
            else
                obj = obj[v]
            end
        else
            print(string.format("invalid segment \"%s\" of path \"%s\"", v, tag))
            return
        end
    end
end

function Observee:get(tag)
    local paths = string.split(tag, ".")
    for i, v in ipairs(paths) do
        if string.sub(v, 1, 1) == "@" then
            local n = tonumber(string.sub(v, 2))
            if n then
                paths[i] = n
            end
        end
    end
    local obj = self.maps
    for _, v in ipairs(paths) do
        if obj[v] ~= nil then
            obj = obj[v]
        else
            print(string.format("invalid segment \"%s\" of path \"%s\"", v, tag))
            return
        end
    end
    return obj
end

function Observee:dispose()
    self:inactive()
    self.evtBus:removeAllEventListeners()
    self.evtBus = nil
    self.maps = nil
    self.tag = nil
end

return Observee