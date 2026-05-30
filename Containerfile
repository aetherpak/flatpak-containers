# Pin Fedora Minimal as base
ARG FEDORA_DIGEST=sha256:673e2dd3288620989514c72e6b4b29fdd9b92adb59f12901505bd7348ff32b84
ARG BASE_IMAGE=flatpak

FROM registry.fedoraproject.org/fedora-minimal@${FEDORA_DIGEST} AS flatpak

LABEL org.opencontainers.image.title="AetherPak Flatpak Base" \
      org.opencontainers.image.description="Minimal Fedora image with flatpak and ostree utilities" \
      org.opencontainers.image.source="https://github.com/aetherpak/flatpak-containers" \
      org.opencontainers.image.licenses="MIT"

# Install flatpak, ostree and standard utilities
RUN microdnf install -y --setopt=install_weak_deps=0 --nodocs \
        flatpak \
        ostree \
        ca-certificates \
        git \
        jq \
        curl \
        tar \
        gzip \
    && microdnf clean all \
    && rm -rf /var/cache/dnf /var/lib/dnf/history* \
    && /usr/bin/flatpak --version

WORKDIR /workspace
CMD ["/bin/bash"]


FROM ${BASE_IMAGE} AS flatpak-builder

LABEL org.opencontainers.image.title="AetherPak Flatpak Builder" \
      org.opencontainers.image.description="Fedora base image with flatpak-builder and compilation dependencies"

# Install flatpak-builder and debugging/compile helper tools
RUN microdnf install -y --setopt=install_weak_deps=0 --nodocs \
        flatpak-builder \
        elfutils \
    && microdnf clean all \
    && rm -rf /var/cache/dnf /var/lib/dnf/history*
