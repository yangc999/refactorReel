
local Promise = cc.load("promise").Promise
local IService = import(".IService")
local HttpService = class("HttpService", IService)
HttpService.__new = HttpService.new
HttpService.new = nil

function HttpService:getInstance()
    if not self.inst then
        self.inst = HttpService.__new()
    end
    return self.inst
end

function HttpService:ctor()

end

function HttpService:start()
    
end

function HttpService:stop()

end

function HttpService:timeout(time)
    local pr = Promise.new(function(resolve, reject)
        local entry
        local scheduler = cc.Director:getInstance():getScheduler()
        local function timeout()
            scheduler:unscheduleScriptEntry(entry)
            reject("timeout")
        end
        entry = scheduler:scheduleScriptFunc(timeout, time, false)
    end)
    return pr
end

function HttpService:get(url)
    local pr = Promise.new(function(resolve, reject)
        local xhr = cc.XMLHttpRequest:new()
        xhr:open("GET", url)
        xhr:registerScriptHandler(function()
            if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
                local response = xhr.response
                resolve(response)
            else
                reject("errorStatus")
            end
            xhr:unregisterScriptHandler()
        end)
        xhr:send()
    end)
    return pr
end

function HttpService:post(url, data)
    local pr = Promise.new(function(resolve, reject)
        local xhr = cc.XMLHttpRequest:new()
        xhr:open("POST", url)
        xhr:registerScriptHandler(function()
            if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
                local response = xhr.response
                resolve(response)
            else
                reject("errorStatus")
            end
            xhr:unregisterScriptHandler()
        end)
        xhr:send(json.encode(jsonData))
    end)
    return pr
end

--@Example
--[[
使用post,get,timeout组合promise完成请求的模型
例如:
1.超时5秒的GET请求
Promise.race({HttpService:timeout(5), HttpService:get(url)}):andThen(...)
2.重试3次的GET请求
local foo = function()
    return HttpService:get(url)
end
Promise.retry(foo, 3):andThen(...)
3.重试3次,每次超时5秒的GET请求
local foo = function()
    return Promise.race({HttpService:timeout(5), HttpService:get(url)})
end
Promise.retry(foo, 3):andThen(...)
--]]

return HttpService