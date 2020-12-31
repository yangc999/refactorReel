-- This is an automatically generated class by FairyGUI. Please do not modify it.

local Machine = fgui.extension_class(fgui.GComponent)
rawset(Machine, "__cname", "Machine")

Machine.URL = "ui://oktoh4rcnfw05"

function Machine:__create()
    return fgui.UIPackage:createObject("Machine", "Machine")
end

function Machine:ctor()
    self.button_Spin = self:getChild("button_Spin")
    self.button_Main = self:getChild("button_Main")
end

return Machine