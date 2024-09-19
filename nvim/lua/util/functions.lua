local util = {}

util.get_wifi_ssid = function ()
	local result = ""
	if util.is_macos() then
		local process_handle = io.popen("ifconfig | rg 'inet' | rg '192.168' | awk '{print $2}' | awk -F. '{print $3}'")
		if process_handle == nil then
			return result
		end
		result = process_handle:read("*a")
		process_handle:close()
	else
		local process_handle = io.popen("nmcli -t -f active,ssid dev wifi | rg '^(yes|igen)' | cut -d':' -f2")
		if process_handle == nil then
			return result
		end
		result = process_handle:read("*a")
		process_handle:close()
	end
	return result
end

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

util.is_wifi_ssid = function (ssid)
	return string.match(util.get_wifi_ssid(), ssid)
end

return util
