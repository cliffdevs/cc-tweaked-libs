local TurtleRegistry = require("../cfg-store/TurtleRegistry/turtleregistry")
local Config = require("../cfg-store/Config/config")

local function intro()
    print("Welcome to Creep Controller!")
end

local function menu(options)
    for i=1,#options do
        print(i .. " " .. options[i].name)
    end

    local selection = tonumber(read())
    options[selection].method()

    menu(options)
end

local function listCreeps()
    print(textutils.serialise(TurtleRegistry.getRegistry()))
end

local function printConfig()
    print(textutils.serialise(Config.getConfig()))
end

local function getConfig()
    print("Which config do you want to read?")
    local value = read()

    print(textutils.serialise(Config.getConfig()[value]))
end

local function updateLumberjackConfig()
    print("Which creep are you updating?")
    local creepId = read()

    local coords = {}
    for var=i,3 do
        print("point " .. i .. ", x: ")
        local x = tonumber(read())

        print("point " .. i .. ", y: ")
        local y = tonumber(read())

        print("point " .. i .. ", z: ")
        local z = tonumber(read())

        coords[i] = { x = x, y = y, z = z }
    end

    Config.getConfig()[creepId] = {
        role = "lumberjack",
        coordinates = coords
    }

    print("Update config for creep=" .. creepId)
    print(textutils.serialise(Config.getConfig()[creepId]))
end

local function updateConfig()
    local options = {
        { method = updateLumberjackConfig, name = "Lumberjack Config" }
    }

    menu(options)
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
