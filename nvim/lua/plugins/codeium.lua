local enabled_in_directories = { ".config", "book_club" }
local current_directory = vim.fn.getcwd()
local is_enabled = false
for _, directory in ipairs(enabled_in_directories) do
	if current_directory:find(directory, 1, true) then
		is_enabled = true
	end
end
return {
	"Exafunction/codeium.vim",
	event = "BufEnter",
	cond = is_enabled,
}
