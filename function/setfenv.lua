env={}
env.x=1
function fn(y)
  x=y
end
setfenv(fn,env)
fn(2)

print(env.x)