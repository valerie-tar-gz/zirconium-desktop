default:
    @zjust --choose

zdots-update:
    #!/usr/bin/env bash
    yes s | chezmoi apply --no-tty --keep-going -S "/usr/share/zirconium/zdots" --verbose --config "$HOME/.config/zirconium/chezmoi/chezmoi.toml"

zdots-reset FILE:
    #!/usr/bin/env bash
    chezmoi apply --force -S "/usr/share/zirconium/zdots" --verbose --config "$HOME/.config/zirconium/chezmoi/chezmoi.toml" {{FILE}}

zdots-override-all:
    #!/usr/bin/env bash
    chezmoi apply --force -S "/usr/share/zirconium/zdots" --verbose --config "$HOME/.config/zirconium/chezmoi/chezmoi.toml" 

toggle-user-motd:
    #!/usr/bin/env bash

    TARGET="${XDG_CONFIG_HOME:-$HOME/.config}/zirconium/no-show-user-motd"

    if [ -e "$TARGET" ] ; then
         rm -r "${TARGET}"
         echo "Enabled the MOTD"
    else
        mkdir -p "$(dirname "$(realpath ${TARGET})")"
        touch "${TARGET}"
        echo "Disabled the MOTD"
    fi
