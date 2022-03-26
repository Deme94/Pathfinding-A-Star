local List = {}

-- Create a Table with list functions
function List:New()

  -- list table
  local t = {}
  -- entry table
  t._et = {}
  
  -- Get the value at index from the list
  function t:Get(index)
	return self._et[index]
  end
  
  -- Set a value at index on to the list
  function t:Set(index, value)
	table.insert(self._et, index, value)
  end

  -- Add a value on to the List
  function t:Add(...)
    if ... then
      local targs = {...}
      -- add values
      for _,v in ipairs(targs) do
        table.insert(self._et, v)
      end
    end
  end

  -- Remove index from the List
  function t:RemoveIndex(index)
	if t:Size() ~= 0 then
		table.remove(self._et, index)
	end
  end
  
  -- Remove value from the List
  function t:RemoveValue(value)
	if t:Size() ~= 0 then
		for i, v in t:Iterator() do
			if v == value then
				table.remove(self._et, i)
				break
			end
		end
	end
  end
  
  -- Return true if List contains value, otherwise return false
  function t:Contains(value)
	for _, v in t:Iterator() do
		if v == value then
			return true
		end
	end
	return false
  end
  
  -- Return (index, value) pairs from the List
  function t:Iterator()
	return ipairs(self._et)
  end
  
  -- clear List
  function t:Clear()
    for i=1,t:Size() do
      self:RemoveIndex(i)
    end
  end

  -- get entries
  function t:Size()
    return #self._et
  end
  
  return t
end

return List
