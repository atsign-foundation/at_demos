<img src="https://atsign.dev/assets/img/@developersmall.png?sanitize=true">

### Now for a little internet optimism

# at_hello_world

# @Protocol Hello World

This directory contains the complete code for the Hello World application. Feel free to use
this for testing, debugging, or just trying out the app!

## Getting Started

1. Clone this project from the @ Company repository.

2. To run the app, make sure to have your docker containers running and have your machine pointing to the local DNS server (the address is 127.0.0.1).

**- For Windows:**
Navigate to:

Settings > Network & Internet > Change Adapter Settings > Select adapter, Properties >  Internet version 4 (TCP/IPv4). 

Then use the following DNS server addresses:
DNS=127.0.0.1
FallbackDNS=1.1.1.1
**Then restart the DNS system using the command:**
$ sudo service systemd-resolved restart
**Use the below command:**
$ sudo resolvectl status |  more
**Check for the output below:**
Global
       LLMNR setting: no
MulticastDNS setting: no
  DNSOverTLS setting: no
      DNSSEC setting: no
    DNSSEC supported: no
         DNS Servers: 127.0.0.1
Fallback DNS Servers: 1.1.1.1
DNSSEC NTA: 10.in-addr.arpa

**- For Mac:**
Navigate to:
System Preferences > Network > Wifi/Ethernet > Advanced > DNS. 
From here add 127.0.0.1 at the top.



**Side Note:** You can only use this app with one test @sign at a time (e.g. @kevin🛠). If you'd like to use a different
test @sign, uninstall the Flutter app from your emulator and build it again.
