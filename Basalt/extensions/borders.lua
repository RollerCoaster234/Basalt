
---@class VisualElement
local borderExtension = {}
local tHex = require("tHex")


---@protected
function borderExtension.extensionProperties(original)
    local Element = require("basaltLoader").load("BasicElement")
    Element:initialize("VisualElement")
    Element:addProperty("border", "boolean", false)
    Element:addProperty("borderSides", "table", {["top"]=true, ["bottom"]=true, ["left"]=true, ["right"]=true})
    Element:addProperty("borderType", "string", "small")
    Element:addProperty("borderColor", "color", colors.black)
end

---@protected
function borderExtension.init(original)
    local Element = require("basaltLoader").load("BasicElement")
    Element:extend("Init", function(self)
        table.insert(self.renderData, function(self)
            local border = self:getBorder()
            if(border)then
                local width, height = self:getSize()
                local borderColor = tHex[self:getBorderColor()]
                local borderside = self:getBorderSides()
                local bg = tHex[self:getBackground()]
                local borderType = self:getBorderType()

                if(borderType=="solid")then
                    for i=1, height do
                        self:addBlit(0, i, " ", borderColor, borderColor, true)
                        self:addBlit(width+1, i, " ", borderColor, borderColor, true)
                    end
                    local emptyStr = (" "):rep(width+2)
                    local bColStr = borderColor:rep(width+2)
                    if(borderside["top"])then
                        self:addBlit(0, 0, emptyStr, bColStr, bColStr, true)
                    end
                    if(borderside["bottom"])then
                        self:addBlit(0, height+1, emptyStr, bColStr, bColStr, true)
                    end
                elseif(borderType=="small")then
                    for i=1, height do
                        if(borderside["left"])then
                            self:addBlit(0, i, "\149", borderColor, bg, true)
                        end
                        if(borderside["right"])then
                            self:addBlit(width+1, i, "\149", bg, borderColor, true)
                        end
                    end
                    local bColStr = borderColor:rep(width+1)
                    local bEleColStr = bg:rep(width+1)
                    if(borderside["top"])then
                        self:addBlit(1, 0, ("\131"):rep(width+1), bColStr, bEleColStr)
                    end
                    if(borderside["bottom"])then
                        self:addBlit(1, height+1, ("\143"):rep(width+1), bEleColStr, bColStr)
                    end
                    if(borderside["top"] and borderside["left"])then  -- top left
                        self:addBlit(0, 0, "\151", borderColor, bg, true)
                    end
                    if(borderside["top"] and borderside["right"])then
                        self:addBlit(width+1, 0, "\148", bg, borderColor, true) -- top right
                    end
                    if(borderside["bottom"] and borderside["left"])then
                        self:addBlit(0, height+1, "\138", bg, borderColor, true) -- bottom left
                    end
                    if(borderside["bottom"] and borderside["right"])then
                        self:addBlit(width+1, height+1, "\133", bg, borderColor, true) -- bottom right
                    end
                end
            end

        end)
        return self
    end)
end

--- Enables/disables the border on a specific side
---@param self VisualElement
---@param side string|table
---@param value? boolean
---@return VisualElement
function borderExtension.setBorderSide(self, side, value)
    if(type(side)=="table")then
        self.borderSides = side
    else
        self.borderSides[side] = value
    end
    return self
end

--- Gets if the border is enabled on a side
---@param self VisualElement
---@param side string
---@return boolean
function borderExtension.getBorderSide(self, side)
    return self.borderSide[side]
end


return {
    VisualElement = borderExtension,
}