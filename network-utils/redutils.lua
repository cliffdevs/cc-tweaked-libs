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

return {
    openRednet = openRednet
}