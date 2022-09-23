local protocol_get = "getconfig"
local protocol_put = "putconfig"

local function server()
    rednet.host(protocol_get,  "server" .. os.getComputerID())
    rednet.host(protocol_put, "server" .. os.getComputerID())
    while true do
        local senderId, message = rednet.receive(protocol_put)
        print("Recieved config request from " + senderId)

        local configRequest = textutils.unserialise(message)
    end
end

return {
    server = server
}