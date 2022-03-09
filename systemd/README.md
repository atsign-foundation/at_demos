# Systemd Units

This directory contains three systemd unit definitions. Each runs a component
of the demo in a GNU screen, which can be attached to (for logging etc.)
with `screen -r`

## Installation

The `mwc*.service` files should be placed in `\etc\systemd\system` (as root).

Modify the `mwc-sender.service` unit to use the appropriate sender and target
@signs. (The boilerplate uses @deviceatsign @appatsign).

Then:

```bash
sudo systemctl enable mwc*.service
```

The services will then start at the next reboot, or can be started manually
with:

```bash
sudo systemctl enable mwc*.service
```

## Usage

When running there will be three detached screens. `screen -r` will list them:

```
There are several suitable screens on:
        904.mwcsender   (09/03/22 16:26:53)     (Detached)
        903.mwcspub     (09/03/22 16:26:53)     (Detached)
        901.mwcdisplay  (09/03/22 16:26:53)     (Detached)
Type "screen [-d] -r [pid.]tty.host" to resume one of them.
```

An individual screen can be attached to by e.g. `screen -r mwcdisplay`.

To detach again use `Ctrl-a d`