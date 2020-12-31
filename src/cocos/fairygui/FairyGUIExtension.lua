--[[
注册组件扩展，用于继承FairyGUI原来的组件类。
例子：
MyButton = fgui.extension_class(GButton)
fgui.register_extension("ui://包名/我的按钮", MyButton)
function MyButton:ctor() --当组件构建完成时此方法被调用
    print(self:GetChild("n1"))
end
--添加自定义的方法和字段
function MyButton:Test()
    print('test')
end
local get = tolua.initget(MyButton)
local set = tolua.initset(MyButton)
get.myProp = function(self)
    return self._myProp
end
set.myProp = function(self, value)
    self._myProp = value
    self:GetChild('n1').text = value
end
local myButton = someComponent:GetChild("myButton") --这个myButton的资源是“我的按钮”
myButton:Test()
myButton.myProp = 'hello'
local myButton2 = UIPackage.CreateObject("包名","我的按钮")
myButton2:Test()
myButton2.myProp = 'world'
]]

function fgui.register_extension(url, extension)
    fgui.UIObjectFactory:setPackageItemExtension(url, extension.__super[".classname"], extension.__bind)
    extension.__binded = true
end

function fgui.extension_class(base)
    local cls = {}
    cls.__index = cls
    cls.__binded = false

    cls.__super = base or fgui.GComponent
    setmetatable(cls, {__index = cls.__super})

    cls.__bind = function(ins)
        local t = {}
        setmetatable(t, {__index = cls})
        tolua.setpeer(ins, t)
        ins.class = cls
        ins:addEventListener(fgui.UIEventType.onConstruct, handler(ins, cls.ctor))
    end

    if not cls.ctor then
        -- add default constructor
        cls.ctor = function() end
    end
    cls.new = function(...)
        local instance = cls.__create(...)
        if not cls.__binded then
            local t = {}
            setmetatable(t, {__index = cls})
            tolua.setpeer(instance, t)
            instance.class = cls
            instance:ctor(...)
        end
        return instance
    end
    cls.create = function(_, ...)
        return cls.new(...)
    end

    return cls
end