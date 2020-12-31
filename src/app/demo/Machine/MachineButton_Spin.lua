-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MachineButton_Spin = fgui.extension_class(fgui.GButton)
rawset(MachineButton_Spin, "__cname", "MachineButton_Spin")

MachineButton_Spin.URL = "ui://oktoh4rcnfw02"

function MachineButton_Spin:__create()
    return fgui.UIPackage:createObject("Machine", "MachineButton_Spin")
end

function MachineButton_Spin:ctor()
    self.spin_up = self:getChild("spin_up")
end

return MachineButton_Spin