local Container = require("basaltLoader").load("Container")

--- @class Frame : FrameP
local Frame = setmetatable({}, Container)

Frame:initialize("Frame")

--- Creates a new frame.
---@param id string The id of the object.
---@param parent? Container The parent of the object.
---@param basalt Basalt The basalt object.
--- @return Frame
---@protected
function Frame:new(id, parent, basalt)
  local newInstance = Container:new(id, parent, basalt)
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:setType("Frame")
  newInstance:create("Frame")
  newInstance:setZ(10)
  newInstance:setSize(30, 12)
  return newInstance
end

return Frame