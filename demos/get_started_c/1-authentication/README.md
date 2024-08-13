# 1 - authentication

## Description

In this first example, we will show you how to PKAM authenticate with your atSign's atServer. This application is a barebones application with nothing but the authentication process. The application will authenticate with the atServer and print out a message saying that it has authenticated successfully.

PKAM Authentication will require you to already have your atSign activated, which consequently means that you have the atSign's atKeys already generated and are stored in the `~/.atsign/keys/` directory. If you do not have your atSign's keys already, you will need to activate your atSign using at_activate.

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
    cd at_demos/demos/get_started_c/1-authentication
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
[DEBG] 2024-08-12 15:33:31.227990 | connection |        SENT: "soccer99"
[DEBG] 2024-08-12 15:33:31.261288 | connection |        RECV: "f2e273c3-fdae-5983-8f6f-524b678ddf38.swarm0002.atsign.zone:6925"
[DEBG] 2024-08-12 15:33:31.642959 | connection |        SENT: "from:soccer99"
[DEBG] 2024-08-12 15:33:31.679654 | connection |        RECV: "data:_691a27a0-be50-4080-9a00-1617f12ba882@soccer99:52d51199-2fdc-42e5-b122-382e46d52fbe"
[DEBG] 2024-08-12 15:33:31.718106 | connection |        SENT: "pkam:Z8k1TOIj+g+Qw6DlXApa47HEpiYD2s+7xm7XJNpTV/GZ3M+/qkWNAGVTsG57L1+3bvQCFJ5KfJNuACevMkshGJnBkhI2MSrLtn2vz4jhYRzCoRVn7alJOTtpTh9Sorca170zPT8iQyG3QbmmOTMgRwzmQjrXxSAQlSwH4nm5lGux92Yt+twrzM6yxPXH3S2Vhnt81HYOB74PVlqV+buPzxzbAFC4Qhk+2Igt9sEDGGAkSmcQilyJobiB1QtWKDoSh4anR4dBf1cLHncIHYi12y5C5PNma7DDZC/mwVVM6CrzZ/Ya6RlPVXm2Q5cfL7Eo7qXFqoWYXv9oPvF74cfzAQ=="
[DEBG] 2024-08-12 15:33:31.757393 | connection |        RECV: "data:success"
[INFO] 2024-08-12 15:33:31.757463 | 1-authentication | Authenticated to atServer successfully!
```