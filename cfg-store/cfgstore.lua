local TurtleRegistry = require("turtleregistry")
local ConfigServer = require("config")

print("Starting config-store server...")

parallel.waitForAny(ConfigServer.server, TurtleRegistry.server)
