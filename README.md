# LVGL ported to Verdin iMX8MP on Torizon OS

## Overview

This guide provides steps to cross-compile an LVGL project for the Verdin iMX8MP from Toradex. The project is based on the [lv_port_pc_vscode](https://github.com/lvgl/lv_port_pc_vscode/tree/release/v8) repository.

Torizon OS includes a pre-installed Docker runtime, enabling the use of containers. This repository offers instructions on how to run the cross-compiled LVGL demo inside a container on top of the [Weston](https://wiki.archlinux.org/title/Weston) compositor.

## Buy

You can purchase the Verdin iMX8MP and compatible carrier boards directly from Toradex.

## Specification

### CPU and Memory
- **Module:** Vedin iMX8MP
- **RAM:** 4GB internal
- **Flash:** 32GB internal
- **GPU:** 2D: Vivante GC520L / 3D: Vivante GC7000UL

## Getting started

### Hardware setup
- Insert the Verdin iMX8MP module into one of Toradex’s carrier boards.
- Connect a display to the carrier board. HDMI, LVDS, or DSI displays can be used by default.

### Software setup
- Ensure the Verdin iMX8MP module is running Torizon OS.
- On the host, set up the toolchain to cross-compile the binary for ARM32/ARM64. You can download the toolchain or use the cross-toolchain containers available on DockerHub. For instance:
```bash
docker pull torizon/debian-cross-toolchain-arm64
```

### Build the binary on the host
- Clone this repository repository:
```bash
git clone --recursive https://github.com/lvgl/lv_port_toradex_verdin_imx8m_plus.git
```

- SStart the cross-compiler container, mounting the repository:
```bash
docker run -it -v ${PWD}:/workdir torizon/debian-cross-toolchain-arm64 /bin/bash
```

- Install X11 dependencies inside the container:
```bash
apt-get update &&  apt-get install -y libx11-dev:arm64
```

- Compile the project:
```bash
cd /workdir
make
```

- Transfer the generated binary to the module:
```bash
scp build/bin/demo torizon@board-ip:/home/torizon
```

### Run the binary on the module

- Start the Weston compositor:
```bash
docker run -e ACCEPT_FSL_EULA=1 -d --rm --name=weston --net=host --cap-add CAP_SYS_TTY_CONFIG \
             -v /dev:/dev -v /tmp:/tmp -v /run/udev/:/run/udev/ \
             --device-cgroup-rule='c 4:* rmw' --device-cgroup-rule='c 13:* rmw' \
             --device-cgroup-rule='c 199:* rmw' --device-cgroup-rule='c 226:* rmw' \
             torizon/weston-vivante:$CT_TAG_WESTON_VIVANTE --developer --tty=/dev/tty7
```

- Create a Dockerfile with the following content:
```Dockerfile
FROM torizon/debian:3.3-bookworm

# Install dependencies
RUN apt-get update && apt-get install libx11-dev

# Copy the binary to the container
COPY ./demo /

# Execute the binary
CMD ["/demo"]
```

- Build the LVGL container:
```bash
docker build -t lvgl-example .
```

- Run the generated container:
```bash
docker run -it --rm -e DISPLAY=:0 -u $(id -u):$(id -g) -v /dev:/dev -v /tmp:/tmp -v /run/udev/:/run/udev/ --device -cgroup-rule='c 4:* rmw' --device-cgroup-rule='c 13:* rmw' --device-cgroup-rule='c 199:* rmw' --device-cgroup-rule='c 226:* rmw' lvgl-example
```

### Debugging

- Since the demo is based on the - Since the demo is based on [lv_port_pc_vscode](), it's possible to debug it on VSCode before deploying the binary.

## Contribution and Support

If you find any issues with the development board feel free to open an Issue in this repository. For LVGL related issues (features, bugs, etc) please use the main [lvgl repository](https://github.com/lvgl/lvgl).

If you found a bug and found a solution too please send a Pull request. If you are new to Pull requests refer to [Our Guide](https://docs.lvgl.io/master/CONTRIBUTING.html#pull-request) to learn the basics.
