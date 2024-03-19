local split = require("utils").splitString
local deepcopy = require("utils").deepcopy
local uuid = require("utils").uuid

local Element = {}

local properties = {}
local propertyTypes = {}
local extensions = {}
local activeType = "BasicElement"

function Element:new(id, parent, basalt)
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self
    newInstance.__noCopy = true
    newInstance:create("BasicElement")
    newInstance.parent = parent
    newInstance.basalt = basalt
    newInstance.Name = id or uuid()
    return newInstance
end

--[[
    setmetatable(proxy, {
    __index = function(_, key)
        return t[key]
    end,
    __newindex = function(_, key, value)
        t[key] = value
    end
})
]]

local function defaultRule(typ)
    return function(self, name, value)
        local isValid = false
        if(type(typ)=="string")then
        local types = split(typ, "|")

            for _,v in pairs(types)do
                if(type(value)==v)then
                    isValid = true
                end
                if(v=="number")then
                    if(type(value)=="string")then
                        if(tonumber(value)~=nil)then
                            isValid = true
                            value = tonumber(value)
                        end
                    end
                end
                if(v=="boolean")then
                    if(type(value)=="string")then
                        if(value=="true")then
                            isValid = true
                            value = true
                        elseif(value=="false")then
                            isValid = true
                            value = false
                        end
                    end
                end
                if(v:find("table"))then
                    -- v could have something like string|table>name,background,foreground we need to sub table>name,background,foreground out of the string and store it to a variable
                    local subTable = v:match("table>(.*)")
                    if(subTable)then
                        local subTableTypes = split(subTable, ",")
                        if(type(value)=="table")then
                            local newTable = {}
                            for k,v in pairs(subTableTypes)do
                                if(value[v]~=nil)then
                                    newTable[v] = value[v]
                                else
                                    error(self:getType()..": Invalid type for property "..name.."! Expected table with keys "..subTable)
                                end
                            end
                            value = newTable
                            isValid = true
                        end
                    elseif(type(value)=="table")then
                        isValid = true
                    end

                    
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

function Element.addPropertyObserver(self, propertyName, observerFunction)
    if not self.propertyObservers[propertyName] then
        self.propertyObservers[propertyName] = {}
    end
    table.insert(self.propertyObservers[propertyName], observerFunction)
end

function Element.removePropertyObserver(self, propertyName, index)
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

function Element.forcePropertyObserverUpdate(self, propertyName)
    if not self.propertyObservers[propertyName] then
        return
    end
    for _,v in pairs(self.propertyObservers[propertyName])do
        v(self, propertyName)
    end
end

function Element.setProperty(self, name, value, rule)
    if(name==nil)then
        error(self:getType()..": Property name cannot be nil!")
    end
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

function Element.getProperty(self, name)
    local prop = self[name]
    if(type(prop)=="function")then
        return prop()
    end
    return prop
end

function Element.hasProperty(self, name)
    return self[name]~=nil
end

function Element.setProperties(self, properties)
    for k,v in pairs(properties) do
        self[k] = v
    end
    return self
end

function Element.getProperties(self)
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

function Element.getPropertyType(self, name)
    for k,v in pairs(self.type)do
        if(propertyTypes[v]~=nil)then
            if(propertyTypes[v][name]~=nil)then
                return propertyTypes[v][name]
            end
        end
    end
end

function Element.updateRender(self)
    if(self.parent~=nil)then
        self.parent:forceVisibleChildrenUpdate()
        self.parent:updateRender()
    else
        self.updateRendering = true
    end
end

function Element.addProperty(self, name, typ, defaultValue, readonly, setLogic, getLogic)
    if(typ==nil)then typ = "any" end
    if(readonly==nil)then readonly = false end

    local fName = name:gsub("^%l", string.upper)
    if not properties[activeType] then
        properties[activeType] = {}
        propertyTypes[activeType] = {}
    end
    if(type(defaultValue)=="table")then
        defaultValue = deepcopy(defaultValue)
    end
    properties[activeType][name] = defaultValue
    propertyTypes[activeType][name] = typ

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
            self:setProperty(name, value, defaultRule(typ))
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

local log = require("log")
function Element.combineProperty(self, name, ...)
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

function Element.initialize(self, typ)
    activeType = typ
    return self
end

function Element:create(typ)
    if(properties[typ]~=nil)then
        for k,v in pairs(properties[typ])do
            if(type(v)=="table")then
                self[k] = deepcopy(v)
                if(k=="dynValues")then
                    --log(v, self[k])
                end
            else
                self[k] = v
            end
        end
    end
end

function Element.addListener(self, name, event)
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

function Element.fireEvent(self, name, ...)
    if(self.listeners~=nil)then
        if(self.listeners[name]~=nil)then
            for _,v in pairs(self.listeners[name])do
                v(self, ...)
            end
        end
    end
    return self
end

function Element.isType(self, typ)
    for _,v in pairs(self.type)do
        if(v==typ)then
            return true
        end
    end
    return false
end

function Element.listenEvent(self, event, active)
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

function Element.updateEvents(self)
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

function Element.extend(self, name, f)
    if(extensions[activeType]==nil)then
        extensions[activeType] = {}
    end
    if(extensions[activeType][name]==nil)then
        extensions[activeType][name] = {}
    end
    table.insert(extensions[activeType][name], f)
    return self
end

function Element.callExtension(self, name)
    for _,t in pairs(self.type)do
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

Element:addProperty("Name", "string", "BasicElement")

Element:addProperty("type", "string|table", {"BasicElement"}, false, function(self, value)
    if(type(value)=="string")then
        table.insert(self.type, 1, value)
        return self.type
    end
end,
function(self, _, depth)
    return self.type[depth or 1]
end)
Element:addProperty("z", "number", 1, false, function(self, value)
    self.z = value
    if (self.parent ~= nil) then
        self.parent:updateChild(self)
    end
    return value
end)
Element:addProperty("enabled", "boolean", true)
Element:addProperty("parent", "table", nil)
Element:addProperty("events", "table", {})
Element:addProperty("propertyObservers", "table", {})

function Element.init(self)
    if not self.initialized then
        self:callExtension("Init")
    end
    self:setProperty("initialized", true)
    self:callExtension("Load")
end

return Element