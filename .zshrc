export PATH=$HOME/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
alias lg="lazygit"
alias cpwd="pwd | pbcopy"
alias commonlib="cd ~/Documents/Ryerson/web-components-common-ui/application"
alias market="cd ~/Documents/Ryerson/web-marketing-ui/application"
alias store="cd ~/Documents/Ryerson/web-store-ui/application"
export PATH="~/.local/bin/:$PATH"

parse_git_branch() {
   G="git"
   #if current folder is home, G should be "config" instead
   if [[ "$PWD/" == "$HOME/" ]]; then
      G="git --git-dir=/Users/a266836/.cfg/ --work-tree=/Users/a266836"
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

alias firefox="/Applications/Firefox\ Developer\ Edition.app/Contents/MacOS/firefox -start-debugger-server"
alias build="cd ~/Documents/Ryerson/web-components-common-ui/application; bit compile; cd ~/Documents/Ryerson/web-store-ui/application; cp -R ~/Documents/Ryerson/web-components-common-ui/application/node_modules/@ryerson/frontend.table/dist ~/Documents/Ryerson/web-store-ui/application/node_modules/@ryerson/frontend.table; yarn start;"
alias config='/usr/bin/git --git-dir=/Users/a266836/.cfg/ --work-tree=/Users/a266836'
alias lazyconfig='lazygit --git-dir=/Users/a266836/.cfg/ --work-tree=/Users/a266836'
alias plover="/Applications/Plover.app/Contents/MacOS/Plover"
# export PATH=$HOME/bin:$PATH
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# . "$HOME/.cargo/env"
export VISUAL=lvim;
export EDITOR=lvim;
alias transfer="bash ~/Documents/Ryerson/transfer.sh"
alias transfermarket="bash ~/Documents/Ryerson/transfermarket.sh"


# pnpm
export PNPM_HOME="~/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

