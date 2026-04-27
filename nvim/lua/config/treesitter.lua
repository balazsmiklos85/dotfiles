if vim.version().minor > 11 then
	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
			if lang and vim.treesitter.query.get(lang, "highlights") then
				vim.treesitter.start(args.buf, lang)
			end
		end,
	})
end
