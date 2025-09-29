#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Basic tools
dnf5 install -y tuigreet flatpak micro

# Install Bazzite Kernel
dnf5 install https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-114/kernel-6.16.4-114.bazzite.fc42.x86_64.rpm \ #Kernel
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-114/kernel-core-6.16.4-114.bazzite.fc42.x86_64.rpm \ #Kernel Core
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-114/kernel-devel-6.16.4-114.bazzite.fc42.x86_64.rpm \ #Kernel Devel
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-114/kernel-devel-matched-6.16.4-114.bazzite.fc42.x86_64.rpm \ #Kernel Devel Matched
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-114/kernel-modules-6.16.4-114.bazzite.fc42.x86_64.rpm \ #Kernel Modules
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-114/kernel-modules-core-6.16.4-114.bazzite.fc42.x86_64.rpm \ #Kernel Modules Core
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-114/kernel-modules-extra-6.16.4-114.bazzite.fc42.x86_64.rpm \ #Kernel Modules Extra
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-114/kernel-modules-extra-matched-6.16.4-114.bazzite.fc42.x86_64.rpm \ #Kernel Modules Extra Matched
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-114/kernel-modules-internal-6.16.4-114.bazzite.fc42.x86_64.rpm \ #Kernel Modules Internal
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-114/kernel-tools-6.16.4-114.bazzite.fc42.x86_64.rpm \ #Kernel Tools
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-114/kernel-tools-debuginfo-6.16.4-114.bazzite.fc42.x86_64.rpm \ #Kernel Tools Debuginfo
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-114/kernel-tools-libs-6.16.4-114.bazzite.fc42.x86_64.rpm \ #Kernel Tools Libs
https://github.com/bazzite-org/kernel-bazzite/releases/download/6.16.4-114/kernel-tools-libs-devel-6.16.4-114.bazzite.fc42.x86_64.rpm \ #Kernel Tools Libs Devel

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
