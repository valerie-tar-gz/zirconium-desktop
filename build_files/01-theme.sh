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

dnf -y copr enable scottames/ghostty
dnf -y copr disable scottames/ghostty
dnf -y --enablerepo copr:copr.fedorainfracloud.org:scottames:ghostty install ghostty

dnf -y copr enable alternateved/cliphist
dnf -y copr disable alternateved/cliphist
dnf -y --enablerepo copr:copr.fedorainfracloud.org:alternateved:cliphist install cliphist


# # Extracts colors from wallpapers
# # TODO: MOVE TO OUR THING INSTEAD
# dnf -y copr enable purian23/matugen
# dnf -y copr disable purian23/matugen
# dnf -y --enablerepo copr:copr.fedorainfracloud.org:puritan23/matugen install matugen

dnf -y remove alacritty
dnf -y install \
    brightnessctl \
    chezmoi \
    ddcutil \
    fastfetch \
    flatpak \
    fpaste \
    fzf \
    git-core \
    gnome-keyring \
    greetd \
    greetd-selinux \
    just \
    nautilus \
    orca \
    pipewire \
    tuigreet \
    udiskie \
    wireplumber \
    wl-clipboard \
    wlsunset \
    xdg-desktop-portal-gnome \
    xdg-user-dirs \
    xwayland-satellite
rm -rf /usr/share/doc/just

sed -i '/gnome_keyring.so/ s/-auth/auth/ ; /gnome_keyring.so/ s/-session/session/' /etc/pam.d/greetd
cat /etc/pam.d/greetd

dnf install -y --setopt=install_weak_deps=False \
    kf6-kirigami \
    polkit-kde

sed -i "s/After=.*/After=graphical-session.target/" /usr/lib/systemd/user/plasma-polkit-agent.service

# Codecs for video thumbnails on nautilus
dnf config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-multimedia.repo
dnf config-manager setopt fedora-multimedia.enabled=0
dnf -y install --enablerepo=fedora-multimedia \
    ffmpeg libavcodec @multimedia gstreamer1-plugins-{bad-free,bad-free-libs,good,base} lame{,-libs} libjxl ffmpegthumbnailer

add_wants_niri() {
    sed -i "s/\[Unit\]/\[Unit\]\nWants=$1/" "/usr/lib/systemd/user/niri.service"
}
add_wants_niri noctalia.service
add_wants_niri plasma-polkit-agent.service
add_wants_niri swayidle.service
add_wants_niri udiskie.service
add_wants_niri xwayland-satellite.service
cat /usr/lib/systemd/user/niri.service

systemctl enable greetd
systemctl enable firewalld

# Sacrificed to the :steamhappy: emoji old god
dnf install -y \
    default-fonts-core-emoji \
    google-noto-fonts-all \
    google-noto-color-emoji-fonts \
    google-noto-emoji-fonts \
    glibc-all-langpacks

cp -avf "/ctx/files"/. /
mkdir -p /etc/skel/Pictures/Wallpapers
ln -s /usr/share/zirconium/skel/Pictures/Wallpapers/mountains.png /etc/skel/Pictures/Wallpapers/mountains.png
ln -s /usr/share/zirconium/skel/.face /etc/skel/.face
file /etc/skel/.face | grep -F -e "empty" -v
file /etc/skel/Pictures/Wallpapers/* | grep -F -e "empty" -v

systemctl enable --global chezmoi-init.service
systemctl enable --global chezmoi-update.timer
systemctl enable --global noctalia.service
systemctl enable --global plasma-polkit-agent.service
systemctl enable --global swayidle.service
systemctl enable --global udiskie.service
systemctl enable --global xwayland-satellite.service
systemctl preset --global chezmoi-init
systemctl preset --global chezmoi-update
systemctl preset --global noctalia
systemctl preset --global plasma-polkit-agent
systemctl preset --global swayidle
systemctl preset --global udiskie
systemctl preset --global xwayland-satellite

git clone "https://github.com/noctalia-dev/noctalia-shell.git" /usr/share/zirconium/noctalia-shell
cp /etc/skel/Pictures/Wallpapers/mountains.png /usr/share/zirconium/noctalia-shell/Assets/Wallpaper/noctalia.png
git clone "https://github.com/zirconium-dev/zdots.git" /usr/share/zirconium/zdots
install -d /etc/niri/
cp -f /usr/share/zirconium/zdots/dot_config/niri/config.kdl /etc/niri/config.kdl
file /etc/niri/config.kdl | grep -F -e "empty" -v
stat /etc/skel/.face /etc/skel/Pictures/Wallpapers/* /etc/niri/config.kdl

mkdir -p "/usr/share/fonts/Maple Mono"

MAPLE_TMPDIR="$(mktemp -d)"
trap 'rm -rf "${MAPLE_TMPDIR}"' EXIT

LATEST_RELEASE_FONT="$(curl "https://api.github.com/repos/subframe7536/maple-font/releases/latest" | jq '.assets[] | select(.name == "MapleMono-Variable.zip") | .browser_download_url' -rc)"
curl -fSsLo "${MAPLE_TMPDIR}/maple.zip" "${LATEST_RELEASE_FONT}"
unzip "${MAPLE_TMPDIR}/maple.zip" -d "/usr/share/fonts/Maple Mono"

echo 'source /usr/share/zirconium/shell/pure.bash' | tee -a "/etc/bashrc"
