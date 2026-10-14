if vim.g.loaded_floating_weather then
	return
end
vim.g.loaded_floating_weather = true

vim.api.nvim_create_user_command("ToggleFloatingWeather", function()
	require("floating_weather").toggle()
end, {})
