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
	if
		actionId == hash("touch")
		and action.pressed
		and not gui.pick_node(self.text, action.x, action.y)
		and gui.pick_node(self.texture, action.x, action.y)
	then
		local pos = gui.get_screen_position(self.texture);

		-- не будет работать если у self.texture pivot не будет центром
		if action.x < pos.x then
			self:setValue(getPreviousValue(self))
		else
			self:setValue(getNextValue(self))
		end
	end
end

function M.create(node, options, textNodeName, textureNodeName)
	local sld = setmetatable({
		text = gui.get_node(hash(node .. '/' .. (textNodeName or 'text'))),
		texture = gui.get_node(hash(node .. '/' .. (textureNodeName or 'texture'))),
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

return M;