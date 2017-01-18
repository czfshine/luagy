package.path=package.path..";./code/luagy/?.lua;./luagy/?.lua"
local Class=require("grammar.class_min")

baseclass=Class(function (self,x) --构造函数
    self.x2=x
    print ("baseclass init ")
    self:fn(x)
  end
)

baseclass.level=1 --属性
function baseclass:fn(x) --方法
  print("call baseclass fn")
  self.x=x
end

baseobj1=baseclass(1) --新建对象
baseobj2=baseclass(2)

print(baseobj1.x,baseobj2.x)
baseobj2:fn(3)
print(baseobj1.x,baseobj2.x) 

baseobj1.level=3

print(baseclass.level,baseobj2.level,baseobj1.level)

childclass1=Class(baseclass,function (self,y)
    self.y=y
end)

co1=childclass1(3)
co1:fn(2)

print(co1.x,co1.y,co1.level)




--==test
local t=os.clock()
local classs={}
local obj={}
classs[0]=Class(function(self,x)
    self.x=x
  end)
local fn=function (self,y)
      self.y=y
    end
for i=1,10000 do
  classs[i]=Class(classs[i-1],fn)
  --obj[i]=classs[i](1)
end

for k,v in pairs(classs) do
  print(k,v)
end

print(os.clock()-t)
