/// Model for Payment Grade (Creator Tiers)
class PaymentGradeModel {
  final String uuid;
  final String name;
  final int position;
  final String? badgeUrl;
  final int subscriptionAmount;
  final PaymentGradeMetrics? metrics;
  final PaymentGradePayout? payout;
  final List<PaymentGradeBenefit> benefits;
  final bool isCurrentLevel;
  final bool isPreviousLevel;
  final bool isNextLevel;
  final bool isSubscribed;

  PaymentGradeModel({
    required this.uuid,
    required this.name,
    required this.position,
    this.badgeUrl,
    required this.subscriptionAmount,
    this.metrics,
    this.payout,
    required this.benefits,
    required this.isCurrentLevel,
    required this.isPreviousLevel,
    required this.isNextLevel,
    required this.isSubscribed,
  });

  factory PaymentGradeModel.fromJson(Map<String, dynamic> json) {
    // Handle metrics - can be empty object or missing
    PaymentGradeMetrics? metrics;
    if (json['metrics'] is Map<String, dynamic>) {
      metrics =
          PaymentGradeMetrics.fromJson(json['metrics'] as Map<String, dynamic>);
    }

    // Handle payout - can be empty object or missing
    PaymentGradePayout? payout;
    if (json['payout'] is Map<String, dynamic>) {
      payout =
          PaymentGradePayout.fromJson(json['payout'] as Map<String, dynamic>);
    }

    // Handle benefits - can be empty array or missing
    List<PaymentGradeBenefit> benefits = [];
    if (json['benefits'] is List) {
      benefits = (json['benefits'] as List)
          .where((e) => e is Map<String, dynamic>)
          .map((e) => PaymentGradeBenefit.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return PaymentGradeModel(
      uuid: json['uuid']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      position: json['position'] ?? 0,
      badgeUrl: json['badge_url']?.toString(),
      subscriptionAmount: json['subscription_amount'] ?? 0,
      metrics: metrics,
      payout: payout,
      benefits: benefits,
      isCurrentLevel: json['is_current_level'] ?? false,
      isPreviousLevel: json['is_previous_level'] ?? false,
      isNextLevel: json['is_next_level'] ?? false,
      isSubscribed: json['is_subscribed'] ?? false,
    );
  }
}

/// Metrics required for a payment grade
class PaymentGradeMetrics {
  final int minStreams;
  final int minAvgViewers;
  final String minEngagementRate;
  final int minRevenue;
  final int minReturningViewers;

  PaymentGradeMetrics({
    required this.minStreams,
    required this.minAvgViewers,
    required this.minEngagementRate,
    required this.minRevenue,
    required this.minReturningViewers,
  });

  factory PaymentGradeMetrics.fromJson(Map<String, dynamic> json) {
    return PaymentGradeMetrics(
      minStreams: json['min_streams'] ?? 0,
      minAvgViewers: json['min_avg_viewers'] ?? 0,
      minEngagementRate: json['min_engagement_rate'] ?? '0.00',
      minRevenue: json['min_revenue'] ?? 0,
      minReturningViewers: json['min_returning_viewers'] ?? 0,
    );
  }
}

/// Payout percentages for a payment grade
class PaymentGradePayout {
  final int creator;
  final int fans;
  final int clapmi;
  final int livestream;

  PaymentGradePayout({
    required this.creator,
    required this.fans,
    required this.clapmi,
    required this.livestream,
  });

  factory PaymentGradePayout.fromJson(Map<String, dynamic> json) {
    return PaymentGradePayout(
      creator: json['creator'] ?? 0,
      fans: json['fans'] ?? 0,
      clapmi: json['clapmi'] ?? 0,
      livestream: json['livestream'] ?? 0,
    );
  }
}

/// Benefit item for a payment grade
class PaymentGradeBenefit {
  final String uuid;
  final String label;
  final int displayOrder;

  PaymentGradeBenefit({
    required this.uuid,
    required this.label,
    required this.displayOrder,
  });

  factory PaymentGradeBenefit.fromJson(Map<String, dynamic> json) {
    return PaymentGradeBenefit(
      uuid: json['uuid'] ?? '',
      label: json['label'] ?? '',
      displayOrder: json['display_order'] ?? 0,
    );
  }
}

/// Response model for payment grades API
class PaymentGradesResponse {
  final String message;
  final bool success;
  final PaymentGradesData data;

  PaymentGradesResponse({
    required this.message,
    required this.success,
    required this.data,
  });

  factory PaymentGradesResponse.fromJson(Map<String, dynamic> json) {
    // The API returns {"data": {...}} without message/success fields
    // So we need to handle both cases
    PaymentGradesData data;

    if (json['data'] is Map<String, dynamic>) {
      // This is the outer data object containing {data: [...], previous_level: {...}}
      data = PaymentGradesData.fromJson(json['data'] as Map<String, dynamic>);
    } else if (json['data'] is List) {
      // Direct list of payment grades
      final dataList = (json['data'] as List)
          .where((e) => e is Map<String, dynamic>)
          .map((e) => PaymentGradeModel.fromJson(e as Map<String, dynamic>))
          .toList();
      data = PaymentGradesData(data: dataList);
    } else {
      data = PaymentGradesData(data: []);
    }

    return PaymentGradesResponse(
      message: json['message']?.toString() ?? '',
      success: json['success'] ?? true, // Default to true if not present
      data: data,
    );
  }
}

/// Data container for payment grades
class PaymentGradesData {
  final List<PaymentGradeModel> data;
  final PaymentGradeModel? previousLevel;

  PaymentGradesData({
    required this.data,
    this.previousLevel,
  });

  factory PaymentGradesData.fromJson(Map<String, dynamic> json) {
    // Handle data array
    List<PaymentGradeModel> dataList = [];
    if (json['data'] is List) {
      dataList = (json['data'] as List)
          .where((e) => e is Map<String, dynamic>)
          .map((e) => PaymentGradeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // Handle previousLevel
    PaymentGradeModel? prevLevel;
    if (json['previous_level'] is Map<String, dynamic>) {
      prevLevel = PaymentGradeModel.fromJson(
          json['previous_level'] as Map<String, dynamic>);
    }

    return PaymentGradesData(
      data: dataList,
      previousLevel: prevLevel,
    );
  }
}
