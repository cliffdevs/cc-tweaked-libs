-- Execute this in the CLI to update your library to the latest version
if !fs.exists("gitget") then
    shell.run("pastebin get W5ZkVYSi gitget")
end

shell.run("gitget cliffdevs cc-tweaked-libs")

