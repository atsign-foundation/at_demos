# 2c-shared-atkey

## Description

In this example, we learn how to create a shared AtKey.

A shared AtKey is an AtKey that points to a value that is specially encrypted only for the specified `shared_with` atSign. That means, as @soccer0, I can create a Shared AtKey that is shared with @soccer99 and only me and @soccer99 will be able to read the value that the AtKey points to. This is an important concept when writing your own end-to-end encrypted Atsign applications.

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
    cd at_demos/demos/get_started_c/2c-create-shared-atkey
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