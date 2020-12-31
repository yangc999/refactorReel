-- This is an automatically generated class by FairyGUI. Please do not modify it.

local Launch = fgui.extension_class(fgui.GComponent)
rawset(Launch, "__cname", "Launch")

Launch.URL = "ui://1n4czledhf2n4"

function Launch:__create()
    return fgui.UIPackage:createObject("Runtime", "Launch")
end

function Launch:ctor()
    self.infoText = self:getChild("infoText")
    self.progressText = self:getChild("progressText")
    self.loading = self:getChild("loading")
end

return Launch