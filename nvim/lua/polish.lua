-- if true then return end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here
vim.o.exrc = true
vim.o.secure = true

-- vim.filetype.add {
--   pattern = {
--     [".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
--   },
-- }

-- local ansible_dirs = {
--   "**/ansible",         -- e.g. project/infra/automation/...
--   "**/playbooks",
-- }
--
-- local patterns = { "site.yml", "site.yaml" }
-- for _, dir in ipairs(ansible_dirs) do
--   table.insert(patterns, ("*/%s/*.{yml,yaml}"):format(dir))
--   table.insert(patterns, ("*/%s/**/*.{yml,yaml}"):format(dir))
-- end
--
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   pattern = patterns,
--   callback = function(ev)
--     vim.bo[ev.buf].filetype = "yaml.ansible"
--   end,
-- })
