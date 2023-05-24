local baseTemplate = { -- The default main theme for basalt!
    BaseFrameBG = colors.lightGray,
    BaseFrameText = colors.black,
    FrameBG = colors.gray,
    FrameText = colors.black,
    ButtonBG = colors.gray,
    ButtonText = colors.black,
    CheckboxBG = colors.gray,
    CheckboxText = colors.black,
    InputBG = colors.black,
    InputText = colors.lightGray,
    TextfieldBG = colors.black,
    TextfieldText = colors.white,
    ListBG = colors.gray,
    ListText = colors.black,
    MenubarBG = colors.gray,
    MenubarText = colors.black,
    DropdownBG = colors.gray,
    DropdownText = colors.black,
    RadioBG = colors.gray,
    RadioText = colors.black,
    SelectionBG = colors.black,
    SelectionText = colors.lightGray,
    GraphicBG = colors.black,
    ImageBG = colors.black,
    PaneBG = colors.black,
    ProgramBG = colors.black,
    ProgressbarBG = colors.gray,
    ProgressbarText = colors.black,
    ProgressbarActiveBG = colors.black,
    ScrollbarBG = colors.lightGray,
    ScrollbarText = colors.gray,
    ScrollbarSymbolColor = colors.black,
    SliderBG = false,
    SliderText = colors.gray,
    SliderSymbolColor = colors.black,
    SwitchBG = colors.lightGray,
    SwitchText = colors.gray,
    LabelBG = false,
    LabelText = colors.black,
    GraphBG = colors.gray,
    GraphText = colors.black
}


local plugin = {
    Container = function(base, name, basalt)
        local template = {}

        local object = {
            getTemplate = function(self, name)
                local parent = self:getParent()
                return template[name] or (parent~=nil and parent:getTemplate(name) or baseTemplate[name])
            end,
            setTemplate = function(self, _template, col)
                if(type(_template)=="table")then
                    template = _template
                elseif(type(_template)=="string")then
                    template[_template] = col
                end
                self:updateDraw()
                return self
            end,
        }
        return object
    end,

    basalt = function()
        return {
            getTemplate = function(name)
                return baseTemplate[name]
            end,
            setTemplate = function(_template, col)
                if(type(_template)=="table")then
                    baseTemplate = _template
                elseif(type(_template)=="string")then
                    baseTemplate[_template] = col
                end
            end,
        }
    end
    
}

for k,v in pairs({"BaseFrame", "Frame", "ScrollableFrame", "MovableFrame", "Button", "Checkbox", "Dropdown", "Graph", "Graphic", "Input", "Label", "List", "Menubar", "Pane", "Program", "Progressbar", "Radio", "Scrollbar", "Slider", "Switch", "Textfield"})do
plugin[v] = function(base, name, basalt)
        local object = {
            init = function(self)
                if(base.init(self))then
                    local parent = self:getParent() or self
                    self:setBackground(parent:getTemplate(v.."BG"))
                    self:setForeground(parent:getTemplate(v.."Text"))      
                end
            end
        }
        return object
    end
end

return plugin