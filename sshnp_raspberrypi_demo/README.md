# SSHNP with a Raspberry Pi Demo

The demonstration features the utilization of a Raspberry Pi 3 Model B. This documentation guides you through the process of setting up a Raspberry Pi from scratch, encompassing the following steps:

### What you will need
- Raspberry Pi 4 Model B
- MicroSD card (8GB or more preferably)
- MicroSD card reader
- Power supply (5V, 2.5A)
- Ethernet cable (optional)
- HDMI to microHDMI cable 

### 1. Downloading the latest version of Raspbian OS 
You can download the latest version of Raspberry Pi OS (previously called Raspbian) from the official website [here](https://www.raspberrypi.org/downloads/raspbian/). Follow the instructions on the website to install the OS on a microSD card.

### 2. Setting up the Raspberry Pi
Once you have installed the OS on the microSD card, insert the card into the Raspberry Pi. Connect the Raspberry Pi to a monitor using the HDMI to microHDMI cable. Connect the power supply to the Raspberry Pi. Connect the Raspberry Pi to the internet using an ethernet cable or a WiFi connection. 

### 3. Installing sshnp
Once you have set up the Raspberry Pi, you can install sshnp by following the instructions [here](https://www.noports.com). Once you have purchased a license (or have obtained a free trial), you can follow the installation instructions [here](https://www.noports.com/sshnoports-installation).

### 4. Running the demo
You can connect to your device from any machine with the following commands:
```
killall -u "$(whoami)" -r "sshnpd$"
$(sshnp@<device address> -d <device name>)
```

**Example**
```
$(sshnp@alice_device -d raspberry_pi)
```

### Updating your installation
Updating your installation
#### Device
To update the device, run the following command:

```
bash -c "$(curl -fsSL https://getsshnpd.noports.com)" -- --update
```

This will update all services installed under the current user.

#### Client
To update the client, run the following command:

```
bash -c "$(curl -fsSL https://getsshnp.noports.com)" -- --update
```

This will update the sshnp client for the current user.


