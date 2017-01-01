Class=require "grammar.class"

Command=Class(function (self,commandstr,config)
    self.str=commandstr;
    self.config=config
    self:gettable();
  end)
function Command:doit()
  local cmd=self.t[1]
  if(self.config[cmd]) then
    return true,self.config[cmd](self.t)
  else
    return false,"command \""..cmd.."\" can't find"
  end
end
--[[

the commands like:
  commands -abc -p 1 -l 5 9 -o test.out --notprint --dir=./src/ filename1 filename2 
  
  cmdname          shortop                    long op                other arg
                      |                          |                        |
        -------------------------     ------------------------   -----------------------
        /             |         \       /                \       
       /              |          \     /                  \
without arg         a arg   some arg  without          a pram

then the arg table like this:
  t={"commands","-abc","-p","1","-l","5","9","-o","test.out","--notprint","--dir=./src/","filename","filename",
      a=true,b=true,c=true,
      p={"1"},
      l={"5","9"},
      o={"test.out"}
      notprint=true,
      dir="./src/",
      other={
        "filename1",
        "filename2"
      }
    }
        
]]

function Command:gettable()
  self.t={}
  local t=self.t
  self.str:gsub("([^ ]+)",function (w)table.insert(t,w) end)
  local argn=#t
  t.long={}
  t.short={}
  t.other={}
  i=2
  while i<=argn do
    print(i)
    if(k~=1) then
      if(t[i]:sub(1,1)=="-") then
        if(t[i]:sub(2,2)=="-") then
          table.insert(t.long,t[i])
        else
          table.insert(t.short,t[i])
          string.gsub(t[i],"(.)",function (s)
              t.short[s]={} 
              while i<argn and t[i+1]:sub(1,1)~="-" do 
                table.insert(t.short[s],t[i+1])
                i=i+1
                print(i)
              end
            end)
        end
      else
        table.insert(t.other,t[i])
      end
      i=i+1
    end
  end
end
function Command:printarg()
	io.write("The argv is :\n")
	io.write("\tcomand name:",self.t[1] or "nil","\n")
  io.write("\tlong op are:\n")
  for k,v in ipairs(self.t.long) do
      io.write("\t\t",v,"\n")
  end
  
  io.write("\tshort op are:\n")
  for k,v in ipairs(self.t.short) do
      io.write("\t\t",v,"\n")
  end
  io.write("\tother op are:\n")
  for k,v in ipairs(self.t.other) do
      io.write("\t\t",v,"\n")
  end
end

return Command