local util = {}

util.is_at_work = function()
	if not util.is_macos() then
		return false
	end
	local addresses = vim.uv.interface_addresses()
	for _, info in pairs(addresses) do
		for _, addr in ipairs(info) do
			if addr.ip:match("^192%.168%.0%.") then
				return false
			end
		end
	end
	return true
end

util.is_file = function(file_name)
	local file_handle = io.open(file_name, "r")
	return file_handle ~= nil and io.close(file_handle)
end

util.is_macos = function()
	return vim.uv.os_uname().sysname == "Darwin"
end

return util
