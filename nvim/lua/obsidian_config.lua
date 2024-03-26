local Path = require("plenary.path")

local workspaces = {}

local documents_en = os.getenv("HOME") .. "/Documents/notes"
local documents_hu = os.getenv("HOME") .. "/Dokumentumok/notes"

if Path:new(documents_en):exists() then
  table.insert(workspaces, { path = documents_en, name = "notes" })
elseif Path:new(documents_hu):exists() then
  table.insert(workspaces, { path = documents_hu, name = "notes" })
end

require("obsidian").setup {
  workspaces = workspaces,
}

