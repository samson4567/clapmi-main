// import 'dart:convert';

// import 'package:clapmi/features/rewards/data/models/referrer_qr_code_data.dart';

// /// Represents the response from the get referrer QR code endpoint.
// class ReferrerQrCodeResponse {
//   final bool success;
//   final String message;
//   final ReferrerQrCodeData data;

//   ReferrerQrCodeResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//   });

//   factory ReferrerQrCodeResponse.fromMap(Map<String, dynamic> map) {
//     return ReferrerQrCodeResponse(
//       success: map['success'] ?? false,
//       message: map['message'] ?? '',
//       data: ReferrerQrCodeData.fromMap(map['data'] as Map<String, dynamic>),
//     );
//   }

//   factory ReferrerQrCodeResponse.fromJson(String source) =>
//       ReferrerQrCodeResponse.fromMap(
//           json.decode(source) as Map<String, dynamic>);

//   Map<String, dynamic> toMap() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data.toMap(),
//     };
//   }

//   String toJson() => json.encode(toMap());
// }
