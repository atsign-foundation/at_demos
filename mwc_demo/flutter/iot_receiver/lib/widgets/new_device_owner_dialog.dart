import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:iot_receiver/forms/device_owner_form.dart';
import 'package:iot_receiver/models/hro2_device.dart';
import 'package:iot_receiver/models/hro2_device_owner.dart';
import 'package:iot_receiver/screens/device_owners_screen.dart';
import 'package:iot_receiver/services/hro2_data_service.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class NewHrO2DeviceOwner extends StatefulWidget {
  const NewHrO2DeviceOwner({Key? key}) : super(key: key);
  static const String id = '/new_deviceOwner';

  @override
  State<NewHrO2DeviceOwner> createState() => _NewHrO2DeviceOwnerState();
}

class _NewHrO2DeviceOwnerState extends State<NewHrO2DeviceOwner> {
  final _formKey = GlobalKey<FormBuilderState>();
  final Hro2DataService _hrO2DataService = Hro2DataService();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int gridRows = 1;
    if (width > height) {
      gridRows = 2;
    } else {
      gridRows = 1;
    }

    return Scaffold(
        appBar: NewGradientAppBar(
          title: const AutoSizeText(
            'New DeviceOwner',
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
                  case 'CLOSE':
                    exit(0);
                  default:
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
        body: Container(
          decoration: backgroundGradient(gridRows),
          child: SingleChildScrollView(
            child: FormBuilder(
                key: _formKey,
                child: Column(children: [
                  Builder(
                      builder: (context) => FutureBuilder<List<HrO2Device>>(
                          future: _hrO2DataService.getDevices(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<HrO2Device>> snapshot) {
                            if (snapshot.hasData) {
                              return deviceOwnerDeviceSelector(
                                  context,
                                  snapshot.data
                                      ?.map((item) =>
                                          DropdownMenuItem<HrO2Device>(
                                            value: item,
                                            child: Text(item.deviceAtsign),
                                          ))
                                      .toList());
                            } else {
                              return const Text("loading");
                            }
                          })),
                  deviceOwnerAtsignForm(context, ''),
                  Row(
                    children: <Widget>[
                      const SizedBox(width: 20),
                      Expanded(
                        child: BackButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const Spacer(),
                      DeviceOwnerSubmitForm(formKey: _formKey),
                      const Spacer(),
                      Expanded(
                        child: MaterialButton(
                          child: const AutoSizeText(
                            "Submit",
                            style: TextStyle(color: Colors.black),
                            maxLines: 1,
                            maxFontSize: 30,
                            minFontSize: 10,
                          ),
                          onPressed: () async {
                            _formKey.currentState!.save();
                            if (_formKey.currentState!.validate()) {
                              HrO2Device device = _formKey.currentState!
                                  .fields['device_selector']!.value;
                              String deviceOwnerAtsign = _formKey
                                  .currentState!.fields['@deviceOwner']!.value;
                              var newDeviceOwner = HrO2DeviceOwner(
                                deviceOwnerAtsign: deviceOwnerAtsign,
                                hrO2Device: device,
                              );
                              await _hrO2DataService
                                  .putDeviceOwner(newDeviceOwner);
                              if (mounted) {
                                Navigator.of(context)
                                    .pushNamed(DeviceOwnersScreen.id);
                              }
                            } else {
                              Navigator.pop(context, null);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 20)
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     SizedBox(
                  //       width: _width,
                  //       height: _height,
                  //     )
                  //   ],
                  // )
                ])),
          ),
        ));
  }
}

BoxDecoration backgroundGradient(int gridRows) {
  return BoxDecoration(
    color: Colors.white70,
    gradient: gridRows > 1
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 240, 181, 178),
              Color.fromARGB(255, 171, 200, 224)
            ],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 240, 181, 178),
              Color.fromARGB(255, 171, 200, 224)
            ],
          ),
    image: const DecorationImage(
      opacity: .15,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      image: AssetImage(
        'assets/images/blood-pressure.png',
      ),
    ),
  );
}
