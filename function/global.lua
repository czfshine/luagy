x=1
function fn(c)
  x()
end

pcall(fn,5)
print(x)