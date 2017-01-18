Class =require"luagy.grammar.class"

A=Class(function(self,x,y)
    self.a=1;
    self.b=x+y;
    self:init();
    self:fn()
  end)
function A:init()
  self.c=self.a+self+b;
end

function A:fn()
  self.c=0;
end

return A;