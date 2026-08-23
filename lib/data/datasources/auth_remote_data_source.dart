import 'package:dio/dio.dart';
import 'package:parent_supervision/core/network/dio_client.dart';
import 'package:parent_supervision/core/network/api_constants.dart';

class AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSource(this._dioClient);

  Future<Map<String, dynamic>> login(String email, String password, String deviceName) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
          'device_name': deviceName,
        },
      );
      return response.data['data']; // يحتوي على الـ user والـ token
    } on DioException catch (e) {
      // جلب رسالة الخطأ من الـ API إن وجدت
      final errorMessage = e.response?.data['message'] ?? 'حدث خطأ أثناء الاتصال بالخادم';
      throw Exception(errorMessage);
    }
  }
}