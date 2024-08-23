#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
ranger() {
    if [ -z "$RANGER_LEVEL" ]; then
        /usr/bin/ranger "$@"
    else
        exit
    fi
}
export PATH="~/.local/bin:$PATH";
export PATH="~/Documents/Experiments/nvim/potion/bin:$PATH";
export PATH="~/.local/share/gem/ruby/3.0.0/bin:$PATH";
# export PATH="/home/antoine/Documents/Experiments/zig/zig-linux-x86_64-0.13.0-dev.46+3648d7df1/zig:$PATH";
export VISUAL=~/.local/bin/nvim;
export EDITOR=~/.local/bin/nvim;
export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git" ' 
eval "$(zoxide init bash)"
eval "$(mcfly init bash)"
alias cpwd="pwd | wl-copy"
alias bépo="cd /home/antoine/Documents/Experiments/ploverBépo/bépo/plover_bepo; ranger"
alias plover="/home/antoine/Documents/AppImages/plover-4.0.0.dev10+115.gc75215e-x86_64.AppImage"
alias webcam="sudo modprobe facetimehd"
alias vrb="cd /home/antoine/Documents/Experiments/ploverBépo/bépo/scriptsEntrainement/verbesPremierGroupe/src"
alias dict="cd /home/antoine/Documents/Experiments/ploverBépo/bépo/plover_bepo/plover_bepo/dictionaries"
alias experiments="cd /home/antoine/Documents/Experiments; ranger;"
alias mariage="cd /home/antoine/Documents/Mariage; ranger;"
alias abcmacros="cd /home/antoine/Documents/Experiments/Abcjs/macros/abc_macros_code; ranger"
alias mamie="cd /home/antoine/Documents/Experiments/groff/poésiesMamie/"
alias config='/usr/bin/git --git-dir=/home/antoine/.cfg/ --work-tree=/home/antoine'
alias lazyconfig='lazygit --git-dir=/home/antoine/.cfg/ --work-tree=/home/antoine'
alias lg="lazygit"
reaperconf="/home/antoine/.config/REAPER/"
alias reapervim="nvim /home/antoine/.config/REAPER/Scripts/reaper-keys"

# alias zig="/home/antoine/Documents/Experiments/zig/zig-linux-x86_64-0.13.0-dev.46+3648d7df1/zig"
export PATH="$PATH:$HOME/.local/share/yabridge"
export PATH="$PATH:/etc/bash_completion"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#
alias transfer="bash /home/antoine/Documents/Experiments/reaper_exp/reaper_sh_scripts/transfer.sh"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
alias fzbat="fzf --preview 'bat --color=always {}' --preview-window '~3'"
# eval "$(beet completion)"
