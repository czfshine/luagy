package.path=package.path..";./code/luagy/?.lua;./luagy/?.lua"
REPL=require "repl.repl"

config={
    test={
      long={"*print","+dev","?none"},
      short={
        p={"pages"},
        r={}
      },
      other={
        "filename..."
      },
      fn=function ( ... )
          print(...)
      end
    }
  }
r=REPL(config)
HandleClassInstanceTracking()
r:run()
