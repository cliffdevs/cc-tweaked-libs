local registry = {}
local protocol_register = "registry"
local protocol_read_register = "read_registry"
local protocol_read_register_response = "read_registry_response"

local function server()
    rednet.host(protocol_register, "server" .. os.getComputerID())
    rednet.host(protocol_read_register, "server" .. os.getComputerID())
    while true do
        local senderId, message, protocol = rednet.receive()
        print("Received registry request for " .. senderId .. " with message " .. textutils.serialise(message))

        if protocol == protocol_register then
            local registration = textutils.unserialise(message)
            if registration ~= nil and registration.id ~= nil and registration.role ~= nil then
                local current = registry[registration.role]
                if current == nil then
                    current = {}
                end

                if registry[registration.role] == nil then
                    registry[registration.role] = {}
                end

                registry[registration.role][registration.id] = { 
                    lastTime = os.time(),
                }

                print("registry updated!")
                print(textutils.serialise(registry))
            end
        end
        if protocol == protocol_read_register then
            rednet.send(senderId, textutils.serialise(registry), protocol_read_register_response)
            print("Returned registry snapshot")
        end
    end
end

local function register(in_role)
    local workerDetails = {
        id = os.getComputerID(),
        role = in_role
    }
    local serverId = rednet.lookup(protocol_register)
    print("Found registry server: ", serverId)

    rednet.send(serverId, textutils.serialise(workerDetails), protocol_register)
end

local function getRegistry()
    local response = nil
    local function listen()
        local senderId, message, protocol = rednet.receive(protocol_read_register_response)
        response =  textutils.unserialise(message)
    end
    local function request()
        local host = rednet.lookup(protocol_read_register)
        rednet.send(host, "get", protocol_read_register)
    end
    parallel.waitForAll(listen, request)
    return response
end

return {
    server = server,
    register = register,
    getRegistry = getRegistry
}
