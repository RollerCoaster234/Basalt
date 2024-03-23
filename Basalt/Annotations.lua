----- Basic Element ---------------------------------------
--------- Properties --------------------------------------

--- @class BasicElement
local BasicElement = {}

--- Sets the name of the element
---@param self table The element itself
---@param value string -- The name of the element
---@return BasicElement
function BasicElement:setName(value)end

--- Gets the name of the element
---@param self table The element itself
---@return string
function BasicElement:getName()end

--- Sets the type of the element
---@param self table The element itself
---@param value string|table -- The type of the element
---@return BasicElement
function BasicElement:setType(value)end

--- Gets the type of the element
---@param self table The element itself
---@return string|table
function BasicElement:getType()end

--- Sets the z-index of the element
---@param self table The element itself
---@param value number -- The z-index of the element
---@return BasicElement
function BasicElement:setZ(value)end

--- Gets the z-index of the element
---@param self table The element itself
---@return number
function BasicElement:getZ()end

--- Sets the event listener for the element
---@param self table The element itself
---@param value boolean -- If the element event listeners should be listen to events
---@return BasicElement
function BasicElement:setEnabled(value)end

--- Gets the event listener for the element
---@param self table The element itself
---@return boolean
function BasicElement:getEnabled()end

--- Sets the parent of the element
---@param self table The element itself
---@param value table -- The parent of the element
---@return BasicElement
function BasicElement:setParent(value)end

--- Gets the parent of the element
---@param self table The element itself
---@return table
function BasicElement:getParent()end

--- Sets the events of the element
---@param self table The element itself
---@param value table -- The events of the element
---@return BasicElement
function BasicElement:setEvents(value)end

--- Gets the events of the element
---@param self table The element itself
---@return table
function BasicElement:getEvents()end

--- Sets the propertyObservers of the element
---@param self table The element itself
---@param value table -- The propertyObservers of the element
---@return BasicElement
function BasicElement:setPropertyObservers(value)end

--- Gets the propertyObservers of the element
---@param self table The element itself
---@return table
function BasicElement:getPropertyObservers()end

----- Basic Element ---------------------------------------
--------- Listeners ----------------------------------------

----- Visual Element --------------------------------------
--------- Properties --------------------------------------

--- @class VisualElement
local VisualElement = {}

--- Sets the position of the element
---@param self table The element itself
---@param x? integer The x position of the element
---@param y? integer The y position of the element
---@return VisualElement
function VisualElement:setPosition(x, y)end

--- Gets the position of the element
---@param self table The element itself
---@return integer, integer
function VisualElement:getPosition()end

--- Sets the size of the element
---@param self table The element itself
---@param width? integer The width of the element
---@param height? integer The height of the element
---@return VisualElement
function VisualElement:setSize(width, height)end

--- Gets the size of the element
---@param self table The element itself
---@return integer, integer
function VisualElement:getSize()end

--- Sets the background of the element
---@param self table The element itself
---@param color? integer The color of the element
---@return VisualElement
function VisualElement:setBackground(color)end

--- Gets the background of the element
---@param self table The element itself
---@return integer
function VisualElement:getBackground()end

--- Sets the foreground of the element
---@param self table The element itself
---@param color? integer The color of the element
---@return VisualElement
function VisualElement:setForeground(color)end

--- Gets the foreground of the element
---@param self table The element itself
---@return integer
function VisualElement:getForeground()end

-- Sets the x position of the element
---@param self table The element itself
---@param value number -- The x position of the element
---@return VisualElement
function VisualElement:setX(value)end

--- Gets the x position of the element
---@param self table The element itself
---@return number
function VisualElement:getX()end

--- Sets the y position of the element
---@param self table The element itself
---@param value number -- The y position of the element
---@return VisualElement
function VisualElement:setY(value)end

--- Gets the y position of the element
---@param self table The element itself
---@return number
function VisualElement:getY()end

--- Sets the width of the element
---@param self table The element itself
---@param value number -- The width of the element
---@return VisualElement
function VisualElement:setWidth(value)end

--- Gets the width of the element
---@param self table The element itself
---@return number
function VisualElement:getWidth()end

--- Sets the height of the element
---@param self table The element itself
---@param value number -- The height of the element
---@return VisualElement
function VisualElement:setHeight(value)end

--- Sets the visibility of the element
---@param self table The element itself
---@param value boolean -- The visibility of the element
---@return VisualElement
function VisualElement:setVisible(value)end

