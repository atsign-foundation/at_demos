# sshnp_docker_demo

## Getting Started

1. Install [Docker]()
2. Edit shell scripts

Find IP of `sshrvd` docker container. Change `container_name` to the name the container.

```sh
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name               
91.23.**.***
```

## Structure

This is a demo involving three directories (each representing a docker container):

1. `sshnp/` the client machine
2. `sshnpd/` the linux device running the sshnp daemon
3. `sshrvd/` the rendezvous point

Each directory contains:

- `keys/` where you store your `.atKeys`. Check out this [video](https://www.youtube.com/watch?v=8xJnbsuF4C8) on how to generate your associated `.atKeys` for your atSign.
- `db.sh` docker build shell script
- `.startup.sh` script to run on container startup (to start sshnp binary). The Dockerfile copies this file over.
- `Dockerfile` image build instructions

## The Dockerfile

- makes `~/.ssh`
- makes `~/.atsign/keys`
- copies over `~/.startup.sh`
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