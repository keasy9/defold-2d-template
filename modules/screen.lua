local M = {};

function M.show(self, proxy)
	msg.post('main:/controller#main', 'load_proxy', {proxy = proxy})

	return self
end

function M.loader(self, state)
	msg.post('main:/controller#loader', state and 'start' or 'stop')

	return self
end

function M.unload(self)
	msg.post('main:/controller#main', 'unload_proxy')

	return self
end

return M;