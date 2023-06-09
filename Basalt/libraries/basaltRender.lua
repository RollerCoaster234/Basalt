local tHex = require("tHex")
local sub,rep,max,min,unpack = string.sub,string.rep,math.max,math.min,table.unpack

local subCache = {}
local subCacheCount = 0
local function cSub(s, i, j)
    local key = s .. i .. j
    if(subCacheCount > 100)then
        subCache = {}
        subCacheCount = 0
    end
    if not subCache[key] then
        subCache[key] = string.sub(s, i, j)
        subCacheCount = subCacheCount + 1
    end
    return subCache[key]
end

return function(drawTerm)
    local terminal = drawTerm or term.current()
    local width, height = terminal.getSize()
    local cache = {}
    local modifiedLines = {}

    local emptySpaceLine
    local emptyColorLines = {}
    
    local function createEmptyLines()
        emptySpaceLine = rep(" ", width)
        for n = 0, 15 do
            local nColor = 2 ^ n
            local sHex = tHex[nColor]
            emptyColorLines[nColor] = rep(sHex, width)
        end
    end
    ----
    createEmptyLines()

    local function recreateWindowArray()
        createEmptyLines()
        local emptyText = emptySpaceLine
        local emptyFG = emptyColorLines[colors.white]
        local emptyBG = emptyColorLines[colors.black]
        for currentY = 1, height do
            cache[currentY] = cache[currentY] or {}
            cache[currentY][1] = sub(cache[currentY].t == nil and emptyText or cache[currentY].t .. emptyText:sub(1, width - cache[currentY].t:len()), 1, width)
            cache[currentY][2] = sub(cache[currentY].fg == nil and emptyFG or cache[currentY].fg .. emptyFG:sub(1, width - cache[currentY].fg:len()), 1, width)
            cache[currentY][3] = sub(cache[currentY].bg == nil and emptyBG or cache[currentY].bg .. emptyBG:sub(1, width - cache[currentY].bg:len()), 1, width)
            modifiedLines[currentY] = true
        end
    end
    
    recreateWindowArray()

    local function blit(x, y, t, fg, bg, pos, w)
        t = cSub(t, max(1 - pos + 1, 1), max(w - pos + 1, 1))
        fg = cSub(fg, max(1 - pos + 1, 1), max(w - pos + 1, 1))
        bg = cSub(bg, max(1 - pos + 1, 1), max(w - pos + 1, 1))

        if #t == #fg and #t == #bg then
            if y >= 1 and y <= height then
                if x + #t > 0 and x <= width then
                    local startN = x < 1 and 1 - x + 1 or 1
                    local endN = x + #t > width and width - x + 1 or #t

                    local oldCache = cache[y]

                    local newCacheT = cSub(oldCache[1], 1, x - 1) .. cSub(t, startN, endN)
                    local newCacheFG = cSub(oldCache[2], 1, x - 1) .. cSub(fg, startN, endN)
                    local newCacheBG = cSub(oldCache[3], 1, x - 1) .. cSub(bg, startN, endN)

                    if x + #t <= width then
                        newCacheT = newCacheT .. cSub(oldCache[1], x + #t, width)
                        newCacheFG = newCacheFG .. cSub(oldCache[2], x + #t, width)
                        newCacheBG = newCacheBG .. cSub(oldCache[3], x + #t, width)
                    end

                    cache[y][1], cache[y][2], cache[y][3] = newCacheT,newCacheFG,newCacheBG
                    modifiedLines[y] = true
                end
            end
        end
    end

    local function setCache(cacheType, x, y, str)
        if y >= 1 and y <= height and x + #str > 0 and x <= width then
            local startN = max(1, 1 - x + 1)
            local endN = min(#str, width - x + 1)
            local oldCache = cache[y][cacheType]
            local newCache = cSub(oldCache, 1, x - 1) .. cSub(str, startN, endN)
            if x + #str <= width then
                newCache = newCache .. cSub(oldCache, x + #str, width)
            end
            cache[y][cacheType] = newCache
            modifiedLines[y] = true
        end
    end

    local drawHelper = {
        setSize = function(w, h)
            width, height = w, h
            recreateWindowArray()
        end,

        setBg = function(x, y, colorStr)
            setCache(3, x, y, colorStr)
        end,

        setText = function(x, y, text)
            setCache(1, x, y, text)
        end,

        setFg = function(x, y, colorStr)
            setCache(2, x, y, colorStr)
        end,

        blit = function(x, y, t, fg, bg, pos, w)
            blit(x, y, t, fg, bg, pos, w)
        end,

        drawBackgroundBox = function(x, y, width, height, bgCol)
            local colorStr = rep(tHex[bgCol], width)
            for n = 1, height do
                setCache(3, x, y + (n - 1), colorStr)
            end
        end,
        drawForegroundBox = function(x, y, width, height, fgCol)
            local colorStr = rep(tHex[fgCol], width)
            for n = 1, height do
                setCache(2, x, y + (n - 1), colorStr)
            end
        end,
        drawTextBox = function(x, y, width, height, symbol)
            local textStr = rep(symbol, width)
            for n = 1, height do
                setCache(1, x, y + (n - 1), textStr)
            end
        end,

        update = function()
            local xC, yC = terminal.getCursorPos()
            local isBlinking = false
            if (terminal.getCursorBlink ~= nil) then
                isBlinking = terminal.getCursorBlink()
            end
            terminal.setCursorBlink(false)
            for n = 1, height do
                if(modifiedLines[n])then
                    terminal.setCursorPos(1, n)
                    terminal.blit(unpack(cache[n]))
                    modifiedLines[n] = false
                end
            end
            terminal.setBackgroundColor(colors.black)
            terminal.setCursorBlink(isBlinking)
            terminal.setCursorPos(xC, yC)
        end,

        setTerm = function(newTerm)
            terminal = newTerm
        end,
    }
    return drawHelper
end