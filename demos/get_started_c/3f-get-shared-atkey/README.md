# 3f - Get Shared AtKey

## Description

In this example, we are getting the value of a Shared AtKey using the `atclient_get_shared_key` function. This function will return the value of the Shared AtKey that is shared with the atSign that is calling the function. This is useful for when you want to read a value that is shared with you by another atSign or when you are reading a value that you have shared with another atSign. Since the value is encrypted for the both of you, you can both read the data.

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
[DEBG] 2024-08-13 14:10:54.195749 | connection |        SENT: "soccer99"
[DEBG] 2024-08-13 14:10:54.234146 | connection |        RECV: "f2e273c3-fdae-5983-8f6f-524b678ddf38.swarm0002.atsign.zone:6925"
[DEBG] 2024-08-13 14:10:54.683967 | connection |        SENT: "from:soccer99"
[DEBG] 2024-08-13 14:10:54.722964 | connection |        RECV: "data:_5c2827d2-3c0a-4754-b5e8-c3da5d247d3f@soccer99:604b62d1-67cf-405d-8513-3c303a95603b"
[DEBG] 2024-08-13 14:10:54.771383 | connection |        SENT: "pkam:HwA+9Ok0yKYocDV5q72wh4aYiN83lLGdTIBjlIAFvg+dQiJ6YQB7JLEpgCIS+E6M7b3AqhRouNcGDR5BxIvDzM8Wi6qBfLEvCqPPRo5LTMzoJK3Lw6iSmVykC+lTgYkqIb+NMkadCwvZOJeiHowyxuL7dLvKLObKPdWqBicNrgy/95WfQC0HswQretHMK9F42d81DHs2HV+V2Ay4s7Zx7oxZjhLGO+Ekg3ndrLyogaWT/wew+vCEqq6wXIjlKntllrVUa9z2BPywV189xR/4JmRn+h9Yqud00cu71GuVz1uK8FCH4sVud5kaxRhUcPo0+5rNbzODSFTLyd4VnEUSIA=="
[DEBG] 2024-08-13 14:10:54.812088 | connection |        RECV: "data:success"
[DEBG] 2024-08-13 14:10:54.812733 | connection |        SENT: "llookup:shared_key.soccer0@soccer99"
[DEBG] 2024-08-13 14:10:54.854335 | connection |        RECV: "data:GRluAnPbZML0MVUCoq/MWwv0ZVZyRNigrKoeMyn2pZxBujbfPk+KAoGmOmwvEJGsYuplAKZLLreV3QcQxHxUaHQ/weWwXMrgaogJkUlSt99fUAl/vZmK0hG31tnyJ4suEQTJHAUlmc09fy1mLlP/oBZuRLijL9aH0XirGsd7wAoFFuNNaKwhN0Lx8mVjrQNqq4uY39pJuMWAPebLG6uNQk6PZX8GQ9tu15YGerJqRJUsVrXVkPq3jNmRMaMjZWbluz/bzD7b7BK207WqiMv938awGD0qfixPjVg8gY2kY+8uMMXYlVe8eZz4C0LC/egFeEXJkidY2FeNCeJ8oIMtgQ=="
[DEBG] 2024-08-13 14:10:54.925436 | connection |        SENT: "llookup:all:@soccer0:phone.c_demos@soccer99"
[DEBG] 2024-08-13 14:10:54.963870 | connection |        RECV: "data:{"key":"@soccer0:phone.c_demos@soccer99","data":"o1W9ueAeeKSGPoNret8v3g==","metaData":{"createdBy":"@soccer99","updatedBy":"@soccer99","createdAt":"2024-08-13 14:10:27.480Z","updatedAt":"2024-08-13 14:10:27.480Z","status":"active","version":0,"isBinary":false,"isEncrypted":false,"ivNonce":"wWMMdQqECydB6cKOKSc39A=="}}"
[INFO] 2024-08-13 14:10:54.965257 | 3E-get-self-atkey | value: "123-456-7890"
```