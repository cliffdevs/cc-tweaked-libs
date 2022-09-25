local protocol_get = "getconfig"
local protocol_get_response = "getconfigresponse"
local protocol_put = "putconfig"

local config = {}

local function listen_for(protocol, callback)
    rednet.host(protocol, "server" .. os.getComputerID())
    while true do
        local senderId, message, _proto = rednet.receive(protocol)
        print("Received request: " .. senderId .. " " .. textutils.serialiseJSON(message) .. " " .. _proto)
        local payload = textutils.unserialise(message)
        callback(payload, senderId)
    end
end

local function listen_protocol_get()
    local function handle(request, senderId)
        if request.creepId ~= nil then
            print("Received request to read creep config for " .. request.creepId)
            local requestedConfig = config[request.creepId]
            if requestedConfig == nil then requestedConfig = {} end

            rednet.send(senderId, textutils.serialise(requestedConfig), protocol_get_response)
        end
    end
    listen_for(protocol_get, handle)
end

local function listen_protocol_put()
    local function handle(request, senderId)
        if request.creepId ~= nil then
            print("Received request to update creep config " .. request.creepId)
            config[request.creepId] = request
        end
    end

    listen_for(protocol_put, handle)
end

local function server()
    parallel.waitForAny(listen_protocol_get, listen_protocol_put)
end

local function getConfig(creepId)
    local response = nil
    local function listen()
        local senderId, message, protocol = rednet.receive(protocol_get_response)
        response = textutils.unserialise(message)
    end
    local function request()
        local host = rednet.lookup(protocol_get)
        rednet.send(host, textutils.serialise({ creepId = creepId }), protocol_get)
    end
    parallel.waitForAll(listen, request)
    return response
end

return {
    server = server,
    getConfig = getConfig
}
