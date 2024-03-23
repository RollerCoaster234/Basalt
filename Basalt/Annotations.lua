----- Basic Element ---------------------------------------
--------- Properties --------------------------------------

--- @class BasicElementP : BasicElement
local BasicElementP = {}

--- Sets the name of the element
---@param self table The element itself
---@param value string -- The name of the element
---@return BasicElement
function BasicElementP:setName(value)end

--- Gets the name of the element
---@param self table The element itself
---@return string
function BasicElementP:getName()end

--- Sets the type of the element
---@param self table The element itself
---@param value string|table -- The type of the element
---@return BasicElement
function BasicElementP:setType(value)end

--- Gets the type of the element
---@param self table The element itself
---@return string|table
function BasicElementP:getType()end

--- Sets the z-index of the element
---@param self table The element itself
---@param value number -- The z-index of the element
---@return BasicElement
function BasicElementP:setZ(value)end

--- Gets the z-index of the element
---@param self table The element itself
---@return number
function BasicElementP:getZ()end

--- Sets the event listener for the element
---@param self table The element itself
---@param value boolean -- If the element event listeners should be listen to events
---@return BasicElement
function BasicElementP:setEnabled(value)end

--- Gets the event listener for the element
---@param self table The element itself
---@return boolean
function BasicElementP:getEnabled()end

--- Sets the parent of the element
---@param self table The element itself
---@param value table -- The parent of the element
---@return BasicElement
function BasicElementP:setParent(value)end

--- Gets the parent of the element
---@param self table The element itself
---@return table
function BasicElementP:getParent()end

--- Sets the events of the element
---@param self table The element itself
---@param value table -- The events of the element
---@return BasicElement
function BasicElementP:setEvents(value)end

--- Gets the events of the element
---@param self table The element itself
---@return table
function BasicElementP:getEvents()end

--- Sets the propertyObservers of the element
---@param self table The element itself
---@param value table -- The propertyObservers of the element
---@return BasicElement
function BasicElementP:setPropertyObservers(value)end

--- Gets the propertyObservers of the element
---@param self table The element itself
---@return table
function BasicElementP:getPropertyObservers()end

----- Basic Element ---------------------------------------
--------- Listeners ----------------------------------------

---@class BasicElementL : BasicElementP
local BasicElementL = {}



----- Visual Element --------------------------------------
--------- Properties --------------------------------------

--- @class VisualElementP : BasicElementL
local VisualElementP = {}

--- Sets the position of the element
---@param self table The element itself
---@param x? integer The x position of the element
---@param y? integer The y position of the element
---@return VisualElement
function VisualElementP:setPosition(x, y)end

--- Gets the position of the element
---@param self table The element itself
---@return integer, integer
function VisualElementP:getPosition()end

--- Sets the size of the element
---@param self table The element itself
---@param width? integer The width of the element
---@param height? integer The height of the element
---@return VisualElement
function VisualElementP:setSize(width, height)end

--- Gets the size of the element
---@param self table The element itself
---@return integer, integer
function VisualElementP:getSize()end

--- Sets the background of the element
---@param self table The element itself
---@param color? integer The color of the element
---@return VisualElement
function VisualElementP:setBackground(color)end

--- Gets the background of the element
---@param self table The element itself
---@return integer
function VisualElementP:getBackground()end

--- Sets the foreground of the element
---@param self table The element itself
---@param color? integer The color of the element
---@return VisualElement
function VisualElementP:setForeground(color)end

--- Gets the foreground of the element
---@param self table The element itself
---@return integer
function VisualElementP:getForeground()end

-- Sets the x position of the element
---@param self table The element itself
---@param value number -- The x position of the element
---@return VisualElement
function VisualElementP:setX(value)end

--- Gets the x position of the element
---@param self table The element itself
---@return number
function VisualElementP:getX()end

--- Sets the y position of the element
---@param self table The element itself
---@param value number -- The y position of the element
---@return VisualElement
function VisualElementP:setY(value)end

--- Gets the y position of the element
---@param self table The element itself
---@return number
function VisualElementP:getY()end

--- Sets the width of the element
---@param self table The element itself
---@param value number -- The width of the element
---@return VisualElement
function VisualElementP:setWidth(value)end

--- Gets the width of the element
---@param self table The element itself
---@return number
function VisualElementP:getWidth()end

--- Sets the height of the element
---@param self table The element itself
---@param value number -- The height of the element
---@return VisualElement
function VisualElementP:setHeight(value)end

--- Sets the visibility of the element
---@param self table The element itself
---@param value boolean -- The visibility of the element
---@return VisualElement
function VisualElementP:setVisible(value)end

--- Gets the visibility of the element
---@param self table The element itself
---@return boolean
function VisualElementP:getVisible()end

