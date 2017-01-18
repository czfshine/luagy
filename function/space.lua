x=0
function new(x)
  --local x=1
  return function ()
    --local x=2
    print(x)
  end
end
fn=new(3)
fn2=new(8)
fn(4)
fn2(2)
fn2(2)
