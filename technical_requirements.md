# Technical Requirements
## The project purpose
Develop a weather plugin for the [Neovim](https://github.com/neovim/neovim).

## Plugin description
User binds weather forecast display to the key. When you press a key, a floating window opens with this information about the forecast:

- date and time
- temperature (in degrees Celsius)
- presure
- UV index

## How it should work

```mermaid
flowchart TD
    A[Plugin loads] -->|User press the key| B[Send request to wttr.in API]
    B --> |Get response| C[Parse response]
    C --> D[Open floating window and show weather forecast]

```

## Tech stack
- Lua as the main language
- Neovim API
- [wttr.in API](https://wttr.in)

