local M = {}

local filesave = require('modules.filesave')

function M.init(self)
	self.file = filesave.create('settings', {
		-- defaults
		
		sound = 0.5,
		music = 0.7,
		resolution = '1280 x 720',
		fullScreen = false,
	})
end

function M.save(self, data)
	return self.file:save(data)
end

function M.load(self)
	return self.file:load()
end

function M.apply(self, data)
	if data ~= nil then
		self:save(data)
	end
	
	local settings = self:load()

	defos.set_borderless(true)
	defos.set_fullscreen(settings['fullScreen'])

	local size = {}
	for i in string.gmatch(settings['resolution'], "%d+") do
		table.insert(size, i)
	end
	defos.set_window_size(nil, nil, size[1], size[2])
end

M:init()

return M