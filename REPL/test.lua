package.path=package.path..";./code/luagy/?.lua;./luagy/?.lua"
REPL=require "repl.repl"
r=REPL()
HandleClassInstanceTracking()
r:run()
