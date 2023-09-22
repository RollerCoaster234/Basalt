local loader = require("objectLoader")
local utils = require("utils")

local basalt, threads = {}, {}
local updaterActive = false
local mainFrame, focusedFrame, monFrames = nil, nil, {}
local baseTerm = term.current()
local registeredEvents = {}
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

function basalt.create(id, typ)
    local obj = loader.load(typ):new(id, basalt)
    if(obj~=nil)then
        obj:init()
    end
    return obj
end

---- Error Handling
function basalt.errorHandler(errMsg)
    baseTerm.clear()
    term.setCursorPos(1,1)
    baseTerm.setBackgroundColor(colors.black)
    baseTerm.setTextColor(colors.red)
    if(basalt.logging)then
        --log(errMsg, "Error")
    end
    print(errMsg)
    baseTerm.setTextColor(colors.white)
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
    local t = coroutine.create(func)
    local threadData = {thread = t, func = func, timer = nil, args = {}}
    table.insert(threads, threadData)
    threadData.timer = coroutine.resume(t, ...)
    return t
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