import 'dart:io';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_utils/at_logger.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:iot_receiver/models/hro2_receiver.dart';
import 'package:iot_receiver/screens/devices_screen.dart';
import 'package:iot_receiver/services/hro2_data_service.dart';
import 'package:iot_receiver/widgets/new_receiver_dialog.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

final AtSignLogger _logger = AtSignLogger('ReceiversScreen');

class ReceiversScreen extends StatefulWidget {
  const ReceiversScreen({Key? key}) : super(key: key);
  static const String id = '/receivers_screen';
  @override
  State<ReceiversScreen> createState() => _ReceiversScreenState();
}

class _ReceiversScreenState extends State<ReceiversScreen> {
  final HrO2DataService _hrO2DataService = HrO2DataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        title: const AutoSizeText(
          'Receivers',
          minFontSize: 5,
          maxFontSize: 50,
        ),
        gradient: const LinearGradient(colors: [
          Color.fromARGB(255, 173, 83, 78),
          Color.fromARGB(255, 108, 169, 197)
        ]),
        actions: [
          PopupMenuButton<String>(
            color: const Color.fromARGB(255, 108, 169, 197),
            //padding: const EdgeInsets.symmetric(horizontal: 10),
            icon: const Icon(
              Icons.menu,
              size: 20,
            ),
            onSelected: (String result) {
              switch (result) {
                case 'NEW RECEIVER':
                  Navigator.of(context).pushNamed(NewHrO2Receiver.id);
                  break;
                case 'DELETE LIST':
                  AtKey atKey = AtKey()..key = AppConstants.receiverListKey;
                  HrO2DataService().delete(atKey);
                  break;
                case 'DEVICES':
                  Navigator.of(context).pushNamed(DevicesScreen.id);
                  break;
                case 'CLOSE':
                  exit(0);
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                height: 20,
                value: 'NEW RECEIVER',
                child: Text(
                  'NEW RECEIVER',
                  style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 5,
                      backgroundColor: Color.fromARGB(255, 108, 169, 197),
                      color: Colors.black),
                ),
              ),
              const PopupMenuItem<String>(
                height: 20,
                value: 'DELETE LIST',
                child: Text(
                  'DELETE LIST',
                  style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 5,
                      backgroundColor: Color.fromARGB(255, 108, 169, 197),
                      color: Colors.black),
                ),
              ),
              const PopupMenuItem<String>(
                height: 20,
                value: 'DEVICES',
                child: Text(
                  'SEE DEVICES',
                  style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 5,
                      backgroundColor: Color.fromARGB(255, 108, 169, 197),
                      color: Colors.black),
                ),
              ),
              const PopupMenuItem<String>(
                height: 20,
                value: 'CLOSE',
                child: Text(
                  'CLOSE',
                  style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 5,
                      backgroundColor: Color.fromARGB(255, 108, 169, 197),
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Builder(
          builder: (context) => FutureBuilder<List<HrO2Receiver>>(
              future: _hrO2DataService.getReceiverList(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<HrO2Receiver>> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  List<HrO2Receiver>? hrO2ReceiverList = snapshot.data;
                  children = <Widget>[
                    const Text(
                      "The following receivers have been created.",
                      overflow: TextOverflow.visible,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        // padding: const EdgeInsets.symmetric(
                        //     vertical: 5, horizontal: 20),
                        itemCount: hrO2ReceiverList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final HrO2Receiver receiver = hrO2ReceiverList[index];
                          return Dismissible(
                            key: Key(receiver.receiverAtsign),
                            background: Container(
                              color: Colors.red,
                              child: const Align(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 16),
                                    child: Icon(Icons.delete),
                                  ),
                                  alignment: Alignment.centerRight),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                return false;
                              } else {
                                bool delete = true;
                                final snackbarController =
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Delete ${receiver.receiverAtsign} ?'),
                                    action: SnackBarAction(
                                        label: 'Cancel',
                                        onPressed: () => delete = false),
                                  ),
                                );
                                await snackbarController.closed;
                                return delete;
                              }
                            },
                            onDismissed: (_) {
                              setState(() {
                                hrO2ReceiverList.remove(receiver);
                                _hrO2DataService
                                    .putReceiverList(hrO2ReceiverList);
                              });
                            },
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.blue, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              title:
                                  Text(hrO2ReceiverList[index].receiverAtsign),
                              subtitle: Text((hrO2ReceiverList[index].sendHR
                                      ? "sending heart rate"
                                      : "") +
                                  (hrO2ReceiverList[index].sendHR &&
                                          hrO2ReceiverList[index].sendO2
                                      ? ", and "
                                      : "") +
                                  (hrO2ReceiverList[index].sendO2
                                      ? "sending o2"
                                      : "")),
                              // trailing: const Icon(Icons.navigate_next),
                            ),
                          );
                        }),
                  ];
                } else if (snapshot.hasError) {
                  _logger.severe(snapshot.error);
                  children = <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                          '${snapshot.error}, please click the + button below to add a receiver.'),
                    ),
                  ];
                } else {
                  children = <Widget>[
                    // DoOnboardWidget(
                    //     // futurePreference: widget.futurePreference,
                    //     ),
                  ];
                }
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                );
                // child:
              })),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          var newReceiver = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewHrO2Receiver()),
          );
          if (newReceiver == null) {
          } else {
            setState(() {
              // receivers.add(newReceiver);
              // saveReceivers(receivers);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
