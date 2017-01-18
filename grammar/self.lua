t={}
function t:fn(x)
  self.x=x
end

t:fn(1)
t.fn(t,1)