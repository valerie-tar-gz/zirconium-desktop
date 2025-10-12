#!/bin/bash

set -xeuo pipefail

install -d /usr/share/zirconium/

dnf -y copr enable yalter/niri
dnf -y copr disable yalter/niri
dnf -y --enablerepo copr:copr.fedorainfracloud.org:yalter:niri install niri
rm -rf /usr/share/doc/niri

dnf -y copr enable errornointernet/quickshell
dnf -y copr disable errornointernet/quickshell
dnf -y --enablerepo copr:copr.fedorainfracloud.org:errornointernet:quickshell install quickshell

# # Extracts colors from wallpapers
# # TODO: MOVE TO OUR THING INSTEAD
# dnf -y copr enable purian23/matugen
# dnf -y copr disable purian23/matugen
# dnf -y --enablerepo copr:copr.fedorainfracloud.org:puritan23/matugen install matugen

dnf -y copr enable ublue-os/packages
#dnf -y --enablerepo copr:copr.fedorainfracloud.org:ublue-os:packages install \
#	ublue-brew \
#	uupd
dnf -y install ublue-brew uupd
dnf -y copr disable ublue-os/packages
systemctl enable brew-setup.service
systemctl enable uupd.service

dnf -y remove alacritty
dnf -y install \
    brightnessctl \
    chezmoi \
    fastfetch \
    flatpak \
    foot \
    fpaste \
    gamescope \
    git-core \
    gnome-keyring \
    greetd \
    greetd-selinux \
    just \
    nautilus \
    orca \
    pipewire \
    tuigreet \
    wireplumber \
    wl-clipboard \
    wlsunset \
    xdg-desktop-portal-gnome \
    xwayland-satellite

rm -rf /usr/share/doc/just

systemctl enable greetd
systemctl enable firewalld

cp -avf "/ctx/files"/. /
mkdir -p /etc/skel/Pictures/Wallpapers
ln -s /usr/share/zirconium/skel/Pictures/Wallpapers/mountains.png /etc/skel/Pictures/Wallpapers/mountains.png
ln -s /usr/share/zirconium/skel/.face /etc/skel/.face
file /etc/skel/.face | grep -F -e "empty" -v
file /etc/skel/Pictures/Wallpapers/* | grep -F -e "empty" -v
file /etc/niri/config.kdl | grep -F -e "empty" -v

systemctl preset --global noctalia
systemctl preset --global xwayland-satellite
systemctl preset --global foot-server
systemctl preset --global chezmoi-init
systemctl preset --global chezmoi-update
systemctl enable --global noctalia.service
systemctl enable --global xwayland-satellite.service
systemctl enable --global foot-server.service
systemctl enable --global chezmoi-init.service
systemctl enable --global chezmoi-update.timer

git clone "https://github.com/noctalia-dev/noctalia-shell.git" /usr/share/zirconium/noctalia-shell
git clone "https://github.com/zirconium-dev/zdots.git" /usr/share/zirconium/zdots
install -d /etc/niri/
cp -f /usr/share/zirconium/zdots/dot_config/niri/config.kdl /etc/niri/config.kdl

mkdir -p "/usr/share/fonts/Maple Mono"

MAPLE_TMPDIR="$(mktemp -d)"
trap 'rm -rf "${MAPLE_TMPDIR}"' EXIT

LATEST_RELEASE_FONT="$(curl "https://api.github.com/repos/subframe7536/maple-font/releases/latest" | jq '.assets[] | select(.name == "MapleMono-Variable.zip") | .browser_download_url' -rc)"
curl -fSsLo "${MAPLE_TMPDIR}/maple.zip" "${LATEST_RELEASE_FONT}"
unzip "${MAPLE_TMPDIR}/maple.zip" -d "/usr/share/fonts/Maple Mono"
