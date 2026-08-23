import 'package:parent_supervision/data/datasources/device_remote_data_source.dart';
import 'package:parent_supervision/data/models/device_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DeviceRepository {
  final DeviceRemoteDataSource _remoteDataSource;
  final Box _offlineBox;

  DeviceRepository(this._remoteDataSource, this._offlineBox);

  Future<List<DeviceModel>> getUserDevices() async {
    try {
      final data = await _remoteDataSource.getDevices();

      // حفظ نسخة محلياً (Offline Cache)
      await _offlineBox.put('cached_devices', data);

      return data.map((json) => DeviceModel.fromJson(json)).toList();
    } catch (e) {
      // إذا انقطع الإنترنت، جلب البيانات من Hive
      final cachedData = _offlineBox.get('cached_devices');
      if (cachedData != null) {
        final List<dynamic> jsonList = List<dynamic>.from(cachedData);
        return jsonList.map((json) => DeviceModel.fromJson(json)).toList();
      }
      rethrow; // إذا لم يكن هناك إنترنت ولا بيانات سابقة، ارمِ الخطأ
    }
  }

  Future<DeviceModel> addDevice(Map<String, dynamic> deviceData) async {
    final data = await _remoteDataSource.addDevice(deviceData);
    return DeviceModel.fromJson(data);
  }
}