--- Sets the renderData of the element, this table gets iterated over in the render loop
---@param self table The element itself
---@param value table -- The renderData of the element
---@return VisualElement
function VisualElementP:setRenderData(value)end

--- Gets the renderData of the element
---@param self table The element itself
---@return table
function VisualElementP:getRenderData()end

--- Sets the transparency of the element
---@param self table The element itself
---@param value boolean -- If parts of the element should be transparent
---@return VisualElement
function VisualElementP:setTransparency(value)end

--- Gets the transparency of the element
---@param self table The element itself
---@return boolean
function VisualElementP:getTransparency()end

--- Sets if the element should ignore the parent's offset
---@param self table The element itself
---@param value boolean -- If the element should ignore the parent's offset
---@return VisualElement
function VisualElementP:setIgnoreOffset(value)end

--- Gets if the element should ignore the parent's offset
---@param self table The element itself
---@return boolean
function VisualElementP:getIgnoreOffset()end

--- Sets if the element should be the focused element
---@param self table The element itself
---@param value boolean -- If the element should be the focused element
---@return VisualElement
function VisualElementP:setFocused(value)end

--- Gets if the element should be the focused element
---@param self table The element itself
---@return boolean
function VisualElementP:getFocused()end



----- Visual Element --------------------------------------
--------- Listeners ---------------------------------------

--- @class VisualElementL : VisualElementP
local VisualElementL = {}

--- Adds a onClick listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement, button:integer, x:integer, y:integer) -- The function to be called when the element is clicked
---@return VisualElement
function VisualElementL:onClick(func)end

--- Adds a onClickUp listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement, button:integer, x:integer, y:integer) -- The function to be called when the mouse button is released after clicking the element
---@return VisualElement
function VisualElementL:onClickUp(func)end

--- Adds a onDrag listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement, button:integer, x:integer, y:integer) -- The function to be called when the element is dragged
---@return VisualElement
function VisualElementL:onDrag(func)end

--- Adds a onRelease listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement, button:integer, x:integer, y:integer) -- The function to be called when the mouse button is released after clicking the element
---@return VisualElement
function VisualElementL:onRelease(func)end

--- Adds a onHover listener to the element (only available on CraftOS-PC)
---@param self table The element itself
---@param func fun(self:VisualElement, x:integer, y:integer) -- The function to be called when the mouse hovers over the element
---@return VisualElement
function VisualElementL:onHover(func)end

--- Adds a onLeave listener to the element (only available on CraftOS-PC)
---@param self table The element itself
---@param func fun(self:VisualElement, x:integer, y:integer) -- The function to be called when the mouse leaves the element
---@return VisualElement
function VisualElementL:onLeave(func)end

--- Adds a onScroll listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement, direction:integer, x:integer, y:integer) -- The function to be called when the element is scrolled
---@return VisualElement
function VisualElementL:onScroll(func)end

--- Adds a onKey listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement, key:integer) -- The function to be called when a key is pressed while the element is focused
---@return VisualElement
function VisualElementL:onKey(func)end

--- Adds a onKeyUp listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement, key:integer) -- The function to be called when a key is released while the element is focused
---@return VisualElement
function VisualElementL:onKeyUp(func)end

--- Adds a onChar listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement, char:string) -- The function to be called when a character is typed while the element is focused
---@return VisualElement
function VisualElementL:onChar(func)end

--- Adds a onFocus listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement) -- The function to be called when the element is focused
---@return VisualElement
function VisualElementL:onFocus(func)end

--- Adds a onLoseFocus listener to the element
---@param self table The element itself
---@param func fun(self:VisualElement) -- The function to be called when the element loses focus
---@return VisualElement
function VisualElementL:onLoseFocus(func)end



----- Container Element -----------------------------------
--------- Properties --------------------------------------

--- @class ContainerP : VisualElementL
local ContainerP = {}

--- Sets the children of the container
---@param self table The element itself
---@param value table -- The children of the element
---@return Container
function ContainerP:setChildren(value)end

--- Gets the children of the container
---@param self table The element itself
---@return table
function ContainerP:getChildren()end

--- Sets the children events of the container
---@param self table The element itself
---@param value table -- The children events of the element
---@return Container
function ContainerP:setChildrenEvents(value)end

--- Gets the children events of the container
---@param self table The element itself
---@return table
function ContainerP:getChildrenEvents()end

--- Sets the visible children of the container
---@param self table The element itself
---@param value table -- The visible children of the element
---@return Container
function ContainerP:setVisibleChildren(value)end

--- Gets the visible children of the container
---@param self table The element itself
---@return table
function ContainerP:getVisibleChildren()end

