--lua 快速入门与完整语法
--====================================
-->注：假定读者已经学会其他的某一种语言（c/c++/java/python等）
-->内容由浅及深，一开始不会过分的苛求细节，
-->只把lua中常用的语法与其他语言进行关联,方便新手理解.
-->随后将渐渐加深，会把前面跳过的一些细节补齐，同时还有一些注意事项

--# 0.注释
--以 `--` 开头的是注释
-- `--[[......]]` 是多行注释

--# 1.变量类型
--## 1.1 基本类型与语句
a=1;
--变量不需要声明就可以直接使用
--变量类型根据右值决定
--语句末的分号可以省略，如：
b=2

--基本类型有
a=1     --数字
a="abc" --字符串
a=true --布尔值
--没了=_=!
--不像c一样是强类型的，lua中一个变量可以在不同类型之间转换（就像上面）

--## 1.2复合类型
--### 数组

--这样定义一个数组
array={1,2,3,4,5,7,8};
--lua的数组长度是不固定的，所以不用说明长度


--可以通过下标来索引
print(array[1]); --> 1
print(array[2]); --> 2
print(array[7]); --> 8
print(array[9]); -->nil

--发现没有，lua是以1作为数组的起点的！！！！！！！
--nil 代表空，也就是什么都没有（也是一种类型）
-- print函数把表达式的值输出
-- `-->` 符号在注释中表示当前语句输出的值（它是注释！！！以--开头的都是注释）

--### 关联数组
--这样定义一个关联数组
map={}

map["abc"]=1 --给元素赋值
map["bcd"]=2 
--相当于c++中的map<string,int>

--然后取值可以这样
print(map["abc"]) --> 1
print(map["blabla"]) -->nil

--上面说过，lua变量的类型不是强制规定的
--所以可以这样

map["aaa"]=1     --以字符串做键，数字做值
map["bbb"]="ccc" --以字符串做键，字符串做值
map[1]="gg"      --以数字做键，字符串做值

--当然还可以用其他的所有类型（除了nil）做键或者值
--给一个键赋值nil相当于清空

--既然这样，数组也可以有不同的元素类型（混合数组）
array={"gg",2,66,true}

--取值可以这样
print(array[1]) --> gg

--同理对于使用数字当键的关联数组也可以这样取值
print(map[1])   -->gg

--发现没有，数组和关联数组取值方式是一样的，难道他们是同一种类型？

--恭喜你，答对了=_=!
--数组和关联数组在lua里都是用table表示，
--它同时也是Lua里最基本的、最常用的、几乎唯一的、几乎万能的数据结构。

--所以可以这样定义
table={1,2,5,4,5,8,5,5} --数组部分
table["llll"]=123456    --在lua里用hash表实现，所以也叫哈希部分

--lua有个语法糖，如果以字符串做键，在索引时可以不用加双引号，直接在前面加点，就像这样
print(table.llll) -->123456
--和c中的结构体取成员一样

--所以，对于以字符串做键的部分，可以这样定义
table={
  abc=1,
  llll=2,
  exit=0
}
--显而易见，值也可以是table，这样就有了table的嵌套
t1={
  a={
    b=1},
  c=2
}
print(t1.a) -->table:0x0ac56c78  (后面是table对象在内存中的地址）
print(t1.a.b) -->1
print(t1.c) -->2

--# 2. 语句
--## 2.1 语句块

--在lua里 do ... end 就相当于c中的 {...}
--可把多条语句结合成一个block，在这个block里有独立的局部变量
x=1
do
  local x=x+1    -->第一个x是局部变量，第二个是全局变量
  print(x) -->2
end
print(x)  -->1

--##2.2循环
i=0             -- int i=0;
while(i<5) do   -- while(i<5){
  print(i)      --  printf("%d",i);
  i=i+1         --  i++;
end             -- }

--基本和c一样，不过{}用do end 代替，不能直接写i++（不支持）

--while do 中间的括号可以省略
--因为while ... do 中间的... 可以是表达式就行，所以表达式加上括号也还是表达式:)
while i>0 do    -- while(i<5){
  print(i)      --  printf("%d",i);
  i=i-1         --  i++;
end

--for 循环 ：
--写法 for val=start,end,step do  bodycode end 
--变量 val 从 start 以步进step 累加到 end 为止，运行bodycode
for i=1,10,2 do 
  print(i)
end
--for循环还有另外一个用法，以后讲函数高阶时再说

--lua中还有repeat ... until ... 的用法，相当于c中的do{}while() ，（我不常用）
i=0
repeat
  print(i)
  i=i+1
until i>5

--## 2.3分支
--和c一样有if

if(i<1) then   -- if(i<1){
  print("yes") --   printf("yes");
else           -- }else{
  print("no")  --   printf("no");
end            -- }

--if的嵌套
if(i<1) then   
  print("yes") 
elseif i==1 then --括号可以不用，是elseif不是else if(后者是两个if语句所以要两个end，前者只要一个)     
  print("no") 
else
  print("wtf?")
end  

--## 2.4函数

--定义函数要用function关键字

function print_add_1(x)
  print(x+1)
end
print_add_1(x+1)

--lua的函数可以有多个返回值
function swap(x,y)
  return y,x
end

print(swap(1,2))  --> 2    1
--同时赋值语句可以有多个左值和右值
a,b=1,2
a,b = swap(a,b)  -->a=2,b=1
--其实交换两个变量可以直接这样写
a,b=b,a

--数量不同的情况
a     = 1,2   -->a=1   2被舍弃
a,b   = 1,2   -->a=1,b=2
a,b,c = 1,2   -->a=1,b=2,c=nil

--变量组截断：
-- 当某个函数的返回值当做另一个函数的实参时，根据不同情况被截断
function r2()
  return 21,22
end

function r3()
  return 31,32,33
end

function n3(a,b,c)
  print("get args:",a,b,c)
end
n3(r2(),1)    -->21 1 nil    在参数表后面还有参数时，只截取第一个
n3(r2(),1,2)  -->21 1 2
n3(r2(),r3()) -->21 31 32    
n3(1,r3())    -->1 31 32     在参数表前面有参数时，截取到需要参数的个数
n3(1,2,r3())  -->1 2 31

--函数是一等公民，所以你可以这样：
function fn() --一个函数
    print("fn")
end

fn1=fn     --函数可以当做值进行赋值（相当于c的函数指针，不过没有强制规定类型）
fn1() -->fn

--可以这样：
function fn2(f)
  f()
end
fn2(fn)     --函数可以直接当做参数（也像指针）

--还可以这样：
fn2(function ()         --直接定义佚名函数当做参数
    print("fn in line")
  end)

--随你想怎么玩都行
fn3=function ()   --把佚名函数赋值也行
  print("fn3")
end
fn3()

t={}
t[fn]=1
print(t[fn])  --说过的，键值可以是任意类型（除了nil）

--不定参数
--有时函数的参数不确定（比如求最大值）
--可以在定义时用... 代替不定参数

function max(...)
  local arg={...} --在lua5.2以上需要这一句（好像？）
  local m=arg[1] --代表第一个参数
  for i=1,#arg do --#取数组长度
    if arg[i]> m then
        m=arg[i] 
    end
  end
  return m
end

print(max(5,2,8,5,4,5,9,5))

--与其他参数混用
function printf(f,...)
  print(string.format(f,...)) --别管它是怎么实现的 =_=
end

printf("I am %s ,I am %d year old.","czfshine",18)

--可是不能这样，lua没那么智能=_=
--`function printf(...,f)`
--`end`

--TODO:
