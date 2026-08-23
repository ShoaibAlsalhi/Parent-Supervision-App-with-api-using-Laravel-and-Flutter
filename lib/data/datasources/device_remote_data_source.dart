import 'package:dio/dio.dart';
import 'package:parent_supervision/core/network/dio_client.dart';
import 'package:parent_supervision/core/network/api_constants.dart';

class DeviceRemoteDataSource {
  final DioClient _dioClient;

  DeviceRemoteDataSource(this._dioClient);

  Future<List<dynamic>> getDevices() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.devices);
      return response.data['data'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'فشل الاتصال بالخادم');
    }
  }

  // الدالة الجديدة لإضافة جهاز
  Future<Map<String, dynamic>> addDevice(Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.dio.post(ApiConstants.devices, data: data);
      return response.data['data'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'فشل إضافة الجهاز');
    }
  }
}