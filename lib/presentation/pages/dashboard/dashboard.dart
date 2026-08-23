import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_supervision/presentation/cubits/device/device_cubit.dart';
import 'package:parent_supervision/presentation/cubits/device/device_state.dart';
import 'package:parent_supervision/core/theme/app_colors.dart';

import '../../../core/widgets/add_device_sheet.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // جلب الأجهزة فور فتح الشاشة
    context.read<DeviceCubit>().fetchDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => context.read<DeviceCubit>().fetchDevices(),
        child: BlocBuilder<DeviceCubit, DeviceState>(
          builder: (context, state) {
            if (state is DeviceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DeviceError) {
              return Center(child: Text(state.message, style: const TextStyle(color: AppColors.error)));
            } else if (state is DeviceLoaded) {
              final devices = state.devices;
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildSummaryCard(devices.length),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('الأجهزة المرتبطة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton.icon(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => BlocProvider.value(
                              value: context.read<DeviceCubit>(), // تمرير الـ Cubit للنافذة المنبثقة
                              child: const AddDeviceSheet(),
                            ),
                          );
                        },                        icon: const Icon(Icons.add),
                        label: const Text('إضافة'),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (devices.isEmpty)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('لا توجد أجهزة مرتبطة حالياً', style: TextStyle(color: Colors.grey)),
                    ))
                  else
                    ...devices.map((device) => _buildDeviceCard(device)),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCard(int deviceCount) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white24,
            child: Icon(Icons.family_restroom, size: 30, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('حالة العائلة', style: TextStyle(color: Colors.white70, fontSize: 14)),
              Text('$deviceCount أجهزة محمية', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(device) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: device.isOnline ? AppColors.success.withOpacity(0.1) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            device.deviceType == 'ios' ? Icons.apple : Icons.android,
            color: device.isOnline ? AppColors.success : Colors.grey,
          ),
        ),
        title: Text(device.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(device.isOnline ? 'متصل الآن' : 'غير متصل',
                style: TextStyle(color: device.isOnline ? AppColors.success : Colors.grey, fontSize: 12)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.battery_charging_full, color: device.batteryLevel > 20 ? AppColors.success : AppColors.error, size: 20),
            Text('${device.batteryLevel}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}