local protectedNames = {clamp=true, round=true, math=true, colors=true}
local function replace(word)
    if(protectedNames[word])then return word end
    if word:sub(1, 1):find('%a') and not word:find('.', 1, true) then
        return '"' .. word .. '"'
    end
    return word
end

local function parseString(str)
    str = str:gsub("{", "")
    str = str:gsub("}", "")
    for k,v in pairs(colors)do
        if(type(k)=="string")then
            str = str:gsub("%f[%w]"..k.."%f[%W]", "colors."..k)
        end
    end
    str = str:gsub("(%s?)([%w.]+)", function(a, b) return a .. replace(b) end)
    str = str:gsub("%s?%?", " and ")
    str = str:gsub("%s?:", " or ")
    str = str:gsub("%.w%f[%W]", ".width")
    str = str:gsub("%.h%f[%W]", ".height")
    return str
end



local function processString(str, env)
    env.math = math
    env.colors = colors
    env.clamp = function(val, min, max)
        return math.min(math.max(val, min), max)
    end
    env.round = function(val)
        return math.floor(val + 0.5)
    end
    local f = load("return " .. str, "", nil, env)

    if(f==nil)then error(str.." - is not a valid dynamic value string") end
    return f()
end

local function dynamicValue(object, name, dynamicString)
    local objectGroup = {}
    local observers = {}
    dynamicString = parseString(dynamicString)
    local cachedValue = nil
    local needsUpdate = true

    local function updateFunc()
        needsUpdate = true
    end

    for v in dynamicString:gmatch("%a+%.%a+")do
        local name = v:gsub("%.%a+", "")
        local prop = v:gsub("%a+%.", "")
        if(objectGroup[name]==nil)then
            objectGroup[name] = {}
        end
        table.insert(objectGroup[name], prop)
    end

    for k,v in pairs(objectGroup) do
        if(k=="self") then
            for _, b in pairs(v) do
                if(name~=b)then
                    object:addPropertyObserver(b, updateFunc)
                    if(b=="clicked")or(b=="dragging")then
                        object:listenEvent("mouse_click")
                        object:listenEvent("mouse_up")
                    end
                    if(b=="dragging")then
                        object:listenEvent("mouse_drag")
                    end
                    if(b=="hovered")then
                        object:listenEvent("mouse_move")
                    end
                    table.insert(observers, {obj=object, name=b})
                else
                    error("Dynamic Values - self reference to self")
                end
            end
        end

        if(k=="parent") then
            for _, b in pairs(v) do
                object.parent:addPropertyObserver(b, updateFunc)
                table.insert(observers, {obj=object.parent, name=b})
            end
        end

        if(k~="self" and k~="parent")and(protectedNames[k]==nil)then
            local obj = object:getParent():getChild(k)
            for _, b in pairs(v) do
                obj:addPropertyObserver(b, updateFunc)
                table.insert(observers, {obj=obj, name=b})
            end
        end
    end


    local function calculate()
        local env = {}
        local parent = object:getParent()
        for k,v in pairs(objectGroup)do
            local objTable = {}

            if(k=="self")then
                for _,b in pairs(v)do
                    objTable[b] = object:getProperty(b)
                end
            end

            if(k=="parent")then
                for _,b in pairs(v)do
                    objTable[b] = parent:getProperty(b)
                end
            end

            if(k~="self")and(k~="parent")and(protectedNames[k]==nil)then
                local obj = parent:getChild(k)
                if(obj==nil)then
                    error("Dynamic Values - unable to find object: "..k)
                end
                for _,b in pairs(v)do
                    objTable[b] = obj:getProperty(b)
                end
            end
            env[k] = objTable
        end
        return processString(dynamicString, env)
    end

    return {
        get = function(self)
            if(needsUpdate)then
                cachedValue = calculate()
                needsUpdate = false
                object:forcePropertyObserverUpdate(name)
                object:updateRender()
            end
            return cachedValue
        end,
        removeObservers = function(self)
            for _,v in pairs(observers)do
                v.obj:removePropertyObserver(v.name, updateFunc)
            end
        end,
    }
end

local function filterDynValues(self, name, value)
    if(type(value)=="string")and(value:sub(1,1)=="{")and(value:sub(-1)=="}")then
        self.dynValues[name] = dynamicValue(self, name, value)
        value = self.dynValues[name].get
    end
    return value
end

-- The Object Extension API
local DynExtension = {}

function DynExtension.pluginProperties(original)
    original:initialize("Object")
    original:addProperty("dynValues", "table", {})
end

function DynExtension.init(original)
    local setProp = original.setProperty
    original.setProperty = function(self, name, value, rule)
        if(self.dynValues==nil)then
            self.dynValues = {}
        end
        if(self.dynValues[name]~=nil)then
            self.dynValues[name].removeObservers()
        end
        self.dynValues[name] = nil
        value = filterDynValues(self, name, value)
        setProp(self, name, value, rule)
    end
end

return {
    Object = DynExtension
}