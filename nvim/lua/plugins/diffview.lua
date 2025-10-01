return {
	"sindrets/diffview.nvim",
	cond = function()
		local container_file = io.open("/run/.containerenv", "r")
		if container_file then
			container_file:close()
			return true
		end
		local result = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null")
		return string.find(result, "true")
	end,
}
