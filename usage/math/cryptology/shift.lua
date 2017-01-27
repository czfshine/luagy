local str="ofyu mfwfm:qjofusff.iunm"

for i=-64,64 do 
  str:gsub(".",function(s)
      --print(s)
      io.write(s.char(s:byte()+i<0 and 0 or s:byte()+i ))
    end)
  print()
end
  