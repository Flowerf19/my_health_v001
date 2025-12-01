import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/health_connect_service.dart';
import '../../../models/heal_connect_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class HealthConnectCard extends StatelessWidget {
  const HealthConnectCard({super.key});

  @override
  Widget build(BuildContext context) {
    final healthConnectService = Provider.of<HealthConnectService>(context);

    return StreamBuilder<HealConnectData?>(
      stream: healthConnectService.getHealConnectData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorCard(context, snapshot.error.toString());
        }

        if (!snapshot.hasData) {
          return _buildEmptyCard(context, healthConnectService);
        }

        final data = snapshot.data!;
        return _buildConnectedCard(context, data, healthConnectService);
      },
    );
  }

  Widget _buildEmptyCard(BuildContext context, HealthConnectService service) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.fitness_center, color: AppColors.primary),
                SizedBox(width: 8),
                Text('Health Connect', style: AppTextStyles.heading4),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Chưa kết nối với Health Connect', style: AppTextStyles.body1),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final granted = await service.requestPermissions();
                        if (!granted && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Không thể kết nối với Health Connect. Vui lòng kiểm tra quyền trong cài đặt.',
                              ),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Lỗi: $e'),
                              duration: const Duration(seconds: 5),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Kết nối với Health Connect'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () async {
                    try {
                      await service.openHealthConnectSettings();
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lỗi mở cài đặt: $e')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.settings),
                  tooltip: 'Mở cài đặt Health Connect',
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                try {
                  final status = await service.checkConnectionStatus();
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Trạng thái Health Connect'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Đã cài đặt: ${status['isInstalled']}'),
                              Text('Tương thích: ${status['isCompatible']}'),
                              Text('Lỗi: ${status['error'] ?? 'Không có'}'),
                              const SizedBox(height: 8),
                              const Text('Quyền:'),
                              ...(status['permissions'] as Map<String, dynamic>)
                                  .entries
                                  .map(
                                    (e) => Text('${e.key}: ${e.value}'),
                                  ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Đóng'),
                          ),
                        ],
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi kiểm tra trạng thái: $e')),
                    );
                  }
                }
              },
              child: const Text('Kiểm tra trạng thái'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectedCard(
    BuildContext context,
    HealConnectData data,
    HealthConnectService service,
  ) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.fitness_center, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text('Health Connect', style: AppTextStyles.heading4),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () async {
                    try {
                      // Hiển thị loading indicator
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đang đồng bộ dữ liệu sức khỏe...'),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      final healthData = await service.getTodayHealthData();

                      if (context.mounted) {
                        if (healthData.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Không có dữ liệu sức khỏe mới'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Đã đồng bộ dữ liệu sức khỏe thành công',
                              ),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Lỗi: $e'),
                            duration: const Duration(seconds: 5),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Thiết bị: ${data.deviceName}', style: AppTextStyles.body1),
            const SizedBox(height: 8),
            Text(
              'Lần cập nhật cuối: ${_formatDateTime(data.lastSync)}',
              style: AppTextStyles.body2,
            ),
            const SizedBox(height: 16),
            if (data.healthData.isNotEmpty) ...[
              const Text('Dữ liệu sức khỏe:', style: AppTextStyles.body1),
              const SizedBox(height: 8),

              // Hiển thị tổng số bước chân
              if (data.healthData['steps'] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.directions_walk, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Số bước: ${data.healthData['steps']}',
                        style: AppTextStyles.body1,
                      ),
                    ],
                  ),
                ),

              // Hiển thị nhịp tim
              if (data.healthData['heart_rate'] != null &&
                  data.healthData['heart_rate'] is Map)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite, size: 20, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        'Nhịp tim: ${(data.healthData['heart_rate'] as Map)['average']?.toStringAsFixed(1) ?? 'N/A'} BPM',
                        style: AppTextStyles.body1,
                      ),
                    ],
                  ),
                ),

              // Hiển thị thời gian ngủ
              if (data.healthData['sleep'] != null &&
                  data.healthData['sleep'] is Map &&
                  (data.healthData['sleep'] as Map)['totalMinutes'] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.nightlight, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Thời gian ngủ: ${_formatDuration((data.healthData['sleep'] as Map)['totalMinutes'] as int)}',
                        style: AppTextStyles.body1,
                      ),
                    ],
                  ),
                ),

              // Hiển thị nút để xem chi tiết
              OutlinedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Chức năng xem chi tiết đang phát triển'),
                    ),
                  ),
                child: const Text('Xem chi tiết'),
              ),

              const SizedBox(height: 8),

              // Thêm nút xem lịch sử biometric
              OutlinedButton.icon(
                onPressed: () async {
                  try {
                    // Hiển thị đang đồng bộ
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đang đồng bộ dữ liệu...'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // Đồng bộ dữ liệu trước khi xem
                    await service.syncWeeklyHealthData();

                    // Lấy danh sách biometric history
                    final biometricHistory =
                        await service.getBiometricHistory();

                    if (context.mounted) {
                      if (biometricHistory.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Không tìm thấy lịch sử biometric'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Đã tìm thấy ${biometricHistory.length} bản ghi biometric'),
                            duration: const Duration(seconds: 3),
                          ),
                        );

                        // Hiển thị hộp thoại với thông tin biometric record gần nhất
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Thông tin biometric gần nhất'),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Ngày: ${_formatDateTime(biometricHistory[0]['date'].toString())}'),
                                    Text(
                                        'Cân nặng: ${biometricHistory[0]['weight']} kg'),
                                    Text(
                                        'Chiều cao: ${biometricHistory[0]['height']} cm'),
                                    Text(
                                        'BMI: ${biometricHistory[0]['bmi'].toStringAsFixed(1)}'),
                                    Text(
                                        'TDEE: ${biometricHistory[0]['tdee']} calories'),
                                    if (biometricHistory[0]['healthData'] !=
                                        null) ...[
                                      const SizedBox(height: 8),
                                      const Text('Dữ liệu sức khỏe:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      _buildHealthDataInfo(
                                          biometricHistory[0]['healthData']),
                                    ],
                                    const SizedBox(height: 16),
                                    const Text('Các bản ghi gần đây:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    ...biometricHistory
                                        .take(5)
                                        .map((record) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4),
                                              child: Text(
                                                  '${_formatDateTime(record['date'].toString())}: BMI ${record['bmi'].toStringAsFixed(1)}'),
                                            )),
                                  ],
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('Đóng'),
                              ),
                              // TODO: Thêm nút điều hướng đến màn hình lịch sử biometric chi tiết
                            ],
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Lỗi: $e'),
                          duration: const Duration(seconds: 5),
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.history),
                label: const Text('Xem lịch sử biometric'),
              ),
            ] else ...[
              const Text(
                'Chưa có dữ liệu sức khỏe. Nhấn nút làm mới để đồng bộ.',
                style: AppTextStyles.body2,
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  await service.disconnectDevice(data.deviceId);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi: $e')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Ngắt kết nối'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String error) {
    return Card(
      margin: const EdgeInsets.all(16),
      // ignore: deprecated_member_use
      color: AppColors.error.withAlpha(26),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error_outline, color: AppColors.error),
                const SizedBox(width: 8),
                Text(
                  'Lỗi Health Connect',
                  style: AppTextStyles.heading4.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: AppTextStyles.body2.copyWith(color: AppColors.error),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(String dateStr) {
    try {
      if (dateStr.contains('T')) {
        // ISO format
        final date = DateTime.parse(dateStr);
        return '${date.day}/${date.month}/${date.year}';
      } else if (dateStr.contains('Timestamp')) {
        // Firestore timestamp format
        final regex = RegExp(r'seconds=(\d+)');
        final match = regex.firstMatch(dateStr);
        if (match != null) {
          final seconds = int.parse(match.group(1)!);
          final date = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
          return '${date.day}/${date.month}/${date.year}';
        }
      }
      return dateStr;
    } catch (e) {
      return dateStr;
    }
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      return '$hours giờ ${remainingMinutes > 0 ? '$remainingMinutes phút' : ''}';
    } else {
      return '$minutes phút';
    }
  }

  Widget _buildHealthDataInfo(Map<String, dynamic> healthData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (healthData['steps'] != null)
          Text('Bước chân: ${healthData['steps']} bước'),
        if (healthData['heartRate'] != null && healthData['heartRate'] is Map)
          Text(
              'Nhịp tim: ${(healthData['heartRate'] as Map)['averageBpm']} BPM'),
        if (healthData['sleep'] != null && healthData['sleep'] is Map)
          Text(
              'Thời gian ngủ: ${((healthData['sleep'] as Map)['totalMinutes'] / 60).toStringAsFixed(1)} giờ'),
        if (healthData['calories'] != null)
          Text('Calories: ${healthData['calories']} cal'),
        if (healthData['distance'] != null)
          Text(
              'Khoảng cách: ${(healthData['distance'] / 1000).toStringAsFixed(2)} km'),
      ],
    );
  }
}
