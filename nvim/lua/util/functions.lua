local util = {}

util.is_ssh = function()
	return os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY")
end

return util
