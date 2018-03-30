package.path=package.path..";./luagy/?.lua"
Class=require "grammar.class"
Input=require "repl.input"
Prompt=require "repl.prompt"
Command=require "repl.command"

config={
  test={
    long={"*print","+dev","?none"},
    short={
      p={"pages"},
      r={}
    },
    other={
      "filename..."
    }
  }
}
REPL=Class(function (self,config)
    self.input=Input()
    self.pt= Prompt()
    
    self.config=config or {}
  end)

function REPL:listen()
  self.res=self.input.readl()
end

function REPL:run()
	while 1 do
		self.pt:print()
		self:listen()
		if self.res then
			local cmd=Command(self.res,self.config)
      cmd:printarg()
      local e,msg=cmd:doit() 
      if not e then 
        print(msg)
      end
        
		end
	end
end

function REPL:build(...)
  local arg={...}
  for i=1,#arg do
    if(type(arg[i])=="function" )then 
      fn=arg[i]
      break
    end
  end
  
  for i=1,#arg do
    if(type(arg[i])=="string" )then 
      command=arg[i]
      if(not self.config[commmand])then
        self.config[command]=fn
      else
      end
    end
  end
end

function REPL:setpt(t)
  if(type(t)=="function") then 
    self.pt:setptfn(t)
  elseif(type(t)=="string" )then
    self.pt.fn=nil
    self.pt=t
  end
end

return REPL
