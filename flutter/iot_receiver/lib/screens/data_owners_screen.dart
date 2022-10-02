import 'package:at_utils/at_logger.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:iot_receiver/models/hro2_data_owner.dart';
import 'package:iot_receiver/services/hro2_data_service.dart';
import 'package:iot_receiver/widgets/hro2_drawer_widget.dart';
import 'package:iot_receiver/widgets/new_data_owner_dialog.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

final AtSignLogger _logger = AtSignLogger('DataOwnersScreen');

class DataOwnersScreen extends StatefulWidget {
  const DataOwnersScreen({Key? key}) : super(key: key);
  static const String id = '/data_owners_screen';
  @override
  State<DataOwnersScreen> createState() => _DataOwnersScreenState();
}

class _DataOwnersScreenState extends State<DataOwnersScreen> {
  final Hro2DataService _hrO2DataService = Hro2DataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        title: const AutoSizeText(
          'Data Owners',
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
          builder: (context) => FutureBuilder<List<HrO2DataOwner>>(
              future: _hrO2DataService.getDataOwners(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<HrO2DataOwner>> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  List<HrO2DataOwner>? hrO2DataOwnerList = snapshot.data;
                  children = <Widget>[
                    const Text(
                      "The following dataOwners have been created.",
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
                        itemCount: hrO2DataOwnerList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final HrO2DataOwner dataOwner =
                              hrO2DataOwnerList[index];
                          const align = Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Icon(Icons.delete),
                              ));
                          return Dismissible(
                            key: Key(dataOwner.dataOwnerAtsign),
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
                                        'Delete ${dataOwner.dataOwnerAtsign} ?'),
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
                              hrO2DataOwnerList.remove(dataOwner);
                              await _hrO2DataService.putDataOwner(dataOwner);
                              setState(() {});
                            },
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.blue, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              title: Text(
                                  "${hrO2DataOwnerList[index].dataOwnerAtsign}[${hrO2DataOwnerList[index].hrO2Device.deviceAtsign}]"),
                              subtitle: Text(
                                  "${hrO2DataOwnerList[index].hrO2Device.deviceAtsign} ${hrO2DataOwnerList[index].hrO2Device.sensorName.isNotEmpty ? hrO2DataOwnerList[index].hrO2Device.sensorName : ""}"),
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
                          '${snapshot.error}, please click the + button below to add a dataOwner.'),
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
          var newDataOwner = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewHrO2DataOwner()),
          );
          if (newDataOwner == null) {
          } else {
            setState(() {
              // dataOwners.add(newDataOwner);
              // saveDataOwners(dataOwners);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
