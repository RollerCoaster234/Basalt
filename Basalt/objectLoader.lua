local args = table.pack(...)
local dir = fs.getDir(args[2] or "Basalt")
if(dir==nil)then
    error("Unable to find directory "..args[2].." please report this bug to our discord.")
end

local objectLoader = {}

local _OBJECTS = {}
local _PLUGINS = {}
local pluginNames = {}

if(packaged)then
    for k,v in pairs(getProject("plugins"))do
        table.insert(pluginNames, k)
        local newPlugin = v()
        if(type(newPlugin)=="table")then
            for a,b in pairs(newPlugin)do
                if(type(a)=="string")then
                    if(_PLUGINS[a]==nil)then _PLUGINS[a] = {} end
                    table.insert(_PLUGINS[a], b)
                end
            end
        end
    end
else
    for _,v in pairs(fs.list(fs.combine(dir, "plugins")))do
        local newPlugin
        if(fs.isDir(fs.combine(fs.combine(dir, "plugins"), v)))then
            table.insert(pluginNames, fs.combine(fs.combine(dir, "plugins"), v))
            newPlugin = require(v.."/init")
        else
            table.insert(pluginNames, v)
            newPlugin = require(v:gsub(".lua", ""))
        end
        if(type(newPlugin)=="table")then
            for a,b in pairs(newPlugin)do
                if(type(a)=="string")then
                    if(_PLUGINS[a]==nil)then _PLUGINS[a] = {} end
                    table.insert(_PLUGINS[a], b)
                end
            end
        end
    end
end

function objectLoader.load(objectName)
    if _OBJECTS[objectName] then
        return _OBJECTS[objectName]
    end

    local defaultPath = package.path
    local format = "path;/path/?.lua;/path/?/init.lua;"
    local main = format:gsub("path", dir)
    local objFolder = format:gsub("path", dir.."/objects")
    local plugFolder = format:gsub("path", dir.."/plugins")
    local libFolder = format:gsub("path", dir.."/libraries")

    package.path = main..objFolder..plugFolder..libFolder..defaultPath
    _OBJECTS[objectName] = require(fs.combine(dir, "objects", objectName))

    if _PLUGINS[objectName] then
        for _, plugin in ipairs(_PLUGINS[objectName]) do
            if(plugin.pluginProperties~=nil)then
                plugin.pluginProperties(_OBJECTS[objectName])
            end
            plugin.pluginProperties = nil
            if(plugin.init~=nil)then
                plugin.init(_OBJECTS[objectName])
            end
            plugin.init = nil
    
            for a,b in pairs(plugin)do
                if(type(a)=="string")then
                    _OBJECTS[objectName][a] = b
                end
            end
        end
    end

    package.path = defaultPath
    return _OBJECTS[objectName]
end

function objectLoader.getObjectList()
    local objects = {}
    for _,v in pairs(fs.list(fs.combine(dir, "objects")))do
        if(fs.isDir(fs.combine(fs.combine(dir, "objects"), v)))then
            table.insert(objects, v)
        else
            local obj = v:gsub(".lua", "")
            table.insert(objects, obj)
        end
    end
    return objects
end

return objectLoader