local type,len,rep,sub = type,string.len,string.rep,string.sub
local tHex = require("tHex")

local function MassiveMonitor(monitorNames)
    local monitors = {}
    for k,v in pairs(monitorNames)do
        monitors[k] = {}
        for a,b in pairs(v)do
            local mon = peripheral.wrap(b)
            if(mon==nil)then
                error("Unable to find monitor "..b)
            end
            monitors[k][a] = mon
            monitors[k][a].name = b
        end
    end


    local x,y,monX,monY,monW,monH,w,h = 1,1,1,1,0,0,0,0
    local blink,scale = false,1
    local fg,bg = colors.white,colors.black

  
    local function calcSize()
        local maxW,maxH = 0,0
        for k,v in pairs(monitors)do
            local _maxW,_maxH = 0,0
            for a,b in pairs(v)do
                local nw,nh = b.getSize()
                _maxW = _maxW + nw
                _maxH = nh > _maxH and nh or _maxH
            end
            maxW = maxW > _maxW and maxW or _maxW
            maxH = maxH + _maxH
        end
        w,h = maxW,maxH
    end
    calcSize()

    local function calcPosition()
        local relY = 0
        local mX,mY = 0,0
        for k,v in pairs(monitors)do
            local relX = 0
            local _mh = 0
            for a,b in pairs(v)do
                local mw,mh = b.getSize()
                if(x-relX>=1)and(x-relX<=mw)then
                    mX = a
                end
                b.setCursorPos(x-relX, y-relY)
                relX = relX + mw
                if(_mh<mh)then _mh = mh end
            end
            if(y-relY>=1)and(y-relY<=_mh)then
                mY = k
            end
            relY = relY + _mh
        end
        monX,monY = mX,mY
    end
    calcPosition()

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
        if(monitors[monY]==nil)then return end
        local mon = monitors[monY][monX]
        if(mon==nil)then return end
        mon.blit(text, tCol, bCol)
        local mW, mH = mon.getSize()
        if(len(text)+x>mW)then
            local monRight = monitors[monY][monX+1]
            if(monRight~=nil)then
                monRight.blit(text, tCol, bCol)
                monX = monX + 1
                x = x + len(text)
            end
        end
        calcPosition()
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
            calcPosition()
            cursorBlink()
        end,

        setTextScale = function(_scale)
            call("setTextScale", _scale)()
            calcSize()
            calcPosition()
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
local BaseFrame = objectLoader.load("BaseFrame")

local MonitorFrame = setmetatable({}, BaseFrame)

Object:initialize("MonitorFrame")
Object:addProperty("MonitorGroup", "string|table", nil, false, function(self, value)
    self:setTerm(MassiveMonitor(value))
    self.isMonitorGroup = true
end)


function MonitorFrame:new()
  local newInstance = BaseFrame:new()
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:setType("MonitorFrame")
  newInstance:create("MonitorFrame")
  newInstance:setSize(term.getSize())
  newInstance:setTerm(nil)
  return newInstance
end

function MonitorFrame.event(self, event, ...)
  Object.event(self, event, ...)
  if(event=="monitor_resize")then
    self:setSize(term.getSize())
    self:setTerm(term.current())
  end
end

function MonitorFrame:mouse_click(btn, x, y, monitor, ...)
    if(self.isMonitorGroup)then
        local monGroup = self:getTerm()
        x, y = monGroup.calculateClick(monitor, x, y)
    end
    Object.mouse_click(self, btn, x, y, monitor, ...)
end


return MonitorFrame