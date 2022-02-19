#!/bin/sh

# source: https://vi.stackexchange.com/questions/9754/how-to-change-vim-background-color-in-hex-code-or-rgb-color-code

for i in {0..255} ; do
    printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"
    if (( i == 15 )) || (( i > 15 )) && (( (i-15) % 6 == 0 )); then
        printf "\n";
    fi
done
