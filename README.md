# gel
⛏ Rolling Podman container images, batteries included.

## Usage
1. Spin up one of the available Gel flavours (`debian`, `alpine`, `opensuse`, `rocky` and `fedora`).
    1. Image is available on the [Docker Hub](https://hub.docker.com/r/ltgc/gel) if you want to save time. Use `podman pull docker.io/ltgc/gel:<flavour>` to pull the image.
    2. Or feel free to build the image yourself with `./shx up <flavour>`.
2. Connect to the SSH with `ssh -p 1122 root@127.0.1.1`. The default password is `root`.

## Docs
Visit [kb.ltgc.cc](https://kb.ltgc.cc/gel/) for documentation.