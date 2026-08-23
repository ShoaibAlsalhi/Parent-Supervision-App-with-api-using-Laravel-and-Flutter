import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_supervision/presentation/cubits/device/device_cubit.dart';

import 'custom_text_field.dart';

class AddDeviceSheet extends StatefulWidget {
  const AddDeviceSheet({super.key});

  @override
  State<AddDeviceSheet> createState() => _AddDeviceSheetState();
}

class _AddDeviceSheetState extends State<AddDeviceSheet> {
  final _nameController = TextEditingController();
  final _osController = TextEditingController();
  String _selectedType = 'android'; // الافتراضي

  void _submit() {
    if (_nameController.text.isNotEmpty && _osController.text.isNotEmpty) {
      context.read<DeviceCubit>().addDevice(
        _nameController.text.trim(),
        _selectedType,
        _osController.text.trim(),
      );
      Navigator.pop(context); // إغلاق النافذة بعد الإرسال
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'ربط جهاز جديد',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'اسم الجهاز (مثال: هاتف سارة)',
              prefixIcon: Icons.smartphone,
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'إصدار النظام (مثال: Android 13)',
              prefixIcon: Icons.info_outline,
              controller: _osController,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: 'نوع الجهاز'),
              items: const [
                DropdownMenuItem(value: 'android', child: Text('Android')),
                DropdownMenuItem(value: 'ios', child: Text('iOS')),
              ],
              onChanged: (val) => setState(() => _selectedType = val!),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('إضافة الجهاز'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}