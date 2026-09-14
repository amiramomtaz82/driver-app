
import 'package:driver_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../config/secure_storage/secure_storage.dart';
import 'device_id.dart';



@LazySingleton(as:DeviceIdService)

class DeviceIdServiceImp extends DeviceIdService{
  final SecureStorage _secureStorage;

  DeviceIdServiceImp(this._secureStorage);

  static final String _deviceIdKey = LocaleKeys.device_id.tr();

  @override
  Future<void> saveDeviceId(String deviceId) {
    return _secureStorage.write(
      key: _deviceIdKey,
      value: deviceId,
    );
  }

  @override
  Future<String> getDeviceId() async {
    final deviceId = await _secureStorage.read(
      key:LocaleKeys.device_id.tr(),
    );

    if (deviceId != null && deviceId.isNotEmpty) {
      return deviceId;
    }

    final newDeviceId = const Uuid().v4();

    await _secureStorage.write(
      key:LocaleKeys.device_id.tr(),
      value: newDeviceId,
    );

    return newDeviceId;
  }

}