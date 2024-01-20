**at_getting_started**

A few getting started examples using the atPlatform and atSDK using atKey's and atNotifications using the Dart programing language.

Dart can be used on most modern OS's go to [dart.dev](https://dart.dev) to find the version for your OS and install it. Dart uses plain text files so any editor can be used but [VSCode](https://code.visualstudio.com/) offers an excellent Dart programming IDE.

  

To get this code on to you machine you can use [GitHub Desktop](https://desktop.github.com/) or just [git](https://git-scm.com/) and "clone" the repo.

  

Once your Dart environment is installed and you are in the IDE or command line you need to run `dart pub get` this will pull in the needed behind the scenes code and you are ready to go with the code. But first you will need at least two atSigns. These are free or purchased (if you want a personal name) at [Atsign.com](https://atsign.com).

  

Once you have your atSigns you can activate them with `at_activate.dart` using the command `dart run bin/at_activate.dart --atsign <@your atSign>`. Substitute your atSign and it will email you a one time password and cut your cryptographic keys. You will need to do this twice so you have two atSigns to send data from and too.

here is my at_activate of @75colouring

[![asciicast](https://asciinema.org/a/jONqnVe7a5U71K4u33SCuKmOK.svg)](https://asciinema.org/a/jONqnVe7a5U71K4u33SCuKmOK)

  

Next you can use at_key_get to get some encrypted data from an atSign and at_key_put to send it. With commands like this:

  

`dart run bin/at_key_get.dart -a @myatSign -o @otherAtsign -n hello`

  

Remember to put in YOUR atSigns !!

  

You will see nothing at you have not sent anything so do that with a command like

  

`dart run bin/at_key_put.dart -a @otherAtsign -o @myAtsign -n hello -m "hello world"`

  

Again, remember to use your atSigns and swap the send and the recevier! Now if you rerun the first command you will se the "hello world" message along with Meta Data. You will notice in the meta data that there is a TTL. This is a Time to Live in microseconds, so in one minute this data will self distruct (cool!). Try again after a minute and the data is gone.

Here is my session to look at..

[![asciicast](https://asciinema.org/a/1hTyAEN2aSZdOCNkYCPeM46H9.svg)](https://asciinema.org/a/1hTyAEN2aSZdOCNkYCPeM46H9)

  

This is classically know as store and forward messaging but what about near real-time communications? For that we need to use notifications. We have a sender `at_notify_send.dart` and `at_notify_receive.dart` to demonstrate this. Here is mine in action again.

  

[![asciicast](https://asciinema.org/a/RalndACpb8PXoFClpQWiZBfq8.svg)](https://asciinema.org/a/RalndACpb8PXoFClpQWiZBfq8)

  

If you now look at the code, you should be able to build on it for your project and know that communication is private by design.

Take a look at the other demos and see how they build on these primitives of atKeys and notifications.