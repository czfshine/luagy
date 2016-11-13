<<<<<<< HEAD
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
=======

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
>>>>>>> 9740ece6e2dd0f39d899ce9c2d3816298c36a1c9
			end
		end
	end
end

<<<<<<< HEAD
--test
--attrdir("..",print)
=======

return  attrdir
>>>>>>> 9740ece6e2dd0f39d899ce9c2d3816298c36a1c9

