local util = {}

util.is_file = function (file_name)
   local file_handle = io.open(file_name, "r")
   return file_handle ~= nil and io.close(file_handle)
end

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

util.is_vm = function ()
	local process_handle = io.popen("lsmod | rg vboxguest")

	if process_handle == nil then
		return false
	end

	local vbox = process_handle:read("*l")
	process_handle:close()
	return vbox:find("vbox") ~= nil
end

util.is_wifi_ssid = function (ssid)
	return string.match(util.get_wifi_ssid(), ssid)
end

util.is_wsl = function ()
	return os.getenv("WSL_DISTRO_NAME") ~= nil
end

return util
