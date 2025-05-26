source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug "andreyorst/fzf.kak"

colorscheme base16

provide-module projectile %[
  declare-user-mode user-project

  map global user-project t ':projectile-alternative-file<ret>' -docstring 'alternate file'

  def -override projectile-alternative-file 'echo "No alternative file defined"'
  hook global WinSetOption filetype=ruby %{
    require-module projectile-ruby
    set-option current identwidth 2
  }
  hook global WinSetOption filetype=javascript %{
    set-option current formatcmd %{prettier --stdin --parser=babel}
  }
  hook global WinSetOption filetype=json %{
    set-option current formatcmd %{jq .}
  }
]

provide-module projectile-ruby %[
  def -override projectile-alternative-file 'ruby-alternative-file'
]

map global user d '<esc>:fzf-mode<ret>' -docstring "fzf"
map global user f '<esc>:fzf-mode<ret>v' -docstring "fzf vcs"
map global user b '<esc>:fzf-mode<ret>b' -docstring "fzf buffer"
map global user p ':enter-user-mode user-project<ret>' -docstring "project"

require-module projectile

declare-user-mode sys
define-command sys-mode 'enter-user-mode sys' 
define-command -override sys-eval 'eval %val{selection}'

map global normal <semicolon> <,> -docstring 'user mappings'
map global sys <c-e> ':sys-eval<ret>' -docstring 'eval selection'
map global sys <c-r> ':edit "%val{config}/kakrc"<ret>' -docstring 'edit kakrc' 
map global normal <c-x> ':sys-mode<ret>'
map global insert <c-x> '<esc>:sys-mode<ret>'

set-option global indentwidth 2
hook global BufWritePre .* %{
  evaluate-commands %sh{
    if [ -n "$kak_opt_formatcmd" ]; then
      printf "format-buffer\n"
    else
      printf "\n"
    fi
  }
}
