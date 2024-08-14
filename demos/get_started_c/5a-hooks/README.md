# 5a - Hooks

## Description

In this example, we set up a Pre Write Hook.

A Pre Write hook is just one hook you can set up for your atclient_connection, where with pre write hooks, we will call a function (that you define) before we write anything to the atServer.

This is useful for resilient connections, where you may want to check if you are first connected (and reconnection, if necessary) to your atServer before running any commands to it.

In this example, we simply log a message before we write anything to the atServer.

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
    cd at_demos/demos/get_started_c/5a-hooks
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
[DEBG] 2024-08-14 00:07:53.164669 | connection |        SENT: "soccer0"
[DEBG] 2024-08-14 00:07:53.199749 | connection |        RECV: "3733e916-a5d4-5f5a-b527-a53645304a6c.swarm0002.atsign.zone:6926"
[DEBG] 2024-08-14 00:07:53.467401 | connection |        SENT: "from:soccer0"
[DEBG] 2024-08-14 00:07:53.504849 | connection |        RECV: "data:_c5b43b18-97ff-45b3-a9cf-bf695c9e1f70@soccer0:b198de31-10f5-4bab-a272-67f5cee6f326"
[DEBG] 2024-08-14 00:07:53.577491 | connection |        SENT: "pkam:kXg+UUHBf4oMOl1yEK7xtwF7fP0B+WgKLAPnsKGZPIjC27Np5c3w9h7tPqhu6owyRCQZ37p2+wvNzc1IGhpEGIFZCZJBtcZiVj2fctAjh6dWe7Dt3IIX7ruIonSqDU61xtbaAPKIGWu476tIWEx3K02m30u16ADt2p3r8k2kSko6Uqla7exUNY9mOy8fg7JBHqwecOhLxbm4DDwuuR/KV8T74bqgBJzmE8GTvXI2nB4gUpPGTtA+bar2LYN3fHWA5I7fNKsJIX/6aYX7xRgW8mYMikniL1Bcf+4nhAnlJpHbnxMNJGxjS8Fq+VkT4i70MFxzhvORlivkkCFgwh7YHA=="
[DEBG] 2024-08-14 00:07:53.613937 | connection |        RECV: "data:success"
[INFO] 2024-08-14 00:07:53.614055 | 5a-hooks | Hooks set up successfully.
[DEBG] 2024-08-14 00:07:53.614126 | 5a-hooks | pre_write_hook called
[DEBG] 2024-08-14 00:07:53.614246 | connection |        SENT: "llookup:shared_key.soccer99@soccer0"
[DEBG] 2024-08-14 00:07:53.645480 | connection |        RECV: "data:NugqK6Sa1f/0nPJN+uSI1Qzt2YY02h3yurxq5dI0JTtdsK9qX1a4jrjqP8snTkS+wm+x+qwgPo13KiMPqFgNfL+OVz70rlhNjNuRdd82C+yU5uLRUutcblDosVvmnvyYpaZNaACRhpyWe4G4SULbvcFKVBTrXWYaK0AkfwMHJqFSWIP59vBLFkJEKnM5Rito5nVxt2kZK44olChkN/lDc9TpeeQmLyYQjw2KZc1Fw0RPkbpfHNgeBEzqj2i4BxWlGLIdpecMHRaaBd79105utN7jDp8ayTSek8Ye0aC3OSCR/ptDA4BaoHkRcwvXGwV9NF+Ud6HDu6mSMP7PrE7JYQ=="
[DEBG] 2024-08-14 00:07:53.704234 | 5a-hooks | pre_write_hook called
[DEBG] 2024-08-14 00:07:53.704407 | connection |        SENT: "notify:ivNonce:3uxw0xR4mbPUnp6UaBv/MA==:@soccer99:phone.c_demos@soccer0:7rMMrQNyY7S/SCeQj3ADxVNkae7TUJkzVKTbbMD6BB0="
[DEBG] 2024-08-14 00:07:53.743089 | connection |        RECV: "data:6833e78f-e086-4eec-be2e-1f9f8fec901b"
```