--- Sets the visible children  events of the container
---@param self table The element itself
---@param value table -- The visible children events of the element
---@return Container
function ContainerP:setVisibleChildrenEvents(value)end

--- Gets the visible children events of the container
---@param self table The element itself
---@return table
function ContainerP:getVisibleChildrenEvents()end

--- Sets a table of children that have to be re-rendered
---@param self table The element itself
---@param value table -- The children that have to be re-rendered
---@return Container
function ContainerP:setIsVisibleChildrenUpdated(value)end

--- Gets a table of children that have to be re-rendered
---@param self table The element itself
---@return table
function ContainerP:getIsVisibleChildrenUpdated()end

--- Sets if the container should use cursor blinking
---@param self table The element itself
---@param value boolean -- If the container should use cursor blinking
---@return Container
function ContainerP:setCursorBlink(value)end

--- Gets if the container should use cursor blinking
---@param self table The element itself
---@return boolean
function ContainerP:getCursorBlink()end

--- Sets the cursor color of the container
---@param self table The element itself
---@param value integer -- The cursor blink color of the container
---@return Container
function ContainerP:setCursorColor(value)end

--- Gets the cursor color of the container
---@param self table The element itself
---@return integer
function ContainerP:getCursorColor()end

--- Sets the cursor x-position of the container
---@param self table The element itself
---@param value integer -- The cursor x-position of the container
---@return Container
function ContainerP:setCursorX(value)end

--- Gets the cursor x-position of the container
---@param self table The element itself
---@return integer
function ContainerP:getCursorX()end

--- Sets the cursor y-position of the container
---@param self table The element itself
---@param value integer -- The cursor y-position of the container
---@return Container
function ContainerP:setCursorY(value)end

--- Gets the cursor y-position of the container
---@param self table The element itself
---@return integer
function ContainerP:getCursorY()end

--- Sets the currently focused child element
---@param self table The element itself
---@param value table -- The currently focused child element
---@return Container
function ContainerP:setFocusedChild(value)end

--- Gets the currently focused child element
---@param self table The element itself
---@return table
function ContainerP:getFocusedChild()end

--- Sets the x-offset of the container
---@param self table The element itself
---@param value integer -- The x-offset of the container
---@return Container
function ContainerP:setXOffset(value)end

--- Gets the x-offset of the container
---@param self table The element itself
---@return integer
function ContainerP:getXOffset()end

--- Sets the y-offset of the container
---@param self table The element itself
---@param value integer -- The y-offset of the container
---@return Container
function ContainerP:setYOffset(value)end

--- Gets the y-offset of the container
---@param self table The element itself
---@return integer
function ContainerP:getYOffset()end

--- Sets the offset of the container
---@param self table The element itself
---@param x integer -- The x-offset of the container
---@param y integer -- The y-offset of the container
---@return Container
function ContainerP:setOffset(x, y)end



----- Container Element -----------------------------------
--------- Elements ----------------------------------------

--- @class ContainerE : ContainerP
local ContainerE = {}

--- Adds a Button to the container
---
--- See https://basalt.madefor.cc/api/button.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the button or a table with the button properties
---@return Button
function ContainerE:addButton(value)end

--- Adds a Label to the container
---
--- See https://basalt.madefor.cc/api/label.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the label or a table with the label properties
---@return Label
function ContainerE:addLabel(value)end

--- Adds a Textfield to the container
---
--- See https://basalt.madefor.cc/api/textfield.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the textfield or a table with the textfield properties
---@return Textfield
function ContainerE:addTextfield(value)end

--- Adds a Image to the container
---
--- See https://basalt.madefor.cc/api/image.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the image or a table with the image properties
---@return Image
function ContainerE:addImage(value)end

--- Adds a Progressbar to the container
---
--- See https://basalt.madefor.cc/api/progressbar.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the progressbar or a table with the progressbar properties
---@return Progressbar
function ContainerE:addProgressbar(value)end

--- Adds a Slider to the container
---
--- See https://basalt.madefor.cc/api/slider.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the slider or a table with the slider properties
---@return Slider
function ContainerE:addSlider(value)end

--- Adds a Checkbox to the container
---
--- See https://basalt.madefor.cc/api/checkbox.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the checkbox or a table with the checkbox properties
---@return Checkbox
function ContainerE:addCheckbox(value)end

--- Adds a List to the container
---
--- See https://basalt.madefor.cc/api/list.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the list or a table with the list properties
---@return List
function ContainerE:addList(value)end

--- Adds a Dropdown to the container
---
--- See https://basalt.madefor.cc/api/dropdown.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the dropdown or a table with the dropdown properties
---@return Dropdown
function ContainerE:addDropdown(value)end

--- Adds a Frame to the container
---
--- See https://basalt.madefor.cc/api/frame.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the frame or a table with the frame properties
---@return Frame
function ContainerE:addFrame(value)end

