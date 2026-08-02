#!/usr/bin/env bash
# toggle-libx265.sh — liga/desliga o libx265 do sistema (.so e .a) para
# evitar que o linker do ffmpeg (build via Conan) resolva -lx265 para o
# arquivo errado (do apt, build diferente do que o Conan compilou).
#
# Uso:
#   ./toggle-libx265.sh status    # mostra o estado atual
#   ./toggle-libx265.sh off       # desliga (renomeia .disabled)
#   ./toggle-libx265.sh on        # religa (renomeia de volta)
#   ./toggle-libx265.sh toggle    # alterna o estado atual

set -euo pipefail

LIB_SO="/usr/lib/x86_64-linux-gnu/libx265.so"
LIB_A="/usr/lib/x86_64-linux-gnu/libx265.a"
DISABLED_SO="${LIB_SO}.disabled"
DISABLED_A="${LIB_A}.disabled"

status() {
    for pair in "$LIB_SO:$DISABLED_SO" "$LIB_A:$DISABLED_A"; do
        lib="${pair%%:*}"
        disabled="${pair##*:}"
        if [ -e "$lib" ]; then
            echo "LIGADO    -> $lib"
        elif [ -e "$disabled" ]; then
            echo "DESLIGADO -> $lib (backup em $disabled)"
        else
            echo "AUSENTE   -> $lib (nenhuma versão encontrada)"
        fi
    done
}

off() {
    for pair in "$LIB_SO:$DISABLED_SO" "$LIB_A:$DISABLED_A"; do
        lib="${pair%%:*}"
        disabled="${pair##*:}"
        if [ -e "$lib" ]; then
            sudo mv "$lib" "$disabled"
            echo "✓ Desligado: $lib -> $disabled"
        elif [ -e "$disabled" ]; then
            echo "Já desligado: $lib"
        else
            echo "Nada a desligar: $lib (não encontrado)"
        fi
    done
}

on() {
    for pair in "$LIB_SO:$DISABLED_SO" "$LIB_A:$DISABLED_A"; do
        lib="${pair%%:*}"
        disabled="${pair##*:}"
        if [ -e "$disabled" ]; then
            sudo mv "$disabled" "$lib"
            echo "✓ Ligado: $disabled -> $lib"
        elif [ -e "$lib" ]; then
            echo "Já ligado: $lib"
        else
            echo "Nada a ligar: $lib (backup não encontrado)"
        fi
    done
}

toggle() {
    if [ -e "$LIB_SO" ] || [ -e "$LIB_A" ]; then
        off
    else
        on
    fi
}

case "${1:-}" in
    status) status ;;
    off) off ;;
    on) on ;;
    toggle) toggle ;;
    *)
        echo "Uso: $0 {status|on|off|toggle}"
        exit 1
        ;;
esac
