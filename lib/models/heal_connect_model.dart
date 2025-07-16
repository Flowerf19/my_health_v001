class HealConnectData {
  final String userId;
  final String deviceId;
  final String deviceName;
  final bool isConnected;
  final String lastSync;
  final Map<String, dynamic> healthData;

  HealConnectData({
    required this.userId,
    required this.deviceId,
    required this.deviceName,
    required this.isConnected,
    required this.lastSync,
    required this.healthData,
  });

  factory HealConnectData.fromJson(Map<String, dynamic> json) {
    return HealConnectData(
      userId: json['userId'] as String,
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      isConnected: json['isConnected'] as bool,
      lastSync: json['lastSync'] as String,
      healthData: json['healthData'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'isConnected': isConnected,
      'lastSync': lastSync,
      'healthData': healthData,
    };
  }

  HealConnectData copyWith({
    String? userId,
    String? deviceId,
    String? deviceName,
    bool? isConnected,
    String? lastSync,
    Map<String, dynamic>? healthData,
  }) {
    return HealConnectData(
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      isConnected: isConnected ?? this.isConnected,
      lastSync: lastSync ?? this.lastSync,
      healthData: healthData ?? this.healthData,
    );
  }
}
