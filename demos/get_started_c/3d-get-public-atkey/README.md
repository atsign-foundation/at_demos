# 3d - Get Public AtKey

## Description

In this example, we are obtaining the public data that is hidden behind the public AtKey we created in example 3a. In this scenario, the `shared_by` atSign could be *any* atSign (it does not only have to be the pkam authenticated atSign that we originally authenticated with). Since we can see the public data of any atSign on any atServer, we can pass in any activated atSign into the shared_by argument.

But for our purposes, we will just attempt to read the public AtKey that happens to be on our atServer which we created.

As you can see from the example, we will create the AtKey then call the `atclient_get_public_key` method which will go ahead and fetch the value for us from the atServer.

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
    cd at_demos/demos/get_started_c/3d-get-public-atkey
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
[DEBG] 2024-08-13 13:57:24.647932 | connection |        SENT: "soccer99"
[DEBG] 2024-08-13 13:57:24.685866 | connection |        RECV: "f2e273c3-fdae-5983-8f6f-524b678ddf38.swarm0002.atsign.zone:6925"
[DEBG] 2024-08-13 13:57:28.173144 | connection |        SENT: "from:soccer99"
[DEBG] 2024-08-13 13:57:28.210100 | connection |        RECV: "data:_eb7672d6-8e95-4de2-bfda-58a5499d4431@soccer99:fe706530-d01e-4971-b8f5-1b3a7cea68e9"
[DEBG] 2024-08-13 13:57:28.248171 | connection |        SENT: "pkam:Y/3UxXY/PafSqmIXLrTUhugR8Ih5nbjAEQA+xYmUVH0xnH83ab9vBorkJfRt++USDk4UYLPz1GL5/pqQQy847aDsqXakthZQXkSHVEERJj3U2JBW1JaQWCVPJFT8EKoB6THZYdP90Js5su2xonxEYgQXMKKIuY1PBjjh30TzEytwfixvK17m8/fTrxA+NQ2rXU4zFgYiSLIiuUHCMIrjZUIx4w05drjn2HaxIwhjK+oCaabW4inD6PEzlgA1ggZ3AUZYd5FY+0tuiR1cJHN6z9gySx+2jARyoBFUHKGoqHlyyZ2bmU74fnb+kMFog+/P8JGJGVpYFh+afX6q8dMsiw=="
[DEBG] 2024-08-13 13:57:28.295610 | connection |        RECV: "data:success"
[DEBG] 2024-08-13 13:57:28.295775 | connection |        SENT: "plookup:all:phone.c_demos@soccer99"
[DEBG] 2024-08-13 13:57:28.615529 | connection |        RECV: "data:{"data":"123-456-7890","metaData":{"createdBy":"@soccer99","updatedBy":"@soccer99","createdAt":"2024-08-13 01:19:33.844Z","updatedAt":"2024-08-13 01:19:33.844Z","status":"active","version":0,"isBinary":false,"isEncrypted":false},"key":"public:phone.c_demos@soccer99"}"
[INFO] 2024-08-13 13:57:28.615635 | 3d-get-public-atkey | value: "123-456-7890"
```