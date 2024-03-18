local floor,sin,cos,pi,sqrt,pow = math.floor,math.sin,math.cos,math.pi,math.sqrt,math.pow

-- You can find the easings here https://easings.net

local function lerp(s, e, pct)
    return s + (e - s) * pct
end

local function linear(t)
    return t
end

local function flip(t)
    return 1 - t
end

local function easeIn(t)
    return t * t * t
end

local function easeOut(t)
    return flip(easeIn(flip(t)))
end

local function easeInOut(t)
    return lerp(easeIn(t), easeOut(t), t)
end

local function easeOutSine(t)
    return sin((t * pi) / 2);
end

local function easeInSine(t)
    return flip(cos((t * pi) / 2))
end

local function easeInOutSine(t)
    return -(cos(pi * t) - 1) / 2
end

local function easeInBack(t)
    local c1 = 1.70158;
    local c3 = c1 + 1
    return c3*t^3-c1*t^2
end

local function easeInCubic(t)
    return t^3
end

local function easeInElastic(t)
    local c4 = (2*pi)/3;
    return t == 0 and 0 or (t == 1 and 1 or (
        -2^(10*t-10)*sin((t*10-10.75)*c4)
    ))
end

local function easeInExpo(t)
    return t == 0 and 0 or 2^(10*t-10)
end

local function easeInOutBack(t)
    local c1 = 1.70158;
    local c2 = c1 * 1.525;
    return t < 0.5 and ((2*t)^2*((c2+1)*2*t-c2))/2 or ((2*t-2)^2*((c2+1)*(t*2-2)+c2)+2)/2
end

local function easeInOutCubic(t)
    return t < 0.5 and 4 * t^3 or 1-(-2*t+2)^3 / 2
end

local function easeInOutElastic(t)
    local c5 = (2*pi) / 4.5
    return t==0 and 0 or (t == 1 and 1 or (t < 0.5 and -(2^(20*t-10) * sin((20*t - 11.125) * c5))/2 or (2^(-20*t+10) * sin((20*t - 11.125) * c5))/2 + 1))
end

local function easeInOutExpo(t)
    return t == 0 and 0 or (t == 1 and 1 or (t < 0.5 and 2^(20*t-10)/2 or (2-2^(-20*t+10)) /2))
end

local function easeInOutQuad(t)
    return t < 0.5 and 2*t^2 or 1-(-2*t+2)^2/2
end

local function easeInOutQuart(t)
    return t < 0.5 and 8*t^4 or 1 - (-2*t+2)^4 / 2
end

local function easeInOutQuint(t)
    return t < 0.5 and 16*t^5 or 1-(-2*t+2)^5 / 2
end

local function easeInQuad(t)
    return t^2
end

local function easeInQuart(t)
    return t^4
end

local function easeInQuint(t)
    return t^5
end

local function easeOutBack(t)
    local c1 = 1.70158;
    local c3 = c1 + 1
    return 1+c3*(t-1)^3+c1*(t-1)^2
end

local function easeOutCubic(t)
    return 1 - (1-t)^3
end

local function easeOutElastic(t)
    local c4 = (2*pi)/3;

    return t == 0 and 0 or (t == 1 and 1 or (2^(-10*t)*sin((t*10-0.75)*c4)+1))
end

local function easeOutExpo(t)
    return t == 1 and 1 or 1-2^(-10*t)
end

local function easeOutQuad(t)
    return 1 - (1 - t) * (1 - t)
end

local function easeOutQuart(t)
    return 1 - (1-t)^4
end

local function easeOutQuint(t)
    return 1 - (1 - t)^5
end

local function easeInCirc(t)
    return 1 - sqrt(1 - pow(t, 2))
end

local function easeOutCirc(t)
    return sqrt(1 - pow(t - 1, 2))
end

local function easeInOutCirc(t)
    return t < 0.5 and (1 - sqrt(1 - pow(2 * t, 2))) / 2 or (sqrt(1 - pow(-2 * t + 2, 2)) + 1) / 2;
end

local function easeOutBounce(t)
    local n1 = 7.5625;
    local d1 = 2.75;

    if (t < 1 / d1)then
        return n1 * t * t
    elseif (t < 2 / d1)then
        local a = t - 1.5 / d1
        return n1 * a * a + 0.75;
    elseif (t < 2.5 / d1)then
        local a = t - 2.25 / d1
        return n1 * a * a + 0.9375;
    else
        local a = t - 2.625 / d1
        return n1 * a * a + 0.984375;
    end
end

local function easeInBounce(t)
    return 1 - easeOutBounce(1 - t)
end

local function easeInOutBounce(t)
    return t < 0.5 and (1 - easeOutBounce(1 - 2 * t)) / 2 or (1 + easeOutBounce(2 * t - 1)) / 2;
end

