// import 'dart:convert';

// /// Represents the data structure within the referrer QR code response.
// class ReferrerQrCodeData {
//   final String qrCode;

//   ReferrerQrCodeData({required this.qrCode});

//   factory ReferrerQrCodeData.fromMap(Map<String, dynamic> map) {
//     return ReferrerQrCodeData(
//       qrCode: map['qr_code'] ?? '',
//     );
//   }

//   factory ReferrerQrCodeData.fromJson(String source) =>
//       ReferrerQrCodeData.fromMap(json.decode(source) as Map<String, dynamic>);

//   Map<String, dynamic> toMap() {
//     return {
//       'qr_code': qrCode,
//     };
//   }

//   String toJson() => json.encode(toMap());
// }
