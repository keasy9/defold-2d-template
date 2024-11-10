local M = {};

local border = hash('border')
local fill = hash('fill')

local function onHover(m)
	if m.color == nil then
		m.color = gui.get_color(m.btn)
	end

	gui.set_color(m.text, m.hovered and vmath.vector4(0,0,0,1) or m.color)
	gui.play_flipbook(m.btn, m.hovered and fill or border)
end

function M.onInput(self, actionId, action)
	local hovered = self.hovered

	if actionId == nil then
		hovered = gui.pick_node(self.btn, action.x, action.y)

	elseif actionId == hash("touch") and action.pressed then
		if self.onClick and gui.pick_node(self.btn, action.x, action.y) then
			self.onClick(self, action)
		end
	end

	if hovered ~= self.hovered then
		self.hovered = hovered
		onHover(self)
	end
end

function M.create(node, btnNodeName, textNodeName)
	local btn = setmetatable({
		btn = gui.get_node(hash(node .. '/' .. (btnNodeName or 'button'))),
		text = gui.get_node(hash(node .. '/' .. (textNodeName or 'text'))),
		hovered = false,
		color = nil,
		onClick = nil,
	}, {
		__index = M,
	})

	return btn;
end

function M.setOnClick(self, onClick)
	self.onClick = onClick

	return self;
end

return M;