
local require=require;
local loadfile=loadfile;
local print=print;
module( "importall");

local attrdir=require "file.attrdir"
function isLUA(path)
  if path:sub(-4,-1) ==".lua" then 
    return true;
  end
  return false;
end

function requirelua(path)
  --[[TODO
  path=path:sub(3,-1)
  path=path:sub(1,-5)
  path=path:gsub("/",".")
  require(path)]]
  local statu,err=loadfile(path)
  if statu==nil then 
    return false,err
  else
    statu();
    return true;
  end
  
end

function importer(path)
  if(isLUA(path)) then 
    requirelua(path)
  end
end
  
function importall(path)
  attrdir(path,importer)
end

return importall