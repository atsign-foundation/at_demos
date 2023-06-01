import 'package:at_dude/commands/contact_details_command.dart';
import 'package:at_dude/models/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AtsignAvatar extends StatefulWidget {
  const AtsignAvatar({Key? key}) : super(key: key);

  @override
  State<AtsignAvatar> createState() => _AtsignAvatarState();
}

class _AtsignAvatarState extends State<AtsignAvatar> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ContactDetailsCommand().run();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: context.watch<ContactsModel>().profileData.profileImage == null
            ? const Icon(
                Icons.person_outline,
                color: Colors.black,
              )
            : ClipOval(
                child: Image.memory(
                    context.watch<ContactsModel>().profileData.profileImage!)),
      ),
      onTap: () {},
    );
  }
}
