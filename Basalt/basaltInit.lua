local curDir = fs.getDir(table.pack(...)[2]) or ""
local basaltPath = ".basalt"

local defaultPath = package.path
local format = "path;/path/?.lua;/path/?/init.lua;"

local main = format:gsub("path", basaltPath)
local eleFolder = format:gsub("path", basaltPath.."/elements")
local extFolder = format:gsub("path", basaltPath.."/extensions")
local libFolder = format:gsub("path", basaltPath.."/libraries")
package.path = defaultPath..main..eleFolder..extFolder..libFolder.."rom/?"

local Basalt = require("main")
package.path = defaultPath

return Basalt