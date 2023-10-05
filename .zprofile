## zprofile

## general
# history & completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
export HISTFILE=${HOME}/.zhistory
export HISTSIZE=10000
export SAVEHIST=100000
setopt hist_ignore_dups
setopt EXTENDED_HISTORY
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_no_store
setopt hist_expand
setopt inc_append_history
bindkey "^R" history-incremental-search-backward
# etc
stty stop undef

# VARIABLE
export BROWSER=/Applications/Vivaldi.app/Contents/MacOS/Vivaldi
export EDITOR=nvim
bindkey -e
export MANPAGER="nvim +Man!"
export XDG_CONFIG_HOME=~/.config
export LANG=en_US.UTF-8
# PATH
PATH="$HOME/usr/bin:$HOME/usr/local/bin:/usr/local/opt/coreutils/libexec/gnubin:$HOME/.config/composer/vendor/bin:/usr/local/opt/llvm/bin:$PATH"
export MANPATH="$MANPATH:/usr/local/opt/coreutils/libexec/gnuman"
# LANGUAGE
# -> python
export PYENV_ROOT="${HOME}/.pyenv"
PATH="${PYENV_ROOT}/bin:$PATH"
eval "$(pyenv init -)"
# -> ruby
#PATH="${HOME}/.rbenv/bin:$PATH"
#eval "$(rbenv init -)"
# -> php (also: phpenv-build,phpenv-composer)
PATH="${HOME}/.phpenv/bin:$PATH"
eval "$(phpenv init -)"
# -> go
export GOPATH=$HOME/usr/local/go
PATH="$PATH:$GOPATH/bin"
# -> node.js
export NODEBREW_ROOT="$HOME/.nodebrew"
PATH="$NODEBREW_ROOT/current/bin:$PATH"
# -> terraform
PATH="$HOME/.tfenv/bin:$PATH"
PATH="$HOME/.tgenv/bin:$PATH"
# avoid duplication
typeset -U path PATH
# finalize
export PATH

# CLI tools
# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
# git
autoload -Uz add-zsh-hook
autoload -Uz colors
colors
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true
autoload -Uz is-at-least
if is-at-least 4.3.10; then
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "+"    
  zstyle ':vcs_info:git:*' unstagedstr "-"  
  zstyle ':vcs_info:git:*' formats '(%s)-[%b] %c%u'
  zstyle ':vcs_info:git:*' actionformats '(%s)-[%b|%a] %c%u'
fi
function _update_vcs_info_msg() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg
RPROMPT="%1(v|%F{green}%1v%f|)"
# R
disable r
# tmux
[[ -z $TMUX && ! -z "$PS1" ]] && tmux
set -o ignoreeof # stop tmux from exit with C-d
# fzf
export FZF_DEFAULT_OPTS='--height 40% --reverse'
export FZF_TMUX=1
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
export FZF_COMPLETION_TRIGGER=',,'
