function printf ( ... )
	return io.stdout:write ( string.format ( ... ) )
end 

function enum( tbl )
	local ret = {}
	for i,v in ipairs(tbl) do
		ret[v] = i
		i = i + 1
	end
	
	-- modify metatable below
	setmetatable( ret, ret )    -- 自己就是自己的 metatable
	ret.safeindex = function(t, k)    -- 定义一个 assert 版的 __index
		t.__index = nil
		local tmp = t[k]
		t.__index = t.safeindex
		assert( tmp )
		return tmp
	end
	ret.__index = ret.safeindex    -- 将默认的 __index 替换成 assert 版的 __index
	-- 结束修改 metatable
	return ret
end