--- Gets the visibility of the element
---@param self table The element itself
---@return boolean
function VisualElement:getVisible()end

--- Sets the renderData of the element, this table gets iterated over in the render loop
---@param self table The element itself
---@param value table -- The renderData of the element
---@return VisualElement
function VisualElement:setRenderData(value)end

--- Gets the renderData of the element
---@param self table The element itself
---@return table
function VisualElement:getRenderData()end

--- Sets the transparency of the element
---@param self table The element itself
---@param value boolean -- If parts of the element should be transparent
---@return VisualElement
function VisualElement:setTransparency(value)end

--- Gets the transparency of the element
---@param self table The element itself
---@return boolean
function VisualElement:getTransparency()end

--- Sets if the element should ignore the parent's offset
---@param self table The element itself
---@param value boolean -- If the element should ignore the parent's offset
---@return VisualElement
function VisualElement:setIgnoreOffset(value)end

--- Gets if the element should ignore the parent's offset
---@param self table The element itself
---@return boolean
function VisualElement:getIgnoreOffset()end

--- Sets if the element should be the focused element
---@param self table The element itself
---@param value boolean -- If the element should be the focused element
---@return VisualElement
function VisualElement:setFocused(value)end

--- Gets if the element should be the focused element
---@param self table The element itself
---@return boolean
function VisualElement:getFocused()end



----- Visual Element --------------------------------------
--------- Listeners ---------------------------------------

--- Adds a onClick listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement, button:integer, x:integer, y:integer) -- The function to be called when the element is clicked
---@return VisualElement
function VisualElement:onClick(func)end

--- Adds a onClickUp listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement, button:integer, x:integer, y:integer) -- The function to be called when the mouse button is released after clicking the element
---@return VisualElement
function VisualElement:onClickUp(func)end

--- Adds a onDrag listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement, button:integer, x:integer, y:integer) -- The function to be called when the element is dragged
---@return VisualElement
function VisualElement:onDrag(func)end

--- Adds a onRelease listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement, button:integer, x:integer, y:integer) -- The function to be called when the mouse button is released after clicking the element
---@return VisualElement
function VisualElement:onRelease(func)end

--- Adds a onHover listener to the element (only available on CraftOS-PC)
---@param self table The element itself
---@param func fun(self:VisualElement, x:integer, y:integer) -- The function to be called when the mouse hovers over the element
---@return VisualElement
function VisualElement:onHover(func)end

--- Adds a onLeave listener to the element (only available on CraftOS-PC)
---@param self table The element itself
---@param func fun(self:VisualElement, x:integer, y:integer) -- The function to be called when the mouse leaves the element
---@return VisualElement
function VisualElement:onLeave(func)end

--- Adds a onScroll listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement, direction:integer, x:integer, y:integer) -- The function to be called when the element is scrolled
---@return VisualElement
function VisualElement:onScroll(func)end

--- Adds a onKey listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement, key:integer) -- The function to be called when a key is pressed while the element is focused
---@return VisualElement
function VisualElement:onKey(func)end

--- Adds a onKeyUp listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement, key:integer) -- The function to be called when a key is released while the element is focused
---@return VisualElement
function VisualElement:onKeyUp(func)end

--- Adds a onChar listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement, char:string) -- The function to be called when a character is typed while the element is focused
---@return VisualElement
function VisualElement:onChar(func)end

--- Adds a onFocus listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement) -- The function to be called when the element is focused
---@return VisualElement
function VisualElement:onFocus(func)end

--- Adds a onLoseFocus listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement) -- The function to be called when the element loses focus
---@return VisualElement
function VisualElement:onLoseFocus(func)end



----- Container Element -----------------------------------
--------- Properties --------------------------------------

--- @class Container
local Container = {}

--- Sets the children of the container
---@param self table The element itself
---@param value table -- The children of the element
---@return Container
function Container:setChildren(value)end

--- Gets the children of the container
---@param self table The element itself
---@return table
function Container:getChildren()end

--- Sets the children events of the container
---@param self table The element itself
---@param value table -- The children events of the element
---@return Container
function Container:setChildrenEvents(value)end

--- Gets the children events of the container
---@param self table The element itself
---@return table
function Container:getChildrenEvents()end

--- Sets the visible children of the container
---@param self table The element itself
---@param value table -- The visible children of the element
---@return Container
function Container:setVisibleChildren(value)end

--- Gets the visible children of the container
---@param self table The element itself
---@return table
function Container:getVisibleChildren()end

