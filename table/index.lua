-- Access inside table over __call
-- This is a very nice access since it only can be called over <this>()
function newT()
	-- create access to a table
	local _t = {}
	-- metatable
	local mt = {}
	mt.__call = function()
		-- hold access to the table over function call
		return _t
	end
	return setmetatable( {},mt )
end

-- Access inside table over commonly used variable self[self], inside __index
function newT2()
	local t = {}
	local mt = {}
	mt.__index = {
		[t] = {}
		}
	return setmetatable( t,mt )
end

-- Access inside table over nomal variable
-- disadvantage is that setting a key to _t will override
-- the access to the hidden table
function newT3()
	local mt = {}
	mt.__index = {
		_t = {}
		}
	return setmetatable( {},mt )
end

-- Access over nomal variable inside table
function newT4()
	local t = {}
	t._t = {}
	return t
end
-- CHILLCODE™

t = newT()
t1 = os.clock()
for i = 1, 1000000 do
	-- set var 
	t()[i] = i
	--access var
	assert( t()[i] == i )
end
print("TIME1:",os.clock()-t1)

t = newT2()
t1 = os.clock()
for i = 1, 1000000 do
	-- set var 
	t[t][i] = i
	--access var
	assert( t[t][i] == i )
end
print("TIME2:",os.clock()-t1)
collectgarbage()
t = newT3()
t1 = os.clock()
for i = 1, 1000000 do
	-- set var 
	t._t[i] = i
	--access var
	assert( t._t[i] == i )
end
print("TIME3:",os.clock()-t1)
collectgarbage()
t = newT4()
t1 = os.clock()
for i = 1, 1000000 do
	-- set var 
	t._t[i] = i
	--access var
	assert( t._t[i] == i )
end
print("TIME4:",os.clock()-t1)