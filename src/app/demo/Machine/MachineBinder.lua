-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MachineButton_Spin = import(".MachineButton_Spin")
local MachineButton_Main = import(".MachineButton_Main")
local Machine = import(".Machine")

local MachineBinder = class("MachineBinder")

function MachineBinder:BindAll()
    fgui.register_extension(MachineButton_Spin.URL, MachineButton_Spin)
    fgui.register_extension(MachineButton_Main.URL, MachineButton_Main)
    fgui.register_extension(Machine.URL, Machine)
end

return MachineBinder