default:
    @zjust --choose

zdots-update:
    #!/usr/bin/env bash
    yes s | chezmoi update --no-tty --keep-going -S "$HOME/.local/share/zirconium/chezmoi" --verbose --config "$HOME/.config/zirconium/chezmoi/chezmoi.toml"

zdots-reset FILE:
    #!/usr/bin/env bash
    chezmoi apply --force -S "$HOME/.local/share/zirconium/chezmoi" --verbose --config "$HOME/.config/zirconium/chezmoi/chezmoi.toml" {{FILE}}

zdots-override-all:
    #!/usr/bin/env bash
    chezmoi update --force -S "$HOME/.local/share/zirconium/chezmoi" --verbose --config "$HOME/.config/zirconium/chezmoi/chezmoi.toml" 

