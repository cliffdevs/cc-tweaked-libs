local RedUtils = require("../network-utils/redutils")
local TurtleRegistry = require("TurtleRegistry/turtleregistry")
local ConfigServer = require("Config/config")

print("CfgServer started.")

RedUtils.openRednet()
parallel.waitForAny(ConfigServer.server, TurtleRegistry.server)
