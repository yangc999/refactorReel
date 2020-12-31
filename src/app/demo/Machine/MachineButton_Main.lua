-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MachineButton_Main = fgui.extension_class(fgui.GButton)
rawset(MachineButton_Main, "__cname", "MachineButton_Main")

MachineButton_Main.URL = "ui://oktoh4rcnfw04"

function MachineButton_Main:__create()
    return fgui.UIPackage:createObject("Machine", "MachineButton_Main")
end

function MachineButton_Main:ctor()
    self.main_up = self:getChild("main_up")
end

return MachineButton_Main