-- This is an automatically generated class by FairyGUI. Please do not modify it.

local LoadLoading = fgui.extension_class(fgui.GProgressBar)
rawset(LoadLoading, "__cname", "LoadLoading")

LoadLoading.URL = "ui://64mp9o9ohf2n5"

function LoadLoading:__create()
    return fgui.UIPackage:createObject("Load", "LoadLoading")
end

function LoadLoading:ctor()
    self.bg = self:getChild("bg")
end

return LoadLoading