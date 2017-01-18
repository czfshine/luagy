local function Class( _ctor)
  local c = {} --生成器
  c.__index = c  --对象要从类索引方法等
  c._ctor = _ctor --保留构造函数
  
  setmetatable(c, {__call = function(class_tbl, ...)
    local obj = {} --新的对象
    setmetatable(obj,c)
    
    if c._ctor then
      c._ctor(obj,...)
    end
    return obj
  end})
  return c
end

return Class