import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../core/constants/text_styles.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_card.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Báo cáo sức khỏe', centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSummarySection(),
            _buildHealthMetricsSection(),
            _buildActivitySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return CustomCard(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tổng quan', style: AppTextStyles.heading4),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem(
                icon: Icons.favorite,
                label: 'Nhịp tim',
                value: '72 bpm',
                color: AppColors.primary,
              ),
              _buildSummaryItem(
                icon: Icons.monitor_weight,
                label: 'Cân nặng',
                value: '65 kg',
                color: AppColors.secondary,
              ),
              _buildSummaryItem(
                icon: Icons.local_fire_department,
                label: 'Calories',
                value: '1200 kcal',
                color: AppColors.info,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthMetricsSection() {
    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Chỉ số sức khỏe', style: AppTextStyles.heading4),
          const SizedBox(height: 16),
          _buildHealthMetricItem(
            label: 'Huyết áp',
            value: '120/80 mmHg',
            trend: 'Bình thường',
            trendColor: AppColors.success,
          ),
          _buildHealthMetricItem(
            label: 'Đường huyết',
            value: '5.2 mmol/L',
            trend: 'Bình thường',
            trendColor: AppColors.success,
          ),
          _buildHealthMetricItem(
            label: 'Cholesterol',
            value: '4.5 mmol/L',
            trend: 'Cao',
            trendColor: AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetricItem({
    required String label,
    required String value,
    required String trend,
    required Color trendColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: trendColor.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              trend,
              style: AppTextStyles.bodySmall.copyWith(
                color: trendColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection() {
    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hoạt động gần đây', style: AppTextStyles.heading4),
          const SizedBox(height: 16),
          _buildActivityItem(
            icon: Icons.directions_walk,
            label: 'Đi bộ',
            value: '5,000 bước',
            time: 'Hôm nay',
          ),
          _buildActivityItem(
            icon: Icons.directions_run,
            label: 'Chạy bộ',
            value: '3.5 km',
            time: 'Hôm qua',
          ),
          _buildActivityItem(
            icon: Icons.pool,
            label: 'Bơi lội',
            value: '30 phút',
            time: '2 ngày trước',
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String label,
    required String value,
    required String time,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: AppColors.primary.withAlpha(26),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        value,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
      trailing: Text(
        time,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
