local M = {
	currentProxy = nil,
};

function M.show(self, proxy)
	if self.currentProxy then
		msg.post(self.currentProxy, 'disable')
		msg.post(self.currentProxy, 'final')
		msg.post(self.currentProxy, 'unload')
	end

	self.currentProxy = '#' .. proxy

	msg.post(self.currentProxy, 'async_load')
end

function on_message(self, message_id, message, sender)
	if message_id == hash('proxy_loaded') then
		msg.post(sender, 'init')
		msg.post(sender, 'enable')
	end
end

return M;