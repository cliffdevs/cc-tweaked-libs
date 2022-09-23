local TurtleRegistry = require("TurtleRegistry/turtleregistry")
local ConfigServer = require("Config/config")

print("Starting config-store server...")

parallel.waitForAny(ConfigServer.server, TurtleRegistry.server)
