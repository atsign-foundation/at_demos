# 4a - Monitor

## Description

Monitor is useful for listening for notifications (which are known as real-time events) that are sent to you by other atServers. You will first have to `#include <atclient/monitor.h>` at the top of your C program to use monitor functions.

This program won't do anything but give you errors when running the program. This is intended. Every time we run `atclient_monitor_read` it attemps to read the network buffer for any notifications. And if there aren't any notifications, it cannot differentiate the difference between a network error and no notifications. This is why you see the error messages and is normal behaviour. It is up to the programmer to evaluate whether they should check if they are truly connected to the server (send a heartbeat ping) or if they should just ignore the error messages.

In the next example (4b-notify), we will send a notification to our monitor client and the monitor client will be able to read the notification.

## Files

- [main.c](./main.c) - The main file that contains the code for the application.
- [CMakeLists.txt](./CMakeLists.txt) - The CMake file that contains the build instructions for the application.

## How To Run The Example

The following instructions are for running the example on a Linux/MacOS machine. You could run it on a Windows machine given that you are either running it on a Windows Subsystem for Linux (WSL), using a Linux virtual machine, or using a Bash shell like Git Bash. You could also run it on a Windows command prompt, given that you have the necessary tools and you know what commands do what.

1. Clone the repository.

    ```sh
    git clone https://github.com/atsign-foundation/at_demos.git
    ```

1. Change the "ATSIGN" line in `main.c` to an atSign you have set up already. It is assumed that you atSign's keys are in the `~/.atsign/keys/` directory. For example, I have my `@soccer99` keys set up with the file `@soccer99_key.atKeys` in the `/home/jeremy/.atsign/keys/` directory. If you do not have your atSign's keys already, you will need to activate your atSign using at_activate.

    ```c
    #define ATSIGN "@<YOUR_ATSIGN>"
    ```

1. Navigate to the `get_started_c` directory.

    ```sh
    cd at_demos/demos/get_started_c/4a-monitor
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

```sh
$ ./build/main
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
```