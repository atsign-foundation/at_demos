# sshnp_docker_demo

This is a demo of sshing into one docker container from another docker container without having ports open (not even port 22). There are three docker containers: `sshnp`, `sshnpd`, and `sshrvd`. This demo involves using [sshnp](https://github.com/atsign-foundation/sshnoports).

## Getting Started

Follow these steps to get sshnp working on your machine using Docker.

### 1. Prerequisites

1. Install [Docker](https://www.docker.com/products/docker-desktop/) and open it in the background. Check that you have docker installed. Run this in your terminal. Your output should be similar:

```sh
docker --version
Docker version 23.0.5, build bc4487a
```

2. You will need 2 atSigns and their associated `.atKeys` files. If you will be running your own rendezvous service, you will instead need 3 atSigns (one for each docker container). 
 
Regardless of running a rendevous service or not, you will need to add your atKey files within the following dirs:
- sshnp/keys/
- sshnpd/keys/ 
- sshrvd/keys/ \
*NOTE*: You don't need keys in the sshrvd if you aren't running sshrvd yourself

For example, your file structure should be similar to:`sshnp/keys/@sshnp_key.atKeys`, `sshnpd/keys/@sshnpd_key.atKeys`, `sshrvd/keys/@sshrvd_key.atKeys`. If you need help getting your `.atKeys` files, see [1A. Getting your .atKeys](#1a-getting-your-atkeys).

#### 1A. Getting your .atKeys

<!-- TODO INCLUDE "GETTING YOUR ATKEYS" VIDEO WHEN IT IS UPLOADED -->

1. Go to [my.atsign.com/go](https://my.atsign.com/go) and get as many atSigns as you need (2 if you are using Atsign's rendezvous service, 3 if you are using you will be running your own rendezvous service).

2. Once you have checked out with your brand new atSigns, be sure to go through each of them and press the orange "Activate" button. This will open your atSign for activation

3. Use [at_onboarding_cli/at_activate](https://github.com/atsign-foundation/at_libraries/tree/trunk/packages/at_onboarding_cli) (if you prefer a command-line approach) or download one of our [apps](https://atsign.com/apps/) (such as [atmospherePro](https://atsign.com/apps/atmospherepro/)) to utilize the onboarding widget to generate your `.atKeys` files. You will need to generate a `.atKeys` file for each of your atSigns. Be sure to not lose these keys as they are used to authenticate into an atSign's atServer.

### 2. Finding IP of sshrvd*

If you are using a rendezvous service serviced by Atsign, you may skip any of the `sshrvd` steps denoted by the *

This is a tedious but short step where we need to do to find the IP of the sshrvd docker container.


1. Let's build and run the `sshrvd` docker container by running

```sh
cd sshrvd
./docker-build.sh
```

2. Now, in another terminal window, find the IP address of the `sshrvd` docker container.

```sh
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' sshnp_docker_demo_sshrvd
172.**.*.*
```

3. Note this IP address for later. Stop the docker container with `Ctrl + D`

```
root@7452c3c9e744:/atsign# 
exit
```

### 3. Setting up the `.startup` Shell Scripts

1. We will generate a `.startup.sh` for each container. 

In the root of the project, run the `interactive-setup-startup-scripts.sh` script.

Example:

```sh
./interactive-setup-startup-scripts.sh
Enter your sshnp atSign (e.g. "@sshnp"):
@soccer99
Enter your sshnpd atSign (e.g. "@sshnpd"):
@22easy
Enter your sshrvd atSign (e.g. "@sshrvd"):
@48leo
Enter your email (optional, Enter to skip):

Enter your device name (optional, Enter to skip):
docker
\nFinished setup with arguments:
sshnp: @soccer99
sshnpd: @22easy
sshrvd: @48leo
email: 
deviceName: docker
```

This will generate `sshnp/.startup.sh`, `sshnpd/.startup.sh`, `sshrvd/.startup.sh` which will be used by the Docker containers.

2. Edit the <ip> in the `sshrvd/.startup.sh` script with the IP we obtained from Step 2.*

Your `sshrvd/.startup.sh` should be similar to:

```sh
#!/bin/bash
ssh-keygen -A
ssh-keygen -o -a 100 -t ed25519 -f /atsign/.ssh/id_ed25519 -C "john@example.com"
/usr/sbin/sshd -D -o "ListenAddress 127.0.0.1" -o "PasswordAuthentication no"  &
while true
do
sudo -u atsign /atsign/sshnp/sshrvd -a @48leo -i 172.17.*.* -v -s
sleep 3
done
```

### 4. Running the Shell Scripts

1. Open three terminals side-by-side

#### Terminal 1
2. First let's docker build `sshrvd` using the `docker-build.sh` shell script.*

```sh
cd sshrvd
./docker-build.sh
root@6a83b17a9499:/atsign#
```
#### Terminal 2
3. Next, let's docker build `sshnpd` using the `docker-build.sh` shell script.

```sh
cd sshnpd
./docker-build.sh
root@4636ff324650:/atsign#
```

#### Terminal 3
4. Lastly, let's docker build `sshnp` using the `docker-build.sh` shell script.

```sh
cd sshnp
./docker-build.sh
root@4636ff324651:/atsign#
```

5. Open the `sshrvd` terminal that has the running docker container, and run the `.startup.sh` script. (Press Enter to enter a blank password for the keypairs)*

```sh
root@6a83b17a9499:/atsign# ./startup.sh
ssh-keygen: generating new host keys: DSA 
Generating public/private ed25519 key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /atsign/.ssh/id_ed25519
Your public key has been saved in /atsign/.ssh/id_ed25519.pub
...
```

Once running, let it run in the background and move onto the next step.

6. Now, open the `sshnpd` terminal and run the `.startup.sh` script

```sh
root@105fd65cb88e:/atsign# ./startup.sh
ssh-keygen: generating new host keys: DSA 
INFO|2023-05-29 18:37:37.310524|AtClientManager|setCurrentAtSign called with atSign @66dear32
...
```

Once running, let it run in the background and move onto the next step.

7. Lastly, open the `sshnp` terminal and run the `.startup.sh` script

```sh
root@b3b94028c184:/atsign# ./startup.sh
ssh-keygen: generating new host keys: DSA 
Generating public/private ed25519 key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /atsign/.ssh/id_ed25519
...
```

Running the `sshnp` script should give you an output at the end similar to:

```sh
ssh -p 44743 atsign@localhost -i /atsign/.ssh/id_ed25519 
```

8. Simply run this command in the `sshnp` container. This will ssh you into the `sshnpd` container!

Run the command in the container (e.g. `ssh -p 34325 atsign@localhost -i /atsign/.ssh/id_ed25519 `)

```sh
root@7452c3c9e744:/atsign# ssh -p 34325 atsign@localhost -i /atsign/.ssh/id_ed25519 
...
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
...
atsign@105fd65cb88e:~$ ls
sshnp
atsign@105fd65cb88e:~$ echo Hurray!
Hurray!
```

## Structure

This is a demo involving three directories (each representing a docker container):

1. `sshnp/` the client machine
2. `sshnpd/` the linux device running the sshnp daemon
3. `sshrvd/` the rendezvous point

Additional directories:

- `demo-base/` contains the base docker image
- `script-templates/` contains the templates for the `.startup.sh` scripts and a `docker-build-template.sh` used by the three `docker-build.sh`s

Each directory contains (or will contain):

- `keys/` where you store your `.atKeys`, copied to Docker container
- `docker-build.sh` docker build shell script, builds custom docker image, custom image uses demo-base as base image
- `.startup.sh` a generated script after running `interactive-setup-startup-scripts.sh`

## The Dockerfile

- works inside of `~`
- ${USER} var specifies the user of the machine
- makes `~/.ssh`
- makes `~/.atsign/keys` and copies keys over to container
- copies over `~/.startup.sh`
- sets up user with name "atsign". if you are changing the user's name, then change it in each Dockerfile ENV variable as well as replace "atsign" in the three `.startup.sh` scripts.
- installs [sshnp](https://github.com/atsign-foundation/sshnoports) binaries from releases on github

## Usage

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