--- Sets the visible children  events of the container
---@param self table The element itself
---@param value table -- The visible children events of the element
---@return Container
function Container:setVisibleChildrenEvents(value)end

--- Gets the visible children events of the container
---@param self table The element itself
---@return table
function Container:getVisibleChildrenEvents()end

--- Sets a table of children that have to be re-rendered
---@param self table The element itself
---@param value table -- The children that have to be re-rendered
---@return Container
function Container:setIsVisibleChildrenUpdated(value)end

--- Gets a table of children that have to be re-rendered
---@param self table The element itself
---@return table
function Container:getIsVisibleChildrenUpdated()end

--- Sets if the container should use cursor blinking
---@param self table The element itself
---@param value boolean -- If the container should use cursor blinking
---@return Container
function Container:setCursorBlink(value)end

--- Gets if the container should use cursor blinking
---@param self table The element itself
---@return boolean
function Container:getCursorBlink()end

--- Sets the cursor color of the container
---@param self table The element itself
---@param value integer -- The cursor blink color of the container
---@return Container
function Container:setCursorColor(value)end

--- Gets the cursor color of the container
---@param self table The element itself
---@return integer
function Container:getCursorColor()end

--- Sets the cursor x-position of the container
---@param self table The element itself
---@param value integer -- The cursor x-position of the container
---@return Container
function Container:setCursorX(value)end

--- Gets the cursor x-position of the container
---@param self table The element itself
---@return integer
function Container:getCursorX()end

--- Sets the cursor y-position of the container
---@param self table The element itself
---@param value integer -- The cursor y-position of the container
---@return Container
function Container:setCursorY(value)end

--- Gets the cursor y-position of the container
---@param self table The element itself
---@return integer
function Container:getCursorY()end

--- Sets the currently focused child element
---@param self table The element itself
---@param value table -- The currently focused child element
---@return Container
function Container:setFocusedChild(value)end

--- Gets the currently focused child element
---@param self table The element itself
---@return table
function Container:getFocusedChild()end

--- Sets the x-offset of the container
---@param self table The element itself
---@param value integer -- The x-offset of the container
---@return Container
function Container:setXOffset(value)end

--- Gets the x-offset of the container
---@param self table The element itself
---@return integer
function Container:getXOffset()end

--- Sets the y-offset of the container
---@param self table The element itself
---@param value integer -- The y-offset of the container
---@return Container
function Container:setYOffset(value)end

--- Gets the y-offset of the container
---@param self table The element itself
---@return integer
function Container:getYOffset()end

--- Sets the offset of the container
---@param self table The element itself
---@param x integer -- The x-offset of the container
---@param y integer -- The y-offset of the container
---@return Container
function Container:setOffset(x, y)end



----- Container Element -----------------------------------
--------- Elements ----------------------------------------

--- Adds a Button to the container
---
--- See https://basalt.madefor.cc/api/button.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the button or a table with the button properties
---@return Button
function Container:addButton(value)end

--- Adds a Label to the container
---
--- See https://basalt.madefor.cc/api/label.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the label or a table with the label properties
---@return Label
function Container:addLabel(value)end

--- Adds a Input to the container
---
--- See https://basalt.madefor.cc/api/input.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the input or a table with the input properties
---@return Input
function Container:addInput(value)end

--- Adds a Textfield to the container
---
--- See https://basalt.madefor.cc/api/textfield.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the textfield or a table with the textfield properties
---@return Textfield
function Container:addTextfield(value)end

--- Adds a Image to the container
---
--- See https://basalt.madefor.cc/api/image.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the image or a table with the image properties
---@return Image
function Container:addImage(value)end

--- Adds a Progressbar to the container
---
--- See https://basalt.madefor.cc/api/progressbar.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the progressbar or a table with the progressbar properties
---@return Progressbar
function Container:addProgressbar(value)end

--- Adds a Slider to the container
---
--- See https://basalt.madefor.cc/api/slider.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the slider or a table with the slider properties
---@return Slider
function Container:addSlider(value)end

--- Adds a Checkbox to the container
---
--- See https://basalt.madefor.cc/api/checkbox.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the checkbox or a table with the checkbox properties
---@return Checkbox
function Container:addCheckbox(value)end

--- Adds a List to the container
---
--- See https://basalt.madefor.cc/api/list.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the list or a table with the list properties
---@return List
function Container:addList(value)end

