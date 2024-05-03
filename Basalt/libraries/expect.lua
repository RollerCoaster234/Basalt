local expect = {}

local function coloredPrint(message, color)
    term.setTextColor(color)
    print(message)
    term.setTextColor(colors.white)
end

local function _expect(argument, ...)
    local types = {...}
    local valid = false
    for _, expectedType in ipairs(types) do
        if(type(expectedType)=="table")then
            for _,v in ipairs(expectedType)do
                if argument == v then
                    valid = true
                    break
                end
            end
        end
        if type(argument) == expectedType then
            valid = true
            break
        end
        if(expectedType=="color")then
            if(type(argument)=="string")then
                if(colors[argument])then
                    valid = true
                    break
                end
            elseif(type(argument)=="number")then
                for _,v in pairs(colors)do
                    if(v==argument)then
                        valid = true
                        break
                    end
                end
            end
        end
        if(expectedType=="dynValue")then
            if(type(argument)=="string")then
                if(argument:sub(1,1)=="{")and(argument:sub(-1)=="}")then
                    valid = true
                    break
                end
            end
        end
    end
    if(type(argument)=="table")then
        if argument.isType then
            for _, expectedType in ipairs(types) do
                if argument:isType(expectedType) then
                    valid = true
                    break
                end
            end
        end
    end

    if not valid then
        local traceback = debug.traceback()
        local location, lineNumber, functionName
        local lines = {}
        for line in traceback:gmatch("[^\n]+") do
            lines[#lines + 1] = line
        end
        if #lines >= 2 then
            local lastFunctionLine = lines[#lines - 1]
            functionName = lastFunctionLine:match("^.-:.-: in function '([^']+)'$")
        end
        if not functionName then
            functionName = "Unknown function"
        end
        location, lineNumber = traceback:match("\n([^\n]+):(%d+): in main chunk$")
        if location and lineNumber then
            local file = fs.open(location, "r")
            if file then
                local lineContent = ""
                local currentLineNumber = 1
                repeat
                    lineContent = file.readLine()
                    if currentLineNumber == tonumber(lineNumber) then
                        coloredPrint("\149Line " .. lineNumber, colors.cyan)
                        coloredPrint(lineContent, colors.lightGray)
                        break
                    end
                    currentLineNumber = currentLineNumber + 1
                until not lineContent
                file.close()
            end
        else
            location = "Unknown location"
            lineNumber = "Unknown line"
        end
        return location, lineNumber, functionName, traceback
    end
     return true
end

function expect.expect(position, argument, ...)
    if(position==nil)then position = 1 end
    if(argument==nil)then return end
    local types = {...}
    local location, lineNumber, functionName, traceback = _expect(argument, ...)
    if(location~=true)then
        local fileName = location:gsub("^%s+", "")
        if(expect.basalt~=nil)then
            expect.basalt.stop()
        end
        coloredPrint("Basalt Initialization Error:", colors.red)
        print(traceback)
        print()
        if(location:sub(1,1)=="/")then
            fileName = location:sub(2)
        end
        
        term.setTextColor(colors.red)
        term.write("Error in ")
        term.setTextColor(colors.white)
        term.write(fileName:gsub("/", ""))
        term.setTextColor(colors.red)
        term.write(":")
        term.setTextColor(colors.lightBlue)
        term.write(lineNumber)
        term.setTextColor(colors.red)
        term.write(": ")
        coloredPrint("Invalid argument in function '" .. functionName .. ":"..position.."'. Expected " .. table.concat(types, ", ") .. ", got " .. type(argument), colors.red)
        local file = fs.open(location:gsub("^%s+", ""), "r")
        if file then
            print()
            local lineContent = ""
            local currentLineNumber = 1
            repeat
                lineContent = file.readLine()
                if currentLineNumber == tonumber(lineNumber) then
                    coloredPrint("\149Line " .. lineNumber, colors.cyan)
                    coloredPrint("  "..lineContent, colors.lightGray)
                    break
                end
                currentLineNumber = currentLineNumber + 1
            until not lineContent
            file.close()
        else
            error("Unable to open file "..location:gsub("^%s+", "")..".")
        end
        --error()
        return false
    end
    return true
end

function expect.getExpectData(...)
    return _expect(...)
end

return expect