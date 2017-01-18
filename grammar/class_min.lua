local function Class(base, _ctor)
  local c = {} --生成器
   
  if not _ctor and type(base) == 'function' then
    --基类
    _ctor = base
    base = nil
    
  elseif type(base) == 'table' then
  
    --复制父类的方法
    for i,v in pairs(base) do
      c[i] = v
    end
    
    c._base = base
  end 
  
  
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