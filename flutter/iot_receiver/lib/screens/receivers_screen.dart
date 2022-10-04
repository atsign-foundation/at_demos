import 'package:at_utils/at_logger.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:iot_receiver/models/hro2_receiver.dart';
import 'package:iot_receiver/services/hro2_data_service.dart';
import 'package:iot_receiver/widgets/hro2_drawer_widget.dart';
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
  final Hro2DataService _hrO2DataService = Hro2DataService();

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
      ),
      drawer: const HRo2DrawerWidget(),
      body: Builder(
          builder: (context) => FutureBuilder<List<HrO2Receiver>>(
              future: _hrO2DataService.getReceivers(),
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
                          const align = Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Icon(Icons.delete),
                              ));
                          return GestureDetector(
                            onTap: () async{
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  NewHrO2Receiver(hrO2Receiver: receiver,)),
                              );
                            },
                            child: Dismissible(
                              key: Key(receiver.receiverAtsign),
                              background: Container(
                                color: Colors.red,
                                child: align,
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
                              onDismissed: (_) async {
                                hrO2ReceiverList.remove(receiver);
                                await _hrO2DataService.deleteReceiver(receiver);
                                setState(() {});
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
                                        ? "sending o2 saturation"
                                        : "")),
                                // trailing: const Icon(Icons.navigate_next),
                              ),
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
