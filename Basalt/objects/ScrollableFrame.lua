local max,min,sub,rep = math.max,math.min,string.sub,string.rep

return function(name, basalt)
    local base = basalt.getObject("Frame")(name, basalt)
    local objectType = "ScrollableFrame"

    base:addProperty("AutoCalculate", "boolean", true)
    base:addProperty("Direction", "number", 0)
    base:addProperty("ScrollAmount", "number", 0, false, function(self, value)
        self:setAutoCalculate(false)
    end)
    base:addProperty("ScrollSpeed", "number", 1)

    local function getHorizontalScrollAmount(self)
        local amount = 0
        local children = self:getChildren()
        for _, b in pairs(children) do
            if(b.element.getWidth~=nil)and(b.element.getX~=nil)then
                local w, x = b.element:getWidth(), b.element:getX()
                local width = self:getWidth()
                if(b.element:getType()=="Dropdown")then
                    if(b.element:isOpened())then
                        local dropdownW = b.element:getDropdownSize()
                        if (dropdownW + x - width >= amount) then
                            amount = max(dropdownW + x - width, 0)
                        end
                    end
                end

                if (w + x - width >= amount) then
                    amount = max(w + x - width, 0)
                end
            end
        end
        return amount
    end

    local function getVerticalScrollAmount(self)
        local amount = 0
        local children = self:getChildren()
        for _, b in pairs(children) do
            if(b.element.getHeight~=nil)and(b.element.getY~=nil)then
                local h, y = b.element:getHeight(), b.element:getY()
                local height = self:getHeight()
                if(b.element:getType()=="Dropdown")then
                    if(b.element:isOpened())then
                        local _,dropdownH = b.element:getDropdownSize()
                        if (dropdownH + y - height >= amount) then
                            amount = max(dropdownH + y - height, 0)
                        end
                    end
                end
                if (h + y - height >= amount) then
                    amount = max(h + y - height, 0)
                end
            end
        end
        return amount
    end

    local function scrollHandler(self, dir)
        local xO, yO = self:getOffset()
        local scrollAmn
        local direction = self:getDirection()
        local calculateScrollAmount = self:getAutoCalculate()
        local manualScrollAmount = self:getScrollAmount()
        local scrollSpeed = self:getScrollSpeed()
        if(direction==1)then
            scrollAmn = calculateScrollAmount and getHorizontalScrollAmount(self) or manualScrollAmount
            self:setOffset(min(scrollAmn, max(0, xO + dir * scrollSpeed)), yO)
        elseif(direction==0)then
            scrollAmn = calculateScrollAmount and getVerticalScrollAmount(self) or manualScrollAmount
            self:setOffset(xO, min(scrollAmn, max(0, yO + dir * scrollSpeed)))
        end
        self:updateDraw()
    end
    
    local object = {    
        getType = function()
            return objectType
        end,

        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        getBase = function(self)
            return base
        end, 
        
        load = function(self)
            base.load(self)
            self:listenEvent("mouse_scroll")
            self:listenEvent("mouse_drag")
        end,

        removeChildren = function(self)
            base.removeChildren(self)
            self:listenEvent("mouse_scroll")
        end,

        scrollHandler = function(self, dir, x, y)
            if(base:getBase().scrollHandler(self, dir, x, y))then
                self:sortChildren()
                for _, obj in ipairs(self:getEvents("mouse_scroll")) do
                    if (obj.element.scrollHandler ~= nil) then
                        local xO, yO = 0, 0
                        if(self.getOffset~=nil)then
                            xO, yO = self:getOffset()
                        end
                        if(obj.element.getIgnoreOffset())then
                            xO, yO = 0, 0
                        end
                        if (obj.element.scrollHandler(obj.element, dir, x+xO, y+yO)) then
                            return true
                        end
                    end
                end
                scrollHandler(self, dir)
                self:clearFocusedChild()
                return true
            end
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("scrollableFrame", function()
                if(self:getAutoCalculate())then
                    scrollHandler(self, 0)
                end
            end, 0)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end