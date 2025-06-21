# Ryan's config for the Zoomer Shell

# General Notes:
# - See zshbuiltins(1) and zshoptions(1) for more details.
# - Reminder that startup files are read in order: 
#   [.zshenv always] -> [.zprofile if login] -> [.zshrc if interactive] -> [.zlogin if login] -> [.zlogout sometimes]
#   If ZDOTDIR is not set, then the value of HOME is used.
#   For each user startup file, the cooresponding system startup file is read immediatley before.
#   See https://zsh.sourceforge.io/Intro/intro_3.html


# Save command history
# - below overrides the defalts in /etc/zshrc
# - Keep HISTSIZE at least 20% larger than SAVEHIST, see https://zsh.sourceforge.io/Doc/Release/Options.html#History
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=2000   # Maximum events for internal history
SAVEHIST=1000   # Maximum events in history file
# Remove superflous empty spaces from lines when adding to hist (blank lines are already omitted)
setopt HIST_REDUCE_BLANKS
# Save history on each command execution, but only load when starting a new session
setopt INC_APPEND_HISTORY


# Enable colors
autoload -U colors && colors


# Customize prompt in Longhorn colors \m/ plus git branch info
autoload -Uz vcs_info
precmd () { vcs_info }
setopt PROMPT_SUBST
# Color codes for 256 color terminals https://unix.stackexchange.com/questions/124407/what-color-codes-can-i-use-in-my-bash-ps1-prompt/124409#124409
zstyle ':vcs_info:git:*' formats ' %F{222}[%b]%f'
PROMPT='%F{166}%B%n@MBP%b %~%f${vcs_info_msg_0_} %# '


# Enable ls colors:
# - LSCOLORS is BSD style, less options, used by /bin/ls on MacOS
# - LS_COLORS is GNU style, more options, used by zsh tab completions
# export LSCOLORS="exfxcxdxbxegedabagacad" # uncomment to override defaults of /bin/ls
# LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43" # uncomment to override defaults of tab completion
# 
# references:
# - https://gist.github.com/thomd/7667642
# - http://www.bigsoft.co.uk/blog/2008/04/11/configuring-ls_colors


# Built-in tab completion:
autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # see ls colors above
# case-insensitive (uppercase from lowercase) completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zmodload zsh/complist
compinit
_comp_options+=(globdots)   # Include hidden files.


# Load nvm for node.js
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


# Add Homebrew to path
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"


# Load aliases:
[[ -f $ZDOTDIR/.zshaliases ]] && source $ZDOTDIR/.zshaliases


# Enable Zsh's actual run-help function (by default it is aliased to 'man')
unalias run-help
autoload -Uz run-help
HELPDIR="/usr/local/share/zsh/help"
# pipe run-help into less
alias run-help='function _run-help(){run-help "$@" | less}; _run-help'
# omit loading run-help helper functions for now https://wiki.archlinux.org/title/zsh


# Load zsh-autosuggestions
# https://github.com/zsh-users/zsh-autosuggestions
# source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"


# Load zsh-syntax-highlighting (should be sourced very last)
# https://github.com/zsh-users/zsh-syntax-highlighting
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# bun completions
[ -s "/Users/ryantipps/.bun/_bun" ] && source "/Users/ryantipps/.bun/_bun"

# pnpm
export PNPM_HOME="/Users/ryantipps/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
