infilename="lua_use.lua"
outfile=io.open("lua_use.md","w")
infile=io.open(infilename,"r")
LOCAL =0
function write(...)
    if LOCAL~=0 then
        io.write(...)
    else
        outfile:write(...)
    end
end

inlua=0
for line in infile:lines() do
    if line:sub(1,2)=="--" then 
        if inlua~=0 then 
            inlua =0
            write("```\n") 
        end
        if line:sub(3,3)==">" then 
            write(line:sub(3,-1).."\n")
        else
            write(line:sub(3,-1).."\n\n")
        end

    else 
        if inlua==0 then 
            if #line~=0 then
                write("```lua\n")
                inlua=1
            end
        end
        write(line.."\n")
    end
end
