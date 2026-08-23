import 'package:dio/dio.dart';
import 'package:parent_supervision/core/network/api_constants.dart';
import 'package:parent_supervision/core/utils/secure_storage_helper.dart';

class DioClient {
  final Dio _dio;
  final SecureStorageHelper _secureStorageHelper;

  DioClient(this._dio, this._secureStorageHelper) {
    _dio
      ..options.baseUrl = ApiConstants.baseUrl
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

    // Interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // جلب التوكن وإضافته تلقائياً لكل طلب
          final token = await _secureStorageHelper.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // هنا يمكننا مستقبلاً تتبع أخطاء الـ 401 (انتهاء صلاحية التوكن)
          // وتوجيه المستخدم لشاشة تسجيل الدخول
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}