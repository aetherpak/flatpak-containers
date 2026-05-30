# Flatpak Containers

Multi-stage Fedora-based container images for Flatpak application packaging.

## Images

1. **Flatpak Base Image (`ghcr.io/aetherpak/flatpak:latest`)**: Includes minimal Fedora utilities with `flatpak` and `ostree`.
2. **Flatpak Builder Image (`ghcr.io/aetherpak/flatpak-builder:latest`)**: Includes `flatpak-builder` and `elfutils` for compiling and building flatpaks.

## Development

Use `make setup` to initialize pre-commit hooks and `make lint` to run quality checks.
