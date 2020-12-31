
cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"

local function main()
    -- cc.Director:getInstance():setDisplayStats(true)
    local app = import("app.core.App"):getInstance()
    cc.exports.g_app = app
    app:startup()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end