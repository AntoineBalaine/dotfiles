export PATH=$HOME/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH="/opt/homebrew/Cellar/python@3.12/3.12.3/bin/python3":$PATH

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
alias lg="lazygit"
alias cpwd="pwd | pbcopy"
alias commonlib="cd ~/Documents/Ryerson/web-components-common-ui/application"
alias market="cd ~/Documents/Ryerson/web-marketing-ui/application"
alias store="cd ~/Documents/Ryerson/web-store-ui/application"
export PATH="~/.local/bin/:$PATH"
export PATH="/opt/homebrew/bin/python3/:$PATH"

parse_git_branch() {
   G="git"
   #if current folder is home, G should be "config" instead
   if [[ "$PWD/" == "$HOME/" ]]; then
      G="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
   fi
   # G is a command, how to run it as a command instead of a string?

   eval ${G} branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/'
}

COLOR_DEF=$'%f'
COLOR_USR=$'%F{243}'
COLOR_DIR=$'%F{197}'
COLOR_GIT=$'%F{39}'
setopt PROMPT_SUBST
export PROMPT='${COLOR_USR}%n ${COLOR_DIR}%~ ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF} $ '

alias firefox="/Applications/Firefox\ Developer\ Edition.app/Contents/MacOS/firefox -start-debugger-server 6000"
alias build="cd ~/Documents/Ryerson/web-components-common-ui/application; bit compile; cd ~/Documents/Ryerson/web-store-ui/application; cp -R ~/Documents/Ryerson/web-components-common-ui/application/node_modules/@ryerson/frontend.table/dist ~/Documents/Ryerson/web-store-ui/application/node_modules/@ryerson/frontend.table; yarn start;"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias lazyconfig='lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias plover="/Applications/Plover.app/Contents/MacOS/Plover"
# export PATH=$HOME/bin:$PATH
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# . "$HOME/.cargo/env"
export VISUAL=nvim;
export EDITOR=nvim;
alias transfer="bash ~/Documents/Ryerson/transfer.sh"
alias transfermarket="bash ~/Documents/Ryerson/transfermarket.sh"
alias reaper="/Applications/REAPER.app"

# pnpm
export PNPM_HOME="~/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

eval "$(zoxide init zsh)"
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/lib/ruby/gems/3.3.0/bin:$PATH"

# https://github.com/gokcehan/lf/blob/master/etc/lfcd.sh
lf() {
  # `command` is needed in case `lfcd` is aliased to `lf`
  cd "$(command lf -print-last-dir "$@")" || exit
}
bindkey -s '^o' 'lf\n'  # zsh
source .env

export FZF_DEFAULT_COMMAND="rg --files"
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info --multi --preview \"bat --color=always {}\""

alias rgf="rg --color=always --line-number --no-heading --smart-case \"${*:-}\" | \
  fzf --ansi \
      --color "hl:-1:underline,hl+:-1:underline:reverse" \
      --delimiter : \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --bind 'enter:become(nvim {1} +{2})'"

rem -q
