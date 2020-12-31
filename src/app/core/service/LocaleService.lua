
local IService = import(".IService")
local LocaleService = class("LocaleService", IService)
LocaleService.__new = LocaleService.new
LocaleService.new = nil

LocaleService.localeList = {
    {locale="", path=""}, 
}

function LocaleService:getInstance()
    if not self.inst then
        self.inst = LocaleService.__new()
    end
    return self.inst
end

function LocaleService:ctor()
    self.i18n = cc.load("i18n")
    -- self.i18n.loadFile()
end

function LocaleService:start()

end

function LocaleService:stop()

end

function LocaleService:setLocale(lc)
    if true then
        self.i18n.setLocale(lc)
    end
end

function LocaleService:translate(str, param)

end

return LocaleService