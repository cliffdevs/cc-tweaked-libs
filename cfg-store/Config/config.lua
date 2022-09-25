local RedUtils = require("../../network-utils/redutils")

local protocol_get = "getconfig"
local protocol_put = "putconfig"

local config = {}

local function listen_protocol_get()
    local function handle(request, senderId)
        if request.creepId ~= nil then
            print("Received request to read creep config for " .. request.creepId)
            local requestedConfig = config[request.creepId]
            if requestedConfig == nil then requestedConfig = {} end

            RedUtils.respond(senderId, requestedConfig, protocol_get)
        end
    end
    RedUtils.listen_for(protocol_get, handle)
end

local function listen_protocol_put()
    local function handle(request, senderId)
        if request.creepId ~= nil then
            print("Received request to update creep config " .. request.creepId)
            config[request.creepId] = request
        end
    end

    RedUtils.listen_for(protocol_put, handle)
end

local function server()
    parallel.waitForAny(listen_protocol_get, listen_protocol_put)
end

local function getConfig(creepId)
    return RedUtils.blocking_request(creepId, { creepId = creepId }, protocol_get)
end

return {
    server = server,
    getConfig = getConfig
}
