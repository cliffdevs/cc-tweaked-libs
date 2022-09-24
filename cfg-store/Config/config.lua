local protocol_get = "getconfig"
local protocol_get_response = "getconfigresponse"
local protocol_put = "putconfig"

local config = {}

local function server()
    rednet.host(protocol_get,  "server" .. os.getComputerID())
    rednet.host(protocol_put, "server" .. os.getComputerID())
    while true do
        local senderId, message, protocol = rednet.receive(protocol_put)
        print("Received config request from " .. senderId .. " with protocol " .. protocol)

        if protocol == protocol_get then
            local configRequest = textutils.unserialise(message)
            local requestedConfig = config[configRequest.creepId]
            if requestedConfig == nil then requestedConfig = {} end
            print("Received request to read creep config for " .. configRequest.creepId)

            rednet.send(senderId, textutils.serialise(requestedConfig), protocol_get_response)
        end

        if protocol == protocol_put then
            local configRequest = textutils.unserialise(message)
            config[configRequest.creepId] = configRequest
            print("Updated config for creepId " .. configRequest.creepId)
        end
        
    end
end

local function getConfig(creepId)
    local function listen()
        local senderId, message, protocol = rednet.receive(protocol_get_response)
        return textutils.unserialise(message)
    end
    local listener = coroutine.create(listen)
    local host = rednet.lookup(protocol_get)
    rednet.send(host, textutils.serialise({ creepId = creepId }), protocol_get)
    local _status, result = coroutine.resume(listener)
    return result
end

return {
    server = server,
    getConfig = getConfig
}