local lerp = {
    linear = linear,
    lerp = lerp,
    flip=flip,
    easeIn=easeIn,
    easeInSine = easeInSine,
    easeInBack=easeInBack,
    easeInCubic=easeInCubic,
    easeInElastic=easeInElastic,
    easeInExpo=easeInExpo,
    easeInQuad=easeInQuad,
    easeInQuart=easeInQuart,
    easeInQuint=easeInQuint,
    easeInCirc=easeInCirc,
    easeInBounce=easeInBounce,
    easeOut=easeOut,
    easeOutSine = easeOutSine,
    easeOutBack=easeOutBack,
    easeOutCubic=easeOutCubic,
    easeOutElastic=easeOutElastic,
    easeOutExpo=easeOutExpo,
    easeOutQuad=easeOutQuad,
    easeOutQuart=easeOutQuart,
    easeOutQuint=easeOutQuint,
    easeOutCirc=easeOutCirc,
    easeOutBounce=easeOutBounce,
    easeInOut=easeInOut,
    easeInOutSine = easeInOutSine,
    easeInOutBack=easeInOutBack,
    easeInOutCubic=easeInOutCubic,
    easeInOutElastic=easeInOutElastic,
    easeInOutExpo=easeInOutExpo,
    easeInOutQuad=easeInOutQuad,
    easeInOutQuart=easeInOutQuart,
    easeInOutQuint=easeInOutQuint,
    easeInOutCirc=easeInOutCirc,
    easeInOutBounce=easeInOutBounce,
}

local CustomAnimation = {}

CustomAnimation.__index = CustomAnimation

function CustomAnimation:new()
    local self = {}
    setmetatable(self, CustomAnimation)
    self.duration = 0
    self.curTime = 0
    self.timeIncrement = 0.05
    self.ease = "linear"
    self._animations = {}
    self._animationCache = {}
    self.onDoneHandler = {}
    return self
end

function CustomAnimation.setEase(self, ease)
    if(lerp[ease]==nil)then
        error("Ease "..ease.." does not exist")
    end
    self.ease = ease
    return self
end

function CustomAnimation.setIncrement(self, increment)
    self.timeIncrement = math.max(increment, 0.05)
    return self
end

function CustomAnimation.on(self, time)
    time = floor(time * 20) / 20
    self.duration = time
    return self
end

function CustomAnimation.run(self, func)
    local inserted = false
    for k,v in pairs(self._animations)do
        if(v.time==self.duration)then
            table.insert(v.anims, func)
            inserted = true
            break
        end
    end
    if(not inserted)then
        table.insert(self._animations, {time=self.duration, anims={func}})
    end
    return self
end

function CustomAnimation.wait(self, time)
    time = floor(time * 20) / 20
    self.duration = self.duration + time
    return self
end

function CustomAnimation.update(self, timerId)
    if(timerId==self.timerId)then
        self.curTime = self.curTime + self.timeIncrement
        if(self.curTime>=self.duration)then
            if(#self.onDoneHandler>0)then
                for _,v in pairs(self.onDoneHandler)do
                    v()
                end
            end
            self._animationCache = {}
            os.cancelTimer(self.timerId)
            return
        end
        for k,v in pairs(self._animationCache)do
            if(v.time<=self.curTime)then
                for _,anim in pairs(v.anims)do
                    anim(self)
                end
                table.remove(self._animationCache, k)
            end
        end
        self.timerId = os.startTimer(self.timeIncrement)
    end
end

function CustomAnimation.play(self)
    self.curTime = 0
    self.timerId = os.startTimer(self.timeIncrement)
    for k,v in pairs(self._animations)do
        self._animationCache[k] = {time=v.time, anims={}}
        for _,anim in pairs(v.anims)do
            table.insert(self._animationCache[k].anims, anim)
        end
    end
end

function CustomAnimation.stop(self)
    os.cancelTimer(self.timerId)
end

function CustomAnimation.onDone(self, func)
    table.insert(self.onDoneHandler, func)
    return self
end

local Animation = {}

local function animationMoveHelper(element, v3, v4, duration, offset, ease, get, set)
    local animation = CustomAnimation:new()
    animation:setEase(ease or "linear")
    if(offset~=nil)then
        animation:wait(offset)
    end
    local v1, v2 = get(element)
    for i=0.05, duration, 0.05 do
        animation:run(function(self)
            local pct = lerp[self.ease](i/duration)
            local newV1 = math.floor(lerp.lerp(v1, v3, pct)+0.5)
            local newV2 = math.floor(lerp.lerp(v2, v4, pct)+0.5)
            element:setPosition(newV1, newV2)
        end):wait(0.05)
    end
    animation:onDone(function()
        set(element, v3, v4)
        for k,v in pairs(element.animations)do
            if(v==posAnimation)then
                table.remove(element.animations, k)
                break
            end
        end
    end):play()
    table.insert(element.animations, animation)
    return animation
end 

function Animation.animatePosition(element, x, y, duration, offset, ease)
    return animationMoveHelper(element, x, y, duration, offset, ease, element.getPosition, element.setPosition)
end

function Animation.animateSize(element, x, y, duration, offset, ease)
    return animationMoveHelper(element, x, y, duration, offset, ease, element.getSize, element.setSize)
end

function Animation.animateOffset(element, x, y, duration, offset, ease)
    if(element.getOffset==nil or element.setOffset==nil)then
        error("Element "..element:getType().." does not have offset")
    end
    return animationMoveHelper(element, x, y, duration, offset, ease, element.getOffset, element.setOffset)
end

function Animation.newAnimation(element)
    return CustomAnimation:new()
end

function Animation.extensionProperties(original)
    local Element = require("basaltLoader").load("BasicElement")
    Element:initialize("VisualElement")
    Element:addProperty("animations", "table", {})
end

function Animation.init(original)
    local baseEvent = original.event
    
    original.event = function(self, event, timerId, ...)
        if(event=="timer")then
            for _,v in pairs(self.animations)do
                v:update(timerId)
            end
        end

        if(baseEvent)then
            return baseEvent(self, event, timerId, ...)
        end
    end
end

return {
    VisualElement = Animation,
}