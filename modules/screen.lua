local M = {};

function M.show(proxy)
	msg.post('main:/controller#main', 'load_proxy', {proxy = proxy})
end

return M;