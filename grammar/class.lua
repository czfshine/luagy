--- class.lua
-- Compatible with Lua 5.1 (not 5.0).
-- @usage :
-- in a lua fie (example:'baseclass.lua'):
--~
--~require "class"  --load this file
--~
--~--create a base class
--~local BaseClass=Class(function(self,arg_1,arg_2,...)
-- 		in here add some init code
--~ end)
--~
--~--add a method to base class
--~function BaseClass:Method(arg_1,arg_2,...) --don't need "self"
--		here has some method code
--~end
--~
--~return BaseClass  --this line is must,because use 'local' keyword.
--
-- ----------------------------------
-- Then,in other lua file
--~BaseClass=require "baseclass"
--~
--~--Inheritance
--~local ChildClass=Class(BaseClass,function(self,arg,...)
-- some code
--~end)
--~
--~return ChildClass
--
-- ----------------------------------
-- in test file
--~BaseClass=require "baseclass"
--~ChildClass=require "childclass"
--~
--~--create a instance for base class
--~test1 = BaseClass()
--~--or need argument
--~test2 = BaseClass(arg_1,arg_2,arg_3) --not have "self"
--~--create child class
--~test3 = ChildClass()
--
------------------------------------------
--==============END=======================
local TrackClassInstances = false
function Class(base, _ctor)
    local c = {}    -- a new class instance
    if not _ctor and type(base) == 'function' then
        _ctor = base
        base = nil
    elseif type(base) == 'table' then
    -- our new class is a shallow copy of the base class!
        for i,v in pairs(base) do
            c[i] = v
        end
        c._base = base
    end

    -- the class will be the metatable for all its objects,
    -- and they will look up their methods in it.
    c.__index = c

    -- expose a constructor which can be called by <classname>(<args>)
    local mt = {}

    if TrackClassInstances == true then
        if ClassTrackingTable == nil then
            ClassTrackingTable = {}
        end
        ClassTrackingTable[mt] = {}
	local dataroot = "@"..CWD.."\\"
        local tablemt = {}
        setmetatable(ClassTrackingTable[mt], tablemt)
        tablemt.__mode = "k"         -- now the instancetracker has weak keys

        local source = "**unknown**"
        if _ctor then
  	    -- what is the file this ctor was created in?

	    local info = debug.getinfo(_ctor, "S")
	    -- strip the drive letter
	    -- convert / to \\
	    source = info.source
	    source = string.gsub(source, "/", "\\")
            source = string.gsub(source, dataroot, "")
	    local path = source

	    local file = io.open(path, "r")
	    if file ~= nil then
	        local count = 1
   	        for i in file:lines() do
	            if count == info.linedefined then
                        source = i
		        -- okay, this line is a class definition
		        -- so it's [local] name = Class etc
		        -- take everything before the =
		        local equalsPos = string.find(source,"=")
		        if equalsPos then
			    source = string.sub(source,1,equalsPos-1)
		        end
		        -- remove trailing and leading whitespace
                        source = source:gsub("^%s*(.-)%s*$", "%1")
		        -- do we start with local? if so, strip it
                        if string.find(source,"local ") ~= nil then
                            source = string.sub(source,7)
                        end
	                -- trim again, because there may be multiple spaces
                        source = source:gsub("^%s*(.-)%s*$", "%1")
                        break
	            end
                    count = count + 1
	        end
	        file:close()
	    end
        end

        mt.__call = function(class_tbl, ...)
            local obj = {}
            setmetatable(obj,c)
            ClassTrackingTable[mt][obj] = source
            if c._ctor then
                c._ctor(obj,...)
            end
            return obj
        end
    else
        mt.__call = function(class_tbl, ...)
            local obj = {}
            setmetatable(obj,c)
            if c._ctor then
               c._ctor(obj,...)
            end
            return obj
        end
    end

    c._ctor = _ctor
    c.is_a = function(self, klass)
        local m = getmetatable(self)
        while m do
            if m == klass then return true end
            m = m._base
        end
        return false
    end
    setmetatable(c, mt)
    return c
end

local lastClassTrackingDumpTick = 0

function HandleClassInstanceTracking()
    if TrackClassInstances then
        lastClassTrackingDumpTick = lastClassTrackingDumpTick + 1

        if lastClassTrackingDumpTick >= ClassTrackingInterval then
            collectgarbage()
            print("------------------------------------------------------------------------------------------------------------")
            lastClassTrackingDumpTick = 0
            if ClassTrackingTable then
                local sorted = {}
                local index = 1
                for i,v in pairs(ClassTrackingTable) do
                    local count = 0
                    local first = nil
                    for j,k in pairs(v) do
                        if count == 1 then
                            first = k
                        end
                        count = count + 1
                    end
                    if count>1 then
                        sorted[#sorted+1] = {first, count-1}
                    end
                    index = index + 1
                end
                -- get the top 10
                table.sort(sorted, function(a,b) return a[2] > b[2] end )
                for i=1,10 do
                    local entry = sorted[i]
                    if entry then
                        print(tostring(i).." : "..tostring(sorted[i][1]).." - "..tostring(sorted[i][2]))
                    end
                end
                print("------------------------------------------------------------------------------------------------------------")
            end
        end
    end
end
