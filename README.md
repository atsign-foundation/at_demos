<h1><a href="https://atsign.com#gh-light-mode-only"><img width=250px src="https://atsign.com/wp-content/uploads/2022/05/atsign-logo-horizontal-color2022.svg#gh-light-mode-only" alt="The Atsign Foundation"></a><a href="https://atsign.com#gh-dark-mode-only"><img width=250px src="https://atsign.com/wp-content/uploads/2023/08/atsign-logo-horizontal-reverse2022-Color.svg#gh-dark-mode-only" alt="The Atsign Foundation"></a></h1>

# at_demos

[![GitHub License](https://img.shields.io/badge/license-BSD3-blue.svg)](./LICENSE)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/atsign-foundation/at_demos/badge)](https://securityscorecards.dev/viewer/?uri=github.com/atsign-foundation/at_demos&sort_by=check-score&sort_direction=desc)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/8110/badge)](https://www.bestpractices.dev/projects/8110)
Welcome! We have a collection of demo apps written to help you get a head start
on your atPlatform journey. We recommend looking at the apps in the following
order:
1. `at_getting_started` : Learn the fundamental elements of the atPlatform. Cut your own cryptographic keys
    with at_activate. Then with at_put to send and at_get to receive asynchronous data. Then move on to near realtime communication with at_send and at_receive.

2. `at_rpc_demo` : Sample 'client' and 'server' programs which demonstrate
   the use of the AtRpc library in the
   [at_client](https://pub.dev/packages/at_client) package.

3. `at_notifications`: A demo using `.notify` and `.subscribe` to send/receive
   notifications in the atPlatform. Demo uses [at_client] as the core dependency
   to utilize the atProtocol and [at_onboarding_cli] to authenticate atSigns to
   their atServers. To begin, follow the steps outlined in
   the [README](./at_notifications/README.md) of at_notifications to get
   started!
4. You should also definitely check out the
   [at_talk](https://github.com/atsign-foundation/at_talk) repo which
   shows how to build a simple end-to-end encrypted messaging app with the
   atPlatform.

5. `qt_atsign_plant_demo` a demo of using Atsign's technology with Qt's QML in Python to remotely and securely control/monitor a plant from a Qt app involving 2 raspberry pis, 4 sensors, and 1 actuator. Check it out here: [qt_atsign_plant_demo](./qt_atsign_plant_demo/)

6. `sshnp_raspberrypi_demo`: A demo establishing an SSH connection between a
   Raspberry Pi 4 Model B and a client device without requiring any open ports
   on the host machine (not even port 22). To begin, follow the steps outlined
   in the [README](./sshnp_raspberrypi_demo/README.md) of sshnp_raspberrypi_demo
   to get started!

7. `sshnp_docker_demo`: A demo to establish an SSH connection between two
   Docker containers without requiring any open ports on the host machine (not
   even port 22). To begin, follow the steps outlined in
   the [README](./sshnp_docker_demo/README.md) of sshnp_docker_demo to get
   started!

We are super glad that you are beginning your journey as an atDev. We highly
recommend that you join our discord dev community for troubleshooting, dev
updates, and much more!
