
local bbgExtension = {}

function bbgExtension.extensionProperties(original)
    local Element = require("basaltLoader").load("BasicElement")
    Element:initialize("VisualElement")
    Element:addProperty("backgroundSymbol", "char", "")
    Element:addProperty("backgroundSymbolColor", "color", colors.red)
end

function bbgExtension.init(original)
    local Element = require("basaltLoader").load("BasicElement")
    Element:extend("Init", function(self)
        table.insert(self.renderData, 2, function(self)
            local bg = self:getBackgroundSymbol()
            if(bg~="")or(bg~=" ")then
                local width, height = self:getSize()
                bg = bg:sub(1,1)
                for i=1, height do
                    self:addText(1, i, bg:rep(width))
                end
            end
        end)
        return self
    end)
end


return {
    VisualElement = bbgExtension,
}