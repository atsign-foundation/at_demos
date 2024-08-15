# 3c - Put Shared AtKey

## Description

In this example, we will learn how to put a Shared AtKey. 

A Shared AtKey is an AtKey that points to a value on your atServer that is specially encrypted for a specific `shared_with` atSign. That means, as @soccer99, I can create a Shared AtKey that is shared with @soccer0 and @soccer99 where only those two atSigns will be able to read the value that the AtKey points to. This is an important concept when writing your own end-to-end encrypted Atsign applications.

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
    cd at_demos/demos/get_started_c/3c-put-shared-atkey
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
[DEBG] 2024-08-13 14:10:26.791854 | connection |        SENT: "soccer99"
[DEBG] 2024-08-13 14:10:26.827739 | connection |        RECV: "f2e273c3-fdae-5983-8f6f-524b678ddf38.swarm0002.atsign.zone:6925"
[DEBG] 2024-08-13 14:10:27.187802 | connection |        SENT: "from:soccer99"
[DEBG] 2024-08-13 14:10:27.236573 | connection |        RECV: "data:_6dcae875-8787-47df-9abc-feb0f37122f9@soccer99:e27bed1d-6634-4664-83ed-fccc786d8e75"
[DEBG] 2024-08-13 14:10:27.311265 | connection |        SENT: "pkam:UB1l1RlGskIjKlq0zP1FPMbGuwxFJ59lceWokO67o0yxqMSYfOEzlmghIWNuTAqqq/oywVSe4KwWx2uht5i1KYnIJf7+95yL5qsx8m1c5v10WzIzIUGWMoEAeeGkzpQAi7qLNDvZMcjdR4YIIV43AgQEWp3bVPgqEbrMt444uSLF2KYaNjiYhQMJX9S/PwMR/WH7FzTdsy68LNGvzMyAI05+tWSGDF3CmEbCjpqrs0bPMNsW8dSA9+2dQYFoyIs3vWN5Ea3yyi/dclrCwwk1Zwe6P930YpTzg/XWgIZi013mXFsVKuDJ4ZdIbD6iz3cKaqqT9quyuvU3i0vK2LYAjA=="
[DEBG] 2024-08-13 14:10:27.346437 | connection |        RECV: "data:success"
[DEBG] 2024-08-13 14:10:27.347081 | connection |        SENT: "llookup:shared_key.soccer0@soccer99"
[DEBG] 2024-08-13 14:10:27.387394 | connection |        RECV: "data:GRluAnPbZML0MVUCoq/MWwv0ZVZyRNigrKoeMyn2pZxBujbfPk+KAoGmOmwvEJGsYuplAKZLLreV3QcQxHxUaHQ/weWwXMrgaogJkUlSt99fUAl/vZmK0hG31tnyJ4suEQTJHAUlmc09fy1mLlP/oBZuRLijL9aH0XirGsd7wAoFFuNNaKwhN0Lx8mVjrQNqq4uY39pJuMWAPebLG6uNQk6PZX8GQ9tu15YGerJqRJUsVrXVkPq3jNmRMaMjZWbluz/bzD7b7BK207WqiMv938awGD0qfixPjVg8gY2kY+8uMMXYlVe8eZz4C0LC/egFeEXJkidY2FeNCeJ8oIMtgQ=="
[DEBG] 2024-08-13 14:10:27.451918 | connection |        SENT: "update:ivNonce:wWMMdQqECydB6cKOKSc39A==:@soccer0:phone.c_demos@soccer99 o1W9ueAeeKSGPoNret8v3g=="
[DEBG] 2024-08-13 14:10:27.508017 | connection |        RECV: "data:1253"
```