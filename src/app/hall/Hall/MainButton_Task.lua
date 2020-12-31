-- This is an automatically generated class by FairyGUI. Please do not modify it.

local MainButton_Task = fgui.extension_class(fgui.GButton)
rawset(MainButton_Task, "__cname", "MainButton_Task")

MainButton_Task.URL = "ui://qp8dts8hbl3n1b"

function MainButton_Task:__create()
    return fgui.UIPackage:createObject("Hall", "MainButton_Task")
end

function MainButton_Task:ctor()
    self.Task_up = self:getChild("Task_up")
end

return MainButton_Task