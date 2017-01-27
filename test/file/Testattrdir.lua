attrdir=require "file.attrdir"

Testattrdir = {}
local data={}

function Testattrdir:testCount()
  attrdir("./test/file/", function (t) table.insert(data,t) end)
  local count=#data;
  luaunit.assertEquals(count,1)
end
