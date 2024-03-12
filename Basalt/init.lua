local curDir = fs.getDir(table.pack(...)[2]) or ""

local defaultPath = package.path
if not(packed)then
    local format = "path;/path/?.lua;/path/?/init.lua;"

    local main = format:gsub("path", curDir)
    local eleFolder = format:gsub("path", curDir.."/elements")
    local extFolder = format:gsub("path", curDir.."/extensions")
    local libFolder = format:gsub("path", curDir.."/libraries")


    package.path = main..eleFolder..extFolder..libFolder..defaultPath
end
local Basalt = require("main")
package.path = defaultPath

return Basalt