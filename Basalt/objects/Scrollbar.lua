local tHex = require("tHex")

return function(name, basalt)
    local base = basalt.getObject("VisualObject")(name, basalt)
    local objectType = "Scrollbar"

    base:setZIndex(2)
    base:setSize(1, 8)
    base:setBackground(colors.lightGray, "\127", colors.gray)

    base:addProperty("SymbolChar", "char", " ")
    base:addProperty("SymbolBG", "color", colors.black)
    base:addProperty("SymbolFG", "color", colors.black)
    base:combineProperty("Symbol", "SymbolChar", "SymbolBG", "SymbolFG")
    base:addProperty("SymbolAutoSize", "boolean", true)

    local index = 1

    local function updateSymbolSize()
        local w,h = base:getSize()
        local symbolAutoSize = base:getSymbolAutoSize()
        if(symbolAutoSize)then
            local barType = base:getBarType()
            local scrollAmount = base:getScrollAmount()
            local symbol = base:getSymbolChar()
            base:setSymbolSize(math.max((barType == "vertical" and h or w-(#symbol)) - (scrollAmount-1), 1))
        end
    end
    updateSymbolSize()

    base:addProperty("ScrollAmount", "number", 3, false, updateSymbolSize)
    base:addProperty("SymbolSize", "number", 1, false, updateSymbolSize)
    base:addProperty("BarType", {"vertical", "horizontal"}, "vertical", false, updateSymbolSize)

    local function mouseEvent(self, button, x, y)
    local obx, oby = self:getAbsolutePosition()
    local w,h = self:getSize()
        updateSymbolSize()
        local barType = self:getBarType()
        local symbol = self:getSymbolChar()
        local symbolSize = self:getSymbolSize()
        local size = barType == "vertical" and h or w
        for i = 0, size do
            if ((barType == "vertical" and oby + i == y) or (barType == "horizontal" and obx + i == x)) and (obx <= x) and (obx + w > x) and (oby <= y) and (oby + h > y) then
                index = math.min(i + 1, size - (#symbol + symbolSize - 2))
                self:scrollbarMoveHandler()
                self:updateDraw()
            end
        end
    end

    local object = {
        getType = function(self)
            return objectType
        end,

        load = function(self)
            base.load(self)
            self:listenEvent("mouse_click")
            self:listenEvent("mouse_up")
            self:listenEvent("mouse_scroll")
            self:listenEvent("mouse_drag")
        end,

        setIndex = function(self, _index)
            index = _index
            if (index < 1) then
                index = 1
            end
            updateSymbolSize()
            self:updateDraw()
            return self
        end,

        getIndex = function(self)
            local w,h = self:getSize()
            local barType = self:getBarType()
            local scrollAmount = self:getScrollAmount()
            return scrollAmount > (barType=="vertical" and h or w) and math.floor(scrollAmount/(barType=="vertical" and h or w) * index) or index
        end,

        mouseHandler = function(self, button, x, y, ...)
            if (base.mouseHandler(self, button, x, y, ...)) then
                mouseEvent(self, button, x, y)
                return true
            end
            return false
        end,

        dragHandler = function(self, button, x, y)
            if (base.dragHandler(self, button, x, y)) then
                mouseEvent(self, button, x, y)
                return true
            end
            return false
        end,

        setSize = function(self, ...)
            base.setSize(self, ...)
            updateSymbolSize()
            return self
        end,

        scrollHandler = function(self, dir, x, y)
            if(base.scrollHandler(self, dir, x, y))then
                local w,h = self:getSize()
                updateSymbolSize()
                index = index + dir
                if (index < 1) then
                    index = 1
                end
                local barType = self:getBarType()
                local symbol = self:getSymbolChar()
                local symbolSize = self:getSymbolSize()
                index = math.min(index, (barType == "vertical" and h or w) - (barType == "vertical" and symbolSize - 1 or #symbol+symbolSize-2))
                self:scrollbarMoveHandler()
                self:updateDraw()
            end
        end,

        onChange = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("scrollbar_moved", v)
                end
            end
            return self
        end,


        scrollbarMoveHandler = function(self)
            self:sendEvent("scrollbar_moved", self:getIndex())
        end,

        customEventHandler = function(self, event, ...)
            base.customEventHandler(self, event, ...)
            if(event=="basalt_FrameResize")then
                updateSymbolSize()
            end 
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("scrollbar", function()
                local w,h = self:getSize()
                local barType = self:getBarType()
                local symbol = self:getSymbolChar()
                local symbolSize = self:getSymbolSize()
                local symbolBG = self:getSymbolBG()
                local symbolFG = self:getSymbolFG()
                if (barType == "horizontal") then
                    for n = 0, h - 1 do
                        self:addBlit(index, 1 + n, symbol:rep(symbolSize), tHex[symbolFG]:rep(#symbol*symbolSize), tHex[symbolBG]:rep(#symbol*symbolSize))
                    end
                elseif (barType == "vertical") then
                    for n = 0, h - 1 do
                        if (index == n + 1) then
                            for curIndexOffset = 0, math.min(symbolSize - 1, h) do
                                self:addBlit(1, index + curIndexOffset, symbol:rep(math.max(#symbol, w)), tHex[symbolFG]:rep(math.max(#symbol, w)), tHex[symbolBG]:rep(math.max(#symbol, w)))
                            end
                        end
                    end
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end