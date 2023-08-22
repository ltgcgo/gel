# gel
⛏ Rolling server container images, batteries included.

## Usage
### Containers
1. Spin up one of the available Gel flavours (`debian`, `alpine`, `opensuse`, `rocky` and `fedora`).
    1. Image is available on the [Docker Hub](https://hub.docker.com/r/ltgc/gel) if you want to save time. Use `podman pull docker.io/ltgc/gel:<flavour>` to pull the image.
    2. Or feel free to build the image yourself with `./shx up <flavour>`.
2. Connect to the SSH with `ssh -p 1122 root@127.0.1.1`. The default password is `root`.

### Native
1. On any of the supported distros, make sure `curl` is available.
2. Execute `sh <(curl -Ls https://github.com/ltgcgo/gel/releases/latest/download/install.sh)`.
3. Connect to the SSH with `ssh -p 1122 <serverIP>`. The default password is `root`.

## Docs
Visit [kb.ltgc.cc](https://kb.ltgc.cc/gel/) for documentation.