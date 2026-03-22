class CustomResponseModel<T> {
  final bool isSuccessful;
  String message;
  final T? data;

  final Map? fullDetails;

  CustomResponseModel({
    required this.isSuccessful,
    required this.message,
    required this.data,
    required this.fullDetails,
  });

  CustomResponseModel copyWith({
    bool? isSuccessful,
    String? message,
    T? data,
  }) {
    return CustomResponseModel(
      isSuccessful: isSuccessful ?? this.isSuccessful,
      message: message ?? this.message,
      data: data ?? this.data,
      fullDetails: fullDetails ?? fullDetails,
    );
  }

  factory CustomResponseModel.fromjson(Map json) {
    return CustomResponseModel(
      isSuccessful: json['success'] ?? false,
      message: json['message'],
      data: json['data'],
      fullDetails: json,
    );
  }

  factory CustomResponseModel.dummy() {
    return CustomResponseModel<T>(
        isSuccessful: true,
        message: "dummy response is true",
        data: {"dumb": "totaly"} as T,
        fullDetails: {});
  }
  factory CustomResponseModel.error({required String message}) {
    return CustomResponseModel<T>(
        isSuccessful: false, message: message, data: null, fullDetails: {});
  }
  factory CustomResponseModel.success({required String message}) {
    return CustomResponseModel<T>(
        isSuccessful: true, message: message, data: null, fullDetails: {});
  }

  Map toMap() {
    return {
      "success": isSuccessful,
      "message": message,
      "data": data,
      "fullDetails": fullDetails
    };
  }

  @override
  String toString() {
    return "${super.toString()}>>> ${toMap()}";
  }
}
