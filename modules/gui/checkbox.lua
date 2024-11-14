local M = {};

local border = hash('border')
local fill = hash('fill')

local function toggle(m)
	if m.color == nil then
		m.color = gui.get_color(m.box)
	end

	if m.sound then
		sound.play(m.sound, {gain = SETTINGS:load()['sound']})
	end

	gui.play_flipbook(m.box, m.value and fill or border)
end

function M.onInput(self, actionId, action)
	if actionId == hash("touch") and action.pressed then
		if gui.pick_node(self.node, action.x, action.y) then
			self:setValue(not self.value)
			if self.onChange then
				self.onChange()
			end
		end
	end

end

function M.create(node, boxNodeName, containerNodeName)
	local btn = setmetatable({
		node = gui.get_node(hash(node .. '/' .. (containerNodeName or 'container'))),
		box = gui.get_node(hash(node .. '/' .. (boxNodeName or 'box'))),
		color = nil,
		onChange = nil,
		value = false,
	}, {
		__index = M,
	})

	return btn;
end

function M.setOnChange(self, onChange)
	self.onChange = onChange

	return self;
end

function M.setValue(self, value)
	self.value = not (not value)
	toggle(self, value)

	return self;
end

function M.getValue(self, value)
	return self.value
end

function M.setSound(self, sound)
	self.sound = sound

	return self;
end

return M;