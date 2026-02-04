bindkey -v
export KEYTIMEOUT=1

function zle-keymap-select {
    if [[ $KEYMAP == vicmd ]]; then
        echo -ne '\e[2 q'  # block
    else
        echo -ne '\e[6 q'  # beam
    fi
}

zle -N zle-keymap-select
echo -ne '\e[6 q'
