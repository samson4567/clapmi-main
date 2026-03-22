class BaseResponse {
  String success;
  String message;
  dynamic data;
  String? nextClaim;

  BaseResponse(
      {required this.success,
      required this.message,
      required this.data,
      this.nextClaim});

  factory BaseResponse.fromJson(Map<String, dynamic>? json) {
    String status = json?['success'] is bool
        ? (json?['success'] ? 'true' : 'false')
        : json?['success'].toString() ?? "false";
    return BaseResponse(
      success: status,
      message: json?['message'] ?? "",
      data: json?['data'],
      nextClaim: json?['next_claim'],
    );
  }
}
