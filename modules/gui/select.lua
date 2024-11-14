local M = {};

local function getPreviousValue(m)
	local prev = nil
	for _, elem in pairs(m.options) do
		if elem == m.value and prev ~= nil then
			return prev
		else
			prev = elem
		end
	end

	-- если прошли до конца и не нашли предыдущий элемент, значит текущий элемент - первый, возвращаем последний
	return prev
end

local function getNextValue(m)
	local prev = nil
	local first = nil
	for _, elem in pairs(m.options) do
		if first == nil then
			first = elem
		end
		
		if prev == m.value then
			return elem
		else
			prev = elem
		end
	end

	-- если прошли до конца и не нашли следущий элемент, значит текущий элемент - последний, возвращаем первый
	return first
end

function M.onInput(self, actionId, action)
	if actionId == hash("touch") and action.pressed then
		if gui.pick_node(self.prev, action.x, action.y) then
			if self.sound then
				sound.play(self.sound, {gain = SETTINGS:load()['sound']})
			end
			self:setValue(getPreviousValue(self))
		elseif gui.pick_node(self.next, action.x, action.y) then
			if self.sound then
				sound.play(self.sound, {gain = SETTINGS:load()['sound']})
			end
			self:setValue(getNextValue(self))
		end
	end
end

function M.create(node, options, textNodeName, prevNodeName, nextNodeName)
	local sld = setmetatable({
		text = gui.get_node(hash(node .. '/' .. (textNodeName or 'text'))),
		prev = gui.get_node(hash(node .. '/' .. (prevNodeName or 'prevButton'))),
		next = gui.get_node(hash(node .. '/' .. (nextNodeName or 'nextButton'))),
		onChange = nil,
		value = nil,
		options = options,
	}, {
		__index = M,
	})

	return sld;
end

function M.setOnChange(self, onChange)
	self.onChange = onChange

	return self;
end

function M.setValue(self, value, silently)
	for _, elem in pairs(self.options) do
		if elem == value then
			self.value = value
			gui.set_text(self.text, value)

			if not silently and self.onChange then self:onChange() end

			return self
		end
	end

	return self
end

function M.getValue(self)
	return self.value;
end

function M.setSound(self, sound)
	self.sound = sound

	return self;
end

return M;