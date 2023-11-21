# gel
⛏ Rolling server bases, batteries included.

## Usage
### Native
For bare-metal, virtual machines and LXC containers.

1. On any of the supported distros, make sure `curl` is available.
2. Execute `sh <(curl -Ls https://github.com/ltgcgo/gel/releases/latest/download/install.sh)`.
3. Connect to the SSH with `ssh -p 1122 <serverIP>`. User passwords won't change, but SSH settings will.

### Containers
Container images are only offered as a convenient way of inspecting the installations.

1. Spin up one of the available Gel flavours.
    1. Images are available on the [Docker Hub](https://hub.docker.com/r/ltgc/gel) if you want to save time. Use `podman pull docker.io/ltgc/gel:<flavour>` to pull the images.
    2. Or feel free to build the image yourself with `./shx up <flavour>`.
2. Connect to the SSH with `ssh -p 1122 root@127.0.1.1`. The default password is `root`.

## Docs
Visit [kb.ltgc.cc](https://kb.ltgc.cc/gel/) for documentation.