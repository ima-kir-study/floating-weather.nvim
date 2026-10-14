local M = {}

-- rewrite defaults with user settings
local defaults = require("floating_weather.config")
M.config = vim.deepcopy(defaults)
function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

function M.toggle()
    vim.print(1)
end

return M

