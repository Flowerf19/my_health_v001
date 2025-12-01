import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../core/constants/text_styles.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: '9:40',
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        actions: [
          Row(
            children: [
              Opacity(
                opacity: 0.35,
                child: Container(
                  width: 17.18,
                  height: 11,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: AppColors.textPrimary),
                      borderRadius: BorderRadius.circular(2.67),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 1.38),
              Container(
                width: 14.06,
                height: 7.12,
                decoration: ShapeDecoration(
                  color: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.33),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeartRateSection(),
            _buildHealthMetricsSection(),
            _buildLatestReportSection(),
          ],
        ),
      ),
    );
  }



  Widget _buildHeartRateSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: CustomCard(
        // ignore: deprecated_member_use
        backgroundColor: AppColors.primary.withAlpha(26),
        child: const SizedBox(
          height: 131,
          child: Stack(
            children: [
              Positioned(
                left: 20,
                top: 20,
                child: Text('Heart rate', style: AppTextStyles.heading4),
              ),
              Positioned(
                left: 20,
                top: 50,
                child: Text('97', style: AppTextStyles.heading1),
              ),
              Positioned(
                left: 86,
                top: 90,
                child: Text('bpm', style: AppTextStyles.bodySmall),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthMetricsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHealthMetricItem(
            // ignore: deprecated_member_use
            color: AppColors.secondary.withAlpha(107),
            label: 'Blood Group',
            value: 'A+',
          ),
          _buildHealthMetricItem(
            // ignore: deprecated_member_use
            color: AppColors.warning.withAlpha(26),
            label: 'Weight',
            value: '103lbs',
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetricItem({
    required Color color,
    required String label,
    required String value,
  }) {
    return Container(
      width: 139,
      height: 145,
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.heading3),
        ],
      ),
    );
  }

  Widget _buildLatestReportSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Latest report', style: AppTextStyles.heading4),
          const SizedBox(height: 20),
          _buildReportItem(
            icon: Icons.bedtime,
            label: 'Sleep 3 hours 50 mins',
            date: 'Jul 10, 2023',
          ),
          const SizedBox(height: 20),
          _buildReportItem(
            icon: Icons.directions_walk,
            label: 'Step 2500/5000',
            date: 'Jul 5, 2023',
          ),
          const SizedBox(height: 20),
          _buildReportItem(
            icon: Icons.local_fire_department,
            label: 'Calories : 250/2500',
            date: 'Jul 5, 2023',
          ),
          const SizedBox(height: 20),
          _buildReportItem(
            icon: Icons.monitor_weight,
            label: 'BMI 19.5',
            date: 'Jul 5, 2023',
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem({
    required IconData icon,
    required String label,
    required String date,
  }) {
    return Container(
      width: double.infinity,
      height: 67,
      decoration: ShapeDecoration(
        color: AppColors.background,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: AppColors.divider),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 53,
            margin: const EdgeInsets.only(left: 10),
            decoration: ShapeDecoration(
              // ignore: deprecated_member_use
              color: AppColors.primary.withAlpha(31),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                date,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
