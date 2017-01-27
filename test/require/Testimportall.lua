
--some thing to fix the loadTest.lua
--
if importall then 
  importall=package.loaded["importall"];
else
  
require "require.importall"
end
--



Testimportall={}

function Testimportall:Testmatch()
  luaunit.assertEquals(importall.isLUA("llll.lua"),true)
  luaunit.assertEquals(importall.isLUA("llll.lu"),false)
  luaunit.assertEquals(importall.isLUA("llll.llua"),false)
end

function Testimportall:Testrequire()
  local status,err=importall.requirelua("./file/attrdir.lua")
  
  importall.requirelua("./file/attrdir.lua")
  luaunit.assertIsFunction(attrdir)
  luaunit.assertEquals(status,true)
  
  local status,err=importall.requirelua("./file/attrdir233333.lua")
  luaunit.assertEquals(status,false)
end


function Testimportall:Testmainfunction()
  importall.importall("./print")
  luaunit.assertIsFunction(ptt)
  luaunit.assertIsFunction(pt)
 end
 