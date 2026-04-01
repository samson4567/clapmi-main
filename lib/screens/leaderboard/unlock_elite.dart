import 'dart:math' as math;

import 'package:clapmi/core/di/injector.dart';
import 'package:clapmi/features/user/data/datasources/user_remote_datasource.dart';
import 'package:clapmi/features/user/data/models/payment_grade_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

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
      if (!mounted) {
        return;
      }
      setState(() {
        _paymentGrades = response.data.data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const Image(
            image: AssetImage('assets/icons/pnc.png'),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Column(
              children: [
                _buildBackButton(context),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextButton.icon(
          onPressed: () => context.pop(),
          icon:
              const Icon(Icons.chevron_left, color: Colors.white, size: 22),
          label: const Text(
            'Back',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_paymentGrades == null || _paymentGrades!.isEmpty) {
      return const Center(
        child: Text('No data available', style: TextStyle(color: Colors.white)),
      );
    }

    final grades = [..._paymentGrades!]
      ..sort((a, b) => a.position.compareTo(b.position));

    final currentLevel = grades.firstWhere(
      (level) => level.isCurrentLevel,
      orElse: () => grades.first,
    );

    final nextLevel = _getNextLevel(grades, currentLevel) ?? currentLevel;
    final isTopLevel = nextLevel.uuid == currentLevel.uuid;
    final targetTitle =
        isTopLevel ? currentLevel.name : nextLevel.name;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          Center(child: _buildTierHero(nextLevel, isTopLevel)),
          SizedBox(height: 18.h),
          Center(
            child: Text(
              isTopLevel
                  ? 'You are on $targetTitle'
                  : 'How to unlock $targetTitle',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 26.sp,
                height: 1.2,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Center(
            child: Text(
              isTopLevel
                  ? 'You have already reached the highest creator tier.'
                  : 'Move from ${currentLevel.name} to $targetTitle by meeting these targets.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.72),
                fontFamily: 'Poppins',
                fontSize: 14.sp,
                height: 1.45,
              ),
            ),
          ),
          SizedBox(height: 28.h),
          _buildLevelSummary(currentLevel, nextLevel, isTopLevel),
          SizedBox(height: 24.h),
          if (!isTopLevel && nextLevel.metrics != null && currentLevel.metrics != null)
            _buildRequirementsSection(currentLevel, nextLevel),
          if (!isTopLevel && nextLevel.metrics != null && currentLevel.metrics != null)
            SizedBox(height: 24.h),
          if (nextLevel.benefits.isNotEmpty) _buildBenefitsSection(nextLevel),
          if (nextLevel.benefits.isNotEmpty) SizedBox(height: 20.h),
          if (nextLevel.payout != null) _buildPayoutSection(nextLevel),
          if (nextLevel.payout != null) SizedBox(height: 24.h),
          _buildAllTiersSection(grades, currentLevel, nextLevel),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go('/leaderboard'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F6FD6),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'View Leaderboard',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[700]!,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            const SizedBox(height: 20),
            Container(height: 28, width: 220, color: Colors.white),
            const SizedBox(height: 24),
            ...List.generate(
              4,
              (_) => Container(
                margin: const EdgeInsets.only(bottom: 14),
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 48),
          SizedBox(height: 16.h),
          Text(
            'Failed to load tier data',
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

  Widget _buildTierHero(PaymentGradeModel nextLevel, bool isTopLevel) {
    return Container(
      width: 132.w,
      height: 132.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFF8B5CF6).withOpacity(0.26),
            const Color(0xFF8B5CF6).withOpacity(0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: _buildTierBadge(
        level: nextLevel,
        size: 88,
        forceLocalLegendAsset: nextLevel.name.toLowerCase() == 'legend',
        tintLegend: !isTopLevel,
      ),
    );
  }

  Widget _buildLevelSummary(
      PaymentGradeModel currentLevel, PaymentGradeModel nextLevel, bool isTopLevel) {
    return Row(
      children: [
        Expanded(
          child: _buildLevelCard(
            title: 'Your Current Level',
            level: currentLevel,
            isHighlighted: false,
          ),
        ),
        if (!isTopLevel) SizedBox(width: 12.w),
        if (!isTopLevel)
          Expanded(
            child: _buildLevelCard(
              title: 'Next Level',
              level: nextLevel,
              isHighlighted: true,
            ),
          ),
      ],
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
        color: const Color(0xFF111214).withOpacity(isHighlighted ? 0.98 : 0.88),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHighlighted
              ? const Color(0xFF1F6FD6)
              : Colors.white.withOpacity(0.08),
          width: isHighlighted ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.55),
              fontFamily: 'Poppins',
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              _buildTierBadge(
                level: level,
                size: 44,
                forceLocalLegendAsset: level.name.toLowerCase() == 'legend',
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      level.subscriptionAmount > 0
                          ? '\$${level.subscriptionAmount}/month'
                          : 'Free tier',
                      style: TextStyle(
                        color: isHighlighted
                            ? const Color(0xFF77B5FF)
                            : Colors.white.withOpacity(0.55),
                        fontFamily: 'Poppins',
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementsSection(
      PaymentGradeModel currentLevel, PaymentGradeModel nextLevel) {
    final currentMetrics = currentLevel.metrics!;
    final targetMetrics = nextLevel.metrics!;
    final rows = [
      _RequirementRowData(
        label: 'Total livestreams',
        rangeText:
            '${currentMetrics.minStreams} - ${targetMetrics.minStreams}',
        currentValueText: '${currentMetrics.minStreams}',
        progress: _ratio(currentMetrics.minStreams, targetMetrics.minStreams),
      ),
      _RequirementRowData(
        label: 'Avg. live viewers',
        rangeText:
            '${currentMetrics.minAvgViewers} - ${targetMetrics.minAvgViewers}',
        currentValueText: '${currentMetrics.minAvgViewers}',
        progress: _ratio(
          currentMetrics.minAvgViewers,
          targetMetrics.minAvgViewers,
        ),
      ),
      _RequirementRowData(
        label: 'Engagement rate',
        rangeText:
            '${currentMetrics.minEngagementRate}% - ${targetMetrics.minEngagementRate}%',
        currentValueText: '${currentMetrics.minEngagementRate}%',
        progress: _ratio(
          _parseNum(currentMetrics.minEngagementRate),
          _parseNum(targetMetrics.minEngagementRate),
        ),
      ),
      _RequirementRowData(
        label: 'Revenue generated',
        rangeText:
            '\$${_compact(currentMetrics.minRevenue)} - \$${_compact(targetMetrics.minRevenue)}',
        currentValueText: '\$${_compact(currentMetrics.minRevenue)}',
        progress: _ratio(currentMetrics.minRevenue, targetMetrics.minRevenue),
      ),
      _RequirementRowData(
        label: 'Returning viewers',
        rangeText:
            '${currentMetrics.minReturningViewers}% - ${targetMetrics.minReturningViewers}%',
        currentValueText: '${currentMetrics.minReturningViewers}%',
        progress: _ratio(
          currentMetrics.minReturningViewers,
          targetMetrics.minReturningViewers,
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows.map(_buildRequirementRow).toList(),
    );
  }

  Widget _buildRequirementRow(_RequirementRowData row) {
    final completed = row.progress >= 1;
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${row.label}: ${row.rangeText}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontFamily: 'Poppins',
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: row.progress,
                    minHeight: 3.5,
                    backgroundColor: Colors.white.withOpacity(0.12),
                    valueColor:
                        const AlwaysStoppedAnimation(Color(0xFF77B5FF)),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                row.currentValueText,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.72),
                  fontFamily: 'Poppins',
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                width: 18.w,
                height: 18.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: completed
                      ? const Color(0xFF1F6FD6)
                      : Colors.transparent,
                  border: Border.all(
                    color: const Color(0xFF1F6FD6),
                    width: 1.2,
                  ),
                ),
                child: completed
                    ? Icon(Icons.check, size: 12.sp, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection(PaymentGradeModel nextLevel) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF181919).withOpacity(0.92),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Level Benefits:',
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 14.h),
          ...nextLevel.benefits.map(
            (benefit) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.workspace_premium_outlined,
                      size: 14.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      benefit.label,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.88),
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutSection(PaymentGradeModel nextLevel) {
    final payout = nextLevel.payout!;
    final items = [
      ('Earnings from live streams', payout.livestream),
      ('Creator share', payout.creator),
      ('Fan share', payout.fans),
      ('Clapmi share', payout.clapmi),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${nextLevel.name} payout rates',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 14.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: items
              .map(
                (item) => SizedBox(
                  width: ((MediaQuery.of(context).size.width - (48.w) - 10.w) /
                          2)
                      .clamp(140.0, 220.0),
                  child: Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF174C96), Color(0xFF0D2C56)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/commentcoin.png',
                              width: 18.w,
                              height: 18.w,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              '${item.$2}%',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 18.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          item.$1,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.74),
                            fontFamily: 'Poppins',
                            fontSize: 11.sp,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildAllTiersSection(List<PaymentGradeModel> grades,
      PaymentGradeModel currentLevel, PaymentGradeModel nextLevel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Tiers',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 14.h),
        ...grades.map(
          (level) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _buildLevelOverviewItem(level, currentLevel, nextLevel),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelOverviewItem(
      PaymentGradeModel level, PaymentGradeModel currentLevel, PaymentGradeModel nextLevel) {
    final isCurrent = level.uuid == currentLevel.uuid;
    final isNext = level.uuid == nextLevel.uuid && nextLevel.uuid != currentLevel.uuid;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF111214).withOpacity(0.88),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent
              ? const Color(0xFF1F6FD6)
              : isNext
                  ? Colors.green
                  : Colors.white.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          _buildTierBadge(level: level, size: 36),
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
                    if (isCurrent) ...[
                      SizedBox(width: 8.w),
                      _buildTierTag('Current', const Color(0xFF1F6FD6)),
                    ],
                    if (isNext) ...[
                      SizedBox(width: 8.w),
                      _buildTierTag('Next', Colors.green),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  level.subscriptionAmount > 0
                      ? '\$${level.subscriptionAmount}/month'
                      : 'Free',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.56),
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

  Widget _buildTierTag(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTierBadge({
    required PaymentGradeModel level,
    required double size,
    bool forceLocalLegendAsset = false,
    bool tintLegend = false,
  }) {
    final normalized = level.name.toLowerCase();

    if (forceLocalLegendAsset || normalized == 'legend') {
      return Image.asset(
        'assets/icons/legend1.png',
        width: size.w,
        height: size.h,
        fit: BoxFit.contain,
      );
    }

    if (level.badgeUrl != null && level.badgeUrl!.isNotEmpty) {
      return Image.network(
        level.badgeUrl!,
        width: size.w,
        height: size.h,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            _buildLocalTierBadge(normalized, size, tintLegend: tintLegend),
      );
    }

    return _buildLocalTierBadge(normalized, size, tintLegend: tintLegend);
  }

  Widget _buildLocalTierBadge(String normalized, double size,
      {bool tintLegend = false}) {
    final path = switch (normalized) {
      'icon' => 'assets/icons/ic.png',
      'prime' => 'assets/icons/prime.png',
      'elite' => 'assets/icons/elite.png',
      'legend' => 'assets/icons/legend1.png',
      _ => 'assets/icons/elite.png',
    };

    return Image.asset(
      path,
      width: size.w,
      height: size.h,
      fit: BoxFit.contain,
    );
  }

  PaymentGradeModel? _getNextLevel(
      List<PaymentGradeModel> grades, PaymentGradeModel currentLevel) {
    final higherLevels = grades
        .where((level) => level.position > currentLevel.position)
        .toList()
      ..sort((a, b) => a.position.compareTo(b.position));

    if (higherLevels.isEmpty) {
      return null;
    }

    return higherLevels.first;
  }

  double _ratio(num current, num target) {
    if (target <= 0) {
      return 0;
    }
    return math.max(0, math.min(current / target, 1)).toDouble();
  }

  double _parseNum(String value) {
    return double.tryParse(value.replaceAll('%', '').trim()) ?? 0;
  }

  String _compact(num value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}

class _RequirementRowData {
  final String label;
  final String rangeText;
  final String currentValueText;
  final double progress;

  const _RequirementRowData({
    required this.label,
    required this.rangeText,
    required this.currentValueText,
    required this.progress,
  });
}
