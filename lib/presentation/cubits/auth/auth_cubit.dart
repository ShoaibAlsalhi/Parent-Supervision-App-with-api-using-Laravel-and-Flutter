import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_supervision/data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> login(String email, String password, String deviceName) async {
    emit(AuthLoading()); // إخبار الواجهة بعرض دائرة التحميل
    try {
      final user = await _authRepository.login(email, password, deviceName);
      emit(AuthSuccess(user)); // إخبار الواجهة بالنجاح وتمرير بيانات المستخدم
    } catch (e) {
      // إزالة كلمة Exception: من الرسالة إن وجدت
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      emit(AuthError(errorMessage)); // إخبار الواجهة بوجود خطأ
    }
  }
}