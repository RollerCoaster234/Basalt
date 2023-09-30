local loader = require("objectLoader")
local utils = require("utils")
local log = require("log")

local basalt, threads = {log=log}, {}
local updaterActive = false
local mainFrame, focusedFrame, monFrames = nil, nil, {}
local baseTerm = term.current()
local registeredEvents = {}
local objectQueue = {}
loader.setBasalt(basalt)

---- Frame Rendering
local function drawFrames()
    if(updaterActive==false)then return end
    if(mainFrame~=nil)then
        mainFrame:render()
        mainFrame:processRender()
    end
    for _,v in pairs(monFrames)do
        v:render()
        v:processRender()
    end
end

---- Event Handling
local throttle = {}
local lastEventTimes = {}
local lastEventArgs = {}

local events = {
    mouse = {mouse_click=true,mouse_up=true,mouse_drag=true,mouse_scroll=true,mouse_move=true,monitor_touch=true},
    keyboard = {key=true,key_up=true,char=true}
}
local function updateEvent(event, ...)
    local p = {...}
    if(event=="terminate")then basalt.stop() end
    if(event=="mouse_move")then
        if(p[1]==nil)or(p[2]==nil)then return end
    end

    for _,v in pairs(registeredEvents)do
        if(v==event)then
            if not v(event, unpack(p)) then
                return
            end
        end
    end

    if(#objectQueue>0)then
        for _=1,math.min(#objectQueue,50) do
            local obj = table.remove(objectQueue, 1)
            obj:load()
        end
        os.startTimer(0.05)
    end

    if event == "timer" then
        for k,_ in pairs(throttle) do
            if lastEventTimes[k] == p[1] then
                if mainFrame ~= nil and mainFrame[k] ~= nil then
                    mainFrame[k](mainFrame, unpack(lastEventArgs[k]))
                end
                for _,v in pairs(monFrames) do
                    if v[k] ~= nil then
                        v[k](v, unpack(lastEventArgs[k]))
                    end
                end
                lastEventTimes[k] = nil
                lastEventArgs[k] = nil
                return
            end
        end
    end

    if throttle[event] ~= nil and throttle[event] > 0 then
        if lastEventTimes[event] == nil then
            lastEventTimes[event] = os.startTimer(throttle[event])
        end
        lastEventArgs[event] = p
        return
    else
        if(events.mouse[event])then
            if(event=="monitor_touch")then
                for _,v in pairs(monFrames) do
                    if v[event] ~= nil then
                        v[event](v, unpack(p))
                    end
                end
            else
                if mainFrame ~= nil and mainFrame.event ~= nil then
                    mainFrame[event](mainFrame, unpack(p))
                end
            end
        elseif(events.keyboard[event])then
            if focusedFrame ~= nil and focusedFrame[event] ~= nil then
                focusedFrame[event](focusedFrame, unpack(p))
            end
        else
            if mainFrame ~= nil and mainFrame.event ~= nil then
                mainFrame:event(event, unpack(p))
            end
            for _,v in pairs(monFrames) do
                if v[event] ~= nil then
                    v[event](v, unpack(p))
                end
            end
        end
        if(#threads>0)then
            for k,v in pairs(threads)do
                if(coroutine.status(v.thread)=="dead")then
                    table.remove(threads, k)
                else
                    if(v.filter~=nil)then
                        if(event~=v.filter)then
                            drawFrames()
                            return
                        end
                        v.filter=nil
                    end
                    local ok, filter = coroutine.resume(v.thread, event, ...)
                    if(ok)then
                        v.filter = filter
                    else
                        basalt.errorHandler(filter)
                    end
                end
            end
        end
        drawFrames()
    end
end

function basalt.addFrame(id)
    id = id or utils.uuid()
    local frame = loader.load("BaseFrame"):new(id, basalt)
    frame:init()
    if(mainFrame==nil)then
        mainFrame = frame
    end
    return frame
end

function basalt.addMonitor(id)
    id = id or utils.uuid()
    local frame = loader.load("Monitor"):new(id, basalt)
    frame:init()
    table.insert(monFrames, frame)
    return frame
end

function basalt.addBigMonitor(id)
    id = id or utils.uuid()
    local frame = loader.load("BigMonitor"):new(id, basalt)
    frame:init()
    table.insert(monFrames, frame)
    return frame
end

local ObjectManager = {}
local proxyData = {}

local function getObjectZIndex(objectType)
    if proxyData[objectType] == nil then
        proxyData[objectType] = {}
        proxyData[objectType].zIndex = loader.load(objectType):new(nil, basalt):getZ()
    end
    return proxyData[objectType].zIndex
end

local function createProxy(container, id, objectType)
    return setmetatable({
        calls = {},
        isProxy = true,
        getZ = function(self)
            return getObjectZIndex(objectType)
        end,
        getName = function(self)
            return id
        end,
        load = function(self)
            self.isProxy = false
            local calls = self.calls
            container.real = loader.load(objectType):new(id, basalt)
            for _, call in ipairs(calls) do
                if(container.real[call.method]~=nil)then
                    container.real[call.method](container.real, unpack(call.args))
                end
            end
            if container.real.init then
                container.real:init()
                container.real.basalt = basalt
            end
            local parent = self:getParent()
            if(parent~=nil)then
                parent:childVisibiltyChanged()
            end
        end
    }, {
        __index = function(_, methodName)
            if container.real then
                return container.real[methodName]
            end

            return function(self, ...)
                table.insert(self.calls, {method = methodName, args = {...}})
                return self
            end
        end
    })
end

function ObjectManager.create(id, objectType)
    local container = {}
    container.proxy = createProxy(container, id, objectType)
    return container.proxy
end

function basalt.create(id, typ)
    local proxy = ObjectManager.create(id, typ)
    table.insert(objectQueue, proxy)
    return proxy
end

---- Error Handling
function basalt.errorHandler(errMsg)
    baseTerm.clear()
    baseTerm.setCursorPos(1,1)
    baseTerm.setBackgroundColor(colors.black)
    baseTerm.setTextColor(colors.red)
    if(basalt.logging)then
        log(errMsg, "Error")
    end
    print(errMsg)
    baseTerm.setTextColor(colors.white)
    sleep(2)
    updaterActive = false
end

-- Public functions
function basalt.autoUpdate(isActive)
    updaterActive = isActive
    if(isActive==nil)then updaterActive = true end
    local function f()
        drawFrames()
        while updaterActive do
            updateEvent(os.pullEventRaw())
        end
    end
    while updaterActive do
        local ok, err = xpcall(f, debug.traceback)
        if not(ok)then
            basalt.errorHandler(err)
        end
    end
end

function basalt.getObjects()
    return loader.getObjectList()
end

function basalt.onEvent(event, func)
    if(registeredEvents[event]==nil)then
        registeredEvents[event] = {}
    end
    table.insert(registeredEvents[event], func)
end

function basalt.removeEvent(event, func)
    if(registeredEvents[event]==nil)then return end
    for k,v in pairs(registeredEvents[event])do
        if(v==func)then
            table.remove(registeredEvents[event], k)
        end
    end
end

function basalt.setFocusedFrame(frame)
    if(focusedFrame~=nil)then
        focusedFrame:lose_focus()
    end
    if(frame~=nil)then
        frame:get_focus()
    end
    focusedFrame = frame
end

-- not finished
function basalt.thread(func, ...)
    local threadData = {}
    threadData.thread = coroutine.create(func)
    local ok, filter = coroutine.resume(threadData.thread, ...)
    if(ok)then
        threadData.filter = filter
        table.insert(threads, threadData)
        return threadData
    end
    basalt.errorHandler(filter)
end

function basalt.stop()
    updaterActive = false
end

function basalt.getTerm()
    return baseTerm
end

local plugins = loader.getPlugin("Basalt")
if(plugins~=nil)then
    for _,v in pairs(plugins)do
        for a,b in pairs(v)do
            basalt[a] = b
        end
    end
end

return basalt