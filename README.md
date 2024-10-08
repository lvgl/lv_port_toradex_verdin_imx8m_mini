# LVGL ported to verdin imx8mm



## Overview

This guide provides steps to setup the Verdin imx8m Mini and run a cross-compiled LVGL application on the target.

This guide is done with Verdin imx8m Mini Quad 2GB IT on Yavia carrier board.



## Buy

You can purchase the Verdin i.MX8 from [Toradex website](https://www.toradex.com/computer-on-modules/verdin-arm-family/nxp-imx-8m-mini-nano). 

There are different Verdin AM62 available: 

- Verdin i.MX8M Mini DualLite 1GB
- Verdin i.MX8M Mini DualLite 1GB WB IT
- Verdin i.MX8M Mini Quad 2GB IT
- Verdin i.MX8M Mini Quad 2GB WB IT (No CAN)
- Verdin i.MX8M Mini Quad 2GB WB IT

You can find the differences between these SOMs on the Verdin i.MX8M Datasheet [here](https://www.toradex.com/computer-on-modules/verdin-arm-family/nxp-imx-8m-mini-nano) (section 1.3).

This is a SoM (System on Module) that can be tested with a carrier board. Toradex recommends ordering one of the following carrier boards for your first-time order: 

- [Dahlia Carrier Board](https://developer.toradex.com/hardware/verdin-som-family/carrier-boards/dahlia-carrier-board/)
- [Yavia](https://developer.toradex.com/hardware/verdin-som-family/carrier-boards/verdin-development-board/)
- [Verdin Development Board](https://developer.toradex.com/hardware/verdin-som-family/carrier-boards/verdin-development-board/)



## Benchmark

The default buffering is fbdev.

**Frame buffer, 1 threads**

| Name                      | Avg. CPU | Avg. FPS | Avg. time | render time | flush time |
| ------------------------- | -------- | -------- | --------- | ----------- | ---------- |
| Empty screen              | 20.00%   | 26       | 7         | 2           | 5          |
| Moving wallpaper          | 82.00%   | 19       | 43        | 38          | 5          |
| Single rectangle          | 10.00%   | 29       | 0         | 0           | 0          |
| Multiple rectangles       | 18.00%   | 28       | 5         | 4           | 1          |
| Multiple RGB images       | 51.00%   | 27       | 19        | 14          | 5          |
| Multiple ARGB images      | 42.00%   | 27       | 13        | 8           | 5          |
| Rotated ARGB images       | 74.00%   | 27       | 26        | 21          | 5          |
| Multiple labels           | 50.00%   | 28       | 15        | 10          | 5          |
| Screen sized text         | 84.00%   | 26       | 31        | 26          | 5          |
| Multiple arcs             | 53.00%   | 27       | 16        | 11          | 5          |
| Containers                | 30.00%   | 27       | 8         | 8           | 0          |
| Containers with overlay   | 82.00%   | 20       | 40        | 35          | 5          |
| Containers with opa       | 59.00%   | 27       | 17        | 16          | 1          |
| Containers with opa_layer | 70.00%   | 24       | 28        | 26          | 2          |
| Containers with scrolling | 62.00%   | 27       | 21        | 16          | 5          |
| Widgets demo              | 28.00%   | 27       | 9         | 8           | 1          |
| All scenes avg.           | 50.00%   | 26       | 18        | 15          | 3          |

**Frame buffer, 4 threads**

| Name                      | Avg. CPU | Avg. FPS | Avg. time | render time | flush time |
| ------------------------- | -------- | -------- | --------- | ----------- | ---------- |
| Empty screen              | 21.00%   | 25       | 7         | 2           | 5          |
| Moving wallpaper          | 53.00%   | 27       | 20        | 15          | 5          |
| Single rectangle          | 11.00%   | 28       | 1         | 1           | 0          |
| Multiple rectangles       | 34.00%   | 27       | 11        | 9           | 2          |
| Multiple RGB images       | 42.00%   | 27       | 13        | 8           | 5          |
| Multiple ARGB images      | 38.00%   | 28       | 11        | 6           | 5          |
| Rotated ARGB images       | 52.00%   | 28       | 17        | 12          | 5          |
| Multiple labels           | 40.00%   | 28       | 11        | 6           | 5          |
| Screen sized text         | 55.00%   | 28       | 18        | 13          | 5          |
| Multiple arcs             | 38.00%   | 28       | 11        | 6           | 5          |
| Containers                | 49.00%   | 27       | 16        | 15          | 1          |
| Containers with overlay   | 80.00%   | 27       | 27        | 22          | 5          |
| Containers with opa       | 72.00%   | 26       | 24        | 23          | 1          |
| Containers with opa_layer | 82.00%   | 24       | 31        | 29          | 2          |
| Containers with scrolling | 52.00%   | 28       | 16        | 11          | 5          |
| Widgets demo              | 23.00%   | 27       | 9         | 8           | 1          |
| All scenes avg.           | 46.00%   | 27       | 14        | 11          | 3          |

The other configurations that can be used are:

- DRM
- Wayland

Any of these buffering strategies can be used with multiple threads to render the frames.



## Specification

### CPU and memory

- **MCU**: Verdin i.MX8M Mini Quad 2GB IT ([datasheet](https://www.toradex.com/computer-on-modules/verdin-arm-family/nxp-imx-8m-mini-nano))
  - 4 64-bit Arm® Cortex®-A53 @1.6GHz
  - Arm® Cortex®-M4F MCU @400MHz


- **RAM:** 2GB LPDDR4 RAM
  - 32-Bit data bus with inline ECC 

  - Supports speeds up to 1500 MT/s

- **Flash:** 16GB eMMC Flash
- **GPU:** 

  - Vivante GCNanoUltra GPU Units
  - Vivante GC 320 CPC Units

### Carrier board - Yavia

The guide was done on Yavia. You can find the datasheet of the carrier board [here](https://docs.toradex.com/111745-yavia-v1.0-datasheet.pdf). 



## Getting started

### Hardware setup

If it is the first time you are booting the SoM, it comes with Toradex Easy Installer by default, so you can skip the next section

### (Optional) Flash Toradex Easy Installer (Tezi)

As mentioned, this is required if you want to flash again the SoM to start with a clean setup, or because you want to change the OS version.

The following steps come from [Tezi documentation](https://developer.toradex.com/easy-installer/toradex-easy-installer/loading-toradex-easy-installer). For this guide, we will use  the USB OTG approach.

- Download Tezi [here](https://developer.toradex.com/easy-installer/toradex-easy-installer/download-tezi/). Download the lastest release, version 6 for Verdin iMX8M Mini.

- Then put the SoM in recovery mode: 

  - Plug a USB Type-C to Type-A cable into the DRP connector (J7) 
  - Connect the USB cable to your PC (host)
  - Press and hold the Recovery button (B3) while plugging the power supply cable into the J1 connector. You can also press the recovery button and press the reset button next to it.
  - Keep the B3 button pressed for 6 seconds and release it.

  If something goes wrong, there is a video showing how to enter the board in recovery mode in [Tezi documentation](https://developer.toradex.com/easy-installer/toradex-easy-installer/loading-toradex-easy-installer) (section "Put your SoM in recovery mode").

- Load Tezi through the USB OTG interface. To do so, go to the directory you downloaded Tezi and unzip it. Then to load Tezi: 

  ```bash
  cd <unzipped_directory>
  ./recovery-linux.sh
  ```

- Then wait for Tezi installer to display the flash options on the screen.



### Flash a new image with Tezi

In this guide, we will use the default `Toradex Embedded Linux Reference Multimedia Image`.

You need a mouse plugged in the USB port to select and flash the image. Wait for the installation to be completed!

If you want to create your own system and flash it, [here](https://developer.toradex.com/easy-installer/toradex-easy-installer/flashing-new-image-using-tezi/) is a detailed guide to use Tezi.



### Software setup

This guide was tested on Ubuntu 22.04 host.

#### Install docker

- Follow this [tutorial](/https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04) to install and setup docker on your system.

- Support to run arm64 docker containers on the host: 

  ```bash
  sudo apt-get install qemu-user-static
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
  ```

#### Install utilities 

```bash
sudo apt install picocom nmap
```



### Run the default project

Clone the repository: 

```bash
git clone --recurse-submodules https://github.com/lvgl/lv_port_toradex_verdin_imx8m_mini.git
```

Build the docker image and the lvgl benchmark application: 

```bash
cd lv_port_toradex_verdin_imx8m_mini
./scripts/docker_setup.sh --create-image
./scripts/docker_setup.sh --build-app
```

Run the executable on the target: 

- Get the IP of the target board:

  - <u>Option 1</u>: from the UART, on the board: 

    ```bash
    sudo picocom -b 115200 /dev/ttyUSB0
    ## Then inside the console, log as "root", no password required 
    ## Then retrieve the ip of the board
    ip a
    ```

  - <u>Option 2</u>: Get the IP from your host with nmap

    ```bash
    ## Find the IP of the board. You need to know your ip (ifconfig or ip a)
    ## HOST_IP should be built like this :
    ## If the ip is 192.168.1.86, in the following command HOST_IP = 192.168.1.0/24
    nmap -sn <HOST_IP>/24 | grep verdin-imx8
    ```

- Then transfer the executable on the board: 

  ```bash
  scp lvgl_port_linux/bin/lvgl-app root@<BOARD_IP>:/root
  ```

- Start the application

  ```bash
  ssh root@<BOARD_IP>
  
  systemctl stop wayland-app-launch.service
  ######################################
  ## WARNING: do not stop these services if using wayland demo
  systemctl stop weston.socket 
  systemctl stop weston.service 
  ######################################
  
  ./lvgl-app
  ```



### Change configuration

Some configurations are provided in the folder `lvgl_conf_example` .

The default configuration used is lv_conf_fb_4_threads.h. To change the configuration, modify the `lvgl_port_linux/lv_conf.h` file with the desired configuration.

Also modify the `lvgl_port_linux/CMakelists.txt` file option: 

```cmake
option(LV_USE_WAYLAND "Use the wayland client backend" OFF)
option(LV_USE_SDL "Use the SDL backend" OFF)
option(LV_USE_DRM "Use the libdrm backend" OFF)
```

Default fbdev backend. Only set 1 of these options to "ON" and ensure it's coherent with `lv_conf.h`. This can also be changed from the script `scripts/build_app.sh`.



### Start with your own application

The folder `lvgl_port_linux` is an example of an application using LVGL. 

LVGL is integrated as a submodule in the folder. To change the version of the library: 

```bash
cd lvgl_port_linux
git checkout <branch_name_or_commit_hash>
```

The file `main.c` is the default application provided and is configured to run the benchmark demo provided by LVGL library. 

The main steps to create your own application are: 

- Modify `main.c`
- Add any folders and files to extend the functionalities
- Update `Dockerfile` to add any package
- Modify `CMakeLists.txt` provided file to ensure all the required files are compiled and linked
- Use the docker scripts provided to build the application for ARM64 architecture.



## TroubleShooting

### Output folder permissions

If there is any problem with the output folder generated permissions, modify the permissions: 

```bash
sudo chown -R $(whoami):$(whoami) lvgl_port_linux/bin
```

### Fbdev example runtime error

This error can be printed when running the application: 

```bash
[Warn]	(1382.767, +37)	 lv_display_refr_timer: No draw buffer lv_refr.c:374
[Warn]	(1382.804, +37)	 lv_display_refr_timer: No draw buffer lv_refr.c:374
[Warn]	(1382.841, +37)	 lv_display_refr_timer: No draw buffer lv_refr.c:374
[Warn]	(1382.878, +37)	 lv_display_refr_timer: No draw buffer lv_refr.c:374
```

To fix the issue find the existing fbdev available: 

```bash
ls /dev/fb*
```

Export the variable to match the fbdev name: 

```bash
export LV_LINUX_FBDEV_DEVICE=/dev/fb0
```

### Wayland example runtime error

While running the application, if there is an error about `XDG_RUNTIME_DIR`, add the following environment variable on the board.

```bash
export XDG_RUNTIME_DIR=/run/user/1000
```



### Changing configuration causes errors building the application

CMake may have troubles with CMakeLists.txt changes with some variables setup. If there is any problem building, try to clean the build folder: 

```bash
rm -rf lv_port_linux/build-arm64
```



## Contribution and Support

If you find any issues with the development board feel free to open an Issue in this repository. For LVGL related issues (features, bugs, etc) please use the main [lvgl repository](https://github.com/lvgl/lvgl).

If you found a bug and found a solution too please send a Pull request. If you are new to Pull requests refer to [Our Guide](https://docs.lvgl.io/master/CONTRIBUTING.html#pull-request) to learn the basics.

