luaunit=require('luaunit.luaunit')
importall=require("require.importall")
importall("./test")

os.exit(luaunit.LuaUnit.run("-v"))