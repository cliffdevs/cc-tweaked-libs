local registry = {}

local function server()
---@diagnostic disable-next-line: undefined-field
    rednet.host("registry", "server" .. os.getComputerID())
    while true do
        local senderId, message = rednet.receive("register")
        print("Received registry request for " + senderId)

        local registration = textutils.unserialise(message)
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

local function register(in_role)
    local workerDetails = {
---@diagnostic disable-next-line: undefined-field
        id = os.getComputerID(),
        role = in_role
    }
    local serverId = rednet.lookup("registry")
    print("Found registry server: ", serverId)

    rednet.send(serverId, textutils.serialise(workerDetails), "registry")
end

return {
    server = server,
    register = register,
}
