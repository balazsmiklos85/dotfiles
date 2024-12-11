return {
	"Exafunction/codeium.vim",
	event = "BufEnter",
	cond = function()
		local current_directory = vim.fn.getcwd()
		for _, directory in ipairs({ ".config", "book_club", "project_euler", "semantify_table" }) do
			if current_directory:find(directory, 1, true) then
				return true
			end
		end
		return false
	end,
}
