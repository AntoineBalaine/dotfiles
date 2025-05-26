:prompt "what’s your name:" %{ info "hello %val{text}" }

:prompt -shell-script-candidates ls file: %{ info "you selected %val{text}" }
1. **Creates a prompt labeled "file:"** - This is what the user sees when the prompt appears
2. **Populates the prompt with shell command results** - The `-shell-script-candidates ls` part runs the `ls` command and uses its output (the list of files in the current directory) to provide auto-completion options

prompt -shell-script-candidates 'fd --type file' open: %{ edit -existing %val{text} }

define-command my-file-picker %{
  prompt -shell-script-candidates 'fd --type file' open: %{ edit -existing %val{text} }
}

map global user f ':my-file-picker<ret>'

some things I’d like:
- git inline diff, toggleable
- navigate git hunks
- use ctrl for navigating splits
- easy motion
- PR reviews
- AI integration
- file tree ?
- search replace à la Spectre/vscode search/replace
- surround
- normal mode movements similar to a basic editor/html input
- lsp
- tree-sitter
- local configs in project directories
- virtual text for context.nvim
- block selection instead of line selection?
- formatting?
- debugger
- switch/vary colorscheme on mode change
- zig comp diag
- todo comments https://discuss.kakoune.com/t/highlight-todo-but-only-in-comments/2330
- use ripgrep instead of grep
- shortcuts/buffer list in line or as tabs?
- refactoring?
- wrapping
- custom cmds in lazygit for integration with kakoune (`e` tells kakoune which file to edit, and loads the diff)

What’s the approach for plugins, currently?
Is using a plug-in manager the de-facto approach, or are most users doing their own thing?
The main reason why I’m interested in Kakoune is because I’d like to remove or control dependencies as much as possible. 
If I have some dependencies, is there a path to update? What’s the typical frequency for things breaking? Do you pin on commit versions or release versions (if at all do pin?) ?

When it comes to editing itself: I’m not sure I love sprinkling the alt key all over the place, especially given that macos doesn’t actually _have_ an alt key. Have users gone the route of remapping to avoid chording/using the alt key before? How successful were those attempts?
