if vim.g.loaded_floating_weather then
    return
end
vim.g.loaded_floating_weather = true

-- local cfg = require("floating_weather.config")

vim.api.nvim_create_user_command("ToggleFloatingWeather", function()
    require("floating_weather").toggle()
end, {})

