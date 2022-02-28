export CLASSPATH=.:/usr/share/java/
export TEXINPUTS=.:/usr/share/texmf-texlive/tex/latex/prosper

alias tailf='tail -f'
alias ll='ls -lh'
alias lt='ls -lhrt'
alias ssh='ssh -q'
alias bos-start='sudo systemctl start bosecr-back'
alias bos-stop='sudo systemctl stop bosecr-back'
alias vpn-cirb='sudo openfortivpn -c /etc/openfortivpn/config'
alias pull='git stash; git pull; git stash pop'

alias movieEncoding='ffprobe -show_entries stream=codec_name,codec_tag_string,bit_rate -v error'
alias heyaml='/home/mlefevre/DEV/devops/puppet-stack-bos/bin/eyaml.sh'
