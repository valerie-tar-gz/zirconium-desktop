#!/bin/bash

set -xeuo pipefail

systemctl enable systemd-timesyncd
systemctl enable systemd-resolved.service

dnf -y install dnf-plugins-core 'dnf5-command(config-manager)'

dnf config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
dnf config-manager setopt tailscale-stable.enabled=0
dnf -y install --enablerepo='tailscale-stable' tailscale

systemctl enable tailscaled

dnf -y install \
    NetworkManager-wifi \
    atheros-firmware \
    brcmfmac-firmware \
    iwlegacy-firmware \
    iwlwifi-dvm-firmware \
    iwlwifi-mvm-firmware \
    mt7xxx-firmware \
    nxpwireless-firmware \
    realtek-firmware \
    tiwilink-firmware \
    firewalld

dnf -y remove \
    chrony # :vlone:

dnf -y install \
    whois \
    plymouth \
    tuned \
    tuned-ppd

systemctl enable firewalld

sed -i 's|^ExecStart=.*|ExecStart=/usr/bin/bootc update --quiet|' /usr/lib/systemd/system/bootc-fetch-apply-updates.service
sed -i 's|^OnUnitInactiveSec=.*|OnUnitInactiveSec=7d\nPersistent=true|' /usr/lib/systemd/system/bootc-fetch-apply-updates.timer
sed -i 's|#AutomaticUpdatePolicy.*|AutomaticUpdatePolicy=stage|' /etc/rpm-ostreed.conf
sed -i 's|#LockLayering.*|LockLayering=true|' /etc/rpm-ostreed.conf

systemctl enable bootc-fetch-apply-updates

tee /usr/lib/systemd/zram-generator.conf <<'EOF'
[zram0]
zram-size = min(ram, 8192)
EOF

tee /usr/lib/systemd/system-preset/91-resolved-default.preset <<'EOF'
enable systemd-resolved.service
EOF
tee /usr/lib/tmpfiles.d/resolved-default.conf <<'EOF'
L /etc/resolv.conf - - - - ../run/systemd/resolve/stub-resolv.conf
EOF

# GO AWAY fedora flatpaks.
rm -f /usr/lib/systemd/system/flatpak-add-fedora-repos.service
mkdir -p /etc/flatpak/remotes.d/
dnf remove -y fedora-flathub-remote fedora-third-party
mkdir -p /etc/flatpak/remotes.d/
curl --retry 3 -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo
rm -rf /usr/lib/systemd/system/flatpak-add-fedora-repos.service

systemctl preset systemd-resolved.service

HOME_URL="https://github.com/valerie-tar-gz/zirconium"
echo "zirconium" | tee "/etc/hostname"
# OS Release File (changed in order with upstream)
# TODO: change ANSI_COLOR
sed -i -f - /usr/lib/os-release <<EOF
s|^NAME=.*|NAME=\"Zirconium\"|
s|^ID=.*|ID=\"zirconium\"|
s|^PRETTY_NAME=.*|PRETTY_NAME=\"Zirconium\"|
s|^VERSION_CODENAME=.*|VERSION_CODENAME=\"Pants\"|
s|^VARIANT_ID=.*|VARIANT_ID=""|
s|^HOME_URL=.*|HOME_URL=\"${HOME_URL}\"|
s|^BUG_REPORT_URL=.*|BUG_REPORT_URL=\"${HOME_URL}/issues\"|
s|^SUPPORT_URL=.*|SUPPORT_URL=\"${HOME_URL}/issues\"|
s|^CPE_NAME=\".*\"|CPE_NAME=\"cpe:/o:valerie-tar-gz:zirconium\"|
s|^DOCUMENTATION_URL=.*|"${HOME_URL}"|
s|^DEFAULT_HOSTNAME=.*|DEFAULT_HOSTNAME="zirconium"|

/^REDHAT_BUGZILLA_PRODUCT=/d
/^REDHAT_BUGZILLA_PRODUCT_VERSION=/d
/^REDHAT_SUPPORT_PRODUCT=/d
/^REDHAT_SUPPORT_PRODUCT_VERSION=/d
EOF
