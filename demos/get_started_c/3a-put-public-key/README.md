# 3a - Put Public AtKey

## Description

In this example, we are putting a Public value behind a Public AtKey onto our atServer. By putting a public value, the value is not encrypted and can be accessed by any atSign. This is useful for sharing information that you want to be publicly accessible.

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
    cd at_demos/demos/get_started_c/3a-put-self-key
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
[DEBG] 2024-08-13 01:19:33.201884 | connection |        SENT: "soccer99"
[DEBG] 2024-08-13 01:19:33.236603 | connection |        RECV: "f2e273c3-fdae-5983-8f6f-524b678ddf38.swarm0002.atsign.zone:6925"
[DEBG] 2024-08-13 01:19:33.691836 | connection |        SENT: "from:soccer99"
[DEBG] 2024-08-13 01:19:33.726807 | connection |        RECV: "data:_c63cbc3a-0d99-4323-bfd2-9b9052813cf0@soccer99:6ca669a1-6957-4fc3-8c1f-bd516b2f88d3"
[DEBG] 2024-08-13 01:19:33.788857 | connection |        SENT: "pkam:IZx7r/V+msbrNFd/qg3VDkVoAbGFovTHMD0Nwze6tUiC4PqQ40nd95VSbdhL0s9HyaRrpYh2pMKPcqkIg82HxH/8tRDG6/4O4iTqy7eCY1pz7/Wvltvh5cOIPlg3Je0wTcmXlUGmI3bl9XH9Rhjwsx66XLNbpRMRrvikhW3rwlrzaZnnaMUuj09LLGkd8tzscqZumFynhYpK00270SkClyPGoct5F1GXJPZidDFqQXJO0QqmAQn4l25iDeJQB+Ib2dCCP5q6dT9rWn2uIcemWQh8Q57kJCeHLVA7HfzmWAtRIjP7mrgRTOik5YlSMNEkvTJWVJP6hdyksK7l1fsU1w=="
[DEBG] 2024-08-13 01:19:33.832183 | connection |        RECV: "data:success"
[DEBG] 2024-08-13 01:19:33.832465 | connection |        SENT: "update:public:phone.c_demos@soccer99 123-456-7890"
[DEBG] 2024-08-13 01:19:33.877283 | connection |        RECV: "data:1239"
```