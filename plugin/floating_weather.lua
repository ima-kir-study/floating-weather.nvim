if vim.g.loaded_floating_weather then
    return
end
vim.g.loaded_floating_weather = true

-- local cfg = require("floating_weather.config")

local bufnr = vim.api.nvim_get_current_buf()

vim.api.nvim_create_user_command("ToggleFloatingWeather", function()
    require("floating_weather").toggle()
end, { buf = bufnr })

