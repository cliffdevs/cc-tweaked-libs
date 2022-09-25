local RedUtils = require("../../network-utils/redutils")

local registry = {}
local protocol_register = "registry"
local protocol_read_register = "read_registry"

local function listen_protocol_register()
    local function handle(registration, senderId)
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
    RedUtils.listen_for(protocol_register, handle)
end

local function listen_protocol_read_register()
    local function handle(message, senderId)
        RedUtils.respond(senderId, registry, protocol_read_register)
    end
    RedUtils.listen_for(protocol_read_register, handle)
end

local function server()
    parallel.waitForAny(listen_protocol_register, listen_protocol_read_register)
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
    local host = rednet.lookup(protocol_read_register)
    return RedUtils.blocking_request(host, "get", protocol_read_register)
end

return {
    server = server,
    register = register,
    getRegistry = getRegistry
}
