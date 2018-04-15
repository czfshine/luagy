function table.len(t)
    if type(t) ~= "table" then
        return -1
    end
    len=0
    for k,v in pairs(t) do
        len=len+1
    end
    return len
end