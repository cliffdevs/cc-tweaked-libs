local RedUtils = require("../network-utils/redutils")
local TurtleRegistry = require("../cfg-store/TurtleRegistry/turtleregistry")
local Config = require("../cfg-store/Config/config")

RedUtils.openRednet()

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

local function getConfig()
    print("Which config do you want to read?")
    local value = read()

    print(textutils.serialise(Config.getConfig(value)))
end

local function updateLumberjackConfig()
    print("Which creep are you updating?")
    local creepId = read()

    local coords = {}
    for i=1,3 do
        print("point " .. i .. ", x: ")
        local x = tonumber(read())

        print("point " .. i .. ", y: ")
        local y = tonumber(read())

        print("point " .. i .. ", z: ")
        local z = tonumber(read())

        coords[i] = { x = x, y = y, z = z }
    end

    local creepConfig = {
        role = "lumberjack",
        coordinates = coords
    }

    Config.updateConfig(creepConfig)
    print(textutils.serialise(Config.getConfig(creepId)))
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
        { method = getConfig, name = "Get Config" },
        { method = updateConfig, name = "Update Config" }
    }
    menu(options)
end


intro()
mainMenu()
