if status is-interactive
    set fish_greeting $(date)
end

direnv hook fish | source

alias trash="gio trash"
alias gedit="gnome-text-editor"
