#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Basic tools
dnf5 install -y tuigreet flatpak micro

#Bazzite Kernel (Currently has to be manually updated. I don't like that! One day it can change.)
sudo dnf5 install -y https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-111/kernel-modules-core-6.16.4-111.bazzite.fc42.x86_64.rpm \ #Kernel-Modules-Core
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-111/kernel-core-6.16.4-111.bazzite.fc42.x86_64.rpm \ #Kernel-core
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-111/kernel-modules-6.16.4-111.bazzite.fc42.x86_64.rpm \ #Kernel-modules
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-111/kernel-modules-extra-6.16.4-111.bazzite.fc42.x86_64.rpm \ #Kernel-modules-extra
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-111/kernel-devel-6.16.4-111.bazzite.fc42.x86_64.rpm \ #Kernel-devel
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-111/kernel-tools-libs-6.16.4-111.bazzite.fc42.x86_64.rpm \ #Kernel-tools-libs
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-111/kernel-tools-6.16.4-111.bazzite.fc42.x86_64.rpm \ #Kernel-tools
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-111/kernel-devel-matched-6.16.4-111.bazzite.fc42.x86_64.rpm \ #Kernel-devel-matched
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-111/kernel-6.16.4-111.bazzite.fc42.x86_64.rpm \ #Kernel


# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
