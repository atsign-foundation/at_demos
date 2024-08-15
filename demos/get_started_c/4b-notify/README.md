# 4b - Notify

## Description

In this example, we will send a notification to our monitor client and the monitor client will be able to read the notification.

In order for your example to work, I recommend opening two terminals; 1 terminal with the monitor client connection running (4a-monitor) and 1 terminal which will run this program (4b-notify).

You will need to add `#include <atclient/notify.h>` to the top of your C program to use notify functions.

## Files

- [main.c](./main.c) - The main file that contains the code for the application.
- [CMakeLists.txt](./CMakeLists.txt) - The CMake file that contains the build instructions for the application.

## How To Run The Example

The following instructions are for running the example on a Linux/MacOS machine. You could run it on a Windows machine given that you are either running it on a Windows Subsystem for Linux (WSL), using a Linux virtual machine, or using a Bash shell like Git Bash. You could also run it on a Windows command prompt, given that you have the necessary tools and you know what commands do what.

1. Clone the repository.

    ```sh
    git clone https://github.com/atsign-foundation/at_demos.git
    ```

1. Change the "ATSIGN" line in `main.c` to an atSign you have set up already. It is assumed that you atSign's keys are in the `~/.atsign/keys/` directory. For example, I have my `@soccer0` keys set up with the file `@soccer0_key.atKeys` in the `/home/jeremy/.atsign/keys/` directory. If you do not have your atSign's keys already, you will need to activate your atSign using at_activate.

    ```c
    #define ATSIGN "@<YOUR_ATSIGN>"
    ```

1. Navigate to the `get_started_c` directory.

    ```sh
    cd at_demos/demos/get_started_c/4b-notify
    ```

1. CMake configure

    ```sh
    cmake -S . -B build
    ```

1. Build

    ```sh
    cmake --build build
    ```

1. Run the application

    ```sh
    ./build/main
    ```

### Expected Output

This is the output of running `4b-notify`

```sh
$ ./build/main
[DEBG] 2024-08-13 16:59:05.515240 | connection |        SENT: "soccer0"
[DEBG] 2024-08-13 16:59:05.553300 | connection |        RECV: "3733e916-a5d4-5f5a-b527-a53645304a6c.swarm0002.atsign.zone:6926"
[DEBG] 2024-08-13 16:59:05.877743 | connection |        SENT: "from:soccer0"
[DEBG] 2024-08-13 16:59:05.914687 | connection |        RECV: "data:_bc7ba9c7-6ce7-42d4-a71a-4c2367d6b2e7@soccer0:cec850b6-0d45-416c-b076-2d7934c1ad12"
[DEBG] 2024-08-13 16:59:05.953083 | connection |        SENT: "pkam:FhrR7AaRMY0rrgb0+olQwoBr27K4OPMGa6SrLUnyjUn5anEeG5f+RvoW85a/MY2tljg0jINhFmgjW5QgNzEp0zXG8BAJUsPitXT/Gda36KBwvXha8X4HNr2FcwdTbG1/ObJzmxkW/GBa5RNVGFPF+6C4U0Tsy7KkQwQ3qSK3zkUzVaL/tomyS6e7zAwvZimLmP00jLdhtIC/1HTEMexe99WmIXBtbUGS/4uFAG6QdpwW7IkzKa2Xnupyh8n/u7URJ7VgznKtbgpOQorY9BRed+xF5lpRFgRuizHeVcYPUBrJ76QYAALLxGHBF6V9MrxLn0Fj4sNAHJA6L7ZBkbJvDg=="
[DEBG] 2024-08-13 16:59:05.995608 | connection |        RECV: "data:success"
[DEBG] 2024-08-13 16:59:05.995736 | connection |        SENT: "llookup:shared_key.soccer99@soccer0"
[DEBG] 2024-08-13 16:59:06.034033 | connection |        RECV: "data:NugqK6Sa1f/0nPJN+uSI1Qzt2YY02h3yurxq5dI0JTtdsK9qX1a4jrjqP8snTkS+wm+x+qwgPo13KiMPqFgNfL+OVz70rlhNjNuRdd82C+yU5uLRUutcblDosVvmnvyYpaZNaACRhpyWe4G4SULbvcFKVBTrXWYaK0AkfwMHJqFSWIP59vBLFkJEKnM5Rito5nVxt2kZK44olChkN/lDc9TpeeQmLyYQjw2KZc1Fw0RPkbpfHNgeBEzqj2i4BxWlGLIdpecMHRaaBd79105utN7jDp8ayTSek8Ye0aC3OSCR/ptDA4BaoHkRcwvXGwV9NF+Ud6HDu6mSMP7PrE7JYQ=="
[DEBG] 2024-08-13 16:59:06.073286 | connection |        SENT: "notify:ivNonce:TmXgV2Sf5hZweart50gWhw==:@soccer99:phone.c_demos@soccer0:6zKcjvd3mHUalL9m4ttuE6EYBgCV8alBb2gAyzxxocM="
[DEBG] 2024-08-13 16:59:06.131892 | connection |        RECV: "data:ca33a073-dda3-4df4-b49f-746e6b8a747f"
```

