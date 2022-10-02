import 'package:at_utils/at_logger.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:iot_receiver/models/hro2_device_owner.dart';
import 'package:iot_receiver/services/hro2_data_service.dart';
import 'package:iot_receiver/widgets/hro2_drawer_widget.dart';
import 'package:iot_receiver/widgets/new_device_owner_dialog.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

final AtSignLogger _logger = AtSignLogger('DeviceOwnersScreen');

class DeviceOwnersScreen extends StatefulWidget {
  const DeviceOwnersScreen({Key? key}) : super(key: key);
  static const String id = '/device_owners_screen';
  @override
  State<DeviceOwnersScreen> createState() => _DeviceOwnersScreenState();
}

class _DeviceOwnersScreenState extends State<DeviceOwnersScreen> {
  final Hro2DataService _hrO2DataService = Hro2DataService();

  @override
  Widget build(BuildContext context) {
    _hrO2DataService.getDeviceOwners();
    return Scaffold(
      appBar: NewGradientAppBar(
        title: const AutoSizeText(
          'Device Owners',
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
          builder: (context) => FutureBuilder<List<HrO2DeviceOwner>>(
              future: _hrO2DataService.getDeviceOwners(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<HrO2DeviceOwner>> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  List<HrO2DeviceOwner>? hrO2DeviceOwnerList = snapshot.data;
                  children = <Widget>[
                    const Text(
                      "The following deviceOwners have been created.",
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
                        itemCount: hrO2DeviceOwnerList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final HrO2DeviceOwner deviceOwner =
                              hrO2DeviceOwnerList[index];
                          const align = Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Icon(Icons.delete),
                              ));
                          return Dismissible(
                            key: Key(deviceOwner.deviceOwnerAtsign),
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
                                        'Delete ${deviceOwner.deviceOwnerAtsign} ?'),
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
                              hrO2DeviceOwnerList.remove(deviceOwner);
                              await _hrO2DataService
                                  .putDeviceOwner(deviceOwner);
                              setState(() {});
                            },
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.blue, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              title: Text(
                                  hrO2DeviceOwnerList[index].deviceOwnerAtsign),
                              subtitle: Text(
                                  "${hrO2DeviceOwnerList[index].hrO2Device.deviceAtsign} ${hrO2DeviceOwnerList[index].hrO2Device.sensorName.isNotEmpty ? hrO2DeviceOwnerList[index].hrO2Device.sensorName : ""}"),
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
                          '${snapshot.error}, please click the + button below to add a deviceOwner.'),
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
          var newDeviceOwner = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewHrO2DeviceOwner()),
          );
          if (newDeviceOwner == null) {
          } else {
            setState(() {
              // deviceOwners.add(newDeviceOwner);
              // saveDeviceOwners(deviceOwners);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
