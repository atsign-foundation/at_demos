# Getting a PPP connection

Ensure that contents of `etc` directory copied into place.

To turn on:

```
sudo pon a-gsm
```

To set as default route:

```
sudo route add default dev ppp0
```

MTU needs to be reduced, otherwise TLS hangs at CONNECT:

```
sudo ifconfig ppp0 mtu 1200
```

To shut down:

```
sudo poff a-gsm
```

For status:

```
plog
```