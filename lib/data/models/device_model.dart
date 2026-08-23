class DeviceModel {
  final int id;
  final String name;
  final String deviceType;
  final String? osVersion;
  final bool isOnline;
  final int batteryLevel;
  final String? storageSpace;
  final DateTime? lastSeenAt;

  DeviceModel({
    required this.id,
    required this.name,
    required this.deviceType,
    this.osVersion,
    required this.isOnline,
    required this.batteryLevel,
    this.storageSpace,
    this.lastSeenAt,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      name: json['name'],
      deviceType: json['device_type'] ?? 'android',
      osVersion: json['os_version'],
      isOnline: json['is_online'] ?? false,
      batteryLevel: json['battery_level'] ?? 0,
      storageSpace: json['storage_space'],
      lastSeenAt: json['last_seen_at'] != null
          ? DateTime.parse(json['last_seen_at'])
          : null,
    );
  }
}