--- Adds a Scrollbar to the container
---
--- See https://basalt.madefor.cc/api/scrollbar.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the scrollbar or a table with the scrollbar properties
---@return Scrollbar
function ContainerE:addScrollbar(value)end

--- Adds a Menubar to the container
---
--- See https://basalt.madefor.cc/api/menubar.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the menubar or a table with the menubar properties
---@return Menubar
function ContainerE:addMenubar(value)end

--- Adds a Flexbox to the container
---
--- See https://basalt.madefor.cc/api/flexbox.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the flexbox or a table with the flexbox properties
---@return Flexbox
function ContainerE:addFlexbox(value)end

--- Adds a MovableFrame to the container
---
--- See https://basalt.madefor.cc/api/movableframe.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the movableframe or a table with the movableframe properties
---@return MovableFrame
function ContainerE:addMovableFrame(value)end

--- Adds a ScrollableFrame to the container
---
--- See https://basalt.madefor.cc/api/scrollableframe.html for more information.
---@param self table The element itself
---@param value? string|table -- The name of the scrollableframe or a table with the scrollableframe properties
---@return ScrollableFrame
function ContainerE:addScrollableFrame(value)end




----- BaseFrame Element -----------------------------------
--------- Properties --------------------------------------

--- @class BaseFrameP : ContainerE
local BaseFrameP = {}



------ Frame ----------------------------------------------
--------- Properties --------------------------------------

--- @class FrameP : ContainerE
local FrameP = {}



------ Button ---------------------------------------------
--------- Properties --------------------------------------

--- @class ButtonP : VisualElementL
local ButtonP = {}

--- Sets the text of the button
---@param self table The element itself
---@param value string -- The text of the button
---@return Button
function ButtonP:setText(value)end

--- Gets the text of the button
---@param self table The element itself
---@return string
function ButtonP:getText()end



------ Label ----------------------------------------------
--------- Properties --------------------------------------

--- @class LabelP : VisualElementL
local LabelP = {}

--- Sets the text of the label
---@param value string -- The text of the label
---@param self table The element itself
---@return Label
function LabelP:setText(value)end

--- Gets the text of the label
---@param self table The element itself
---@return string
function LabelP:getText()end

--- Sets the autoSize of the label (automatically changes the width of the label to fit the text)
---@param self table The element itself
---@param value boolean -- The autoSize of the label
---@return Label
function LabelP:setAutoSize(value)end

--- Gets the autoSize of the label
---@param self table The element itself
---@return boolean
function LabelP:getAutoSize()end

