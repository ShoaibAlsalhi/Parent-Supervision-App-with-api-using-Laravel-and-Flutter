import 'package:parent_supervision/data/datasources/auth_remote_data_source.dart';
import 'package:parent_supervision/core/utils/secure_storage_helper.dart';
import 'package:parent_supervision/data/models/user_model.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageHelper _secureStorageHelper;

  AuthRepository(this._remoteDataSource, this._secureStorageHelper);

  Future<UserModel> login(String email, String password, String deviceName) async {
    final data = await _remoteDataSource.login(email, password, deviceName);

    final user = UserModel.fromJson(data['user']);
    final token = data['token'] as String;

    // حفظ التوكن بأمان
    await _secureStorageHelper.saveToken(token);

    return user;
  }
}