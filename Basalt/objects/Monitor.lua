local type,len,rep,sub = type,string.len,string.rep,string.sub
local tHex = require("tHex")

local objectLoader = require("objectLoader")
local Object = objectLoader.load("Object")
local Container = objectLoader.load("Container")


local Monitor = setmetatable({}, Container)

Object:initialize("Monitor")

Object:addProperty("Monitor", "any", nil, nil, function(self, value)
    if(type(value=="string"))then
       value = peripheral.wrap(value)
    end
    self:setSide(peripheral.getName(value))
    self:setSize(value.getSize())
    self:setTerm(value)
    return value
end)
Object:addProperty("Side", "string", nil, nil, function(self, value)
    if(value==nil)then
      return nil
    end
    if(type(value)=="string")then
      if(peripheral.isPresent(value))then
        if(peripheral.getType(value)=="monitor")then
          return value
        end
      end
    end
end)


function Monitor:new(id, basalt)
  local newInstance = Container:new(id, basalt)
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:setType("Monitor")
  newInstance:create("Monitor")
  return newInstance
end

function Monitor:event(event, ...)
  Container.event(self, event, ...)
  if(event=="monitor_resize")then
    local mon = self:getMonitor()
    self:setSize(mon.getSize())
    self:setTerm(mon)
  end
end

function Monitor:monitor_touch(side, ...)
  if(side==self:getSide())then
    self.basalt.setFocusedFrame(self)
    self:mouse_click(1, ...)
  end
end

function Monitor:lose_focus()
  Container.lose_focus(self)
  self:setCursor(false)
end

return Monitor