Class=require "grammar.class"

Command=Class(function (self,commandstr)
    self.str=commandstr;
    self:gettable();
  end)

function Command:gettable()
  self.t={}
  self.str:gsub("([^ ]+)",function (w)table.insert(self.t,w) end)
  for k,v in ipairs(self.t) do
    if(k~=1) then
      if(v:sub(1,1)=="-") then
        if(v:sub(2,2)=="-") then
          --islong(t,sub)
        else
          --isshort(t,sub)
        end
      else
       -- isother(t,sub)
      end
    end
  end
end
function Command:printarg()
	io.write("The argv is :\n")
	io.write("\tcomand name:",self.t[1] or "nil","\n")
end

return Command