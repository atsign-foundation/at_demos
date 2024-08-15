# 3e - Get Self AtKey

## Description

In this example, we are using `atclient_get_self_key` to retrieve a value that has been specially encrypted for our atSign's atKeys. This is useful for when you want to store data that only you can read. This is useful for storing sensitive information that you do not want to be public.

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
    cd at_demos/demos/get_started_c/3e-get-self-atkey
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
[DEBG] 2024-08-13 14:05:37.736989 | connection |        SENT: "soccer99"
[DEBG] 2024-08-13 14:05:37.776706 | connection |        RECV: "f2e273c3-fdae-5983-8f6f-524b678ddf38.swarm0002.atsign.zone:6925"
[DEBG] 2024-08-13 14:05:38.205265 | connection |        SENT: "from:soccer99"
[DEBG] 2024-08-13 14:05:38.242897 | connection |        RECV: "data:_160f3661-937a-448c-aac8-fb1b4fdb369b@soccer99:e91bda8e-053f-465e-96a6-72ecc7d3914d"
[DEBG] 2024-08-13 14:05:38.287194 | connection |        SENT: "pkam:IxetMxnF/YRFNhC+WjnTkEC2IuokzSCfF+iEbgdviMI7Rhf5VGo7Fs13745+7pHd4jGiE9xNtE4AW7qam/z56Zt7GUDFmUvRKxx5QxahPEXd37SpRLF5IBu4lLOEHalViIPIsJkbt20rPFV/uXI3oa1n//UXHMuu8wY0HSXmwTpc7H+qY/UvJG9kgzKh2YIFFcyHJO100SvvlaM2uz4jTUu7BKoeWu37+UjyIqdluYXEq4yZYNYVrELydoyq5XVhTrficpaIUUGlhKxn9MwR1LepmzRnf1PVNeaFt0hpleYIHG6GC1753Jz5y8RmKP1VQPItJ/lp+uMbj8oBR6BSnw=="
[DEBG] 2024-08-13 14:05:38.330444 | connection |        RECV: "data:success"
[DEBG] 2024-08-13 14:05:38.331088 | connection |        SENT: "llookup:all:phone.c_demos@soccer99"
[DEBG] 2024-08-13 14:05:38.364783 | connection |        RECV: "data:{"key":"phone.c_demos@soccer99","data":"zRipyX8FAC2IUJp8KuIWvQ==","metaData":{"createdBy":"@soccer99","updatedBy":"@soccer99","createdAt":"2024-08-13 00:57:33.957Z","updatedAt":"2024-08-13 01:13:57.337Z","status":"active","version":1,"isBinary":false,"isEncrypted":false,"ivNonce":"VaHBS9YBeVxJWBrNDcm6xw=="}}"
[INFO] 2024-08-13 14:05:38.365410 | 3E-get-self-atkey | value: "123-456-7890"
```