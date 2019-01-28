export CLASSPATH=.:/usr/share/java/
export TEXINPUTS=.:/usr/share/texmf-texlive/tex/latex/prosper

alias tailf='tail -f'
alias ll='ls -lh'
alias lt='ls -lhrt'
alias bos-start='sudo systemctl start bosecr-back'
alias bos-stop='sudo systemctl stop bosecr-back'

alias movieEncoding='ffprobe -show_entries stream=codec_name,codec_tag_string,bit_rate -v error'
