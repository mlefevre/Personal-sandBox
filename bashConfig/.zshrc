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
