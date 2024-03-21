local loader = require("basaltLoader")
local utils = require("utils")
local log = require("log")

local basalt, threads = {log=log, extensionExists = loader.extensionExists}, {}
local updaterActive = false
local mainFrame, focusedFrame, monFrames = nil, nil, {}
local baseTerm = term.current()
local registeredEvents = {}
local elementQueue = {}
local keysDown,mouseDown = {}, {}
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
local throttle = {mouse_drag=0.05, mouse_move=0.05}
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

    if(#elementQueue>0)then
        for _=1,math.min(#elementQueue,50) do
            local obj = table.remove(elementQueue, 1)
            obj:load()
        end
        os.startTimer(0.05)
    end

    if event == "timer" then
        for k,v in pairs(lastEventTimes) do
            if v == p[1] then
                if mainFrame ~= nil and mainFrame[k] ~= nil then
                    mainFrame[k](mainFrame, unpack(lastEventArgs[k]))
                end
                for _,b in pairs(monFrames) do
                    if b[k] ~= nil then
                        b[k](b, unpack(lastEventArgs[k]))
                    end
                end
                lastEventTimes[k] = nil
                lastEventArgs[k] = nil
                drawFrames()
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
        if(event=="key")then
            keysDown[p[1]] = true
        end
        if(event=="key_up")then
            keysDown[p[1]] = false
        end
        if(event=="mouse_click")then
            mouseDown[p[1]] = true
        end
        if(event=="mouse_up")then
            mouseDown[p[1]] = false
            if mainFrame ~= nil and mainFrame.mouse_release ~= nil then
                mainFrame.mouse_release(mainFrame, unpack(p))
            end
        end
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

function basalt.isKeyDown(key)
    return keysDown[key] or false
end

function basalt.isMouseDown(button)
    return mouseDown[button] or false
end

function basalt.getMainFrame(id)
    if(mainFrame==nil)then
        mainFrame = loader.load("BaseFrame"):new(id or "Basalt_Mainframe", nil, basalt)
        mainFrame:init()
    end
    return mainFrame
end

function basalt.addFrame(id)
    id = id or utils.uuid()
    local frame = loader.load("BaseFrame"):new(id, nil, basalt)
    frame:init()
    if(mainFrame==nil)then
        mainFrame = frame
    end
    return frame
end

function basalt.addMonitor(id)
    id = id or utils.uuid()
    local frame = loader.load("Monitor"):new(id, nil, basalt)
    frame:init()
    table.insert(monFrames, frame)
    return frame
end

function basalt.addBigMonitor(id)
    id = id or utils.uuid()
    local frame = loader.load("BigMonitor"):new(id, nil, basalt)
    frame:init()
    table.insert(monFrames, frame)
    return frame
end

local ElementManager = {}
local proxyData = {}

local function getElementZIndex(elementType)
    if proxyData[elementType] == nil then
        proxyData[elementType] = {}
        proxyData[elementType].zIndex = loader.load(elementType):new(nil, basalt):getZ()
    end
    return proxyData[elementType].zIndex
end

function ElementManager.create(id, elementType)
    local container = {}
    container.proxy = createProxy(container, id, elementType)
    return container.proxy
end

function basalt.create(id, parent, typ)
    local l = loader.load(typ)
    if(type(l)=="string")then
        l = load(l, nil, "t", _ENV)()
    end
    return l:new(id, parent, basalt)
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

function basalt.getElements()
    return loader.getElementList()
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

local extensions = loader.getExtension("Basalt")
if(extensions~=nil)then
    for _,v in pairs(extensions)do
        v.basalt = basalt
        for a,b in pairs(v)do
            basalt[a] = b
        end
    end
end

return basalt