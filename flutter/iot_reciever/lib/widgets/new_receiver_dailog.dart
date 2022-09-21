import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:iot_reciever/forms/receiver_form.dart';
import 'package:iot_reciever/models/hro2_receiver.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class NewHrO2Receiver extends StatefulWidget {
  const NewHrO2Receiver({Key? key}) : super(key: key);
  static const String id = '/newradio';

  @override
  _NewHrO2Receiver createState() => _NewHrO2Receiver();
}

class _NewHrO2Receiver extends State<NewHrO2Receiver> {
  final _formKey = GlobalKey<FormBuilderState>();

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
            'Devices',
            minFontSize: 5,
            maxFontSize: 50,
          ),
          gradient:
              const LinearGradient(colors: [Color.fromARGB(255, 173, 83, 78), Color.fromARGB(255, 108, 169, 197)]),
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
                  sendToShortnameForm(context, ''),
                  deviceAtsignForm(context, ''),
                  sendToAtsignForm(context, ''),
                  sendHRForm(context, ''),
                  sendO2Form(context, ''),
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
                      ReceiverSubmitForm(formKey: _formKey),
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
                          onPressed: () {
                            _formKey.currentState!.save();
                            if (_formKey.currentState!.validate()) {
                              String deviceAtsign = _formKey.currentState!.fields['@device']!.value;
                              String sendToAtsign = _formKey.currentState!.fields['@receiver']!.value;
                              String sendToShortname = _formKey.currentState!.fields['ShortName']!.value;
                              print(sendToShortname);
                              var sendHr = _formKey.currentState!.fields['sendHR']!.value;
                              var sendO2 = _formKey.currentState!.fields['sendO2']!.value;

                              var newReceiver = HrO2Receiver(
                                  sendToShortname: sendToAtsign,
                                  deviceAtsign: deviceAtsign,
                                  sendToAtsign: sendToAtsign,
                                  receiverUuid: UniqueKey().toString(),
                                  sendHR: sendHr,
                                  sendO2: sendO2);
                              
                              Navigator.pop(context, newReceiver);
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
            colors: [Color.fromARGB(255, 240, 181, 178), Color.fromARGB(255, 171, 200, 224)],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromARGB(255, 240, 181, 178), Color.fromARGB(255, 171, 200, 224)],
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
