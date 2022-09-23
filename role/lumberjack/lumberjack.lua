local function refuel()

end

local function needsFuel()
    return turtle.getFuelLevel() == 0
end

local function lumberjack()

end

local function findWorkSite()

end

--[[ function to operate a lumberjack turtle --]]
local function main()
    while true do
        if needsFuel() then
            refuel()
        else
            
        end
    end
end

return { execute = main }