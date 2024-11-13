local M = {}

local filesave = require('modules.filesave')

function M.init(self)
	self.file = filesave.create('settings', {
		-- defaults
		
		sound = 0.5,
		resolution = '1280 x 720',
	})
end

function M.save(self, data)
	return self.file:save(data)
end

function M.load(self)
	return self.file:load()
end

M:init()

return M