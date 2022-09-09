import 'package:flutter/material.dart';

import '../data/profile_data.dart';

class ContactsModel extends ChangeNotifier {
  late ProfileData _profileData;

  ProfileData get profileData => _profileData;

  set profileData(ProfileData profileData) {
    _profileData = profileData;
    notifyListeners();
  }
}
