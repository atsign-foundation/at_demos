import 'dart:typed_data' show Uint8List;

class ProfileData {
  ProfileData({required this.name, required this.profileImage});

  final String? name;
  final Uint8List? profileImage;
}
