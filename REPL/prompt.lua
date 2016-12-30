Class=require "grammar.class"

Prompt=Class(function (self)
  self.pt=">"
  
  end)


function Prompt:print()
  io.write(self.pt)
end
return Prompt