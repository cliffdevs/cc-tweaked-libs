local protocol_get = "getconfig"
local protocol_get_response = "getconfigresponse"
local protocol_put = "putconfig"

local config = {}

local function server()
    rednet.host(protocol_get,  "server" .. os.getComputerID())
    rednet.host(protocol_put, "server" .. os.getComputerID())
    while true do
        local senderId, message, protocol = rednet.receive(protocol_put)
        print("Received config request from " .. senderId .. " with protocol " .. protocol .. " and message " .. message)

        local request = textutils.unserialise(message)
        if protocol == protocol_get then
            local requestedConfig = config[request.creepId]
            if requestedConfig == nil then requestedConfig = {} end
            print("Received request to read creep config for " .. request.creepId)

            rednet.send(senderId, requestedConfig, protocol_get_response)
        end

        if protocol == protocol_put then
            config[request.creepId] = request
            print("Updated config for creepId " .. request.creepId)
        end
        
    end
end

local function getConfig(creepId)
    local function listen()
        local senderId, message, protocol = rednet.receive(protocol_get_response)
        return message
    end
    local listener = coroutine.create(listen)
    local host = rednet.lookup(protocol_get)
    rednet.send(host, { creepId = creepId }, protocol_get)
    local _status, result = coroutine.resume(listener)
    return result
end

return {
    server = server,
    getConfig = getConfig
}
