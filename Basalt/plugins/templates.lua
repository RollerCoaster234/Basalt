local split = require("utils").splitString

local plugin = {
    VisualObject = function(base, basalt)
        return {
            __getElementPathTypes = function(self, types)
                if(types~=nil)then
                    table.insert(types, 1, self:getTypes())
                else
                    types = {self:getTypes()}
                end
                local parent = self:getParent()
                if(parent~=nil)then
                    return parent:__getElementPathTypes(types)
                else
                    return types
                end
            end,

            init = function(self)
                base.init(self)
                local template = basalt.getTemplate(self)
                if(template~=nil)then
                    for k,v in pairs(template)do
                        if(colors[v]~=nil)then
                            self:setProperty(k, colors[v])
                        else
                            self:setProperty(k, v)
                        end
                    end
                end
                return self
            end,
        }
    end,

    basalt = function()
        local baseTemplate = {
            BaseFrame = {
                Background = colors.lightGray,
                Button = {
                    Background = "{self.clicked ? black : gray}",
                    Foreground = "{self.clicked ? lightGray : black}",
                },
                Container = {
                    Background = colors.gray,
                    Button = {
                        Background = colors.black,
                        Foreground = colors.lightGray,
                        },
                    }
                },
            }

        local function addTemplate(newTemplate)
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

        local function lookUpTemplate(template, allTypes)
            local elementData
            local tLink = template
            if(tLink~=nil)then
                for _, v in pairs(allTypes)do
                    for _, b in pairs(v)do
                        if(tLink[b]~=nil)then
                            tLink = tLink[b]
                            elementData = tLink
                            break
                        end
                    end
                end
            end
            return elementData
        end

        return {
            getTemplate = function(element)
                return lookUpTemplate(baseTemplate, element:__getElementPathTypes())
            end,

            addTemplate = addTemplate,
        }
    end
}

return plugin