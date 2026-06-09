# Pin Fedora Minimal as base
ARG FEDORA_DIGEST=sha256:673e2dd3288620989514c72e6b4b29fdd9b92adb59f12901505bd7348ff32b84
ARG BASE_IMAGE=flatpak

FROM registry.fedoraproject.org/fedora-minimal@${FEDORA_DIGEST} AS flatpak

LABEL org.opencontainers.image.title="AetherPak Flatpak Base" \
      org.opencontainers.image.description="Minimal Fedora image with flatpak and ostree utilities" \
      org.opencontainers.image.source="https://github.com/aetherpak/flatpak-containers" \
      org.opencontainers.image.licenses="MIT"

# Install flatpak, ostree and standard utilities (including gnupg2 for signing)
RUN microdnf install -y --setopt=install_weak_deps=0 --nodocs \
        flatpak \
        ostree \
        ca-certificates \
        git \
        jq \
        curl \
        tar \
        gzip \
        gnupg2 \
        shared-mime-info \
        dbus-daemon \
    && microdnf clean all \
    && rm -rf /var/cache/dnf /var/lib/dnf/history* \
    && /usr/bin/flatpak --version

# Pre-configure Flathub repository remote
RUN flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

WORKDIR /workspace
CMD ["/bin/bash"]


FROM ${BASE_IMAGE} AS flatpak-builder

LABEL org.opencontainers.image.title="AetherPak Flatpak Builder" \
      org.opencontainers.image.description="Fedora base image with flatpak-builder and compilation dependencies"

# Install flatpak-builder, compilation helpers, and metadata validators
RUN microdnf install -y --setopt=install_weak_deps=0 --nodocs \
        flatpak-builder \
        elfutils \
        appstream \
        desktop-file-utils \
        python3-pip \
        gobject-introspection \
        cairo \
        patch \
        unzip \
        bzip2 \
        zstd \
    && microdnf clean all \
    && rm -rf /var/cache/dnf /var/lib/dnf/history*

# Install temporary build dependencies, compile flatpak-builder-lint, and clean up
RUN microdnf install -y --nodocs \
        gcc \
        pkgconf \
        cairo-devel \
        cairo-gobject-devel \
        gobject-introspection-devel \
        python3-devel \
        glib2-devel \
    && pip3 install --no-cache-dir git+https://github.com/flathub-infra/flatpak-builder-lint.git \
    && microdnf remove -y \
        gcc \
        cairo-devel \
        cairo-gobject-devel \
        gobject-introspection-devel \
        python3-devel \
        glib2-devel \
    && microdnf clean all \
    && rm -rf /var/cache/dnf /var/lib/dnf/history*
