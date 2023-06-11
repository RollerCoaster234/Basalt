local loader = require("objectLoader")
local utils = require("utils")

local basalt, threads = {}, {}
local updaterActive = false
local mainFrame, monFrames = nil, {}
local baseTerm = term.current()

-- Private functions

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
local throttle = {mouse_move = 0.1}
local lastEventTimes = {}
local lastEventArgs = {}

local events = {mouse_click=true,mouse_up=true,mouse_drag=true,mouse_scroll=true,mouse_move=true,key=true,key_up=true,char=true}
local function updateEvent(event, ...)
    local p = {...}
    if(event=="terminate")then basalt.stop() end
    if(event=="monitor_touch")then
        event = "mouse_click"
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
        if(events[event])then
            if mainFrame ~= nil and mainFrame[event] ~= nil then
                mainFrame[event](mainFrame, unpack(p))
            end
            for _,v in pairs(monFrames) do
                if v[event] ~= nil then
                    v[event](v, unpack(p))
                end
            end
        else
            if mainFrame ~= nil and mainFrame.event ~= nil then
                mainFrame:event(event, unpack(p))
            end
            for _,v in pairs(monFrames) do
                if v.event ~= nil then
                    v:event(event, unpack(p))
                end
            end
        end
        drawFrames()
    end
end

function basalt.createFrame(id)
    id = id or utils.uuid()
    local frame = loader.load("BaseFrame"):new()
    frame:init()
    if(mainFrame==nil)then
        mainFrame = frame
    end
    return frame
end

---- Error Handling
function basalt.errorHandler(errMsg)
    baseTerm.clear()
    term.setCursorPos(1,1)
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

return basalt