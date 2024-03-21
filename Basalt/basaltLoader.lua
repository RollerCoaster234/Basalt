local args = table.pack(...)
local dir = fs.getDir(args[2] or ".basalt")
if(dir==nil)then
    error("Unable to find directory "..args[2].." please report this bug to our discord.")
end

local basaltLoader = {}

local _ELEMENTS = {}
local availableElements = {}
local _EXTENSIONS = {}
local extensionNames = {}
local basalt

for _,v in pairs(fs.list(fs.combine(dir, "elements")))do
    if(fs.isDir(fs.combine(fs.combine(dir, "elements"), v)))then
        availableElements[v] = true
    else
        local obj = v:gsub(".lua", "")
        availableElements[obj] = true
    end
end

for k,v in pairs(package.loaded)do
    if(string.find(k, "elements/"))then
        local name = k:gsub("elements/", "")
        availableElements[name] = true
    end

    if(string.find(k, "extensions/"))then
        local name = k:gsub("extensions/", "")
        local newExtension = load(require(k), nil, "t", _ENV)()
        table.insert(extensionNames, name)
        if(type(newExtension)=="table")then
            for a,b in pairs(newExtension)do
                if(type(a)=="string")then
                    if(_EXTENSIONS[a]==nil)then _EXTENSIONS[a] = {} end
                    table.insert(_EXTENSIONS[a], b)
                end
            end
        end

    end
end

if(fs.exists(fs.combine(dir, "extensions")))then
    for _,v in pairs(fs.list(fs.combine(dir, "extensions")))do
        local newExtension
        if(fs.isDir(fs.combine(fs.combine(dir, "extensions"), v)))then
            table.insert(extensionNames, fs.combine(fs.combine(dir, "extensions"), v))
            newExtension = require(v.."/init")
        else
            table.insert(extensionNames, v)
            newExtension = require(v:gsub(".lua", ""))
        end
        if(type(newExtension)=="table")then
            for a,b in pairs(newExtension)do
                if(type(a)=="string")then
                    if(_EXTENSIONS[a]==nil)then _EXTENSIONS[a] = {} end
                    table.insert(_EXTENSIONS[a], b)
                end
            end
        end
    end
end

function basaltLoader.load(elementName)
    if _ELEMENTS[elementName] then
        return _ELEMENTS[elementName]
    end

    local defaultPath = package.path
    local format = "path;/path/?.lua;/path/?/init.lua;"
    local main = format:gsub("path", dir)
    local objFolder = format:gsub("path", dir.."/elements")
    local extFolder = format:gsub("path", dir.."/extensions")
    local libFolder = format:gsub("path", dir.."/libraries")

    package.path = main..objFolder..extFolder..libFolder..defaultPath

    _ELEMENTS[elementName] = require(fs.combine("elements", elementName))

    if _EXTENSIONS[elementName] then
        for _, extension in ipairs(_EXTENSIONS[elementName]) do
            if(extension.extensionProperties~=nil)then
                extension.extensionProperties(_ELEMENTS[elementName])
            end
            extension.extensionProperties = nil
            if(extension.init~=nil)then
                extension.init(_ELEMENTS[elementName], basalt)
            end
            extension.init = nil
    
            for a,b in pairs(extension)do
                if(type(a)=="string")then
                    _ELEMENTS[elementName][a] = b
                end
            end
        end
    end

    package.path = defaultPath
    return _ELEMENTS[elementName]
end

function basaltLoader.getElementList()
    return availableElements
end

function basaltLoader.extensionExists(name)
    for k,v in pairs(extensionNames)do
        if(string.lower( v:gsub(".lua", ""))==string.lower(name))then
            return true
        end
    end
    return false
end

function basaltLoader.getExtension(extensionName)
    if(_EXTENSIONS[extensionName]~=nil)then
        return _EXTENSIONS[extensionName]
    end
    return extensionName==nil and _EXTENSIONS or nil
end

function basaltLoader.setBasalt(basaltInstance)
    basalt = basaltInstance
end

return basaltLoader