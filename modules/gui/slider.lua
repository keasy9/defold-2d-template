local M = {};

local function paintOpts(m)
	local opts = m.value * 10

	if not m.color then
		m.color = gui.get_color(m.prev)
	end

	for i, opt in ipairs(m.opts) do
		if i <= opts then
			print(m.color)
			gui.set_color(opt, m.color)
		else
			gui.set_color(opt, vmath.vector4(1,1,1, 1))
		end
	end

	if m.sound then
		sound.stop(m.sound)
		sound.play(m.sound, {gain = SETTINGS:load()['sound'], pan = m.value * 2 - 1})
	end
end

local function setValueByTouch(m, actionId, action)
	-- todo придумать как кликом по телу слайдера установить 0. Псевдоопция?
	for i, opt in ipairs(m.opts) do
		if gui.pick_node(opt, action.x, action.y) then
			local value = i * 0.1
			if value ~= m:getValue() then
				m:setValue(i * 0.1)
			end
			return true
		end
	end

	return false
end

function M.onInput(self, actionId, action)
	if actionId == nil and self.isPressed then
		setValueByTouch(self, actionId, action)
	elseif actionId == hash("touch") and action.pressed then
		if gui.pick_node(self.prev, action.x, action.y) then
			self:setValue(self.value - 0.1)
		elseif gui.pick_node(self.next, action.x, action.y) then
			self:setValue(self.value + 0.1)
		else
			setValueByTouch(self, actionId, action)
			self.isPressed = true
		end
	elseif action.released then
		self.isPressed = false
	end
end

function M.create(node, bodyNodeName, optNodesName, prevNodeName, nextNodeName)
	optNodesName = node .. '/' .. (optNodesName or 'opt')
	
	local sld = setmetatable({
		body = gui.get_node(hash(node .. '/' .. (bodyNodeName or 'body'))),
		prev = gui.get_node(hash(node .. '/' .. (prevNodeName or 'prevButton'))),
		next = gui.get_node(hash(node .. '/' .. (nextNodeName or 'nextButton'))),
		opts = {},
		onChange = nil,
		value = nil,
		isPressed = false,
		color = nil,
	}, {
		__index = M,
	})

	for i = 1, 10, 1 do
		sld.opts[i] = gui.get_node(hash(optNodesName .. i))
	end

	return sld;
end

function M.setOnChange(self, onChange)
	self.onChange = onChange

	return self;
end

function M.setValue(self, value, silently)
	self.value = math.min(math.max(value, 0), 1)

	if not silently and self.onChange then self:onChange() end

	paintOpts(self);

	return self;
end

function M.getValue(self)
	return self.value;
end

function M.setSound(self, sound)
	self.sound = sound

	return self;
end

return M;