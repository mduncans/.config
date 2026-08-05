#!/bin/sh
# Clear all kitty-graphics images (ghosted nvim diagrams etc.) from the terminal
printf '\033Ptmux;\033\033_Ga=d,d=A\033\033\\\033\\' > "$(tmux display -p '#{pane_tty}')"
