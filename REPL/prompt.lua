Class=require "grammar.class"

Prompt=Class(function (self)
  self.pt=">"
  
  end)
function Prompt:setptfn(fn)
  self.fn=fn;
end

  
function Prompt:getpt()
  if(self.fn) then
    return self.fn()
  else
    return self.pt;
  end
end

function Prompt:print()
  io.write(self:getpt())
end
return Prompt