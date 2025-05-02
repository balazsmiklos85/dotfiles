local util = require("util.functions")

if util.is_macos() or util.is_wsl() or util.is_vm() then
	return {}
end

return {
    "Exafunction/windsurf.vim",
	event = "BufEnter",
	cond = function()
		local current_directory = vim.fn.getcwd()
		for _, directory in ipairs({
			".config",
			"book_club",
			"catechism",
			"cv",
			"leetcode",
			"project_euler",
			"semantify_table",
		}) do
			if current_directory:find(directory, 1, true) then
				return true
			end
		end
		return false
	end,
}
