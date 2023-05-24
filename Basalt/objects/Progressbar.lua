return function(name, basalt)
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    local objectType = "Progressbar"

    base:setZIndex(5)
    base:setValue(false)
    base:setSize(25, 3)

    base:addProperty("Progress", "number", 0, false, function(self, value)
        local progress = self:getProgress()
        if (value >= 0) and (value <= 100) and (progress ~= value) then
            self:setValue(progress)
            if (progress == 100) then
                self:progressDoneHandler()
            end
            return value
        end
        return progress
    end)
    base:addProperty("Direction", "number", 0)
    base:addProperty("ActiveBarSymbol", "char", "")
    base:addProperty("ActiveBarColor", "number", colors.black)
    base:addProperty("ActiveBarSymbolColor", "number", colors.white)
    base:combineProperty("ProgressBar", "ActiveBarColor", "ActiveBarSymbol", "ActiveBarSymbolColor")
    base:addProperty("BackgroundSymbol", "char", "")

    local object = {
        getType = function(self)
            return objectType
        end,

        onProgressDone = function(self, f)
            self:registerEvent("progress_done", f)
            return self
        end,

        progressDoneHandler = function(self)
            self:sendEvent("progress_done")
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("progressbar", function()
                local w,h = self:getSize()
                local progress = self:getProgress()
                local activeBarColor, activeBarSymbol, activeBarSymbolCol = self:getProgressBar()
                local direction = self:getDirection()
                local bgBarSymbol = self:getBackgroundSymbol()
                local bgCol = self:getbackground()
                local fgCol = self:getForeground()
                if(bgCol~=false)then self:addBackgroundBox(1, 1, w, h, bgCol) end
                if(bgBarSymbol~="")then self:addTextBox(1, 1, w, h, bgBarSymbol) end
                if(fgCol~=false)then self:addForegroundBox(1, 1, w, h, fgCol) end
                if (direction == 1) then
                    self:addBackgroundBox(1, 1, w, h / 100 * progress, activeBarColor)
                    self:addForegroundBox(1, 1, w, h / 100 * progress, activeBarSymbolCol)
                    self:addTextBox(1, 1, w, h / 100 * progress, activeBarSymbol)
                elseif (direction == 3) then
                    self:addBackgroundBox(1, 1 + math.ceil(h - h / 100 * progress), w, h / 100 * progress, activeBarColor)
                    self:addForegroundBox(1, 1 + math.ceil(h - h / 100 * progress), w, h / 100 * progress, activeBarSymbolCol)
                    self:addTextBox(1, 1 + math.ceil(h - h / 100 * progress), w, h / 100 * progress, activeBarSymbol)
                elseif (direction == 2) then
                    self:addBackgroundBox(1 + math.ceil(w - w / 100 * progress), 1, w / 100 * progress, h, activeBarColor)
                    self:addForegroundBox(1 + math.ceil(w - w / 100 * progress), 1, w / 100 * progress, h, activeBarSymbolCol)
                    self:addTextBox(1 + math.ceil(w - w / 100 * progress), 1, w / 100 * progress, h, activeBarSymbol)
                else
                    self:addBackgroundBox(1, 1, math.ceil( w / 100 * progress), h, activeBarColor)
                    self:addForegroundBox(1, 1, math.ceil(w / 100 * progress), h, activeBarSymbolCol)
                    self:addTextBox(1, 1, math.ceil(w / 100 * progress), h, activeBarSymbol)
                end
            end)
        end,

    }

    object.__index = object
    return setmetatable(object, base)
end