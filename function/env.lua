function p_index(t,k)
  print("index:",k,t.__cont[k])
  if t.__cont[k]~=nil then 
    return t.__cont[k] 
  else
    return _G[k]
  end
end

function p_newindex(t,k,v)
  print("newindex",k,v)
  t.__cont[k]=v
end


mt={__index=p_index,__newindex=p_newindex}
env={__cont={}}
setmetatable(env,mt)

function fn(x,y)
  local a=1
  b=2
  b=c
  d=x
  e=b
  print(y)
end

setfenv(fn,env)

fn(1,2)

