
require"lfs"
local tmp = "/tmp"
--A function to iterine all file in a directory.
require"lfs"

local sep = "/"
local upper = ".."

function attrdir (path,fn)
  -- function fn(filename,filepath)
	for file in lfs.dir(path) do
		if file ~= "." and file ~= ".." then
			local p = path..sep..file
			local attr = lfs.attributes (p)
			assert (type(attr) == "table")
			if attr.mode == "directory" then
				attrdir (p,fn)
			else --is file
        fn(file,p)
			end
		end
	end
end


return  attrdir

