return function(name, basalt)
    local base = basalt.getObject("VisualObject")(name, basalt)
    -- Base object
    local objectType = "ChangeableObject"


    base:addProperty("ChangeHandler", "function", nil)
    base:addProperty("value", "any", nil, false, function(self, value)
        local _value = self:getValue()
        if (value ~= _value) then
            local valueChangedHandler = self:getChangeHandler()
            print(valueChangedHandler)
            if(valueChangedHandler~=nil)then
                valueChangedHandler(self, value)
            end
            self:sendEvent("value_changed", value)
        end
    end)
    
    local object = {
        getType = function(self)
            return objectType
        end,
        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,
        onChange = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("value_changed", v)
                end
            end
            return self
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end