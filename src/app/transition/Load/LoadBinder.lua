-- This is an automatically generated class by FairyGUI. Please do not modify it.

local LoadLoading = import(".LoadLoading")
local Load = import(".Load")

local LoadBinder = class("LoadBinder")

function LoadBinder:BindAll()
    fgui.register_extension(LoadLoading.URL, LoadLoading)
    fgui.register_extension(Load.URL, Load)
end

return LoadBinder