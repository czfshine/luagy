-- 打印table

-- 打印一层
local function print_table(t,fn)
  local fn =fn or print
  if type(t) =="table" then
    for k,v in pairs(t) do
      fn(k,v)
    end
  else
    print("Isn't table:",t)
  end
end

--迭代打印所有层次的table
ptt=function (t,fn,k,m)
  local k=k or ""
  local fn =fn or print
  if m then
  print("_-------"..k.."------_")
  end
  print_table(t,function (k,v)
      if type(v) =="table" then
        ptt(v,fn,k)
      else
        fn(k,v,t)
      end
    end)
  end


--缩写
pt=print_table
