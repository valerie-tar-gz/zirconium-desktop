#!/bin/bash

set -xeuo pipefail

install -d /usr/share/zirconium/

dnf -y copr enable yalter/niri
#dnf -y copr disable yalter/niri
#dnf -y --enablerepo copr:copr.fedorainfracloud.org:yalter:niri install niri
dnf -y install niri
dnf -y copr disable yalter/niri
rm -rf /usr/share/doc/niri

dnf -y copr enable errornointernet/quickshell
#dnf -y --enablerepo copr:copr.fedorainfracloud.org:errornointernet:quickshell install quickshell
dnf -y install quickshell
dnf -y copr disable errornointernet/quickshell

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
systemctl enable --global noctalia
systemctl enable --global xwayland-satellite
systemctl enable --global foot-server

git clone "https://github.com/noctalia-dev/noctalia-shell/" /usr/share/zirconium/noctalia-shell
