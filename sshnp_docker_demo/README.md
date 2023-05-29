# sshnp_docker_demo

This is a demo of sshing into one docker container from another docker container without having ports open (not even port 22). This demo involves using [sshnp](https://github.com/atsign-foundation/sshnoports).

## Getting Started

### 1. Prerequisites

1. Install [Docker](https://www.docker.com/products/docker-desktop/) and open it in the background. Check that you have docker installed. Run this in your terminal. Your output should be similar:

```sh
docker --version
Docker version 23.0.5, build bc4487a
```

2. You will need 3 atSigns and their associated `.atKeys` files (one for each docker container). 

3. For each of your atSigns, put the `.atKeys` file into the `keys/` directory. For example, your file structure should be similar to:`sshnp/keys/@sshnp_key.atKeys`, `sshnpd/keys/@sshnpd_key.atKeys`, `sshrvd/keys/@sshrvd_key.atKeys`

### 2. Finding IP of sshrvd

This is a tedious but short step that we need to do to find the IP of the sshrvd docker container.

Let's build and run the `sshrvd` docker container by running

```sh
cd sshrvd
sh db.sh
```

Now, in another terminal window, find the IP address of the `sshrvd` docker container.

```sh
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' sshrvd
172.**.*.*
```

Note this IP address for later.

### 3. Setting up the Shell Scripts

1. Edit shell scripts `.startup.sh` in each of the three folders. 

(A) The `sshnp/.startup.sh` script:

- replace `john@example.com` with your email
- replace `@sshnp` with your sshnp atSign (e.g. `@soccer99`)
- replace `@sshnpd` with your sshnpd atSign (e.g. `@66dear32`)
- replace `@sshrvd` with your sshrvd atSign (e.g. `@48leo`)
- replace `deviceName` with the name of your device. This has to be the same throughout the rest of the scripts (e.g. `docker`)

```sh
#!/bin/bash
ssh-keygen -A
ssh-keygen -o -a 100 -t ed25519 -f /atsign/.ssh/id_ed25519 -C "john@example.com"
/usr/sbin/sshd -D -o "ListenAddress 127.0.0.1" -o "PasswordAuthentication no"  &
sudo -u atsign /atsign/sshnp/sshnp -f @sshnp -t @sshnpd -h @sshrvd -d deviceName -s id_ed25519.pub -v
```

(B) The `sshnpd/.startup.sh` script:

- replace `@sshnp` with your sshnp atSign (e.g. `@soccer99`)
- replace `@sshnpd` with your sshnpd atSign (e.g. `@66dear32`)
- replace `deviceName` with the name of your device. This has to be the same throughout the rest of the scripts (e.g. `docker`)

```sh
#!/bin/bash
ssh-keygen -A
/usr/sbin/sshd -D -o "ListenAddress 127.0.0.1" -o "PasswordAuthentication no"  &
while true
do
sudo -u atsign /atsign/sshnp/sshnpd -a @sshnpd -m @sshnp -d deviceName -s -u -v
sleep 3
done
```

(C) The `sshrvd/.startup.sh` script:

- replace `john@example.com` with your email
- replace `<ip>` with the ip from Step 2 (e.g. `12.23.2.3`)
- replace `@sshrvd` with your sshnpd atSign (e.g. `@48leo`)

```sh
#!/bin/bash
ssh-keygen -A
ssh-keygen -o -a 100 -t ed25519 -f /atsign/.ssh/id_ed25519 -C "john@example.com"
/usr/sbin/sshd -D -o "ListenAddress 127.0.0.1" -o "PasswordAuthentication no"  &
while true
do
sudo -u atsign /atsign/sshnp/sshrvd -a @sshrvd -i <ip> -v -s
sleep 3
done
```

### 4. Running the Shell Scripts

1. Open three terminals side-by-side

2. First let's docker build `sshrvd` using the `db.sh` shell script.

```sh
cd sshrvd
sh db.sh
root@6a83b17a9499:/atsign#
```

3. Run the `.startup.sh` inside `sshrvd` container with `sh .startup.sh`

```sh
root@6a83b17a9499:/atsign# sh .startup.sh
ssh-keygen: generating new host keys: DSA 
Generating public/private ed25519 key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /atsign/.ssh/id_ed25519
Your public key has been saved in /atsign/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:B8Xa+nYMlIdw2tLnQRuwSsNB9eVTE02PC/vymJoqK9A john@example.com
The key's randomart image is:
+--[ED25519 256]--+
|       .oo+.  .+=|
|       ..ooooo o+|
|        =O.+oo+ .|
|       .++B =o o |
|   .    S+.+...  |
|  . E   ... ..   |
|   .     . o. .  |
|    . .   o.o=   |
|     ..o.oooo .  |
+----[SHA256]-----+
INFO|2023-05-29 18:29:05.683549|AtClientManager|setCurrentAtSign called with atSign @48leo
```

3. Next, let's docker build `sshnpd`

```sh
cd sshnpd
sh db.sh
root@4636ff324650:/atsign#
```

4. Lastly, let's docker build `sshnp`

```sh
cd sshnp
sh db.sh
```





## Structure

This is a demo involving three directories (each representing a docker container):

1. `sshnp/` the client machine
2. `sshnpd/` the linux device running the sshnp daemon
3. `sshrvd/` the rendezvous point

Each directory contains:

- `keys/` where you store your `.atKeys`
- `db.sh` docker build shell script
- `.startup.sh` script to run on container startup (to start sshnp binary). The Dockerfile copies this file over.
- `Dockerfile` image build instructions

## The Dockerfile

- makes `~/.ssh`
- makes `~/.atsign/keys`
- copies over `~/.startup.sh`
- sets up user with name "atsign". if you are changing the user's name, then change it in each Dockerfile as well as the `.startup.sh` scripts.
<!-- TODO -->

## Usage

`sshnp` usage (example: `./sshnp -f @soccer99 -t @66dear32 -h @48leo -d docker -s id_ed25519.pub -v`)

```
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

```
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

```
Version : 3.1.2
-k, --key-file              atSign's atKeys file if not in ~/.atsign/keys/
-a, --atsign (mandatory)    atSign for sshrvd
-m, --manager               Managers atSign that sshrvd will accept requests from. Default is any atSign can use sshrvd
                            (defaults to "open")
-i, --ip (mandatory)        FQDN/IP address sent to clients
-v, --[no-]verbose          More logging
-s, --[no-]snoop            Snoop on traffic passing through service
FormatException: Option atsign is mandatory.
```

## tmp notes

- run everything as root
- run commands 1 by 1 in shell script