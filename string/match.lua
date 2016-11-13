
match={

 has=function (pattern,str,fn)
	_,n=str:gsub(pattern,fn)
	return  n>0 and true or false
end}


return match

