local M = {}

function M.create(filename, defaultData)
	local filesave = setmetatable({
		file = sys.get_save_file('defold-2d-template', filename),
		data = nil,
	}, {
		__index = M,
	})

	if defaultData then
		filesave.data = filesave:load()
		
		for k,v in pairs(defaultData) do
			if not filesave.data[k] then
				filesave.data[k] = v
			end
		end
	end

	return filesave
end

function M.exists(self)
	return sys.exists(self.file)
end

function M.load(self, force)	
	if self.data == nil or force then	
		self.data = self:exists() and sys.load(self.file) or {}
	end
	
	return self.data
end

function M.save(self, data, erase)
	if erase then
		self.data = data
	else
		self.data = self:load()
		for k,v in pairs(data) do self.data[k] = v end
	end

	sys.save(self.file, self.data)
end

return M;