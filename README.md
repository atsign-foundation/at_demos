# at_demos

<img width=250px src="https://atsign.dev/assets/img/atPlatform_logo_gray.svg?sanitize=true">


[![GitHub License](https://img.shields.io/badge/license-BSD3-blue.svg)](./LICENSE)


Welcome! We have a collection of demo apps written to help you get a head start on your atPlatform journey. We recommend looking at the apps in the following order:

1. `at_hello_world`: A beginner app that introduces the fundamental atPlatform verbs.
2. `at_chats`, `at_cookbook`: Intermediate-level applications that build on the `at_hello_world` app to create a messaging service as well as a cookbook.
3. `@mosphere`: A production-level application (included in a separate repo) that uses advanced atPlatform verbs to stream large files across multiple Atsigns.

## Creating your atPlatform application

Just like any Flutter app, an atPlatform application requires a little bit of setup before you can get started. Here are those steps:

1. Add the service file to your app: You can simply copy this service file from the `at_hello_world` application. This file contains helper methods that allow you to implement atProtocol functionality with just a couple of lines of code.
2. Add the configuration file to your app: Again, feel free to copy this from the `at_hello_world` application. This file contains variables that allow you to use the virtual environment. Make sure that the `ROOT_DOMAIN` string is set to `vip.ve.atsign.zone` and you have a unique name for the `NAMESPACE` of your app!
3. Copy the dependencies from the `at_hello_world` pubspec.yaml file and put them into your project.


We are super glad that you are beginning your journey as an atDev. We highly recommend that you join our discord dev community for troubleshooting, dev updates, and much more!
