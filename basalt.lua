settings.define("basalt.path", {description="Path to the basalt folder", default=".basalt", type="string"})
settings.define("basalt.cacheGlobally", {description="Cache the basalt API globally", default=false, type="boolean"})
settings.define("basalt.downloadFiles", {description="Download the required files from Github", default=true, type="boolean"})
settings.define("basalt.storeDownloadedFiles", {description="", default=false, type="boolean"})
settings.define("basalt.autoUpdate", {description="Automatically update the project from Github", default=false, type="boolean"})
settings.define("basalt.versions", {description="The versions of the elements and extensions", default={}, type="table"})
settings.define("basalt.github", {description="The URL to the Github repository", default="https://raw.githubusercontent.com/pyroxenium/Basalt/basalt2/", type="string"})

-- Settings:
local basaltPath = settings.get("basalt.path")
local cacheGlobally = settings.get("basalt.cacheGlobally")
local downloadFiles = settings.get("basalt.downloadFiles")
local autoUpdate = settings.get("basalt.autoUpdate")
local storeDownloadedFiles = settings.get("basalt.storeDownloadedFiles")
local githubURL = settings.get("basalt.github")
local basaltVersion = settings.get("basalt.versions")
--

local githubBasaltConfig = githubURL.."config.json"

-- DO NOT TOUCH BELOW THIS LINE

--- @class BasaltLoader : Basalt
local _basalt = {}

local format = "path;/path/?.lua;/path/?/init.lua;"
local mainPath = format:gsub("path", ".basalt")
package.path = mainPath..basaltPath

local requiredElements = {}
local requiredExtensions = {}
local main = {}
local config
local loaded = false

local function getConfig(key)
    if(config~=nil)then
        return config[key]
    end
    local file = http.get(githubBasaltConfig)
    if(file == nil) then
        error("Failed to download the Basalt config file")
    end
    config = textutils.unserializeJSON(file.readAll())
    return config[key]
end

--- This function will tell Basalt to require a specific element or extension. It will try to download the file from the Github repository if it doesn't exist.
--- @param typ --- The type of the required file. Can be either "element" or "extension".
---| '"extension"' # Looks for the required file in the extensions folder.
---| '"element"' #  Looks for the required file in the elements folder.
--- @param name string -- The name of the required file.
function _basalt.required(typ, name)
    if typ == "element" then
        requiredElements[name] = true
    elseif typ == "extension" then
        requiredExtensions[name] = true
    end
end

--- This function will set a value in the settings API. Look at https://basalt.madefor.cc/ for settings documentation.
--- @param key string -- The key of the setting.
--- @param value any -- The value of the setting.
function _basalt.set(key, value)
    settings.set(key, value)
end

local function downloadRequiredFile(name, typ)
    local url
    if(typ==nil)then
        url = githubURL.."Basalt/"..name..".lua"
        print("Downloading "..name.." from "..url)
    else
        url = githubURL.."Basalt/"..typ.."/"..name..".lua"
        print("Downloading "..typ.." "..name.." from "..url)
    end
    local file = http.get(url)
    if(file == nil) then
        error("Failed to download "..(typ or "").." "..name)
    end
    return file.readAll()
end

local function updateFile(path, file)
    local f = fs.open(path, "w")
    f.write(file)
    f.close()
end

local function checkFileUpdate(name, typ)
    local newestVersion = getConfig("versions")
    if(typ~=nil)then
        if(newestVersion[typ]~=nil)then
            if(newestVersion[typ][name]~=nil)then
                if(basaltVersion[typ]==nil)then
                    basaltVersion[typ] = {}
                end
                if(basaltVersion[typ][name]==nil)then
                    basaltVersion[typ][name] = 0
                end
                if(newestVersion[typ][name]>basaltVersion[typ][name])then
                    local file = downloadRequiredFile(name, typ)
                    updateFile(basaltPath.."/"..typ.."/"..name..".lua", file)
                    basaltVersion[typ][name] = newestVersion[typ][name]
                    return true
                end
            end
        end
    else
        if(newestVersion[name]~=nil)then
            if(basaltVersion[name]==nil)then
                basaltVersion[name] = 0
            end
            if(newestVersion[name]>basaltVersion[name])then
                local file = downloadRequiredFile(name, typ)
                updateFile(basaltPath.."/"..name..".lua", file)
                basaltVersion[name] = newestVersion[name]
                return true
            end
        end
    end
end

local blacklist = {
    ["config.json"] = true,
    elements = true,
    extensions = true,
    libraries = true
}

if(autoUpdate)then
    local elementFiles = fs.list(basaltPath.."/elements")
    for _,v in pairs(elementFiles)do
        v = v:gsub(".lua", "")
        if(checkFileUpdate(v:gsub(".lua", ""), "elements"))then
            print("Updated "..v)
        end
    end
    local extensionFiles = fs.list(basaltPath.."/extensions")
    for _,v in pairs(extensionFiles)do
        if(checkFileUpdate(v:gsub(".lua", ""), "extensions"))then
            print("Updated "..v)
        end
    end
    local libFiles = fs.list(basaltPath.."/libraries")
    for _,v in pairs(libFiles)do
        if(checkFileUpdate(v:gsub(".lua", ""), "libraries"))then
            print("Updated "..v)
        end
    end
    local baseFiles = fs.list(basaltPath)
    for _,v in pairs(baseFiles)do
        v = v:gsub(".lua", "")
        if(blacklist[v]==nil)then
            if(checkFileUpdate(v))then
                print("Updated "..v)
            end
        end
    end
    settings.set("basalt.versions", basaltVersion)
end
    local basalt_mt = {
    __index = function(tbl, key)
        if(key == "required") then
            return _basalt.required
        end
        if(key == "set")then
            return _basalt.set
        end
        if not loaded then
            package.path = mainPath..basaltPath
            if(downloadFiles) then
                for k,v in pairs(requiredElements) do
                    k = k:gsub("^%l", string.upper)
                    if not fs.exists(basaltPath.."/elements/"..k..".lua") then
                        if(storeDownloadedFiles)then
                            local file = downloadRequiredFile(k, "element")
                            local f = fs.open(basaltPath.."/elements/"..k..".lua", "w")
                            print(f)
                            f.write(file)
                            f.close()
                        else
                            if(package.loaded["elements/"..k]==nil)then
                                package.loaded["elements/"..k] = downloadRequiredFile(k, "element")
                            end
                        end
                    end
                end
                for k,v in pairs(requiredExtensions) do
                    if not fs.exists(basaltPath.."/extensions/"..k..".lua") then
                        if(storeDownloadedFiles)then
                            local file = downloadRequiredFile(k, "extension")
                            local f = fs.open(basaltPath.."/extensions/"..k..".lua", "w")
                            f.write(file)
                            f.close()
                        else
                            if(package.loaded["extensions/"..k]==nil)then
                                package.loaded["extensions/"..k] = downloadRequiredFile(k, "extension")
                            end
                        end
                    end
                end
            end
            if(basalt~=nil)and(cacheGlobally)then
                main = basalt
            else
                main = require("basaltInit")
            end
            if(cacheGlobally)then
                _G.basalt = main
            end
            package.path = basaltPath
        end
        loaded = true
        return main[key]
    end
}
setmetatable(_basalt, basalt_mt)

return _basalt