This is the output of running `4a-monitor` in the background

```sh
[DEBG] 2024-08-13 17:25:12.464951 | connection |        SENT: "soccer99"
[DEBG] 2024-08-13 17:25:12.505367 | connection |        RECV: "f2e273c3-fdae-5983-8f6f-524b678ddf38.swarm0002.atsign.zone:6925"
[DEBG] 2024-08-13 17:25:12.930335 | connection |        SENT: "from:soccer99"
[DEBG] 2024-08-13 17:25:13.029469 | connection |        RECV: "data:_64aefeb2-f78f-4d5f-b7f8-4bb890adbc4f@soccer99:f412acbe-c5b3-4753-b1cd-62639713bd83"
[DEBG] 2024-08-13 17:25:13.083401 | connection |        SENT: "pkam:ZfdCuks28t0COWcMAt2CU0oBtoAptPAfPocB8eXi85okAUG5VmkBUwZsctvaft/cLhuGL5V+A6SP6tSBFNqiCiL1iSq2F+Rn/RRmYgqH5yDbSXaPUUK44S1+GB3sU9gf3p10D3VQ+x332o0P93VSRRjTde/jdoXSPhe3HLzp1T4MtzC2igrftB5j0S2PNyLPHM2TPOgN+6Ki61/tUp7TkOxjV3NjrR99Lkm5SYUnBMgdecV933aP3w4vGJ5+7dBaoiAGqghdNilMTSWPsZaVjGuz5tlEj8drX7moa/knZ7a8Oo5z7Q8AwB4KeeFam4o33nI7RxCqUe1XEQ6y+DVJKA=="
[DEBG] 2024-08-13 17:25:13.140190 | connection |        RECV: "data:success"
[DEBG] 2024-08-13 17:25:13.443021 | connection |        SENT: "from:soccer99"
[DEBG] 2024-08-13 17:25:13.491205 | connection |        RECV: "data:_819541d1-02cc-40fd-81fb-ad4b430f1b84@soccer99:d2da8071-fd06-4ff9-b82a-5b7609f6d70d"
[DEBG] 2024-08-13 17:25:13.544085 | connection |        SENT: "pkam:gU7xLHWtd4JRp3bebIN1HOXdZXbrNbacREjh9/9WmorOtExGWFHkGoBj1aGxgdHFIPW2yEavVW5MB2AHsT2pqYcnqMrsTe6t1wL+qUsFQyhrn3pf3vNSjIo+TQKUjT9hzNKFC3i3jaRVzt9MPlnLTGexbBQa3XmrNtxAUHGMakC2D5Syb6Mb20ThfC94V3i7x5iKUEADNexS4foAMm6sve9BFPRRKBybdo4mJeaieTzZBpXkjk7Hq7Db72Vdsoydim3pckmSJDHlh9CavshCjQTovaPGvml7UA7XfXwXZExF46lWLneJV5cMCau7p8Lxj/fwQzs9jHn/IIAe2kcI7A=="
[DEBG] 2024-08-13 17:25:13.580752 | connection |        RECV: "data:success"
[DEBG] 2024-08-13 17:25:13.581200 | connection |        SENT: "monitor .*"
[DEBG] 2024-08-13 17:25:13.581252 | atclient_monitor |  SENT: "monitor .*"
[DEBG] 2024-08-13 17:25:16.583631 | atclient_monitor | Read nothing from the monitor connection: -26624
[ERRO] 2024-08-13 17:25:16.583706 | 4a-monitor | Error reading from monitor: -26624
[DEBG] 2024-08-13 17:25:19.583969 | atclient_monitor | Read nothing from the monitor connection: -26624
[ERRO] 2024-08-13 17:25:19.584270 | 4a-monitor | Error reading from monitor: -26624
[DEBG] 2024-08-13 17:25:22.585143 | atclient_monitor | Read nothing from the monitor connection: -26624
[ERRO] 2024-08-13 17:25:22.585218 | 4a-monitor | Error reading from monitor: -26624
[DEBG] 2024-08-13 17:25:25.587677 | atclient_monitor | Read nothing from the monitor connection: -26624
[ERRO] 2024-08-13 17:25:25.588022 | 4a-monitor | Error reading from monitor: -26624
[DEBG] 2024-08-13 17:25:25.673840 | atclient_monitor |  RECV: "{"id":"-1","from":"@soccer99","to":"@soccer99","key":"statsNotification.@soccer99","value":"1256","operation":"update","epochMillis":1723569925648,"messageType":"MessageType.key","isEncrypted":false,"metadata":null}"
[INFO] 2024-08-13 17:25:25.673999 | 4a-monitor | Received notification: 1256
[DEBG] 2024-08-13 17:25:28.675689 | atclient_monitor | Read nothing from the monitor connection: -26624
[ERRO] 2024-08-13 17:25:28.675747 | 4a-monitor | Error reading from monitor: -26624
[DEBG] 2024-08-13 17:25:29.944352 | atclient_monitor |  RECV: "{"id":"959e8161-11d7-4e8f-b446-3007bf31752c","from":"@soccer0","to":"@soccer99","key":"@soccer99:phone.c_demos@soccer0","value":"mecbQnwHnapO0qIW5zbjzgfviNmKhFV+698rqGJchNA=","operation":"update","epochMillis":1723569929919,"messageType":"MessageType.key","isEncrypted":true,"metadata":{"encKeyName":null,"encAlgo":null,"ivNonce":"jtl3VItZyfOdoYKwS6n5Vw==","skeEncKeyName":null,"skeEncAlgo":null}}"
[DEBG] 2024-08-13 17:25:29.944583 | connection |        SENT: "lookup:shared_key@soccer0"
[DEBG] 2024-08-13 17:25:29.984132 | connection |        RECV: "data:dGqHeGlk00BIp0Fj9LG3MXjFXRPpi7HG/wmBRvupQA6G2WqTMENDSjR9afp10Io3MQnyhnEgB0XnhlXMnhj6vCf5BvoynOCxfU8U/rnEtRKD+H3rdxWgEr+343JWqckTMTOacsqiOqfgZ7HytEFWeIE5lhKb2EG/xvnJjBqZDq8mZP83TGI3T5UtGSxY2CI29Zjf330a762ruskf/QeeLaAVFCtDDRKaNAGz3MnDnkQw347gnsPZjvopw0j9I3PyqG9lK5kehm/+/Ha7WH/AmgfPOTDWcWR5BoCNJ+bSTja1/IzzfqwXSvgj54JEXbrAdIggRZsJYEiSQtcXxlBRHw=="
[INFO] 2024-08-13 17:25:30.023210 | 4a-monitor | Received notification: Hello! This is a notification!
```
