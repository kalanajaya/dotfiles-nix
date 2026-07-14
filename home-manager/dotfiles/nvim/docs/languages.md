# Neovim Language Stack

## Treesitter (Eyes)
    - Treesitter parses your code into a structural tree. It doesn't understand the logic, but it knows exactly what a function, a string, or a variable looks like. Its main job is fast, highly accurate syntax highlighting.
## LSP (Brain)
    - This is an external program running in the background (like pyright or clangd). Neovim talks to it to understand the meaning of your code. The LSP reads your whole project and provides autocomplete, go-to-definition, find-references, and inline error diagnostics.
## DAP (Inspector)
    - Similar to LSP, this is a separate background program, but its job is strictly execution. It allows Neovim to launch your code, set breakpoints, pause execution, and inspect variables in memory.
## Language Plugins (Specialist)
    - Sometimes, generic LSP and DAP aren't enough because a language has a bizarre ecosystem. For example, Java requires a complex handshake to set up its workspace, and Flutter needs to talk to Android emulators. Plugins like nvim-java or flutter-tools act as middle-men to handle that language-specific heavy lifting before handing control back to standard LSP/DAP.
