FROM gitpod/workspace-full:latest
#FROM ubuntu:latest

ENV ANDROID_HOME=/home/gitpod/android-sdk \
    FLUTTER_HOME=/home/gitpod/flutter     \
    DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update && apt-get -y install curl wget gnupg2 apt-utils xz-utils

RUN curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list && \
    apt-get update && \
    apt-get install dart
#     apt-get -y --no-install-recommends install build-essential libkrb5-dev gcc make gradle android-tools-adb android-tools-fastboot && \
#     apt-get clean && \
#     apt-get -y autoremove && \
#     apt-get -y clean
#    rm -rf /var/lib/apt/lists/*;

#RUN apt-get install -y gcc make build-essential wget curl unzip xz-utils libkrb5-dev gradle libpulse0

RUN apt remove --purge openjdk-*-jdk
RUN apt-get install -y openjdk-8-jdk

USER gitpod

RUN cd /home/gitpod && \
    wget -qO flutter_sdk.tar.xz \
    https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_1.22.6-stable.tar.xz &&\
    tar -xvf flutter_sdk.tar.xz && \
    rm -f flutter_sdk.tar.xz

RUN cd /home/gitpod && \
    wget -qO android_studio.tar.xz \
       https://dl.google.com/dl/android/studio/ide-zips/4.1.2.0/android-studio-ide-201.7042882-linux.tar.gz && \
    tar -xvf android_studio.tar.xz && \
    rm -f android_studio.tar.xz

RUN mkdir -p /home/gitpod/android-sdk && \
    cd /home/gitpod/android-sdk && \
     wget https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip && \
    unzip commandlinetools-linux-6858069_latest.zip && \
    rm -f commandlinetools-linux-6858069_latest.zip

