local M = {}

-- rewrite defaults with user settings
local defaults = require("floating_weather.config")
M.config = vim.deepcopy(defaults)
function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

local weather = {
	feels_like = "",
	temperature = "",
	cloud_cover = "",
	pressure = "",
	uv_index = "",
	wind_speed = "",
	weather_code = "",
}

local function getWeather(city, weather)
	local p = io.popen(string.format("curl -s https://wttr.in/%s?format=j2", city))
	local raw = p:read("all")
	p.close()
	local json_data = vim.json.decode(raw).current_condition[1]

	weather.feels_like = json_data.FeelsLikeC
	weather.temperature = json_data.temp_C
	weather.cloud_cover = json_data.cloudcover
	weather.pressure = json_data.pressure
	weather.uv_index = json_data.uvIndex
	weather.wind_speed = json_data.windspeedKmph
	weather.weather_code = json_data.weatherCode

	return weather
end

local weather_code_map = {
	[395] = "Умеренный или сильный снегопад в районе с грозой",
	[392] = "Местами небольшой снег в районе с грозой",
	[389] = "Умеренный или сильный дождь в районе с грозой",
	[386] = "Местами небольшой дождь с грозой",
	[377] = "Умеренный или сильный дождь из ледяных гранул",
	[374] = "Небольшой дождь из ледяных гранул",
	[371] = "Умеренный или сильный снегопад",
	[368] = "Небольшой снегопад",
	[365] = "Умеренный или сильный дождь с мокрым снегом",
	[362] = "Небольшой дождь с мокрым снегом",
	[359] = "Проливной дождь",
	[356] = "Умеренный или сильный ливень",
	[353] = "Легкий дождевой душ",
	[350] = "Ледяные крошки",
	[338] = "Сильный снег",
	[335] = "Неравномерный сильный снег",
	[332] = "Умеренный снег",
	[329] = "Неравномерный умеренный снег",
	[326] = "Легкий снег",
	[323] = "Слабый снежный покров",
	[320] = "Умеренный или сильный мокрый снег",
	[317] = "Небольшой мокрый снег",
	[314] = "Умеренный или сильный ледяной дождь",
	[311] = "Небольшой ледяной дождь",
	[308] = "Сильный дождь",
	[305] = "Временами идет сильный дождь",
	[302] = "Умеренный дождь",
	[299] = "Временами умеренный дождь",
	[296] = "Небольшой дождь",
	[293] = "Кратковременный слабый дождь",
	[284] = "Сильный моросящий дождь",
	[281] = "Моросящий мелкий дождь",
	[266] = "Легкий моросящий дождь",
	[263] = "Кратковременный мелкий моросящий дождь",
	[260] = "Ледяной туман",
	[248] = "Туман",
	[230] = "Метель",
	[227] = "Метущий снег",
	[200] = "Вспышки грозы поблизости",
	[185] = "Кратковременный ледяной дождь поблизости",
	[182] = "Кратковременный мокрый снег поблизости",
	[179] = "Кратковременный снег поблизости",
	[176] = "Кратковременный дождь поблизости",
	[143] = "Туман",
	[122] = "Пасмурно",
	[119] = "Облачно",
	[116] = "Переменная облачность",
	[113] = "Ясно/солнечно",
}

local function formatOutput(data)
	return {
		weather_code_map[tonumber(data.weather_code)],
		string.format("%d°C, ощущается как %d°C", data.temperature, data.feels_like),
		string.format("Ветер %d км/ч", data.wind_speed),
		string.format("Давление %d мм.рт.ст.", data.pressure),
		string.format("УФ-индекс %d", data.uv_index),
	}
end

function M.open()
	vim.print("Opening weather forecast...")
	vim.cmd("redraw")

	-- get and format weather data
	local data = getWeather(M.config.city, weather)
	local formatted_data = formatOutput(data)

	-- create buffer
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted_data)

	vim.print("")

	-- calculate window height and width
	local h = #formatted_data
	local w = 0
	for i = 0, h do
		if formatted_data[i] ~= nil then
			if vim.str_utfindex(formatted_data[i]) > w then
				w = vim.str_utfindex(formatted_data[i])
			end
		end
	end

	-- open floating window
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = w,
		height = h,
		row = (vim.api.nvim_win_get_height(0) - h) / 2,
		col = (vim.api.nvim_win_get_width(0) - w) / 2,
		style = "minimal",
		border = "rounded",
	})

	-- transparent bg
	if M.config.transparent_bg then
		vim.api.nvim_set_hl(0, "MyFloat", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "MyFloatBorder", { bg = "NONE" })
		vim.wo[win].winhighlight = "NormalFloat:MyFloat,FloatBorder:MyFloatBorder"
	end

	-- close window by "q"
	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf, desc = "Close floating window" })
end

return M
