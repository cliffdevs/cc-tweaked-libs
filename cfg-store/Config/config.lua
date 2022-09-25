local RedUtils = require("../../network-utils/redutils")

local protocol_get = "getconfig"
local protocol_put = "putconfig"

local CREEP_CONFIG = {}

local function listen_protocol_get()
    local function handle(request, senderId)
        if request.creepId ~= nil then
            print("Received request to read creep config for " .. request.creepId)
            local requestedConfig = CREEP_CONFIG[request.creepId]
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
            CREEP_CONFIG[request.creepId] = request
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

local function updateConfig(creepConfig)
    local host = rednet.lookup(protocol_put)
    rednet.send(host, textutils.serialise(creepConfig), protocol_put)
end

return {
    server = server,
    getConfig = getConfig
}
