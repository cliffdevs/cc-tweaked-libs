local function intro()
    print("Welcome to Creep Controller!")
end

local function menu(options)
    local index = 0;
    for i=1,options.length do
        print(i .. " " .. options[i].name)
    end

    local selection = tonumber(read())
    options[selection].method()
end

local function listCreeps()

end

local function printConfig()

end

local function getConfig()

end

local function updateConfig()

end

local function mainMenu()
    local options = {
        { method = listCreeps, name = "List Creeps" },
        { method = printConfig, name = "Print Configs" },
        { method = getConfig, name = "Get Config" },
        { method = updateConfig, name = "Update Config" }
    }
    menu(options)
end


intro()
mainMenu()

while true do
    
end