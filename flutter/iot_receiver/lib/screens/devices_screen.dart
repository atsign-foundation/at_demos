import 'dart:io';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:iot_receiver/models/hro2_device.dart';
import 'package:iot_receiver/screens/receivers_screen.dart';
import 'package:iot_receiver/services/hro2_data_service.dart';
import 'package:iot_receiver/widgets/new_device_dialog.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({Key? key}) : super(key: key);
  static const String id = '/devices_screen';
  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  final HrO2DataService _hrO2DataService = HrO2DataService();

  @override
  Widget build(BuildContext context) {
    // * Getting the AtClientManager instance to use below
    //AtClientManager atClientManager = AtClientManager.getInstance();
    // double _width = MediaQuery.of(context).size.width;
    // double _height = MediaQuery.of(context).size.height;
    // var mediaQuery = MediaQuery.of(context);
    // var _width = mediaQuery.size.width * mediaQuery.devicePixelRatio;
    // var _height = mediaQuery.size.height * mediaQuery.devicePixelRatio;

    return Scaffold(
      appBar: NewGradientAppBar(
        title: const AutoSizeText(
          'Devices',
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
                case 'NEW DEVICE':
                  Navigator.of(context).pushNamed(NewHrO2Device.id);
                  break;
                case 'DELETE LIST':
                  AtKey atKey = AtKey()..key = AppConstants.deviceListKey;
                  HrO2DataService().delete(atKey);
                  break;
                case 'RECEIVERS':
                  Navigator.of(context).pushNamed(ReceiversScreen.id);
                  break;
                case 'CLOSE':
                  exit(0);
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                height: 20,
                value: 'NEW DEVICE',
                child: Text(
                  'NEW DEVICE',
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
                value: 'RECEIVERS',
                child: Text(
                  'SEE RECEIVERS',
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
          builder: (context) => FutureBuilder<List<HrO2Device>>(
              future: _hrO2DataService.getDeviceList(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<HrO2Device>> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  List<HrO2Device>? hrO2Devices = snapshot.data;
                  children = <Widget>[
                    const Text(
                      "The following devices have been created.",
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
                        itemCount: hrO2Devices!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final device = hrO2Devices[index];
                          return Dismissible(
                            key: Key(device.deviceUuid),
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
                                    content:
                                        Text('Delete ${device.deviceAtsign} ?'),
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
                                hrO2Devices.remove(device);
                                _hrO2DataService.putDeviceList(hrO2Devices);
                              });
                            },
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.blue, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              title: Text(hrO2Devices[index].deviceAtsign),
                              subtitle: Text(
                                  "identifier ${hrO2Devices[index].deviceUuid}"),
                            ),
                          );
                        }),
                  ];
                } else if (snapshot.hasError) {
                  children = <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                          '${snapshot.error}, please click the + button below to add a device.'),
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
          var newDevice = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewHrO2Device()),
          );
          if (newDevice == null) {
          } else {
            setState(() {
              // devices.add(newDevice);
              // saveDevices(devices);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
