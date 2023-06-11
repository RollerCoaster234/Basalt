local split = require("utils").splitString
local deepcopy = require("utils").deepcopy

local Object = {methods = {}}
setmetatable(Object, {__index = Object.methods})

local properties = {}
local extensions = {}
local activeType = "Object"

function Object.new(self)
    local newInstance = setmetatable({}, self)
    self.__index = self
    self.__noCopy = true
    newInstance:create("Object")
    return newInstance
end

local function defaultRule(typ)
    return function(self, name, value)
        local isValid = false
        if(type(typ)=="string")then
        local types = split(typ, "|")

            for _,v in pairs(types)do
                if(type(value)==v)then
                    isValid = true
                end
            end
        end
        if(typ=="color")then
            if(type(value)=="string")then
                if(colors[value]~=nil)then
                    isValid = true
                    value = colors[value]
                end
            else
                for _,v in pairs(colors)do
                    if(v==value)then
                        isValid = true
                    end
                end
            end
        end
        if(typ=="char")then
            if(type(value)=="string")then
                if(#value==1)then
                    isValid = true
                end
            end
        end
        if(typ=="any")or(value==nil)or(type(value)=="function")then
            isValid = true
        end

        if(not isValid)then
            if(type(typ)=="table")then
                typ = table.concat(typ, ", ")
            end
            error(self:getType()..": Invalid type for property "..name.."! Expected "..typ..", got "..type(value))
        end
        return value
    end
end

function Object.addPropertyObserver(self, propertyName, observerFunction)
    if not self.propertyObservers[propertyName] then
        self.propertyObservers[propertyName] = {}
    end
    table.insert(self.propertyObservers[propertyName], observerFunction)
end

function Object.removePropertyObserver(self, propertyName, index)
    if not self.propertyObservers[propertyName] then
        return
    end
    if(type(index)=="number")then
        table.remove(self.propertyObservers[propertyName], index)
    else
        for k,v in pairs(self.propertyObservers[propertyName])do
            if(v==index)then
                table.remove(self.propertyObservers[propertyName], k)
            end
        end
    end
end

function Object.forcePropertyObserverUpdate(self, propertyName)
    if not self.propertyObservers[propertyName] then
        return
    end
    for _,v in pairs(self.propertyObservers[propertyName])do
        v(self, propertyName)
    end
end

function Object.setProperty(self, name, value, rule)
    if(rule~=nil)then
        value = rule(self, name, value)
    end
    if type(value) == 'table' then
        value = deepcopy(value)
    end

    if(self[name]~=value)then
        self[name] = value
    end

    if(self.propertyObservers[name]~=nil)then
        for _,v in pairs(self.propertyObservers[name])do
            v(self, name, value)
        end
    end
    return self
end

function Object.getProperty(self, name)
    local prop = self[name]
    if(type(prop)=="function")then
        return prop()
    end
    return prop
end

function Object.setProperties(self, properties)
    for k,v in pairs(properties) do
        self[k] = v
    end
    return self
end

function Object.getProperties(self)
    local p = {}
    for k,v in pairs(self)do
        if(type(v)=="function")then
            p[k] = v()
        else
            p[k] = v
        end
    end
    return p
end

function Object.updateRender(self)
    if(self.parent~=nil)then
        self.parent:updateRender()
    else
        self.updateRendering = true
    end
end

function Object.addProperty(self, name, typ, defaultValue, readonly, setLogic, getLogic, alteredRule)
    if(typ==nil)then typ = "any" end
    if(readonly==nil)then readonly = false end
    if(alteredRule==nil)then alteredRule = defaultRule(typ) end

    local fName = name:gsub("^%l", string.upper)
    if not properties[activeType] then
        properties[activeType] = {}
    end
    if(type(defaultValue)=="table")then
        defaultValue = deepcopy(defaultValue)
    end
    properties[activeType][name] = defaultValue

    if not(readonly)then
        self["set"..fName] = function(self, value, ignRenderUpdate, ...)
            if(setLogic~=nil)then
                local modifiedVal = setLogic(self, value, ...)
                if(modifiedVal~=nil)then
                    value = modifiedVal
                end
            end
            if ignRenderUpdate~=true then
                self:updateRender()
            end
            self:setProperty(name, value, alteredRule~=nil and alteredRule(typ) or defaultRule(typ))
            return self
        end
    end
    self["get"..fName] = function(self, ...)
        local prop = self:getProperty(name)
        if(getLogic~=nil)then
            return getLogic(self, prop, ...)
        end
        return prop
    end
end

function Object.combineProperty(self, name, ...)
    name = name:gsub("^%l", string.upper)
    local args = {...}
    self["get" .. name] = function(self)
        local result = {}
        for _,v in pairs(args)do
            result[#result+1] = self["get" .. v:gsub("^%l", string.upper)](self)
        end
        return unpack(result)
    end
    self["set" .. name] = function(self, ...)
        local values = {...}
        for k,v in pairs(args)do
            self["set" .. v:gsub("^%l", string.upper)](self, values[k])
        end
        return self
    end
    return self
end

function Object.initialize(self, typ)
    activeType = typ
    return self
end

function Object.create(self, typ)
    if(properties[typ]~=nil)then
        for k,v in pairs(properties[typ])do
            if(type(v)=="table")then
                self[k] = deepcopy(v)
            else
                self[k] = v
            end
        end
    end
end

function Object.addListener(self, name, event)
    self["on"..name:gsub("^%l", string.upper)] = function(self, ...)
        for _,f in pairs({...})do
            if(type(f)=="function")then
                if(self.listeners==nil)then
                    self.listeners = {}
                end
                if(self.listeners[name]==nil)then
                    self.listeners[name] = {}
                end
                table.insert(self.listeners[name], f)
            end
        end
        self:listenEvent(event)
        return self
    end
return self
end

function Object.fireEvent(self, name, ...)
    if(self.listeners~=nil)then
        if(self.listeners[name]~=nil)then
            for _,v in pairs(self.listeners[name])do
                v(self, ...)
            end
        end
    end
    return self
end

function Object.isType(self, typ)
    for _,v in pairs(self.type)do
        if(v==typ)then
            return true
        end
    end
    return false
end

function Object.listenEvent(self, event, active)
    if(self.parent~=nil)then
        if(active)or(active==nil)then
            self.parent:addEvent(event, self)
            self.events[event] = true
        elseif(active==false)then
            self.parent:removeEvent(event, self)
            self.events[event] = false
        end
    end
    return self
end

function Object.updateEvents(self)
    if(self.parent~=nil)then
        for k,v in pairs(self.events)do
            if(v)then
                self.parent:addEvent(k, self)
            else
                self.parent:removeEvent(k, self)
            end
        end
    end
    return self
end

function Object.extend(self, name, f)
    if(extensions[activeType]==nil)then
        extensions[activeType] = {}
    end
    if(extensions[activeType][name]==nil)then
        extensions[activeType][name] = {}
    end
    table.insert(extensions[activeType][name], f)
    return self
end

function Object.callExtension(self, name)
    for k,t in pairs(self.type)do
        if(extensions[t]~=nil)then
            if(extensions[t][name]~=nil)then
                for _,v in pairs(extensions[t][name])do
                    v(self)
                end
            end
        end
    end
    return self
end

Object:addProperty("Name", "string", "Object")

Object:addProperty("type", "string|table", {"Object"}, false, function(self, value)
    if(type(value)=="string")then
        table.insert(self.type, 1, value)
        return self.type
    end
end,
function(self, _, depth)
    return self.type[depth or 1]
end)
Object:addProperty("z", "number", 1, false, function(self, value)
    if (self.parent ~= nil) then
        self.parent:updateChildZIndex(self, value)
    end
    return value
end)
Object:addProperty("enabled", "boolean", true)
Object:addProperty("parent", "table", nil)
Object:addProperty("events", "table", {})
Object:addProperty("propertyObservers", "table", {})

function Object.init(self)
    if not self.initialized then
        self:callExtension("Init")
    end
    self:setProperty("initialized", true)
    self:callExtension("Load")
end

return Object