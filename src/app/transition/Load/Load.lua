-- This is an automatically generated class by FairyGUI. Please do not modify it.

local Load = fgui.extension_class(fgui.GComponent)
rawset(Load, "__cname", "Load")

Load.URL = "ui://64mp9o9ohf2ne"

function Load:__create()
    return fgui.UIPackage:createObject("Load", "Load")
end

function Load:ctor()
    self.loading = self:getChild("loading")
    self.progress = self:getChild("progress")
end

return Load