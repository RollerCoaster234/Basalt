local function copy(t)
    local new = {}
    for k,v in pairs(t)do
        new[k] = v
    end
    return new
end

local baseTemplate = {
    default = {
        background = colors.cyan,
        foreground = colors.black,
    },
    BaseFrame = {
        background = colors.white,
        foreground = colors.black,
        Button = {
            background = "{self.clicked ? black : cyan}",
            foreground = "{self.clicked ? cyan : black}"
        },
        Container = {
            background = colors.black,
            Button = {
                background = "{self.clicked ? black : cyan}",
                foreground = "{self.clicked ? cyan : black}"
            },
        },
        Checkbox = {
            background = colors.black,
            foreground = colors.cyan,
        },
        Input = {
            background = "{self.focused ? cyan : black}",
            foreground = "{self.focused ? black : cyan}",
        },
        Slider = {
            background = nil,
            knobBackground = "{self.focused ? cyan : black}",
        },
        Label = {
            background = nil,
        },
    },
}

local TempExtension = {}

function TempExtension.init(original, basalt)
    original:extend("Init", function(self)
        local template = basalt.getTemplate(self)
        local objects = basalt.getObjects()
        if(template~=nil)then
            for k,v in pairs(template)do
                if(objects[k]==nil)then
                    if(colors[v]~=nil)then
                        self:setProperty(k, colors[v])
                    else
                        self:setProperty(k, v)
                    end
                end
            end
        end
        return self
    end)
end

function TempExtension.__getElementPathTypes(self, types)
    if(types~=nil)then
        table.insert(types, 1, self.type)
    else
        types = {self.type}
    end
    local parent = self:getParent()
    if(parent~=nil)then
        return parent:__getElementPathTypes(types)
    else
        return types
    end
end

local function lookUpTemplate(allTypes)
    local elementData = copy(baseTemplate.default)
    local tLink = baseTemplate
    if(tLink~=nil)then
        for _, v in pairs(allTypes)do
            for _, b in pairs(v)do
                if(tLink[b]~=nil)then
                    tLink = tLink[b]
                    for k, v in pairs(tLink) do
                        elementData[k] = v
                    end
                    break
                else
                    for k, v in pairs(baseTemplate.default) do
                        elementData[k] = v
                    end
                end
            end
        end
    end
    return elementData
end

local Basalt = {}
function Basalt.getTemplate(element)
    if(element==nil)then
        return baseTemplate
    end
    return lookUpTemplate(element:__getElementPathTypes())
end

function Basalt.addTemplate(newTemplate)
    if(type(newTemplate)=="string")then
        local file = fs.open(newTemplate, "r")
        if(file~=nil)then
            local data = file.readAll()
            file.close()
            baseTemplate = textutils.unserializeJSON(data)
        else
            error("Could not open template file "..newTemplate)
        end
    end
    if(type(newTemplate)=="table")then
        for k,v in pairs(newTemplate)do
            baseTemplate[k] = v
        end
    end
end

function Basalt.setTemplate(newTemplate)
    baseTemplate = newTemplate
end

return {
    Object = TempExtension,
    Basalt = Basalt,
}