import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_supervision/data/repositories/device_repository.dart';
import 'device_state.dart';

class DeviceCubit extends Cubit<DeviceState> {
  final DeviceRepository _deviceRepository;

  DeviceCubit(this._deviceRepository) : super(DeviceInitial());

  Future<void> fetchDevices() async {
    emit(DeviceLoading());
    try {
      final devices = await _deviceRepository.getUserDevices();
      emit(DeviceLoaded(devices));
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      emit(DeviceError(errorMessage));
    }
  }

  Future<void> addDevice(String name, String type, String osVersion) async {
    // نحتفظ بالحالة القديمة لمنع اختفاء الأجهزة أثناء التحميل
    final currentState = state;
    try {
      await _deviceRepository.addDevice({
        'name': name,
        'device_type': type,
        'os_version': osVersion,
        'battery_level': 100, // بيانات افتراضية مؤقتة
        'storage_space': '64GB',
      });
      // بعد الإضافة، نجلب الأجهزة من جديد لتحديث القائمة
      await fetchDevices();
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      emit(DeviceError(errorMessage));

      // إذا كان لدينا بيانات قديمة، نرجعها حتى لا تصبح الشاشة فارغة
      if (currentState is DeviceLoaded) {
        emit(DeviceLoaded(currentState.devices));
      }
    }
  }
}