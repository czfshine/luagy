require"lfs"

local tmp = "/tmp"
local sep = "\\"
local upper = ".."
--print (lfs._VERSION)

--function callback(dir,filename,suff,type)
--type:0 file,1 dir
function attrdir (path,callback)
	for file in lfs.dir(path) do
		if file ~= "." and file ~= ".." then
			local s=string.gfind(file,"%.(%w+)")

			if s then s=s() end

			local f = path..sep..file

			local attr = lfs.attributes (f)
			assert (type(attr) == "table")
			if attr.mode == "directory" then

					callback(f,file,s,1)
					attrdir(f,print)
			else
					callback(f,file,s,0)
			end
		end
	end
end

--test
--attrdir("..",print)

