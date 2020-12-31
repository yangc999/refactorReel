-- This is an automatically generated class by FairyGUI. Please do not modify it.

local Hall = fgui.extension_class(fgui.GComponent)
rawset(Hall, "__cname", "Hall")

Hall.URL = "ui://qp8dts8hbl3n1n"

function Hall:__create()
    return fgui.UIPackage:createObject("Hall", "Hall")
end

function Hall:ctor()
    self.topBar = self:getChild("topBar")
    self.bottomBar = self:getChild("bottomBar")
    self.centre = self:getChild("centre")
    self.turnList = self:getChild("turnList")
end

return Hall