--- Adds a Dropdown to the container
---
--- See https://basalt.madefor.cc/api/dropdown.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the dropdown or a table with the dropdown properties
---@return Dropdown
function Container:addDropdown(value)end

--- Adds a Frame to the container
---
--- See https://basalt.madefor.cc/api/frame.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the frame or a table with the frame properties
---@return Frame
function Container:addFrame(value)end

--- Adds a Scrollbar to the container
---
--- See https://basalt.madefor.cc/api/scrollbar.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the scrollbar or a table with the scrollbar properties
---@return Scrollbar
function Container:addScrollbar(value)end

--- Adds a Menubar to the container
---
--- See https://basalt.madefor.cc/api/menubar.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the menubar or a table with the menubar properties
---@return Menubar
function Container:addMenubar(value)end

--- Adds a Flexbox to the container
---
--- See https://basalt.madefor.cc/api/flexbox.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the flexbox or a table with the flexbox properties
---@return Flexbox
function Container:addFlexbox(value)end

--- Adds a MovableFrame to the container
---
--- See https://basalt.madefor.cc/api/movableframe.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the movableframe or a table with the movableframe properties
---@return MovableFrame
function Container:addMovableFrame(value)end

--- Adds a ScrollableFrame to the container
---
--- See https://basalt.madefor.cc/api/scrollableframe.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the scrollableframe or a table with the scrollableframe properties
---@return ScrollableFrame
function Container:addScrollableFrame(value)end



------ Button ---------------------------------------------
--------- Properties --------------------------------------

--- @class Button
local Button = {}

--- Sets the text of the button
---@param self table The element itself
---@param value string -- The text of the button
---@return Button
function Button:setText(value)end

--- Gets the text of the button
---@param self table The element itself
---@return string
function Button:getText()end



------ Label ----------------------------------------------
--------- Properties --------------------------------------

--- @class Label
local Label = {}

--- Sets the text of the label
---@param value string -- The text of the label
---@param self table The element itself
---@return Label
function Label:setText(value)end

--- Gets the text of the label
---@param self table The element itself
---@return string
function Label:getText()end

--- Sets the autoSize of the label (automatically changes the width of the label to fit the text)
---@param self table The element itself
---@param value boolean -- The autoSize of the label
---@return Label
function Label:setAutoSize(value)end

--- Gets the autoSize of the label
---@param self table The element itself
---@return boolean
function Label:getAutoSize()end

