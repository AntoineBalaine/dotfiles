export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
alias lg="lazygit"
alias cpwd="pwd | xclip -selection clipboard"
alias commonlib="cd $HOME/Documents/Ryerson/web-components-common-ui/application"
alias market="cd $HOME/Documents/Ryerson/web-marketing-ui/application"
alias store="cd $HOME/Documents/Ryerson/web-store-ui/application"
export PATH="$HOME/.local/bin/:$PATH"
parse_git_branch() {
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
export PATH=$HOME/bin:$PATH
export PATH=$HOME/bin:$PATH
alias firefox="/Applications/Firefox\ Developer\ Edition.app/Contents/MacOS/firefox -start-debugger-server 6000"
alias build="cd $HOME/Documents/Ryerson/web-components-common-ui/application; bit compile; cd $HOME/Documents/Ryerson/web-store-ui/application; cp -R $HOME/Documents/Ryerson/web-components-common-ui/application/node_modules/@ryerson/frontend.table/dist $HOME/Documents/Ryerson/web-store-ui/application/node_modules/@ryerson/frontend.table; yarn start;"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias lazyconfig='lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias plover="/Applications/Plover.app/Contents/MacOS/Plover"
export PATH=$HOME/bin:$PATH
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
# . "$HOME/.cargo/env"
export VISUAL=nvim
export EDITOR=nvim
alias transfer="bash $HOME/Documents/Ryerson/transfer.sh"
alias transfermarket="bash $HOME/Documents/Ryerson/transfermarket.sh"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
eval "$(zoxide init bash)"
# pnpm end

# https://github.com/gokcehan/lf/blob/master/etc/lfcd.sh
lf() {
  # `command` is needed in case `lfcd` is aliased to `lf`
  cd "$(command lf -print-last-dir "$@")" || exit
}
bind '"\C-o":"lf\C-m"' # bash

# rem -q
export FZF_DEFAULT_COMMAND="rg --files"
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info --multi --preview \"bat --color=always {}\""

alias rgf="rg --color=always --line-number --no-heading --smart-case \"${*:-}\" | \
  fzf --ansi \
      --color "hl:-1:underline,hl+:-1:underline:reverse" \
      --delimiter : \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --bind 'enter:become(nvim {1} +{2})'"
