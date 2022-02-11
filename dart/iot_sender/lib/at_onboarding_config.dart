import 'config_utils/config_util.dart';
import 'package:yaml/yaml.dart';
import 'package:zxing2/qrcode.dart';
import 'package:image/image.dart';
import 'dart:io';

class AtOnboardingConfig {
  dynamic getConfigValueFromYaml(List<String> args) {
    YamlMap? yamlMap = ConfigUtil.getConfigYaml();
    var value;
    if (yamlMap != null) {
      for (int i = 0; i < args.length; i++) {
        if (i == 0) {
          value = yamlMap[args[0]];
        } else {
          value = value[args[i]];
        }
      }
    }
    if (value == null) {
      throw Exception('Specified config not found');
    }
    return value;
  }

  String? getStringValueFromYaml(List<String> keyParts) {
    var yamlMap = ConfigUtil.getConfigYaml();
    var value;
    if (yamlMap != null) {
      for (int i = 0; i < keyParts.length; i++) {
        if (i == 0) {
          value = yamlMap[keyParts[i]];
        } else {
          if (value != null) {
            value = value[keyParts[i]];
          }
        }
      }
    }

    if (value == Null || value == null) {
      return null;
    } else {
      return value.toString();
    }
  }

  String getRootServerDomain() {
    return getConfigValueFromYaml(['root_server', 'url']);
  }

  int getRootServerPort() {
    return getConfigValueFromYaml(['root_server', 'port']);
  }

  String? getAtKeysFilePath() {
    return getStringValueFromYaml(['auth', 'atKeysPath']);
  }

  String? getQrCodePath() {
    return getStringValueFromYaml(['auth', 'qrPath']);
  }

  dynamic getQrData(String path) {
    var image = decodePng(File(path).readAsBytesSync());

    LuminanceSource source = RGBLuminanceSource(image!.width, image.height,
        image.getBytes(format: Format.abgr).buffer.asInt32List());

    var bitmap = BinaryBitmap(HybridBinarizer(source));
    var result = QRCodeReader().decode(bitmap);

    return result;
  }
}
