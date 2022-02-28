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

To shut down:

```
sudo poff a-gsm
```

For status:

```
plog
```