--- Sets the wrap of the label (wraps the text to the next line if it's too long)
---@param self table The element itself
---@param value boolean -- The wrap of the label
---@return Label
function LabelP:setWrap(value)end

--- Gets the wrap of the label
---@param self table The element itself
---@return boolean
function LabelP:getWrap()end

--- Sets the coloring of the label (enables/disables coloring of the text with special characters)
---@param self table The element itself
---@param value boolean -- The coloring of the label
---@return Label
function LabelP:setColoring(value)end

--- Gets the coloring of the label
---@param self table The element itself
---@return boolean
function LabelP:getColoring()end



------ Checkbox -------------------------------------------
--------- Properties --------------------------------------

--- @class CheckboxP : VisualElementL
local CheckboxP = {}

--- Sets the text of the checkbox
---@param self table The element itself
---@param value string -- The text of the checkbox
---@return Checkbox
function CheckboxP:setText(value)end

--- Gets the text of the checkbox
---@param self table The element itself
---@return string
function CheckboxP:getText()end

--- Sets the checked state of the checkbox
---@param self table The element itself
---@param value boolean -- The checked state of the checkbox
---@return Checkbox
function CheckboxP:setChecked(value)end

--- Gets the checked state of the checkbox
---@param self table The element itself
---@return boolean
function CheckboxP:getChecked()end

--- Sets the checked symbol of the checkbox
---@param self table The element itself
---@param value string -- The checked symbol of the checkbox
---@return Checkbox
function CheckboxP:setCheckedSymbol(value)end

--- Gets the checked symbol of the checkbox
---@param self table The element itself
---@return string
function CheckboxP:getCheckedSymbol()end

--- Sets the checked color of the checkbox
---@param self table The element itself
---@param value integer -- The checked color of the checkbox
---@return Checkbox
function CheckboxP:setCheckedColor(value)end

--- Gets the checked color of the checkbox
---@param self table The element itself
---@return integer
function CheckboxP:getCheckedColor()end

--- Sets the checked background color of the checkbox
---@param self table The element itself
---@param value integer -- The checked background color of the checkbox
---@return Checkbox
function CheckboxP:setCheckedBgColor(value)end

--- Gets the checked background color of the checkbox
---@param self table The element itself
---@return integer
function CheckboxP:getCheckedBgColor()end

--- Sets the symbol of the checkbox
---@param self table The element itself
---@param value string -- The symbol of the checkbox
---@param color integer -- The color of the symbol
---@param bgColor integer -- The background color of the symbol
---@return Checkbox
function CheckboxP:setSymbol(value, color, bgColor)end

--- Gets the symbol of the checkbox
---@param self table The element itself
---@return string, integer, integer
function CheckboxP:getSymbol()end




------ Input ----------------------------------------------
--------- Properties --------------------------------------

--- @class InputP : VisualElementL
local InputP = {}

--- Sets the text of the input
---@param self table The element itself
---@param value string -- The text of the input
---@return Input
function InputP:setValue(value)end

--- Gets the text of the input
---@param self table The element itself
---@return string
function InputP:getValue()end

--- Sets the cursor index of the input
---@param self table The element itself
---@param value integer -- The cursor index of the input
---@return Input
function InputP:setCursorIndex(value)end

--- Gets the cursor index of the input
---@param self table The element itself
---@return integer
function InputP:getCursorIndex()end

--- Sets the scroll index of the input
---@param self table The element itself
---@param value integer -- The scroll index of the input
---@return Input
function InputP:setScrollIndex(value)end

--- Gets the scroll index of the input
---@param self table The element itself
---@return integer
function InputP:getScrollIndex()end

--- Sets the input limit of the input
---@param self table The element itself
---@param value integer -- The input limit of the input
---@return Input
function InputP:setInputLimit(value)end


--- Gets the input limit of the input
---@param self table The element itself
---@return integer
function InputP:getInputLimit()end

--- Sets the input type of the input
---@param self table The element itself
--- @param value --- The input type of the input
---| '"text"' # The default type: text mode
---| '"password"' #  The password mode: hides the text
---| '"number"' #  The number mode: only allows numbers
---@return Input
function InputP:setInputType(value)end

--- Gets the input type of the input
---@param self table The element itself
---@return string
function InputP:getInputType()end

--- Sets the placeholder text of the input
---@param self table The element itself
---@param value string -- The placeholder text of the input
---@return Input
function InputP:setPlaceholderText(value)end

--- Gets the placeholder text of the input
---@param self table The element itself
---@return string
function InputP:getPlaceholderText()end

--- Sets the placeholder color of the input
---@param self table The element itself
---@param value integer -- The placeholder color of the input
---@return Input
function InputP:setPlaceholderColor(value)end

--- Gets the placeholder color of the input
---@param self table The element itself
---@return integer
function InputP:getPlaceholderColor()end

--- Sets the placeholder background color of the input
---@param self table The element itself
---@param value integer -- The placeholder background color of the input
---@return Input
function InputP:setPlaceholderBackground(value)end

--- Gets the placeholder background color of the input
---@param self table The element itself
---@return integer
function InputP:getPlaceholderBackground()end

--- Sets the placeholder of the input
---@param self table The element itself
---@param text string -- The placeholder text of the input
---@param color integer -- The placeholder color of the input
---@param bgColor integer -- The placeholder background color of the input
---@return Input
function InputP:setPlaceholder(text, color, bgColor)end

--- Gets the placeholder of the input
---@param self table The element itself
---@return string, integer, integer
function InputP:getPlaceholder()end



------ Input ----------------------------------------------
--------- Listeners ---------------------------------------

--- @class InputL : InputP
local InputL = {}

--- Adds a onChange listener to the input
---@param self table The element itself
---@param func fun(self:Input, value:string) -- The function to be called when the input changes
---@return Input
function InputL:onChange(func)end

--- Adds a onEnter listener to the input
---@param self table The element itself
---@param func fun(self:Input, value:string) -- The function to be called when the enter key is pressed
---@return Input
function InputL:onEnter(func)end



------ Progressbar ----------------------------------------
--------- Properties --------------------------------------

--- @class ProgressbarP : VisualElementL
local ProgressbarP = {}

--- Sets the progress of the progressbar
---@param self table The element itself
---@param value number -- The progress of the progressbar
---@return Progressbar
function ProgressbarP:setProgress(value)end

--- Gets the progress of the progressbar
---@param self table The element itself
---@return number
function ProgressbarP:getProgress()end

--- Sets the progress background of the progressbar
---@param self table The element itself
---@param value integer -- The progress background of the progressbar
---@return Progressbar
function ProgressbarP:setProgressBackground(value)end

--- Gets the progress background of the progressbar
---@param self table The element itself
---@return integer
function ProgressbarP:getProgressBackground()end

--- Sets the min value of the progressbar
---@param self table The element itself
---@param value number -- The min value of the progressbar
---@return Progressbar
function ProgressbarP:setMinValue(value)end

--- Gets the min value of the progressbar
---@param self table The element itself
---@return number
function ProgressbarP:getMinValue()end

--- Sets the max value of the progressbar
---@param self table The element itself
---@param value number -- The max value of the progressbar
---@return Progressbar
function ProgressbarP:setMaxValue(value)end

--- Gets the max value of the progressbar
---@param self table The element itself
---@return number
function ProgressbarP:getMaxValue()end




------ Textfield ------------------------------------------
--------- Properties --------------------------------------

--- @class TextfieldP : VisualElementL
local TextfieldP = {}

--- Sets the lines for the textfield
---@param self table The element itself
---@param lines table -- The lines for the textfield
---@return Textfield
function TextfieldP:setLines(lines)end

--- Gets the lines for the textfield
---@param self table The element itself
---@return table
function TextfieldP:getLines()end

--- Sets the cursor index for the textfield
---@param self table The element itself
---@param value integer -- The cursor index for the textfield
---@return Textfield
function TextfieldP:setCursorIndex(value)end

--- Gets the cursor index for the textfield
---@param self table The element itself
---@return integer
function TextfieldP:getCursorIndex()end

--- Sets the line index for the textfield
---@param self table The element itself
---@param value integer -- The line index for the textfield
---@return Textfield
function TextfieldP:setLineIndex(value)end

--- Gets the line index for the textfield
---@param self table The element itself
---@return integer
function TextfieldP:getLineIndex()end

--- Sets the scroll index x for the textfield
---@param self table The element itself
---@param value integer -- The scroll index x for the textfield
---@return Textfield
function TextfieldP:setScrollIndexX(value)end

--- Gets the scroll index x for the textfield
---@param self table The element itself
---@return integer
function TextfieldP:getScrollIndexX()end

--- Sets the scroll index y for the textfield
---@param self table The element itself
---@param value integer -- The scroll index y for the textfield
---@return Textfield
function TextfieldP:setScrollIndexY(value)end

--- Gets the scroll index y for the textfield
---@param self table The element itself
---@return integer
function TextfieldP:getScrollIndexY()end



------ Slider ---------------------------------------------
--------- Properties --------------------------------------

--- @class SliderP : VisualElementL
local SliderP = {}

--- Sets the value of the slider
---@param self table The element itself
---@param value number -- The value of the slider
---@return Slider
function SliderP:setValue(value)end

--- Gets the value of the slider
---@param self table The element itself
---@return number
function SliderP:getValue()end

--- Sets the min value of the slider
---@param self table The element itself
---@param value number -- The min value of the slider
---@return Slider
function SliderP:setMinValue(value)end

--- Gets the min value of the slider
---@param self table The element itself
---@return number
function SliderP:getMinValue()end

--- Sets the max value of the slider
---@param self table The element itself
---@param value number -- The max value of the slider
---@return Slider
function SliderP:setMaxValue(value)end

--- Gets the max value of the slider
---@param self table The element itself
---@return number
function SliderP:getMaxValue()end

--- Sets the knob symbol of the slider
---@param self table The element itself
---@param value string -- The knob symbol of the slider
---@return Slider
function SliderP:setKnobSymbol(value)end

--- Gets the knob symbol of the slider
---@param self table The element itself
---@return string
function SliderP:getKnobSymbol()end

--- Sets the knob color of the slider
---@param self table The element itself
---@param value integer -- The knob color of the slider
---@return Slider
function SliderP:setKnobForeground(value)end

--- Gets the knob color of the slider
---@param self table The element itself
---@return integer
function SliderP:getKnobForeground()end

--- Sets the knob background color of the slider
---@param self table The element itself
---@param value integer -- The knob background color of the slider
---@return Slider
function SliderP:setKnobBackground(value)end

--- Gets the knob background color of the slider
---@param self table The element itself
---@return integer
function SliderP:getKnobBackground()end

--- Sets the background symbol of the slider
---@param self table The element itself
---@param value string -- The knob background symbol of the slider
---@return Slider
function SliderP:setBgSymbol(value)end

--- Gets the background symbol of the slider
---@param self table The element itself
---@return string
function SliderP:getBgSymbol()end

--- Sets the steps of the slider
---@param self table The element itself
---@param value integer -- The steps of the slider
function SliderP:setStep(value)end

--- Gets the steps of the slider
---@param self table The element itself
---@return integer
function SliderP:getStep()end

--- Sets the knob of the slider
---@param self table The element itself
---@param value string -- The knob of the slider
---@param fg integer -- The foreground color of the knob
---@param bg integer -- The background color of the knob
---@return Slider
function SliderP:setKnob(value, fg, bg)end

--- Gets the knob of the slider
---@param self table The element itself
---@return string, integer, integer
function SliderP:getKnob()end



----- Slider ---------------------------------------------
--------- Listeners --------------------------------------

--- @class SliderL : SliderP
local SliderL = {}

--- Adds a onChange listener to the slider
---@param self table The element itself
---@param func fun(self:Slider, value:number) -- The function to be called when the slider changes
---@return Slider
function SliderL:onChange(func)end




------ Program --------------------------------------------
--------- Properties --------------------------------------

--- @class ProgramP : VisualElementL
local ProgramP = {}

--- Sets the program object to the program element
---@param self table The element itself
---@param value table -- The program object
---@return Program
function ProgramP:setProgram(value)end

--- Gets the program object of the program element
---@param self table The element itself
---@return table
function ProgramP:getProgram()end



------ Monitor --------------------------------------------
--------- Properties --------------------------------------

--- @class MonitorP : ContainerE
local MonitorP = {}

--- Sets the CC:Tweaked monitor table for the monitor element
---@param self table The element itself
---@param value string|table -- The side where the monitor is attached or the monitor table itself
---@return Monitor
function MonitorP:setMonitor(value)end

--- Gets the CC:Tweaked monitor table of the monitor element
---@param self table The element itself
---@return table
function MonitorP:getMonitor()end

--- Sets the side of the monitor element this property gets updated by setMonitor, so please use setMonitor(side) instead
---@param self table The element itself
---@param value string -- The side of the monitor element
---@return Monitor
function MonitorP:setSide(value)end

--- Gets the side of the monitor element
---@param self table The element itself
---@return string
function MonitorP:getSide()end


------ BigMonitor -----------------------------------------
--------- Properties --------------------------------------

--- @class BigMonitorP : ContainerE
local BigMonitorP = {}

------ List -----------------------------------------------
--------- Properties --------------------------------------

--- @class ListP : VisualElementL
local ListP = {}

--- Sets the items of the list
---@param self table The element itself
---@param value table -- The items of the list
---@return List
function ListP:setItems(value)end

--- Gets the items of the list
---@param self table The element itself
---@return table
function ListP:getItems()end

--- Sets the item background of the list
---@param self table The element itself
---@param value table -- The item background of the list
---@return List
function ListP:setItemBackground(value)end

--- Gets the item background of the list
---@param self table The element itself
---@return table
function ListP:getItemBackground()end

--- Sets the item foreground of the list
---@param self table The element itself
---@param value table -- The item foreground of the list
---@return List
function ListP:setItemForeground(value)end

--- Gets the item foreground of the list
---@param self table The element itself
---@return table
function ListP:getItemForeground()end

--- Sets if selection should be enabled for the list
---@param self table The element itself
---@param value boolean -- If selection should be enabled for the list
---@return List
function ListP:setSelection(value)end

--- Gets if selection is enabled for the list
---@param self table The element itself
---@return boolean
function ListP:getSelection()end

--- Sets if multi selection should be enabled for the list
---@param self table The element itself
---@param value boolean -- If multi selection should be enabled for the list
---@return List
function ListP:setMultiSelection(value)end

--- Gets if multi selection is enabled for the list
---@param self table The element itself
---@return boolean
function ListP:getMultiSelection()end

--- Sets if auto scroll should be enabled for the list (as soon as a new item is added the list will scroll to the bottom)
---@param self table The element itself
---@param value boolean -- If auto scroll should be enabled for the list
---@return List
function ListP:setAutoScroll(value)end

--- Gets if auto scroll is enabled for the list
---@param self table The element itself
---@return boolean
function ListP:getAutoScroll()end

--- Sets the selected index of the list
---@param self table The element itself
---@param value integer -- The selected index of the list
---@return List
function ListP:setSelectedIndex(value)end

--- Gets the selected index of the list
---@param self table The element itself
---@return integer
function ListP:getSelectedIndex()end

--- Sets the selection background of the list
---@param self table The element itself
---@param value integer -- The selection background of the list
---@return List
function ListP:setSelectionBackground(value)end

--- Gets the selection background of the list
---@param self table The element itself
---@return integer
function ListP:getSelectionBackground()end

--- Sets the selection foreground of the list
---@param self table The element itself
---@param value integer -- The selection foreground of the list
---@return List
function ListP:setSelectionForeground(value)end

--- Gets the selection foreground of the list
---@param self table The element itself
---@return integer
function ListP:getSelectionForeground()end

--- Sets the scroll index of the list
---@param self table The element itself
---@param value integer -- The scroll index of the list
---@return List
function ListP:setScrollIndex(value)end

--- Gets the scroll index of the list
---@param self table The element itself
---@return integer
function ListP:getScrollIndex()end

--- Sets the selection color of the list
---@param self table The element itself
---@param bg integer -- The selection background color of the list
---@param fg integer -- The selection foreground color of the list
---@return List
function ListP:setSelectionColor(bg, fg)end

--- Gets the selection color of the list
---@param self table The element itself
---@return integer, integer
function ListP:getSelectionColor()end



----- List -----------------------------------------------
--------- Listeners --------------------------------------

--- @class ListL : ListP
local ListL = {}

--- Adds a onChange event listener for the list
---@param self table The element itself
---@param func fun(self:List, index:integer, item:string) -- The function to be called when the list changes
---@return List
function ListL:onChange(func)end





------ Dropdown -------------------------------------------
--------- Properties --------------------------------------

--- @class DropdownP : ListL
local DropdownP = {}

--- Sets if the dropdown is open
---@param self table The element itself
---@param value boolean -- If the dropdown is open
---@return Dropdown
function DropdownP:setOpened(value)end

--- Gets if the dropdown is open
---@param self table The element itself
---@return boolean
function DropdownP:getOpened()end

--- Sets the dropdown height
---@param self table The element itself
---@param value integer -- The dropdown height
---@return Dropdown
function DropdownP:setDropdownHeight(value)end

--- Gets the dropdown height
---@param self table The element itself
---@return integer
function DropdownP:getDropdownHeight()end

--- Sets the dropdown width
---@param self table The element itself
---@param value integer -- The dropdown width
---@return Dropdown
function DropdownP:setDropdownWidth(value)end

--- Gets the dropdown width
---@param self table The element itself
---@return integer
function DropdownP:getDropdownWidth()end

--- Sets the dropdown size
---@param self table The element itself
---@param width integer -- The dropdown width
---@param height integer -- The dropdown height
---@return Dropdown
function DropdownP:setDropdownSize(width, height)end



------ Menubar --------------------------------------------
--------- Properties --------------------------------------

--- @class MenubarP : ListL

--- Sets the spacing between the items
---@param self table The element itself
---@param value integer -- The spacing between the items
---@return Menubar
function MenubarP:setSpacing(value)end

--- Gets the spacing between the items
---@param self table The element itself
---@return integer



------ MovableFrame ---------------------------------------
--------- Properties --------------------------------------

--- @class MovableFrameP : ContainerE
local MovableFrameP = {}

--- Sets the DragMap of the movableframe
---@param self table The element itself
---@param value table -- The DragMap of the movableframe
---@return MovableFrame
function MovableFrameP:setDragMap(value)end

--- Gets the DragMap of the movableframe
---@param self table The element itself
---@return table
function MovableFrameP:getDragMap()end

------ ScrollableFrame ------------------------------------
--------- Properties --------------------------------------

--- @class ScrollableFrameP : ContainerE
local ScrollableFrameP = {}



------- Scrollbar -----------------------------------------
--------- Properties --------------------------------------

--- @class ScrollbarP : VisualElementL
local ScrollbarP = {}

------- Flexbox -------------------------------------------
--------- Properties --------------------------------------

--- @class FlexboxP : ContainerE
local FlexboxP = {}

--- Sets the direction of the flexbox
---@param self table The element itself
--- @param direction --- The direction of the flexbox
---| '"row"' # The default direction: horizontal
---| '"column"' #  The vertical direction
---@return Flexbox
function FlexboxP:setFlexDirection(direction)end

--- Gets the direction of the flexbox
---@param self table The element itself
---@return string
function FlexboxP:getFlexDirection()end

--- Sets the spacing of the flexbox
---@param self table The element itself
---@param value integer -- The spacing of the flexbox
---@return Flexbox
function FlexboxP:setFlexSpacing(value)end

--- Gets the spacing of the flexbox
---@param self table The element itself
---@return integer
function FlexboxP:getFlexSpacing()end

--- Sets the wrap of the flexbox
---@param self table The element itself
---@param value boolean -- The wrap of the flexbox
---@return Flexbox
function FlexboxP:setFlexWrap(value)end

--- Gets the wrap of the flexbox
---@param self table The element itself
---@return boolean
function FlexboxP:getFlexWrap()end

--- Sets the justify content of the flexbox
---@param self table The element itself
--- @param value --- The justify content of the flexbox
---| '"flex-start"' # The default justify content: aligns the items to the start of the flexbox
---| '"flex-end"' #  Aligns the items to the end of the flexbox
---| '"center"' #  Aligns the items to the center of the flexbox
---| '"space-between"' #  Aligns the items with space between them
---| '"space-around"' #  Aligns the items with space around them
---@return Flexbox
function FlexboxP:setJustifyContent(value)end

--- Gets the justify content of the flexbox
---@param self table The element itself
---@return string
function FlexboxP:getJustifyContent()end

------ 