--- Sets the wrap of the label (wraps the text to the next line if it's too long)
---@param self table The element itself
---@param value boolean -- The wrap of the label
---@return Label
function Label:setWrap(value)end

--- Gets the wrap of the label
---@param self table The element itself
---@return boolean
function Label:getWrap()end

--- Sets the coloring of the label (enables/disables coloring of the text with special characters)
---@param self table The element itself
---@param value boolean -- The coloring of the label
---@return Label
function Label:setColoring(value)end

--- Gets the coloring of the label
---@param self table The element itself
---@return boolean
function Label:getColoring()end



------ Checkbox -------------------------------------------
--------- Properties --------------------------------------

--- @class Checkbox
local Checkbox = {}

--- Sets the text of the checkbox
---@param self table The element itself
---@param value string -- The text of the checkbox
---@return Checkbox
function Checkbox:setText(value)end

--- Gets the text of the checkbox
---@param self table The element itself
---@return string
function Checkbox:getText()end

--- Sets the checked state of the checkbox
---@param self table The element itself
---@param value boolean -- The checked state of the checkbox
---@return Checkbox
function Checkbox:setChecked(value)end

--- Gets the checked state of the checkbox
---@param self table The element itself
---@return boolean
function Checkbox:getChecked()end

--- Sets the checked symbol of the checkbox
---@param self table The element itself
---@param value string -- The checked symbol of the checkbox
---@return Checkbox
function Checkbox:setCheckedSymbol(value)end

--- Gets the checked symbol of the checkbox
---@param self table The element itself
---@return string
function Checkbox:getCheckedSymbol()end

--- Sets the checked color of the checkbox
---@param self table The element itself
---@param value integer -- The checked color of the checkbox
---@return Checkbox
function Checkbox:setCheckedColor(value)end

--- Gets the checked color of the checkbox
---@param self table The element itself
---@return integer
function Checkbox:getCheckedColor()end

--- Sets the checked background color of the checkbox
---@param self table The element itself
---@param value integer -- The checked background color of the checkbox
---@return Checkbox
function Checkbox:setCheckedBgColor(value)end

--- Gets the checked background color of the checkbox
---@param self table The element itself
---@return integer
function Checkbox:getCheckedBgColor()end

--- Sets the symbol of the checkbox
---@param self table The element itself
---@param value string -- The symbol of the checkbox
---@param color integer -- The color of the symbol
---@param bgColor integer -- The background color of the symbol
---@return Checkbox
function Checkbox:setSymbol(value, color, bgColor)end

--- Gets the symbol of the checkbox
---@param self table The element itself
---@return string, integer, integer
function Checkbox:getSymbol()end




------ Input ----------------------------------------------
--------- Properties --------------------------------------

--- @class Input
local Input = {}

--- Sets the text of the input
---@param self table The element itself
---@param value string -- The text of the input
---@return Input
function Input:setValue(value)end

--- Gets the text of the input
---@param self table The element itself
---@return string
function Input:getValue()end

--- Sets the cursor index of the input
---@param self table The element itself
---@param value integer -- The cursor index of the input
---@return Input
function Input:setCursorIndex(value)end

--- Gets the cursor index of the input
---@param self table The element itself
---@return integer
function Input:getCursorIndex()end

--- Sets the scroll index of the input
---@param self table The element itself
---@param value integer -- The scroll index of the input
---@return Input
function Input:setScrollIndex(value)end

--- Gets the scroll index of the input
---@param self table The element itself
---@return integer
function Input:getScrollIndex()end

--- Sets the input limit of the input
---@param self table The element itself
---@param value integer -- The input limit of the input
---@return Input
function Input:setInputimit(value)end


--- Gets the input limit of the input
---@param self table The element itself
---@return integer
function Input:getInputimit()end

--- Sets the input type of the input
---@param self table The element itself
--- @param value --- The input type of the input
---| '"text"' # The default type: text mode
---| '"password"' #  The password mode: hides the text
---| '"number"' #  The number mode: only allows numbers
---@return Input
function Input:setInputType(value)end

--- Gets the input type of the input
---@param self table The element itself
---@return string
function Input:getInputType()end

--- Sets the placeholder text of the input
---@param self table The element itself
---@param value string -- The placeholder text of the input
---@return Input
function Input:setPlaceholderText(value)end

--- Gets the placeholder text of the input
---@param self table The element itself
---@return string
function Input:getPlaceholderText()end

--- Sets the placeholder color of the input
---@param self table The element itself
---@param value integer -- The placeholder color of the input
---@return Input
function Input:setPlaceholderColor(value)end

--- Gets the placeholder color of the input
---@param self table The element itself
---@return integer
function Input:getPlaceholderColor()end

--- Sets the placeholder background color of the input
---@param self table The element itself
---@param value integer -- The placeholder background color of the input
---@return Input
function Input:setPlaceholderBackground(value)end

--- Gets the placeholder background color of the input
---@param self table The element itself
---@return integer
function Input:getPlaceholderBackground()end

--- Sets the placeholder of the input
---@param self table The element itself
---@param text string -- The placeholder text of the input
---@param color integer -- The placeholder color of the input
---@param bgColor integer -- The placeholder background color of the input
---@return Input
function Input:setPlaceholder(text, color, bgColor)end

--- Gets the placeholder of the input
---@param self table The element itself
---@return string, integer, integer
function Input:getPlaceholder()end



------ Input ----------------------------------------------
--------- Listeners ---------------------------------------

--- Adds a onChange listener to the input
---@param self table The element itself
---@param func fun(self:Input, value:string) -- The function to be called when the input changes
---@return Input
function Input:onChange(func)end

--- Adds a onEnter listener to the input
---@param self table The element itself
---@param func fun(self:Input, value:string) -- The function to be called when the enter key is pressed
---@return Input
function Input:onEnter(func)end



------ Progressbar ----------------------------------------
--------- Properties --------------------------------------

--- @class Progressbar
local Progressbar = {}

--- Sets the progress of the progressbar
---@param self table The element itself
---@param value number -- The progress of the progressbar
---@return Progressbar
function Progressbar:setProgress(value)end

--- Gets the progress of the progressbar
---@param self table The element itself
---@return number
function Progressbar:getProgress()end

--- Sets the progress background of the progressbar
---@param self table The element itself
---@param value integer -- The progress background of the progressbar
---@return Progressbar
function Progressbar:setProgressBackground(value)end

--- Gets the progress background of the progressbar
---@param self table The element itself
---@return integer
function Progressbar:getProgressBackground()end

--- Sets the min value of the progressbar
---@param self table The element itself
---@param value number -- The min value of the progressbar
---@return Progressbar
function Progressbar:setMinValue(value)end

--- Gets the min value of the progressbar
---@param self table The element itself
---@return number
function Progressbar:getMinValue()end

--- Sets the max value of the progressbar
---@param self table The element itself
---@param value number -- The max value of the progressbar
---@return Progressbar
function Progressbar:setMaxValue(value)end

--- Gets the max value of the progressbar
---@param self table The element itself
---@return number
function Progressbar:getMaxValue()end




------ Textfield ------------------------------------------
--------- Properties --------------------------------------

--- @class Textfield
local Textfield = {}

--- Sets the lines for the textfield
---@param self table The element itself
---@param lines table -- The lines for the textfield
---@return Textfield
function Textfield:setLines(lines)end

--- Gets the lines for the textfield
---@param self table The element itself
---@return table
function Textfield:getLines()end

--- Sets the cursor index for the textfield
---@param self table The element itself
---@param value integer -- The cursor index for the textfield
---@return Textfield
function Textfield:setCursorIndex(value)end

--- Gets the cursor index for the textfield
---@param self table The element itself
---@return integer
function Textfield:getCursorIndex()end

--- Sets the line index for the textfield
---@param self table The element itself
---@param value integer -- The line index for the textfield
---@return Textfield
function Textfield:setLineIndex(value)end

--- Gets the line index for the textfield
---@param self table The element itself
---@return integer
function Textfield:getLineIndex()end

--- Sets the scroll index x for the textfield
---@param self table The element itself
---@param value integer -- The scroll index x for the textfield
---@return Textfield
function Textfield:setScrollIndexX(value)end

--- Gets the scroll index x for the textfield
---@param self table The element itself
---@return integer
function Textfield:getScrollIndexX()end

--- Sets the scroll index y for the textfield
---@param self table The element itself
---@param value integer -- The scroll index y for the textfield
---@return Textfield
function Textfield:setScrollIndexY(value)end

--- Gets the scroll index y for the textfield
---@param self table The element itself
---@return integer
function Textfield:getScrollIndexY()end



------ Slider ---------------------------------------------
--------- Properties --------------------------------------

--- @class Slider
local Slider = {}

--- Sets the value of the slider
---@param self table The element itself
---@param value number -- The value of the slider
---@return Slider
function Slider:setValue(value)end

--- Gets the value of the slider
---@param self table The element itself
---@return number
function Slider:getValue()end

--- Sets the min value of the slider
---@param self table The element itself
---@param value number -- The min value of the slider
---@return Slider
function Slider:setMinValue(value)end

--- Gets the min value of the slider
---@param self table The element itself
---@return number
function Slider:getMinValue()end

--- Sets the max value of the slider
---@param self table The element itself
---@param value number -- The max value of the slider
---@return Slider
function Slider:setMaxValue(value)end

--- Gets the max value of the slider
---@param self table The element itself
---@return number
function Slider:getMaxValue()end

--- Sets the knob symbol of the slider
---@param self table The element itself
---@param value string -- The knob symbol of the slider
---@return Slider
function Slider:setKnobSymbol(value)end

--- Gets the knob symbol of the slider
---@param self table The element itself
---@return string
function Slider:getKnobSymbol()end

--- Sets the knob color of the slider
---@param self table The element itself
---@param value integer -- The knob color of the slider
---@return Slider
function Slider:setKnobForeground(value)end

--- Gets the knob color of the slider
---@param self table The element itself
---@return integer
function Slider:getKnobForeground()end

--- Sets the knob background color of the slider
---@param self table The element itself
---@param value integer -- The knob background color of the slider
---@return Slider
function Slider:setKnobBackground(value)end

--- Gets the knob background color of the slider
---@param self table The element itself
---@return integer
function Slider:getKnobBackground()end

--- Sets the background symbol of the slider
---@param self table The element itself
---@param value string -- The knob background symbol of the slider
---@return Slider
function Slider:setBgSymbol(value)end

--- Gets the background symbol of the slider
---@param self table The element itself
---@return string
function Slider:getBgSymbol()end

--- Sets the steps of the slider
---@param self table The element itself
---@param value integer -- The steps of the slider
function Slider:setStep(value)end

--- Gets the steps of the slider
---@param self table The element itself
---@return integer
function Slider:getStep()end

--- Sets the knob of the slider
---@param self table The element itself
---@param value string -- The knob of the slider
---@param fg integer -- The foreground color of the knob
---@param bg integer -- The background color of the knob
---@return Slider
function Slider:setKnob(value, fg, bg)end

--- Gets the knob of the slider
---@param self table The element itself
---@return string, integer, integer
function Slider:getKnob()end



----- Slider ---------------------------------------------
--------- Listeners --------------------------------------

--- Adds a onChange listener to the slider
---@param self table The element itself
---@param func fun(self:Slider, value:number) -- The function to be called when the slider changes
---@return Slider
function Slider:onChange(func)end




------ Program --------------------------------------------
--------- Properties --------------------------------------

--- @class Program
local Program = {}

--- Sets the program object to the program element
---@param self table The element itself
---@param value table -- The program object
---@return Program
function Program:setProgram(value)end

--- Gets the program object of the program element
---@param self table The element itself
---@return table
function Program:getProgram()end



------ Monitor --------------------------------------------
--------- Properties --------------------------------------

--- @class Monitor
local Monitor = {}

--- Sets the CC:Tweaked monitor table for the monitor element
---@param self table The element itself
---@param value string|table -- The side where the monitor is attached or the monitor table itself
---@return Monitor
function Monitor:setMonitor(value)end

--- Gets the CC:Tweaked monitor table of the monitor element
---@param self table The element itself
---@return table
function Monitor:getMonitor()end

--- Sets the side of the monitor element this property gets updated by setMonitor, so please use setMonitor(side) instead
---@param self table The element itself
---@param value string -- The side of the monitor element
---@return Monitor
function Monitor:setSide(value)end

--- Gets the side of the monitor element
---@param self table The element itself
---@return string
function Monitor:getSide()end



------ List -----------------------------------------------
--------- Properties --------------------------------------

--- @class List
local List = {}

--- Sets the items of the list
---@param self table The element itself
---@param value table -- The items of the list
---@return List
function List:setItems(value)end

--- Gets the items of the list
---@param self table The element itself
---@return table
function List:getItems()end

--- Sets the item background of the list
---@param self table The element itself
---@param value table -- The item background of the list
---@return List
function List:setItemBackground(value)end

--- Gets the item background of the list
---@param self table The element itself
---@return table
function List:getItemBackground()end

--- Sets the item foreground of the list
---@param self table The element itself
---@param value table -- The item foreground of the list
---@return List
function List:setItemForeground(value)end

--- Gets the item foreground of the list
---@param self table The element itself
---@return table
function List:getItemForeground()end

--- Sets if selection should be enabled for the list
---@param self table The element itself
---@param value boolean -- If selection should be enabled for the list
---@return List
function List:setSelection(value)end

--- Gets if selection is enabled for the list
---@param self table The element itself
---@return boolean
function List:getSelection()end

--- Sets if multi selection should be enabled for the list
---@param self table The element itself
---@param value boolean -- If multi selection should be enabled for the list
---@return List
function List:setMultiSelection(value)end

--- Gets if multi selection is enabled for the list
---@param self table The element itself
---@return boolean
function List:getMultiSelection()end

--- Sets if auto scroll should be enabled for the list (as soon as a new item is added the list will scroll to the bottom)
---@param self table The element itself
---@param value boolean -- If auto scroll should be enabled for the list
---@return List
function List:setAutoScroll(value)end

--- Gets if auto scroll is enabled for the list
---@param self table The element itself
---@return boolean
function List:getAutoScroll()end

--- Sets the selected index of the list
---@param self table The element itself
---@param value integer -- The selected index of the list
---@return List
function List:setSelectedIndex(value)end

--- Gets the selected index of the list
---@param self table The element itself
---@return integer
function List:getSelectedIndex()end

--- Sets the selection background of the list
---@param self table The element itself
---@param value integer -- The selection background of the list
---@return List
function List:setSelectionBackground(value)end

--- Gets the selection background of the list
---@param self table The element itself
---@return integer
function List:getSelectionBackground()end

--- Sets the selection foreground of the list
---@param self table The element itself
---@param value integer -- The selection foreground of the list
---@return List
function List:setSelectionForeground(value)end

--- Gets the selection foreground of the list
---@param self table The element itself
---@return integer
function List:getSelectionForeground()end

--- Sets the scroll index of the list
---@param self table The element itself
---@param value integer -- The scroll index of the list
---@return List
function List:setScrollIndex(value)end

--- Gets the scroll index of the list
---@param self table The element itself
---@return integer
function List:getScrollIndex()end

--- Sets the selection color of the list
---@param self table The element itself
---@param bg integer -- The selection background color of the list
---@param fg integer -- The selection foreground color of the list
---@return List
function List:setSelectionColor(bg, fg)end

--- Gets the selection color of the list
---@param self table The element itself
---@return integer, integer
function List:getSelectionColor()end



----- List -----------------------------------------------
--------- Listeners --------------------------------------

--- Adds a onChange event listener for the list
---@param self table The element itself
---@param func fun(self:List, index:integer, item:string) -- The function to be called when the list changes
---@return List
function List:onChange(func)end





------ Dropdown -------------------------------------------
--------- Properties --------------------------------------

--- @class Dropdown
local Dropdown = {}

--- Sets if the dropdown is open
---@param self table The element itself
---@param value boolean -- If the dropdown is open
---@return Dropdown
function Dropdown:setOpened(value)end

--- Gets if the dropdown is open
---@param self table The element itself
---@return boolean
function Dropdown:getOpened()end

--- Sets the dropdown height
---@param self table The element itself
---@param value integer -- The dropdown height
---@return Dropdown
function Dropdown:setDropdownHeight(value)end

--- Gets the dropdown height
---@param self table The element itself
---@return integer
function Dropdown:getDropdownHeight()end

--- Sets the dropdown width
---@param self table The element itself
---@param value integer -- The dropdown width
---@return Dropdown
function Dropdown:setDropdownWidth(value)end

--- Gets the dropdown width
---@param self table The element itself
---@return integer
function Dropdown:getDropdownWidth()end

--- Sets the dropdown size
---@param self table The element itself
---@param width integer -- The dropdown width
---@param height integer -- The dropdown height
---@return Dropdown
function Dropdown:setDropdownSize(width, height)end



------ Menubar --------------------------------------------
--------- Properties --------------------------------------

--- @class Menubar
local Menubar = {}

--- Sets the spacing between the items
---@param self table The element itself
---@param value integer -- The spacing between the items
---@return Menubar
function Menubar:setSpacing(value)end

--- Gets the spacing between the items
---@param self table The element itself
---@return integer
function Menubar:getSpacing()end



------ MovableFrame ---------------------------------------
--------- Properties --------------------------------------

--- @class MovableFrame
local MovableFrame = {}

--- Sets the DragMap of the movableframe
---@param self table The element itself
---@param value table -- The DragMap of the movableframe
---@return MovableFrame
function MovableFrame:setDragMap(value)end

--- Gets the DragMap of the movableframe
---@param self table The element itself
---@return table
function MovableFrame:getDragMap()end



------- Flexbox -------------------------------------------
--------- Properties --------------------------------------

--- @class Flexbox
local Flexbox = {}

--- Sets the direction of the flexbox
---@param self table The element itself
--- @param direction --- The direction of the flexbox
---| '"row"' # The default direction: horizontal
---| '"column"' #  The vertical direction
---@return Flexbox
function Flexbox:setFlexDirection(direction)end

--- Gets the direction of the flexbox
---@param self table The element itself
---@return string
function Flexbox:getFlexDirection()end

--- Sets the spacing of the flexbox
---@param self table The element itself
---@param value integer -- The spacing of the flexbox
---@return Flexbox
function Flexbox:setFlexSpacing(value)end

--- Gets the spacing of the flexbox
---@param self table The element itself
---@return integer
function Flexbox:getFlexSpacing()end

--- Sets the wrap of the flexbox
---@param self table The element itself
---@param value boolean -- The wrap of the flexbox
---@return Flexbox
function Flexbox:setFlexWrap(value)end

--- Gets the wrap of the flexbox
---@param self table The element itself
---@return boolean
function Flexbox:getFlexWrap()end

--- Sets the justify content of the flexbox
---@param self table The element itself
--- @param value --- The justify content of the flexbox
---| '"flex-start"' # The default justify content: aligns the items to the start of the flexbox
---| '"flex-end"' #  Aligns the items to the end of the flexbox
---| '"center"' #  Aligns the items to the center of the flexbox
---| '"space-between"' #  Aligns the items with space between them
---| '"space-around"' #  Aligns the items with space around them
---@return Flexbox
function Flexbox:setJustifyContent(value)end

--- Gets the justify content of the flexbox
---@param self table The element itself
---@return string
function Flexbox:getJustifyContent()end
------ 