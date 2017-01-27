Lust=require "string.lust.lust"


--==========================================
--用$表示值

-- $. 选择当前参数
Lust([[$.]]):gen("hello") -->hello

-- $1 selects item from environment-as-array:
Lust([[$1 $2]]):gen{ "hello", "world" } -->hello world

-- $foo selects item from environment-as-dictionary:
Lust[[$foo $bar]]:gen{ foo="hello", bar="world" } -->hello world

-- $< > can be used to avoid ambiguity:
Lust[[$<1>2 $<foo>bar]]:gen{ "hello", foo="world" } -- res: "hello2 worldbar"

-- selections can be constructed as paths into the environment:
Lust[[$a.b.c $1.1.1]]:gen{ a={ b={ c="hello" } }, { { "world" } } } -- res: "hello world"

Lust[[$a.1 $1.b]]:gen{ a={ "hello" }, { b="world" } } -- res: "hello world"
-- the # symbol prints the length of an environment selection:

Lust[[$#.]]:gen{ 1, 2, 3 } -- res: "3"

Lust[[$#foo.bar]]:gen{ foo={ bar={ 1, 2, 3 } } } -- res: "3"

-- selections can be resolved dynamically using (x):
Lust[[$(x)]]:gen{ x="foo", foo="hello" } -- res: "hello"

Lust[[$(x.y).1]]:gen{ x={ y="foo" }, foo={"hello"} } -- res: "hello"

--=============================================================



















-- the @name invokes a statically named sub-template:
local temp = Lust[[@child]]
-- define a subtemplate:
temp.child = "$1 to child"
temp:gen{"hello"} -- res: "hello to child"
-- subtemplates can also be specified in the constructor-table:
Lust{
    [[@child]],
    child = "$1 to child",
}:gen{"hello"}  -- res: "hello to child"
-- subtemplate invocations can use < > to avoid ambiguity:
Lust{
    [[@<child>hood]],
    child = "$1 to child",
}:gen{"hello"} -- res: "hello to childhood"
-- subtemplates with subtemplates:
Lust{
    [[@child, @child.grandchild]],
    child = {
        "$1 to child",
        grandchild = "$1 to grandchild",
    },
}:gen{"hello"} -- res: "hello to child, hello to grandchild"
-- subtemplates with subtemplates (alternative naming):
Lust{
    [[@child, @child.grandchild]],
    child = "$1 to child",
    ["child.grandchild"] = "$1 to grandchild",
}:gen{"hello"} -- res: "hello to child, hello to grandchild"
-- subtemplate names can also be resolved dynamically, according to model values, using (x):
Lust{
    [[@(x), @(y)]],
    child1 = "hello world",
    child2 = "hi"
}:gen{ x="child1", y="child2" } -- res: "hello world, hi"
-- the environment passed to a subtemplate can be specifed as a child of the current environment:
Lust{
    [[@1:child @two:child]],
    child = [[$. child]],
}:gen{ "one", two="two" } -- res: "one child two child"
-- the symbol . can be used to explicitly refer to the current environment:
Lust{
    [[@child == @.:child]],
    child = [[$1 child]],
}:gen{ "hello" } -- res: "hello child == hello child"
-- subtemplate paths can mix static and dynamic terms:
Lust{[[@child.(x), @(y).grandchild, @(a.b)]], 
    child ="$1 to child",
    ["child.grandchild"] = "$1 to grandchild",
}:gen{ 
    x="grandchild", 
    y="child", 
    "hello", 
    a = { b="child" } 
} -- res: "hello to grandchild, hello to grandchild, hello to child"
-- child environments can be specified using multi-part paths:
Lust{
    [[@a.1.foo:child]],
    child = [[$. child]],
}:gen{ a={ { foo="hello" } } } -- res: "hello child"
-- subtemplates can be specified inline using @{{ }}:
Lust([[@foo.bar:{{$1 $2}}]]):gen{ foo={ bar={ "hello", "world" } } } -- res: "hello world"
-- environments can also be specified dynamically
-- the @{ } construction is similar to Lua table construction
Lust([[@{ ., greeting="hello" }:{{$greeting $1.place}}]]):gen{ place="world" } -- res: "hello world"
Lust([[@{ "hello", a.b.place }:{{$1 $2}}]]):gen{ a = { b = { place="world" } } } -- res: "hello world"
Lust([[@{ 1, place=a.b }:{{$1 $place.1}}]]):gen{ "hello", a = { b = { "world" } } } -- res: "hello world"
-- dynamic environments can contain arrays:
Lust([[@{ args=["hello", a.b] }:{{$args.1 $args.2.1}}]]):gen{ a = { b = { "world" } } } -- res: "hello world"
-- dynamic environments can contain subtemplate applications:
Lust{
    [[@{ .:child, a=x:child.grandchild }:{{$1, $a}}]],
    child = "$1 to child",
    ["child.grandchild"] = "$1 to grandchild",
}:gen{ "hi", x = { "hello" } } -- res: "hi to child, hello to grandchild"
-- dynamic environments can be nested:
Lust{
    [[@{ { "hello" }, foo={ bar="world" } }:sub]],
    sub = [[$1.1 $foo.bar]],
}:gen{} -- res: "hello world"

-- conditional templates have a conditional test followed by a template application
-- @if(x) tests for the existence of x in the model
local temp = Lust{
    [[@if(x)<greet>]],
    greet = "hello",
}
temp:gen{ x=1 }     -- res: "hello"
temp:gen{ }         -- res: ""
-- @if(?(x)) evaluates x in the model, and then checks if the result is a valid template name
-- this example also demonstrates using dynamically evalutated template application:
local temp = Lust{
    [[@if(?(op))<(op)>]],
    child = "I am a child",
}
temp:gen{ op="child" } -- res: "I am a child"
-- using else and inline templates:
local temp = Lust[[@if(x)<{{hello}}>else<{{bye bye}}>]]
temp:gen{ x=1 } -- res: "hello"
temp:gen{  }    -- res: "bye bye"
-- @if(#x > n) tests that the number of items in the model term 'x' is greater than n:
local temp = Lust[[@if(#. > "0")<{{at least one}}>]]
temp:gen{ "a" } -- res: "at least one")
temp:gen{  }    -- res: ""
-- compound conditions:
local temp = Lust[[@if(#x > "0" and #x < "5")<{{success}}>]]
temp:gen{ x={ "a", "b", "c", "d" } }        -- res: "success"
temp:gen{ x={ "a", "b", "c", "d", "e" } }   -- res: ""
temp:gen{ x={  } }                          -- res: ""
temp:gen{ }                                 -- res: ""
-- compound conditions:
local temp = Lust[[@if(x or not not not y)<{{success}}>else<{{fail}}>]]
temp:gen{ x=1 }         -- res: "success"
temp:gen{ x=1, y=1 }    -- res: "success"
temp:gen{ y=1 }         -- res: "fail"
temp:gen{ }             -- res: "success"
-- compound conditions:
local temp = Lust[[@if(n*"2"+"1" > #x)<{{success}}>else<{{fail}}>]]
temp:gen{ n=3, x = { "a", "b", "c" } }  -- res: "success"
temp:gen{ n=1, x = { "a", "b", "c" } }  -- res: "fail"



-- @map can iterate over arrays in the environment:
local temp = Lust[[@map{ n=numbers }:{{$n.name }}]]
temp:gen{
    numbers = {
        { name="one" },
        { name="two" },
        { name="three" },
    }
}
-- result: "one two three "
-- assigning mapped values a name in the environment
local temp = Lust[[@map{ n=numbers }:{{$n }}]]
temp:gen{
    numbers = { "one", "two", "three" }
}
-- result: "one two three "
-- the _separator field can be used to insert elements between items:
local temp = Lust[[@map{ n=numbers, _separator=", " }:{{$n.name}}]]
temp:gen{
    numbers = {
        { name="one" },
        { name="two" },
        { name="three" },
    }
}
-- result: "one, two, three"
-- _ can be used as a shorthand for _separator:
local temp = Lust[[@map{ n=numbers, _=", " }:{{$n.name}}]]
temp:gen{
    numbers = {
        { name="one" },
        { name="two" },
        { name="three" },
    }
}
-- result: "one, two, three"
-- a map can iterate over multiple arrays in parallel
local temp = Lust[[@map{ a=letters, n=numbers, _=", " }:{{$a $n.name}}]]
temp:gen{
    numbers = {
        { name="one" },
        { name="two" },
        { name="three" },
    },
    letters = {
        "a", "b", "c",
    }
}
-- res: "a one, b two, c three"
-- if parallel mapped items have different lengths, the longest is used:
local temp = Lust[[@map{ a=letters, n=numbers, _=", " }:{{$a $n.name}}]]
temp:gen{
    numbers = {
        { name="one" },
        { name="two" },
        { name="three" },
    },
    letters = {
        "a", "b", "c", "d",
    }
}
-- res: "a one, b two, c three, d "
-- if parallel mapped items are not arrays, they are repeated each time:
local temp = Lust[[@map{ a=letters, n=numbers, prefix="hello", count=#letters, _=", " }:{{$prefix $a $n.name of $count}}]]
temp:gen{
    numbers = {
        { name="one" },
        { name="two" },
        { name="three" },
    },
    letters = {
        "a", "b", "c", "d",
    }
}
-- res: "hello a one of 4, hello b two of 4, hello c three of 4, hello d  of 4"
-- the 'i1' and 'i0' fields are added automatically for one- and zero-based array indices:
local temp = Lust[[@map{ n=numbers }:{{$i0-$i1 $n.name }}]]
temp:gen{
    numbers = {
        { name="one" },
        { name="two" },
        { name="three" },
    }
}
-- res: "0-1 one 1-2 two 2-3 three "
-- if the map only contains an un-named array, each item of the array becomes the environment applied in each iteration:
local temp = Lust[["@map{ ., _separator='", "' }:{{$name}}"]]
temp:gen{
    { name="one" },
    { name="two" },
    { name="three" },
}
-- res: '"one", "two", "three"'

local temp = Lust[[@map{ numbers, count=#numbers, _separator=", " }:{{$name of $count}}]]
temp:gen{
    numbers = {
        { name="one" },
        { name="two" },
        { name="three" },
    }
}
-- res: "one of 3, two of 3, three of 3"
-- @rest is like @map, but starts from the 2nd item:
local temp = Lust[[@rest{ a=letters, n=numbers, _separator=", " }:{{$a $n.name}}]]
temp:gen{
    numbers = {
        { name="one" },
        { name="two" },
        { name="three" },
    },
    letters = {
        "a", "b", "c",
    }
}
-- res: "b two, c three"
-- @iter can be used for an explicit number of repetitions:
local temp = Lust[[@iter{ "3" }:{{repeat $i1 }}]]
temp:gen{} -- res: "repeat 1 repeat 2 repeat 3 "
-- again, _separator works:
local temp = Lust[[@iter{ "3", _separator=", " }:{{repeat $i1}}]]
temp:gen{} -- res: "repeat 1, repeat 2, repeat 3"
-- @iter can take an array item; it will use the length of that item:
local temp = Lust[[@iter{ numbers, _separator=", " }:{{repeat $i1}}]]
temp:gen{
    numbers = {
        { name="one" },
        { name="two" },
        { name="three" },
    }
}
-- res: "repeat 1, repeat 2, repeat 3"
-- @iter can take a range for start and end values:
Lust([[@iter{ ["2", "3"] }:{{repeat $i1 }}]]):gen{}
-- res: "repeat 2 repeat 3 "
local temp = Lust[[@iter{ ["2", numbers], _separator=", " }:{{repeat $i1}}]]
temp:gen{
    numbers = {
        { name="one" },
        { name="two" },
        { name="three" },
    }
}
-- res: "repeat 2, repeat 3"

-- helper function to un-escape \n and \t in Lua's long string
local function nl(str) return string.gsub(str, [[\n]], "\n"):gsub([[\t]], "\t") end

-- if a template application occurs after whitespace indentation, 
-- any generated newlines will repeat this indentation:
local temp = Lust{nl[[
    @iter{ "3", _separator="\n" }:child]],
    child = [[line $i1]],
}
--[=[ res: [[
    line 1
    line 2
    line 3]]
--]=]



-- a handler can be registered for a named template
-- the handler allows a run-time modification of the environment:
local temp = Lust{
    [[@child]],
    child = [[$1]],
}
local model = { "foo" }
local function double_env(env)
    -- create a new env:
    local ee = env[1] .. env[1]
    return { ee }
end
temp:register("child", double_env)
-- res: "foofoo"