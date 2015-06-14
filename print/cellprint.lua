function bool210(status)
    return status and 1 or 0
end

function cellprint(cell,rowmax,colmax,fn)
  for row=1 ,rowmax do 
    for col=1,colmax do 
      io.write(fn(cell[row][col]))
    end
    io.write("\n")
  end
end

  