import 'package:flutter/material.dart';
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:verbs_testing/services/server_demo_service.dart';

class NotifyScreen extends StatefulWidget {
  const NotifyScreen({Key? key}) : super(key: key);

  @override
  _NotifyScreenState createState() => _NotifyScreenState();
}

enum ButtonType { myList, sentList }

class _NotifyScreenState extends State<NotifyScreen> {
  final TextEditingController _messageController = TextEditingController();
  // TextEditingController _keyController = TextEditingController();

  String? receiverAtsign;
  final ServerDemoService _serverDemoService = ServerDemoService.getInstance();
  bool isNotifying = false;
  bool isLoading = false;
  bool atSignSelected = false;
  String? result;
  ButtonType activeButton = ButtonType.sentList;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(' Notify Testing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              children: [
                Text('Hi, ${_serverDemoService.atSign}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('Receiver:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        )),
                    DropdownButton<String>(
                      hint: const Text('\tPick an @sign'),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.black87,
                      ),
                      underline: Container(
                        height: 2,
                        color: Colors.blueAccent,
                      ),
                      onChanged: (String? newValue) async {
                        setState(() {
                          atSignSelected = true;
                          receiverAtsign = newValue;
                        });
                      },
                      value: receiverAtsign,
                      //!= null ? atSign : null,
                      items: atSignsList(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  enabled: atSignSelected,
                  controller: _messageController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      hintText: 'Eg: Hello!',
                      labelText: 'Enter any text to notify'),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width * 0.75, 40)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(isNotifying ? Colors.transparent : Colors.blue),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  onPressed: isNotifying ? null : _notify,
                  child: isNotifying
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          'Notify',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0.0),
                          minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width * 0.45, 40)),
                          foregroundColor:
                              MaterialStateProperty.all(activeButton == ButtonType.myList ? Colors.blue : Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all(activeButton == ButtonType.myList ? Colors.white : Colors.blue),
                          shape: MaterialStateProperty.all(
                            activeButton == ButtonType.myList
                                ? const RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  )
                                : const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                            activeButton = ButtonType.myList;
                          });
                          await _serverDemoService.myNotifications().then((value) {
                            setState(() {
                              isLoading = false;
                            });
                          });
                          setState(() {});
                        },
                        child: Text(
                          'Received',
                          style: TextStyle(
                              fontSize: 14, color: activeButton == ButtonType.myList ? Colors.blue : Colors.white),
                        )),
                    ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0.0),
                        minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width * 0.45, 40)),
                        foregroundColor:
                            MaterialStateProperty.all(activeButton == ButtonType.sentList ? Colors.blue : Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all(activeButton == ButtonType.sentList ? Colors.white : Colors.blue),
                        shape: MaterialStateProperty.all(
                          activeButton == ButtonType.sentList
                              ? const RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                )
                              : const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          activeButton = ButtonType.sentList;
                        });
                      },
                      child: Text(
                        'Sent',
                        style: TextStyle(
                          fontSize: 14,
                          color: activeButton == ButtonType.sentList ? Colors.blue : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                ..._getList()
              ],
            ))
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> atSignsList() {
    var atSignsList = at_demo_data.allAtsigns.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();
    atSignsList.removeWhere((element) => _serverDemoService.atSign == element.value);
    return atSignsList;
  }

  _getList() {
    List<AtNotification> listData = [];
    listData = activeButton == ButtonType.myList
        ? _serverDemoService.myNotificationsList
        : _serverDemoService.sentNotificationsList;

    return isLoading
        ? <Widget>[
            const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            ),
          ]
        : <Widget>[
            const SizedBox(height: 10),
            if (listData.isNotEmpty)
              for (var data in listData)
                if (_serverDemoService.atSign != data.fromAtSign && data.key != 'shared_key')
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), side: const BorderSide(color: Colors.blueGrey)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (activeButton == ButtonType.myList) ...[
                              CustomText(keyTitle: 'From', value: data.fromAtSign),
                              CustomText(keyTitle: 'Title', value: data.key),
                              CustomText(keyTitle: 'operation', value: data.operation),
                            ],
                            if (activeButton == ButtonType.sentList) ...[
                              CustomText(keyTitle: 'To', value: data.toAtSign),
                              CustomText(keyTitle: 'Message', value: data.value),
                              CustomText(keyTitle: 'Status', value: data.status ?? 'Unknown')
                            ],
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  await _showNotificationDetails(data);
                                },
                                icon: const Icon(Icons.info_outline)),
                            if (activeButton == ButtonType.sentList)
                              IconButton(
                                  onPressed: () async {
                                    await _serverDemoService.notifyStatus(data.id!,
                                        doneCallBack: (value) {
                                          setState(() {
                                            data.status = value;
                                          });
                                        },
                                        errorCallBack: (err) => print('$err'));
                                  },
                                  icon: const Icon(Icons.refresh)),
                          ],
                        ),
                      ),
                    ),
                  ),
            if (listData.isEmpty) const Center(child: Text('No Data Found!!'))
          ];
  }

  _showNotificationDetails(AtNotification data) async {
    if (data.value != null && activeButton == ButtonType.myList) {
      data.value = await _serverDemoService.getFromNotification(data, isCached: false);
    }
    showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (_, stateSet) {
            return AlertDialog(
              content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (data.id != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                      ),
                      child: CustomText(keyTitle: 'Id', value: data.id),
                    ),
                  if (data.key != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CustomText(keyTitle: 'Key', value: data.key),
                    ),
                  if (data.value != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CustomText(keyTitle: 'Value', value: data.value),
                    ),
                  if (data.status != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CustomText(keyTitle: 'status', value: data.status),
                    ),
                  if (data.fromAtSign != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CustomText(keyTitle: 'FromAtSign', value: data.fromAtSign),
                    ),
                  if (data.dateTime != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CustomText(
                        keyTitle: 'DateTime',
                        value: DateFormat.yMEd().add_jms().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                int.parse(data.dateTime.toString()),
                              ),
                            ),
                      ),
                    ),
                  if (data.operation != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CustomText(keyTitle: 'Operation', value: data.operation),
                    ),
                ],
              ),
              actions: [TextButton(onPressed: () => Navigator.pop(_), child: const Text('Close'))],
            );
          });
        });
  }

  Future<void> _notify() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isNotifying = true;
    });
    if (_messageController.text.isEmpty) {
      setState(() {
        isNotifying = false;
      });
      await Fluttertoast.showToast(
          msg: 'Message is empty!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    try {
      await _serverDemoService.notify(_messageController.text, receiverAtsign, doneCallBack: (value) {
        print('value is $value');
        Fluttertoast.showToast(
            msg: 'Notified Succesfully!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.black,
            fontSize: 16.0);
        setState(() {
          isNotifying = false;
        });
      }, errorCallBack: (error) {
        result = 'error is:\n$error';

        Fluttertoast.showToast(
            msg: 'Failed to notify!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.black,
            fontSize: 16.0);

        print('error is $error');
        setState(() {
          isNotifying = false;
        });
      });
    } on Exception catch (err, stackTrace) {
      print('$stackTrace');
      setState(() {
        isNotifying = false;
      });
    }
  }
}

class CustomText extends StatelessWidget {
  final String keyTitle;
  final String? value;
  final Color color;
  const CustomText({Key? key, required this.keyTitle, required this.value, this.color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(style: TextStyle(color: color, fontSize: 16), children: [
      TextSpan(text: keyTitle + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: value)
    ]));
  }
}
