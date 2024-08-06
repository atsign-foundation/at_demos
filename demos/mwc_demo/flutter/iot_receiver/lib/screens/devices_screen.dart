import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:iot_receiver/models/hro2_device.dart';
import 'package:iot_receiver/services/hro2_data_service.dart';
import 'package:iot_receiver/widgets/new_device_dialog.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import '../widgets/hro2_drawer_widget.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({Key? key}) : super(key: key);
  static const String id = '/devices_screen';
  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  final Hro2DataService _hrO2DataService = Hro2DataService();

  @override
  Widget build(BuildContext context) {
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
      ),
      drawer: const HRo2DrawerWidget(),
      body: Builder(
          builder: (context) => FutureBuilder<List<HrO2Device>>(
              future: _hrO2DataService.getDevices(),
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
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 16),
                                    child: Icon(Icons.delete),
                                  )),
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
                            onDismissed: (_) async {
                              hrO2Devices.remove(device);
                              await _hrO2DataService.deleteDevice(device);
                              setState(() {});
                            },
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.blue, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              title: Text(hrO2Devices[index].deviceAtsign +
                                  (hrO2Devices[index].sensorName.isNotEmpty
                                      ? " with [${hrO2Devices[index].sensorName} sensor]"
                                      : "")),
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
