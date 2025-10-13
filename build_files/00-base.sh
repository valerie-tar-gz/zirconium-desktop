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

# This package adds "[systemd] Failed Units: *" to the bashrc startup
dnf -y remove console-login-helper-messages \
    chrony

dnf -y install \
    plymouth \
    plymouth-system-theme \
    fwupd \
    libcamera{,-{v4l2,gstreamer,tools}} \
    whois \
    plymouth \
    tuned \
    tuned-ppd \
    unzip \
    steam-devices

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

systemctl preset systemd-resolved.service

dnf -y copr enable ublue-os/packages
dnf -y copr disable ublue-os/packages
dnf -y --enablerepo copr:copr.fedorainfracloud.org:ublue-os:packages install \
	ublue-brew \
	uupd \
	ublue-os-udev-rules
systemctl enable brew-setup.service
systemctl enable uupd.timer
