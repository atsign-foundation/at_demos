# sshnp_docker_demo

This demo involves using [sshnp](https://github.com/atsign-foundation/sshnoports). [sshnp](https://github.com/atsign-foundation/sshnoports) allows you ssh into any remote device/host without that device having any open ports.

There are two docker containers: `sshnp` and `sshnpd`.

## Structure

- `demo-base/` contains Dockerfile [base image](https://hub.docker.com/r/atsigncompany/sshnp_docker_demo_base)
- `sshnp/` the client docker container
- `sshnpd` the device docker container
- `templates` shell script templates
- `clean.sh` run this script if you want to start the demo from scratch
- `README.md` demo guide & documentation


## Getting Started

Follow these steps to get sshnp working on your machine using Docker.

### 1. Prerequisites

1. Install [Docker](https://www.docker.com/products/docker-desktop/) and open it in the background. Check that you have docker installed. Run this in your terminal. Your output should be similar:

```sh
docker --version
Docker version 23.0.5, build bc4487a
```

2. Install [git](https://git-scm.com/downloads) and open it in the background. Check that you have git installed. Run this in your terminal. Your output should be similar:

```sh
git --version
git version 2.39.0
```

3. You will need 2 atSigns and their associated `.atKeys` files, one for each docker container. One atSign will be the client (sshnp) address while the other atSign will be the device (sshnpd) address. See [1A. Getting your .atKeys](#1a-getting-your-atkeys) to learn how to get your atKeys.

4. Git clone this repository, and change into the demo directory to ensure it was cloned properly.

```sh
git clone https://github.com/atsign-foundation/at_demos.git
cd at_demos/sshnp_docker_demo
ls
```

5. Log into Docker, if you are not logged in already:

```sh
docker login
```

#### 1A. Getting your .atKeys

<!-- TODO INCLUDE "GETTING YOUR ATKEYS" VIDEO WHEN IT IS UPLOADED -->

If you already have your `.atKeys` files, you may skip this step.

1. Go to [my.atsign.com/go](https://my.atsign.com/go) and get 2 atSigns.

2. Once purchased, be sure to go through each of them and press the orange "Activate" button. This will open your atSign for activation

3. Use [at_onboarding_cli/at_activate](https://github.com/atsign-foundation/at_libraries/tree/trunk/packages/at_onboarding_cli) (if you prefer a command-line approach) or download one of our [apps](https://atsign.com/apps/) (such as [atmospherePro](https://atsign.com/apps/atmospherepro/)) to utilize the onboarding widget to generate your `.atKeys` files. You will need to generate a `.atKeys` file for each of your atSigns. Be sure to not lose these keys as they are used to authenticate into an atSign's atServer.

### 2. Setting up the sshnpd Docker Container (Device)

Next, let's set up the sshnpd container.

1. Put your sshnpd atSign's `.atKeys` file in `sshnpd/keys`. Your file structure should be similar to `sshnpd/keys/@alice_key.atKeys`.

2. Open up a fresh terminal.

3. Run the `docker-build.sh` script inside of `sshnpd/`. 

```sh
cd sshnpd
./docker-build.sh
```

You may need to `chmod +x docker-build.sh` to make the script executable.

You may need to enter your user password to allow the script to run `sudo` commands. 

If run successfully, your terminal session should be running the docker container. Output should be similar to:

```sh
...
atsign@c602e7e77fa9:~$ 
```

4. Install sshnpd inside the container:

```sh
/bin/bash -c "$(curl -fsSL https://getsshnpd.noports.com)"
```

Note that the device name should be the same throughout the demo.

Example:

```sh
atsign@712f0eea57ed:~$ /bin/bash -c "$(curl -fsSL https://getsshnpd.noports.com)"
Client address (e.g. @alice_client): @soccer99
Device address (e.g. @alice_device): @22easy
Device name: docker
```

This will install and run the sshnpd inside of the docker container.

5. View the tmux session

Optionally, you may run `tmux a` to see logs.

```sh
tmux a
```

You should see a line similar to the following, if the daemon started successfully:

```
INFO|2023-06-07 16:13:34.097561|Monitor (@22easy)|monitor started for @22easy with last notification time: null 
```

Once the daemon is running successfully, you may move onto [Step 3. Setting up the sshnp Docker Container (Client)](#3-setting-up-the-sshnp-docker-container-client).

If your daemon is not running successfully, you may need to troubleshoot. See [Troubleshooting](#troubleshooting) for more information.

### 3. Setting up the sshnp Docker Container (Client)

1. Put your sshnp atSign's `.atKeys` inside of `sshnp/keys/`. Your file structure should be similar to `sshnp/keys/@alice_key.atKeys`.

2. Open up a fresh terminal.

3. Next, let's build the `sshnp` docker container using the `docker-build.sh` shell script.

```sh
cd sshnp
./docker-build.sh
```

You may need to `chmod +x docker-build.sh` to make the script executable.

You may need to enter your password to allow the script to run `sudo` commands.

If run successfully, your terminal sesssion should be running the docker container:

```sh
atsign@f868301cecf8:~$ 
```

4. Install sshnp inside the container:

```sh
/bin/bash -c "$(curl -fsSL https://getsshnp.noports.com)"
```

Example:

```sh
atsign@d49297a4f505:~$ bash -c "$(curl -fsSL https://getsshnp.noports.com)"
Client address (e.g. @alice_client): @soccer99
Device address (e.g. @alice_device): @22easy
Pick your default region:
  am: Americas
  ap: Asia Pacific
  eu: Europe
> am
```

5. Now run the custom sshnp script it generated.

Replace `@sshnpd` with your sshnpd atSign and `docker` with the device name that was specified in [Step 2](#2-setting-up-the-sshnpd-docker-container-device).

```sh
~/.local/bin/sshnp@sshnpd docker
```

6. You should receive an ssh command to run after running the `sshnp` script. Copy and run this command.

Running the `sshnp` script should give you an output at the end similar to:

```sh
ssh -p 44743 atsign@localhost -i /atsign/.ssh/id_ed25519 
```

If the ssh connection was not established successfully, try running Step 5 again as the command may have expired.

You can also wrap the shell script in `$()` to run the command automatically. Example: `$(~/.local/bin/sshnp@sshnpd docker)`

7. You should be ssh'd into the other docker container. (Hurray!)

```sh
atsign@77fe899b6732:~$ ps -a
  PID TTY          TIME CMD
   27 pts/0    00:00:00 bash
   76 pts/1    00:00:00 sshnpd@soccer99
   79 pts/1    00:00:01 dart:sshnpd
  224 pts/2    00:00:00 ps
atsign@77fe899b6732:~$ echo yay
yay
```

## Quick Start

[Getting Started](#getting-started) but a lot quicker.

1. Put your @sshnp atKeys inside of sshnp/keys and your @sshnpd atKeys inside sshnpd/keys. Your file structure should be similar to sshnp/keys/@alice_key.atKeys and sshnpd/keys/@alice_key.atKeys.

2. Start up the sshnpd docker container

```sh
cd sshnpd
./docker-build.sh
```

3. Install sshnpd inside the container:

```sh
/bin/bash -c "$(curl -fsSL https://getsshnpd.noports.com)"
```

4. In another terminal, start up the sshnp docker container

```sh
cd sshnp
./docker-build.sh
```

5. Install sshnp inside the container:

```sh
/bin/bash -c "$(curl -fsSL https://getsshnp.noports.com)"
```

6. Run the custom sshnp script it generated.

Replace `@sshnpd` with your sshnpd atSign.

```sh
$(~/.local/bin/sshnp@sshnpd docker)
```

7. Done!

## Troubleshooting

### sshnpd

If you are having trouble getting the sshnpd daemon to run, try the following:

1. While in the tmux session, `Ctrl + C` to stop the daemon.

If you are not in the tmux session, you may need to run `tmux a` to get into the session.

If you need to start a new tmux session, run `tmux new`. To detach, you can do `Ctrl + B` then `D`.

2. Run the daemon manually:

Replace `@sshnp` with your sshnp atSign.

```sh
~/.local/bin/sshnpd@sshnp
```

3. If it is still not working, check that your keys are in the correct directory.

```sh
ls ~/.atsign/keys
```

## Binary Usage

Usage of each of the binaries (taken from the [sshnp](https://github.com/atsign-foundation/sshnoports) repo)

`sshnp` usage (example: `./sshnp -f @soccer99 -t @66dear32 -h @48leo -d docker -s id_ed25519.pub -v`)

```sh
Version : 3.1.2
-k, --key-file             Sending atSign's atKeys file if not in ~/.atsign/keys/
-f, --from (mandatory)     Sending atSign
-t, --to (mandatory)       Send a notification to this atSign
-d, --device               Send a notification to this device
                           (defaults to "default")
-h, --host (mandatory)     atSign of sshrvd daemon or FQDN/IP address to connect back to 
-p, --port                 TCP port to connect back to (only required if --host specified a FQDN/IP)
                           (defaults to "22")
-l, --local-port           Reverse ssh port to listen on, on your local machine, by sshnp default finds a spare port
                           (defaults to "0")
-s, --ssh-public-key       Public key file from ~/.ssh to be appended to authorized_hosts on the remote device
                           (defaults to "false")
-o, --local-ssh-options    Add these commands to the local ssh command
-v, --[no-]verbose         More logging
-r, --[no-]rsa             Use RSA 4096 keys rather than the default ED25519 keys
```

`sshnpd` usage (example: `./sshnpd -a @66dear32 -m @the50 -d docker -s -u -v`) 

```sh
-k, --keyFile                Sending atSign's keyFile if not in ~/.atsign/keys/
-a, --atsign (mandatory)     atSign of this device
-m, --manager (mandatory)    Managers atSign, that this device will accept triggers from
-d, --device                 Send a trigger to this device, allows multiple devices share an atSign
                             (defaults to "default")
-s, --[no-]sshpublickey      Update authorized_keys to include public key from sshnp
-u, --[no-]username          Send username to the manager to allow sshnp to display username in command line
-v, --[no-]verbose           More logging
```

`sshrvd` usage (example: `./sshrvd -a @48leo -i 172.17.0.2 -v -s`)

```sh
Version : 3.1.2
-k, --key-file              atSign's atKeys file if not in ~/.atsign/keys/
-a, --atsign (mandatory)    atSign for sshrvd
-m, --manager               Managers atSign that sshrvd will accept requests from. Default is any atSign can use sshrvd
                            (defaults to "open")
-i, --ip (mandatory)        FQDN/IP address sent to clients
-v, --[no-]verbose          More logging
-s, --[no-]snoop            Snoop on traffic passing through service
```

## The Dockerfile

<!-- TODO -->