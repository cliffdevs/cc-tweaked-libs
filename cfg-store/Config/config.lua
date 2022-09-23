local function server()
    rednet.host("getconfig",  os.getComputerID())
    rednet.host("putconfig", os.getComputerID())
    while true do
        local senderId, message = rednet.receive("putconfig")
        print("Recieved config request from " + senderId)

        local configRequest = textutils.unserialise(message)
    end
end

return {
    server = server
}