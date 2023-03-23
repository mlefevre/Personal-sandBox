# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=500
SAVEHIST=500
setopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/mlefevre/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
if [ -e /home/mlefevre/.nix-profile/etc/profile.d/nix.sh ]; then . /home/mlefevre/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# Personal configuration
. ~/Personal-sandBox/bashConfig/git-prompt.sh

export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='%F{yellow}[%*]%F{blue} @ %d %F{yellow}$(__git_ps1 " (%s)")%F{green}
%n %#%F{white} '

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi

# Hook direnv on bash console ; see direnv.net
eval "$(direnv hook bash)"

# define Nix path variable for overlay definition
export NIX_PATH=$NIX_PATH:nixpkgs-overlays=http://stash.cirb.lan/CICD/nixpkgs-overlays/archive/20.09.tar.gz

