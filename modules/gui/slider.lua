local M = {};

local function getBackdropSizeAndSegmentWidth(m)
	local size = gui.get(m.backdrop, 'size') -- размер подложки
	local segmentWidth = size.x / 19 -- 10 сегментов, между которыми 9 разделителей

	return size, segmentWidth
end

local function changeValue(m)
	local segments = m.value * 10 -- кол-во сегментов, которые надо закрасить

	local size, segmentWidth = getBackdropSizeAndSegmentWidth(m)

	size.x = (segments * 2 - 1) * segmentWidth -- сегменты + (сегменты - 1 разделителей потому что в конце разделителя нет)

	gui.set(m.filler, 'size', size)
end

local function setValueByTouch(m, actionId, action)
	if gui.pick_node(m.backdrop, action.x, action.y) then
		local pos = gui.get_screen_position(m.backdrop)

		local _, segmentWidth = getBackdropSizeAndSegmentWidth(m)

		local value = (action.x - pos.x) / segmentWidth

		-- иначе 0 установить невозможно
		if value < 0.5 then
			m:setValue(0)
			return true
		end

		-- 1) math.floor(value + 0.5) - правильное округление
		-- 2) (п.1) + 1 - нет разделителя после последнего сегмента
		-- 3) (п.2) / 2 - получить текущий сегмент
		-- 4)  math.ceil(п.3) - округлить до сегмента, если клик был на разделителе
		-- 5) (п.4) / 10 -получить итоговое значение слайдера от 0 до 1
		m:setValue(math.ceil((math.floor(value + 0.5) + 1) / 2) / 10)

		return true
	end

	return false
end

function M.onInput(self, actionId, action)
	if actionId == nil and self.isPressed then
		setValueByTouch(self, actionId, action)
	elseif actionId == hash("touch") and action.pressed then
		self.isPressed = true
		if not setValueByTouch(self, actionId, action) and gui.pick_node(self.texture, action.x, action.y) then
			local pos = gui.get_screen_position(self.texture); -- не будет работать после ресайза окна или на устройствах с другим разрешением
			-- чтобы исправить надо стрелки сделать отдельными нодами, это точно
			-- возможно придётся и деления делать отдельными нодами. Их всего 10, на производительность не должно же сильно повлиять?
			-- по крайней мере сделать пока и добавить тудушку - придумать способ легче
			-- а ещё то же самое надо сделать с селектами

			-- не будет работать если у self.texture pivot не будет центром
			if action.x < pos.x then
				self:setValue(self:getValue() - 0.1)
			else
				self:setValue(self:getValue() + 0.1)
			end
		end
	elseif action.released then
		self.isPressed = false
	end
end

function M.create(node, backdropNodeName, fillerNodeName, textureNodeName)
	local sld = setmetatable({
		backdrop = gui.get_node(hash(node .. '/' .. (backdropNodeName or 'backdrop'))),
		filler = gui.get_node(hash(node .. '/' .. (backdropNodeName or 'filler'))),
		texture = gui.get_node(hash(node .. '/' .. (textureNodeName or 'texture'))),
		onChange = nil,
		value = nil,
		segmentWidth = nil,
		isPressed = false,
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
	self.value = math.min(math.max(value, 0), 1)

	if not silently and self.onChange then self:onChange() end

	changeValue(self);

	return self;
end

function M.getValue(self)
	return self.value;
end

return M;