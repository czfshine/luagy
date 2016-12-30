Class=require "grammar.class"
Input=require "repl.input"
Prompt=require "repl.prompt"
Command=require "repl.command"


REPL=Class(function (self)
    self.input=Input()
    self.pt= Prompt()
  end)

function REPL:listen()
  self.res=self.input.readl()
end

function REPL:run()
	while 1 do
		self.pt:print()
		self:listen()
		if self.res then
			local cmd=Command(self.res)
      cmd:printarg()
		end
	end
end

r=REPL()
r:run()
