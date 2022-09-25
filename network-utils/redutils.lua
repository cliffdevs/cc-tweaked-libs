local sides = { "top", "bottom", "left", "right", "front", "back" }

local function openRednet()
    print("Finding modems...")
    for i = 1, #sides do
    if peripheral.isPresent(sides[i]) then
        if peripheral.getType(sides[i]) == "modem" then
            print("Found: "..sides[i])
            if not rednet.isOpen(sides[i]) then
            rednet.open(sides[i])
            end
        end
    end
    end
end

local function listen_for(protocol, callback)
    rednet.host(protocol, "server" .. os.getComputerID())
    while true do
        local senderId, message, _proto = rednet.receive(protocol)
        print("Received message from: " .. senderId .. " " .. textutils.serialiseJSON(message) .. " " .. _proto)
        local payload = textutils.unserialise(message)
        callback(payload, senderId)
    end
end

local function blocking_request(destinationId, message, protocol)
    local response = nil
    local function listen()
        local senderId, _message, _protocol = rednet.receive(protocol .. "_response")
        print("Received response: " .. senderId .. " " .. _message .. " " .. _protocol)
        response = textutils.unserialise(message)
    end
    local function request()
        local host = rednet.lookup(protocol)
        rednet.send(host, textutils.serialise(message), protocol)
    end
    parallel.waitForAll(listen, request)
    return response
end

local function respond(targetId, message, protocol)
    local response = textutils.serialise(message)
    rednet.send(targetId, response, protocol .. "_response")
    print("Sent response: " .. targetId .. " " .. response .. " " .. protocol)
end

return {
    openRednet = openRednet,
    listen_for = listen_for,
    blocking_request = blocking_request,
    respond = respond
}