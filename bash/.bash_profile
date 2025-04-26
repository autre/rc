source ~/.bashrc

export MOZ_ENABLE_WAYLAND=1

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec sway
fi
