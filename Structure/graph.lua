--Graph (abstract data type)

--def G(P,L)
--~ P: a set of finite points
--~ L: some edges or lines

-- def P{id[int or str]-> p,...}
-- def p{some data}
-- def L{ (id1<->id2,type,power, {other(...)}) }

package.path=package.path..";..\\?.lua;"
require "grammar.class"

local Graph=Class(function (self,...)

	self.P={}
	self.L={}


end)

-- some  base operations
function Graph:add_vertex (id,v)
	self.P[id]=v
end

function Graph:add_edge( id1 ,id2,power,...)

if not self.L[id1] then
self.L[id1]={}
end

if not self.L[id2] then
self.L[id2]={}
end

self.L[id1][id2]={type=0,power=power,...}
if not id1 == id2 then
self.L[id2][id1]={type=1,power=power,...}
end
end

function Graph:adjacent(id1,id2)
if self.L[id1] and self.L[id2] then
return (self.L[id1][id2] or self.L[id2][id1]) and true
else
return false
end
end

function Graph:neighbors (id)
return self.L[id]
end

function Graph:remove_vertex (id)
for k,v in ipairs(self:neighbors(id)) do
print(k,v)
end

for k,v in pairs(self:neighbors(id)) do
print(k,v)
--self.L[k][id]=nil
end

self.L[id]=nil

self.P[id]=nil

end

function Graph:remove_edge (id1, id2)

self.L[id1][id2]=nil
self.L[id2][id1]=nil

end

function Graph:get_vertex_value (id)
return self.P[id]
end

function Graph:set_vertex_value (id ,v)
self.P[id]=v
end

function Graph:get_edge_value (id1 ,id2)
return self.L[id1][id2]
end

function Graph:set_edge_value (x ,y ,v)
--todo
end

-- some visable
function Graph:print()
print(" ---------points :---------")
for k,v in pairs (self.P) do
print(k,v)
end
print("----------lines:-----------")
for k,v in pairs (self.L) do
	for i,j in pairs(v) do
		if j.type ==0 then
			print(k.."<-->"..i)
		end
	end
end

end





--[[
print("test")
G=Graph()

G:add_vertex(1,"a")
G:add_vertex(2,"b")
G:add_vertex(3,"c")
G:add_vertex(4,"d")

G:add_edge(1,2)
G:add_edge(3,2)
G:add_edge(4,2)
G:add_edge(1,1)
print( G:adjacent(1,2),G:adjacent(2,2))
--G:print()
G:remove_vertex (2)
G:print()
print( G:adjacent(1,2),G:adjacent(1,2))]]

return Graph

