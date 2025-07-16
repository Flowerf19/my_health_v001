import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health/health.dart';
import 'package:flutter/services.dart';
import '../../../models/heal_connect_model.dart';
import '../models/biometric_model.dart';

class HealthConnectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final Health health;
  static const platform = MethodChannel('health_connect');

  HealthConnectService() {
    health = Health();
  }

  Future<bool> isHealthConnectAvailable() async {
    try {
      // Sử dụng method checkPermissions mới để kiểm tra cài đặt và quyền
      final result = await platform.invokeMethod('checkPermissions');
      print('Health Connect availability check: $result');

      if (result['installed'] != true) {
        throw PlatformException(
          code: 'HEALTH_CONNECT_NOT_INSTALLED',
          message:
              'Health Connect chưa được cài đặt. Vui lòng cài đặt ứng dụng Health Connect.',
        );
      }

      if (result['compatible'] != true) {
        throw PlatformException(
          code: 'DEVICE_NOT_COMPATIBLE',
          message:
              'Thiết bị không tương thích với Health Connect. Yêu cầu Android 11 trở lên.',
        );
      }

      // Kiểm tra nếu quyền đã được cấp
      if (result['permissionsGranted'] == true) {
        return true;
      } else {
        print('Permissions not granted. Need to request permissions.');
        return false;
      }
    } on PlatformException catch (e) {
      print('Platform error checking Health Connect availability: $e');
      rethrow;
    } catch (e) {
      print('Error checking Health Connect availability: $e');
      return false;
    }
  }

  Stream<HealConnectData?> getHealConnectData() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('health_connect')
        .doc('default_device')
        .snapshots()
        .map(
          (doc) => doc.exists ? HealConnectData.fromJson(doc.data()!) : null,
        );
  }

  Future<bool> requestPermissions() async {
    try {
      // First check availability (only checks installation and compatibility)
      final isAvailable = await isHealthConnectAvailable();
      print(
          'Health Connect availability before permission request: $isAvailable');

      // Request permissions through the plugin
      final result = await platform.invokeMethod('requestPermissions');
      print('Permission request result: $result');

      // Kết quả có thể là Map hoặc bool
      bool granted = false;

      if (result is Map) {
        granted = result['granted'] == true;

        // Xử lý các trường hợp đặc biệt
        if (result['fallback'] == true) {
          print('Used fallback method to open Health Connect settings');
        }

        if (result['alternateMethod'] == true) {
          print('Used alternate method to request permissions');
        }
      } else if (result is bool) {
        granted = result;
      }

      if (!granted) {
        print(
            'Permissions not granted immediately. Will need to check again later.');

        // Đợi một chút rồi kiểm tra lại quyền
        await Future.delayed(const Duration(seconds: 2));
        final checkResult = await platform.invokeMethod('checkPermissions');
        print('Re-checking permissions after request: $checkResult');

        granted = checkResult['permissionsGranted'] == true;
      }

      if (granted) {
        print('Permissions granted, connecting device');
        await connectDevice('default_device', 'Health Connect Device');
      } else {
        print('Permissions were not granted after request');
        throw PlatformException(
          code: 'PERMISSION_DENIED',
          message:
              'Quyền truy cập bị từ chối. Vui lòng cấp quyền trong cài đặt Health Connect.',
        );
      }

      return granted;
    } on PlatformException catch (e) {
      print('Platform error requesting permissions: $e');
      rethrow;
    } catch (e) {
      print('Error requesting permissions: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getTodayHealthData() async {
    try {
      print('Getting health data from Health Connect...');
      final dynamic rawHealthData =
          await platform.invokeMethod('getHealthData');

      print('Health data received - type: ${rawHealthData.runtimeType}');

      // Kiểm tra dữ liệu nhận được
      if (rawHealthData == null) {
        print('Health data is null');
        return <String, dynamic>{'error': 'Health data is null'};
      }

      if (rawHealthData is! Map) {
        print('Health data is not a Map, it is: ${rawHealthData.runtimeType}');
        return <String, dynamic>{'error': 'Invalid data format'};
      }

      // Chuyển đổi thành Map<String, dynamic>
      final Map<String, dynamic> healthData =
          Map<String, dynamic>.from(rawHealthData as Map);

      // In các keys nhận được
      final keys = healthData.keys.toList();
      print('Health data keys: $keys');

      // Lưu trực tiếp vào biometric_history thay vì cập nhật health_connect
      await _saveToBiometricHistory(healthData);

      // Cập nhật thông tin thiết bị
      final User? user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('health_connect')
            .doc('default_device')
            .update({
          'lastSync': DateTime.now().toIso8601String(),
        });
      }

      return healthData;
    } catch (e) {
      print('Error getting health data: $e');
      rethrow;
    }
  }

  // Phương thức mới để lưu dữ liệu sức khỏe vào biometric_history
  Future<void> _saveToBiometricHistory(
      Map<dynamic, dynamic> rawHealthData) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Chuyển đổi sang Map<String, dynamic>
      final Map<String, dynamic> healthData = {};
      rawHealthData.forEach((key, value) {
        if (key is String) {
          healthData[key] = value;
        }
      });

      // Lấy thông tin biometric gần nhất
      final biometricSnapshots = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('biometric_history')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      // Dữ liệu biometric cơ bản
      Map<String, dynamic> biometricData = {
        'date': Timestamp.now(),
        'userId': user.uid,
        'healthData': healthData,
      };

      // Nếu có bản ghi biometric trước đó, giữ lại các thông tin cơ thể
      if (biometricSnapshots.docs.isNotEmpty) {
        final lastBiometric = biometricSnapshots.docs.first.data();
        biometricData['weight'] = lastBiometric['weight'] ?? 60;
        biometricData['height'] = lastBiometric['height'] ?? 160;
        biometricData['bmi'] = lastBiometric['bmi'] ?? 23.5;
        biometricData['tdee'] = lastBiometric['tdee'] ?? 2000;
      } else {
        // Giá trị mặc định nếu không có dữ liệu trước đó
        biometricData['weight'] = 60;
        biometricData['height'] = 160;
        biometricData['bmi'] = 23.5;
        biometricData['tdee'] = 2000;
      }

      // Thêm bản ghi mới vào biometric_history
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('biometric_history')
          .add(biometricData);

      print('Đã lưu dữ liệu sức khỏe vào biometric_history');
    } catch (e) {
      print('Lỗi khi lưu dữ liệu sức khỏe vào biometric_history: $e');
      throw Exception('Không thể lưu dữ liệu sức khỏe: $e');
    }
  }

  Future<void> connectDevice(String deviceId, String deviceName) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final deviceData = {
      'userId': user.uid,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'isConnected': true,
      'lastSync': DateTime.now().toIso8601String(),
      'healthData': {},
    };

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('health_connect')
        .doc(deviceId)
        .set(deviceData);
  }

  Future<void> disconnectDevice(String deviceId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('health_connect')
        .doc(deviceId)
        .update({
      'isConnected': false,
      'lastSync': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updateHealthData(
      String deviceId, Map<String, dynamic> healthData) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Đảm bảo health data là một Map không rỗng
    if (healthData.isEmpty) {
      print('Warning: Empty health data being saved');
      healthData = {'empty': true};
    }

    // Nếu health data là null, thay thế bằng Map rỗng
    if (healthData is! Map) {
      print('Warning: Health data is not a Map, replacing with empty map');
      healthData = {'invalid': true};
    }

    print(
        'Updating health data for device $deviceId with ${healthData.keys.length} keys');

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('health_connect')
          .doc(deviceId)
          .update({
        'healthData': healthData,
        'lastSync': DateTime.now().toIso8601String(),
      });
      print('Health data updated successfully in Firestore');
    } catch (e) {
      print('Error updating health data in Firestore: $e');
      // Có thể document chưa tồn tại, thử tạo mới
      try {
        print('Trying to create new document for health data');
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('health_connect')
            .doc(deviceId)
            .set({
          'userId': user.uid,
          'deviceId': deviceId,
          'deviceName': 'Health Connect Device',
          'isConnected': true,
          'lastSync': DateTime.now().toIso8601String(),
          'healthData': healthData,
        });
        print('Created new document with health data');
      } catch (innerError) {
        print('Failed to create document: $innerError');
        rethrow;
      }
    }
  }

  Future<void> openHealthConnectSettings() async {
    try {
      await platform.invokeMethod('openHealthConnectSettings');
    } on PlatformException catch (e) {
      print('Error opening Health Connect settings: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> checkConnectionStatus() async {
    try {
      const platform = MethodChannel('health_connect');
      final Map<String, dynamic> status = {
        'isInstalled': false,
        'isCompatible': false,
        'permissions': {},
        'error': null,
      };

      // Check if Health Connect is installed
      try {
        final isInstalled =
            await platform.invokeMethod('isHealthConnectInstalled');
        status['isInstalled'] = isInstalled == true;
      } catch (e) {
        status['error'] = 'Không thể kiểm tra cài đặt Health Connect: $e';
        return status;
      }

      if (!status['isInstalled']) {
        status['error'] = 'Health Connect chưa được cài đặt';
        return status;
      }

      // Check device compatibility
      try {
        final isCompatible =
            await platform.invokeMethod('isHealthConnectCompatible');
        status['isCompatible'] = isCompatible == true;
      } catch (e) {
        status['error'] = 'Không thể kiểm tra tính tương thích: $e';
        return status;
      }

      if (!status['isCompatible']) {
        status['error'] = 'Thiết bị không tương thích với Health Connect';
        return status;
      }

      // Check permissions for each data type
      final types = [
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        HealthDataType.SLEEP_IN_BED,
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.SLEEP_AWAKE,
      ];

      for (final type in types) {
        try {
          final hasPermission = await health.hasPermissions([type]);
          status['permissions'][type.toString()] = hasPermission == true;
        } catch (e) {
          status['permissions'][type.toString()] = false;
        }
      }

      // Check if all required permissions are granted
      final allPermissionsGranted =
          status['permissions'].values.every((granted) => granted == true);
      if (!allPermissionsGranted) {
        status['error'] =
            'Thiếu quyền truy cập. Vui lòng cấp đầy đủ quyền trong cài đặt Health Connect.';
      }

      return status;
    } catch (e) {
      return {
        'isInstalled': false,
        'isCompatible': false,
        'permissions': {},
        'error': 'Lỗi khi kiểm tra trạng thái kết nối: $e',
      };
    }
  }

  Future<bool> syncWeeklyHealthData() async {
    try {
      print('Fetching weekly health data from Health Connect...');
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Lấy dữ liệu từ Health Connect
      final healthData = await platform.invokeMethod('getHealthData');

      if (healthData == null) {
        print('Health data received is null');
        return false;
      }

      if (healthData is! Map) {
        print('Health data is not a Map: ${healthData.runtimeType}');
        return false;
      }

      if (healthData.isEmpty) {
        print('Health data is empty');
        return false;
      }

      print('Health data keys: ${healthData.keys.join(", ")}');

      // Lưu dữ liệu vào biometric_history
      await _saveToBiometricHistory(healthData);

      // Lưu dữ liệu hàng ngày thành các biometric riêng biệt
      if (healthData['daily_steps'] != null) {
        Map<String, dynamic> dailySteps = {};
        final rawDailySteps = healthData['daily_steps'];

        if (rawDailySteps is Map) {
          rawDailySteps.forEach((key, value) {
            if (key is String) {
              dailySteps[key] = value;
            }
          });

          if (dailySteps.isNotEmpty) {
            await _processDailySteps(dailySteps, user.uid);
          }
        }
      }

      return true;
    } catch (e) {
      print('Error syncing weekly health data: $e');
      return false;
    }
  }

  // Xử lý dữ liệu bước chân theo ngày thành các bản ghi biometric riêng biệt
  Future<bool> _processDailySteps(
      Map<String, dynamic> dailySteps, String userId) async {
    try {
      print('Processing daily steps data for ${dailySteps.length} days');

      // Lấy thông tin biometric gần nhất
      final biometricSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('biometric_history')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      // Lấy thông tin cơ bản của người dùng
      Map<String, dynamic> baseBiometricData = {};

      if (biometricSnapshot.docs.isNotEmpty) {
        final lastBiometric = biometricSnapshot.docs.first.data();
        baseBiometricData['weight'] = lastBiometric['weight'] ?? 60;
        baseBiometricData['height'] = lastBiometric['height'] ?? 160;
        baseBiometricData['bmi'] = lastBiometric['bmi'] ?? 23.5;
        baseBiometricData['tdee'] = lastBiometric['tdee'] ?? 2000;
      } else {
        baseBiometricData['weight'] = 60;
        baseBiometricData['height'] = 160;
        baseBiometricData['bmi'] = 23.5;
        baseBiometricData['tdee'] = 2000;
      }

      // Tạo batch để ghi nhiều bản ghi cùng lúc
      final batch = _firestore.batch();
      int addedCount = 0;

      // Kiểm tra các ngày đã có trong biometric_history
      final existingDates = await _firestore
          .collection('users')
          .doc(userId)
          .collection('biometric_history')
          .where('date',
              isGreaterThan: Timestamp.fromDate(
                  DateTime.now().subtract(const Duration(days: 30))))
          .get();

      final existingDateStrings = existingDates.docs.map((doc) {
        final date = (doc.data()['date'] as Timestamp).toDate();
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      }).toList();

      print(
          'Found ${existingDateStrings.length} existing dates in biometric_history');

      // Xử lý cho từng ngày
      for (final entry in dailySteps.entries) {
        final dateStr = entry.key;
        final steps = entry.value;

        // Bỏ qua nếu đã có dữ liệu cho ngày này
        if (existingDateStrings.contains(dateStr)) {
          print('Skipping $dateStr - already in biometric_history');
          continue;
        }

        try {
          final date = DateTime.parse(dateStr);

          // Tạo dữ liệu biometric mới cho ngày này
          final biometricData = {
            ...baseBiometricData,
            'date': Timestamp.fromDate(date),
            'userId': userId,
            'healthData': {
              'steps': steps,
              'date': dateStr,
            }
          };

          // Thêm vào batch
          final docRef = _firestore
              .collection('users')
              .doc(userId)
              .collection('biometric_history')
              .doc();

          batch.set(docRef, biometricData);
          addedCount++;

          // Commit batch nếu đã thêm 20 bản ghi
          if (addedCount >= 20) {
            await batch.commit();
            print('Committed batch with $addedCount biometric records');
            addedCount = 0;
          }
        } catch (e) {
          print('Error processing date $dateStr: $e');
        }
      }

      // Commit batch còn lại
      if (addedCount > 0) {
        await batch.commit();
        print('Committed final batch with $addedCount biometric records');
      }

      return true;
    } catch (e) {
      print('Error processing daily steps: $e');
      return false;
    }
  }

  // Lấy danh sách lịch sử biometric
  Future<List<Map<String, dynamic>>> getBiometricHistory() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      print('Fetching biometric history for user ${user.uid}');

      // Lấy biometric history từ Firestore, sắp xếp theo ngày mới nhất
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('biometric_history')
          .orderBy('date', descending: true)
          .limit(30) // Lấy 30 bản ghi gần nhất
          .get();

      if (snapshot.docs.isEmpty) {
        print('No biometric history found');
        return [];
      }

      print('Found ${snapshot.docs.length} biometric records');

      // Chuyển đổi snapshot thành danh sách Map
      List<Map<String, dynamic>> biometricList = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        // Thêm ID vào data
        final item = {
          'id': doc.id,
          ...data,
        };

        // Chuyển đổi Timestamp thành DateTime trong Map
        if (data['date'] is Timestamp) {
          item['date'] = (data['date'] as Timestamp).toDate();
        }

        biometricList.add(item);
      }

      return biometricList;
    } catch (e) {
      print('Error getting biometric history: $e');
      return [];
    }
  }

  // Xóa một bản ghi biometric
  Future<bool> deleteBiometricRecord(String id) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('biometric_history')
          .doc(id)
          .delete();

      print('Biometric record $id deleted successfully');
      return true;
    } catch (e) {
      print('Error deleting biometric record: $e');
      return false;
    }
  }

  // Cập nhật biometric record
  Future<bool> updateBiometricRecord(
      String id, Map<String, dynamic> data) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      print('Updating biometric record $id');

      // Đảm bảo không cập nhật ID
      final updateData = Map<String, dynamic>.from(data);
      updateData.remove('id');

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('biometric_history')
          .doc(id)
          .update(updateData);

      print('Biometric record updated successfully');
      return true;
    } catch (e) {
      print('Error updating biometric record: $e');
      return false;
    }
  }
}
