> [!NOTE]
> Имануилов Кирилл, группа М3102

# Floating Weather

Simple and lightweight Neovim plugin to see how many degrees is it!

[![License: MIT](https://img.shields.io/badge/license-MIT-green?style=flat-square)](https://github.com/ima-kir-study/vim-plugin/blob/main/LICENSE)

Technical requirements: [technical_requirements.md](https://github.com/ima-kir-study/vim-plugin/blob/main/technical_requirements.md)

## Platforms
- Tested on Linux. Plugin work on other platforms is not guaranteed.

## Requirements
- `nvim` (tested on `v0.12.5`)
- `curl`

## Installing

To install plugin, for example, with Packer, use this code:

```lua
use {"ima-kir-study/floating-weather.nvim"}
```

## Setting Up

Add to your `init.lua` smth like this:

```lua
vim.keymap.set("n", "<leader>w", ":ToggleFloatingWeather<CR>", { desc = "FloatingWeather plugin!", buffer = true, silent = true })

require("floating_weather").setup({
    city = 'Москва',
    transparent_bg = true,
})
```

## Using

If you use settings from the [Setting Up](https://github.com/ima-kir-study/floating-weather.nvim/tree/main#setting-up) section, press `<leader>w`

## Sources Used

- `:help lua-plugin`
- `:help io.popen()`
- `:help nvim_create_buf()`
- `:help nvim_buf_set_lines()`
- `:help nvim_list_uis()`
- [auto-save.nvim](https://github.com/pocco81/auto-save.nvim) plugin as an example
- [Weather codes mappings](https://gist.github.com/dawnvoh/a1f513123f7b6a42577d)

