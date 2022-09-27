import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:iot_receiver/forms/device_form.dart';
import 'package:iot_receiver/models/hro2_device.dart';
import 'package:iot_receiver/screens/devices_screen.dart';
import 'package:iot_receiver/services/hro2_data_service.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class NewHrO2Device extends StatefulWidget {
  const NewHrO2Device({Key? key}) : super(key: key);
  static const String id = '/new_device';

  @override
  State<NewHrO2Device> createState() => _NewHrO2DeviceState();
}

class _NewHrO2DeviceState extends State<NewHrO2Device> {
  final _formKey = GlobalKey<FormBuilderState>();
  final HrO2DataService _hrO2DataService = HrO2DataService();

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    int _gridRows = 1;
    if (_width > _height) {
      _gridRows = 2;
    } else {
      _gridRows = 1;
    }

    return Scaffold(
        appBar: NewGradientAppBar(
          title: const AutoSizeText(
            'New Device',
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
          decoration: backgroundGradient(_gridRows),
          child: SingleChildScrollView(
            child: FormBuilder(
                key: _formKey,
                child: Column(children: [
                  deviceAtsignForm(context, ''),
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
                      DeviceSubmitForm(formKey: _formKey),
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
                              String deviceAtsign = _formKey
                                  .currentState!.fields['@device']!.value;
                              var newDevice = HrO2Device(
                                deviceAtsign: deviceAtsign,
                                deviceUuid: UniqueKey().toString(),
                              );
                              await _hrO2DataService.addDeviceToList(newDevice);
                              Navigator.of(context).pushNamed(DevicesScreen.id);
                            } else {
                              Navigator.pop(context, null);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 20)
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: _width,
                        height: _height,
                      )
                    ],
                  )
                ])),
          ),
        ));
  }
}

BoxDecoration backgroundGradient(int _gridRows) {
  return BoxDecoration(
    color: Colors.white70,
    gradient: _gridRows > 1
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
