local type,len,rep,sub = type,string.len,string.rep,string.sub
local tHex = require("tHex")

local function MassiveMonitor(monitors)
    local x,y,monX,monY,monW,monH,w,h = 1,1,1,1,0,0,0,0
    local blink,scale = false,1
    local fg,bg = colors.white,colors.black

    local function updatePosition()
        for k,v in pairs(monitors)do
            for a,b in pairs(v)do
                local wM,hM = b.getSize()
                if(x <= wM)then
                    monX = a
                    monY = k
                    monW = wM
                    monH = hM
                    return
                else
                    x = x - wM
                end
            end
        end
    end
    updatePosition()

    local function updateSize()
        w,h = 0,0
        for k,v in pairs(monitors)do
            local maxY,newW = 0, 0
            for a,b in pairs(v)do
                local wM,hM = b.getSize()
                newW = newW + wM
                if(hM > maxY)then maxY = hM end
                if(newW > w)then w = newW end
            end
            h = h + maxY
        end
    end
    updateSize()

    local function call(f, ...)
        local t = {...}
        return function()
            for k,v in pairs(monitors)do
                for a,b in pairs(v)do
                    b[f](table.unpack(t))
                end
            end
        end
    end

    local function cursorBlink()
        call("setCursorBlink", false)()
        if not(blink)then return end
        if(monitors[monY]==nil)then return end
        local mon = monitors[monY][monX]
        if(mon==nil)then return end
        mon.setCursorBlink(blink)
    end

    local function blit(text, tCol, bCol)
        updatePosition()
        local mon = monitors[monY][monX]
        if(mon==nil)then return end
        local wM,hM = mon.getSize()
    local l = len(text)
        mon.setCursorPos(1, y)
        mon.blit(text, tCol, bCol)
        print(monX, monY)
        if(x + l > wM)then
            x = x + wM - 1
            blit(sub(text, wM - x + 2), sub(tCol, wM - x + 2), sub(bCol, wM - x + 2))
        end
    end

   return {
        clear = call("clear"),

        setCursorBlink = function(_blink)
            blink = _blink
            cursorBlink()
        end,

        getCursorBlink = function()
            return blink
        end,

        getCursorPos = function()
            return x, y
        end,

        setCursorPos = function(newX,newY)
            x, y = newX, newY
            updatePosition()
            cursorBlink()
        end,

        setTextScale = function(_scale)
            call("setTextScale", _scale)()
            updatePosition()
            updateSize()
            scale = _scale
        end,

        getTextScale = function()
            return scale
        end,

        blit = function(text,fgCol,bgCol)
            blit(text,fgCol,bgCol)
        end,

        write = function(text)
            text = tostring(text)
            local l = len(text)
            blit(text, rep(tHex[fg], l), rep(tHex[bg], l))
        end,

        getSize = function()
            return w,h
        end,

        setBackgroundColor = function(col)
            call("setBackgroundColor", col)()
            bg = col
        end,

        setTextColor = function(col)
            call("setTextColor", col)()
            fg = col
        end,

        calculateClick = function(name, xClick, yClick)
            local relY = 0
            for k,v in pairs(monitors)do
                local relX = 0
                local maxY = 0
                for a,b in pairs(v)do
                    local wM,hM = b.getSize()
                    if(b.name==name)then
                        return xClick + relX, yClick + relY
                    end
                    relX = relX + wM
                    if(hM > maxY)then maxY = hM end
                end
                relY = relY + maxY
            end
            return xClick, yClick
        end,

   }
end

local objectLoader = require("objectLoader")
local Object = objectLoader.load("Object")
local Container = objectLoader.load("Container")


local BigMonitor = setmetatable({}, Container)

Object:initialize("BigMonitor")


function BigMonitor:new(id, basalt)
  local newInstance = Container:new(id, basalt)
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:setType("BigMonitor")
  newInstance:create("BigMonitor")
  return newInstance
end

function BigMonitor:event(event, ...)
  Container.event(self, event, ...)
  if(event=="monitor_resize")then

  end
end

function BigMonitor:monitor_touch(side, ...)
  --if(side==self:getSide())then
    --self.basalt.setFocusedFrame(self)
    --self:mouse_click(1, ...)
  --end
end

function BigMonitor:setGroup(group)
    if(type(group)~="table")then
        error("Expected table, got "..type(group))
    end
    local monitors = {}
    for k,v in pairs(group)do
        monitors[k] = {}
        for a,b in pairs(v)do
            if(type(b=="string"))then
                local mon = peripheral.wrap(b)
            if(mon==nil)then
                error("Unable to find monitor "..b)
            end
                monitors[k][a] = mon
                monitors[k][a].name = b
            elseif(type(b)=="table")then
                monitors[k][a] = b
                monitors[k][a].name = peripheral.getName(b)
            end
        end
    end
    self.monitors = monitors
    self.massiveMon = MassiveMonitor(monitors)
    self:setTerm(self.massiveMon)
    self:setSize(self.massiveMon.getSize())
end

function BigMonitor:getGroup()
    return self.monitors
end

function BigMonitor:lose_focus()
    Container.lose_focus(self)
    self:setCursor(false)
end

return BigMonitor