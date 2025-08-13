# 3b - Put Self Key

## Description

In this example, we will learn how to PUT a self key. By creating a SelfKey, we describe the AtKey's key (which is similar to an identifier or name), the sharedby atSign (the shared by atSign should always be the authenticated atSign that is putting the key), as well as the namespace which should be an atSign that you own and have the keys for.

This will put a value into your atServer that only your atSign's keys can decrypt.

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
    cd at_demos/demos/get_started_c/3b-put-self-atkey
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
[DEBG] 2024-08-13 00:57:33.459772 | connection |        SENT: "soccer99"
[DEBG] 2024-08-13 00:57:33.498490 | connection |        RECV: "f2e273c3-fdae-5983-8f6f-524b678ddf38.swarm0002.atsign.zone:6925"
[DEBG] 2024-08-13 00:57:33.816554 | connection |        SENT: "from:soccer99"
[DEBG] 2024-08-13 00:57:33.851395 | connection |        RECV: "data:_3dfc961f-7df2-40ca-a928-1196a90295c5@soccer99:af27499e-077a-49e1-a48c-dfe6308ccb6b"
[DEBG] 2024-08-13 00:57:33.889825 | connection |        SENT: "pkam:c/pu43WuNkhTH+1UAkmig2D5cpni6FQEIvYDbNczXOQqSvgayerFG4PxL4EcDkMQoXx7vCGAgl65xQwjG0KJgQyFmogeB7kkK6USPvtoCnAF5fuopZWK13aEFCo0dSwqYKihRN3rxJ8Rm7ElsC6T7x72DS0869YlSjhdHi+tHGiCIlo+EIQKtq1T5he/pte+W098Qba5Xve3GYI7L7yk/mmyo0eHldZepVCI1AQQUDE7CLXA3bKYVqY0U5LXIY4UHn8lIqSTGdlC3yzEnqbyxf76JXP+fEO/PKMz6EJmY0Qddaum1aSaHGyODKdVU3vMrHUbDyQ6HcnmVJzgLs1sgA=="
[DEBG] 2024-08-13 00:57:33.930166 | connection |        RECV: "data:success"
[DEBG] 2024-08-13 00:57:33.930551 | connection |        SENT: "update:ivNonce:zp4M3feKLksgDBp0RWeDqg==:phone.c_demos@soccer99 D5zOodf884cHtgnEANYmfA=="
[DEBG] 2024-08-13 00:57:33.982410 | connection |        RECV: "data:1237
```