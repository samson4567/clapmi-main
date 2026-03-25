import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:clapmi/features/user/data/datasources/user_remote_datasource.dart';
import 'package:clapmi/features/user/data/models/payment_grade_model.dart';
import 'package:clapmi/core/di/injector.dart';

class UnlockEliteScreen extends StatefulWidget {
  const UnlockEliteScreen({super.key});

  @override
  State<UnlockEliteScreen> createState() => _UnlockEliteScreenState();
}

class _UnlockEliteScreenState extends State<UnlockEliteScreen> {
  final UserRemoteDatasource _datasource =
      getItInstance<UserRemoteDatasource>();

  List<PaymentGradeModel>? _paymentGrades;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPaymentGrades();
  }

  Future<void> _fetchPaymentGrades() async {
    try {
      final response = await _datasource.getPaymentGrades();
      if (mounted) {
        setState(() {
          _paymentGrades = response.data.data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          const Image(
            image: AssetImage('assets/icons/pnc.png'),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Floating elite icon at top
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Image(
                image: const AssetImage('assets/icons/elite.png'),
                width: 120.w,
                height: 120.h,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.chevron_left,
                          color: Colors.white, size: 22),
                      label: const Text('Back',
                          style: TextStyle(color: Colors.white, fontSize: 17)),
                    ),
                  ),
                ),

                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 48),
            SizedBox(height: 16.h),
            Text(
              'Failed to load data',
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _fetchPaymentGrades();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_paymentGrades == null || _paymentGrades!.isEmpty) {
      return const Center(
        child: Text('No data available', style: TextStyle(color: Colors.white)),
      );
    }

    // Find current level and next level
    final currentLevel = _paymentGrades!.firstWhere(
      (level) => level.isCurrentLevel,
      orElse: () => _paymentGrades!.first,
    );

    final nextLevel = _paymentGrades!.firstWhere(
      (level) => level.isNextLevel,
      orElse: () => _paymentGrades!.firstWhere(
        (level) => level.position > currentLevel.position,
        orElse: () => _paymentGrades!.last,
      ),
    );

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 100.h),

          // Title
          Center(
            child: Text(
              'How to Unlock Elite',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Center(
            child: Text(
              'Reach the ${nextLevel.name} tier to unlock Elite status!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontFamily: 'Poppins',
                fontSize: 14.sp,
              ),
            ),
          ),
          SizedBox(height: 32.h),

          // Current Level Card
          _buildLevelCard(
            title: 'Your Current Level',
            level: currentLevel,
            isHighlighted: false,
          ),
          SizedBox(height: 16.h),

          // Next Level Card (Target)
          _buildLevelCard(
            title: 'Next Level to Unlock',
            level: nextLevel,
            isHighlighted: true,
          ),
          SizedBox(height: 32.h),

          // Metrics Requirements
          Text(
            'Requirements to Reach ${nextLevel.name}',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 16.h),

          if (nextLevel.metrics != null) _buildMetricsCard(nextLevel.metrics!),
          SizedBox(height: 32.h),

          // Payout Info
          Text(
            '${nextLevel.name} Payout Rates',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 16.h),

          if (nextLevel.payout != null) _buildPayoutCard(nextLevel.payout!),
          SizedBox(height: 32.h),

          // All Levels Overview
          Text(
            'All Tiers',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 16.h),

          ..._paymentGrades!.map((level) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _buildLevelOverviewItem(level),
              )),

          SizedBox(height: 32.h),

          // CTA Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go('/leaderboard'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A7CF7),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'View Leaderboard',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildLevelCard({
    required String title,
    required PaymentGradeModel level,
    required bool isHighlighted,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isHighlighted
            ? const Color(0xFF4A7CF7).withValues(alpha: 0.3)
            : Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: isHighlighted
            ? Border.all(color: const Color(0xFF4A7CF7), width: 2)
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isHighlighted
                  ? const Color(0xFF4A7CF7).withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isHighlighted ? Icons.arrow_upward : Icons.star,
              color: isHighlighted ? const Color(0xFF4A7CF7) : Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white60,
                    fontFamily: 'Poppins',
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  level.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                if (level.subscriptionAmount > 0) ...[
                  SizedBox(height: 4.h),
                  Text(
                    '\$${level.subscriptionAmount}/month',
                    style: TextStyle(
                      color: const Color(0xFF4A7CF7),
                      fontFamily: 'Poppins',
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsCard(PaymentGradeMetrics metrics) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildMetricRow(
              'Min Streams', '${metrics.minStreams}', Icons.live_tv),
          SizedBox(height: 12.h),
          _buildMetricRow(
              'Min Avg Viewers', '${metrics.minAvgViewers}', Icons.visibility),
          SizedBox(height: 12.h),
          _buildMetricRow('Min Engagement Rate',
              '${metrics.minEngagementRate}%', Icons.trending_up),
          SizedBox(height: 12.h),
          _buildMetricRow(
              'Min Revenue', '\$${metrics.minRevenue}', Icons.attach_money),
          SizedBox(height: 12.h),
          _buildMetricRow('Min Returning Viewers',
              '${metrics.minReturningViewers}', Icons.people),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF4A7CF7), size: 20),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontFamily: 'Poppins',
              fontSize: 14.sp,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildPayoutCard(PaymentGradePayout payout) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildPayoutRow('Creator', payout.creator),
          SizedBox(height: 8.h),
          _buildPayoutRow('Fans', payout.fans),
          SizedBox(height: 8.h),
          _buildPayoutRow('Clapmi', payout.clapmi),
          SizedBox(height: 8.h),
          _buildPayoutRow('Livestream', payout.livestream),
        ],
      ),
    );
  }

  Widget _buildPayoutRow(String label, int percentage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontFamily: 'Poppins',
            fontSize: 14.sp,
          ),
        ),
        Text(
          '$percentage%',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelOverviewItem(PaymentGradeModel level) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: level.isCurrentLevel
            ? Border.all(color: const Color(0xFF4A7CF7), width: 1)
            : level.isNextLevel
                ? Border.all(color: Colors.green, width: 1)
                : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: level.isCurrentLevel
                  ? const Color(0xFF4A7CF7)
                  : level.isNextLevel
                      ? Colors.green
                      : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${level.position}',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      level.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                    if (level.isCurrentLevel) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A7CF7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Current',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    if (level.isNextLevel) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  level.subscriptionAmount > 0
                      ? '\$${level.subscriptionAmount}/month'
                      : 'Free',
                  style: TextStyle(
                    color: Colors.white60,
                    fontFamily: 'Poppins',
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
