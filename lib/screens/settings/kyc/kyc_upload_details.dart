import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class UploadKyc extends StatefulWidget {
  final String verificationUuid;
  final String fullName;
  final String idNumber;
  final String dateOfBirth;

  const UploadKyc({
    super.key,
    required this.verificationUuid,
    required this.fullName,
    required this.idNumber,
    required this.dateOfBirth,
  });

  @override
  State<UploadKyc> createState() => _UploadKycState();
}

class _UploadKycState extends State<UploadKyc> {
  String? selectedKyc;

  final List<Map<String, String>> kycOptions = [
    {'label': 'NIN', 'value': 'nin'},
    {'label': 'International Passport', 'value': 'passport'},
    {'label': "Driver's License", 'value': 'drivers_license'},
    {'label': "Voter's Card", 'value': 'voters_card'},
  ];

  void _onIdTypeSelected(String? value) {
    if (value != null) {
      // Navigate to file upload screen
      context.push(
        MyAppRouteConstant.uploadkycfile,
        extra: {
          'idType': value,
          'verificationUuid': widget.verificationUuid,
          'fullName': widget.fullName,
          'idNumber': widget.idNumber,
          'dateOfBirth': widget.dateOfBirth,
        },
      ).then((result) {
        if (!mounted) return;
        if (result is Map<String, dynamic>) {
          Navigator.pop(context, result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'KYC',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add your personal details below',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 30),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 280,
                    height: 190,
                    child: CustomPaint(
                      painter: OuterCornerFramePainter(
                        color: Colors.grey.shade700,
                        strokeWidth: 2,
                        cornerLength: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child:
                        SvgPicture.asset('assets/icons/card2.svg', height: 160),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text("Select ID Type",
                style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF121313),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF2E2E2E)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: const Color(0xFF121313),
                  value: selectedKyc,
                  hint: const Text("Choose document",
                      style: TextStyle(color: Colors.white54)),
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.white70),
                  isExpanded: true,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  items: kycOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option['value'],
                      child: Text(option['label']!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedKyc = value);
                    _onIdTypeSelected(value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OuterCornerFramePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double cornerLength;

  OuterCornerFramePainter({
    required this.color,
    required this.strokeWidth,
    required this.cornerLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawLine(const Offset(0, 0), Offset(cornerLength, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(0, cornerLength), paint);
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width, cornerLength), paint);
    canvas.drawLine(
        Offset(0, size.height), Offset(0, size.height - cornerLength), paint);
    canvas.drawLine(
        Offset(0, size.height), Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(OuterCornerFramePainter oldDelegate) => false;
}
