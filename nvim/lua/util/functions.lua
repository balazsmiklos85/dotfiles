local util = {}

util.is_macos = function()
	local process_handle = io.popen("uname")

	if process_handle == nil then
		return false
	end

	local os_type = process_handle:read("*l")
	process_handle:close()
	return os_type == "Darwin"
end

util.is_ssh = function()
	return os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY")
end

return util
