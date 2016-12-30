Class=require "grammar.class"

Inputer=Class(function(self)
    
  end)


function Inputer:checkgetch()
	if io.getch or getch or self.getch then
		return true;
	else
		return false;
	end
end

function Inputer:readc()
	io.read(1)
end

function Inputer:read_cl()
	if(self:checkgetch()) then
		return string.char(io.getch())
	else
		return false,"can't find getch function "
	end
end
function Inputer:readl()
	return io.read("*l")
end

return Inputer