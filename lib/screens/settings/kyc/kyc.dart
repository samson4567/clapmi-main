import 'package:clapmi/features/wallet/data/models/kyc_upload_model.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:clapmi/screens/settings/kyc/kyc_process.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class KycInputScreen extends StatefulWidget {
  const KycInputScreen({super.key});

  @override
  State<KycInputScreen> createState() => _KycInputScreenState();
}

class _KycInputScreenState extends State<KycInputScreen> {
  bool _photoTaken = false;
  bool _documentUploaded = false;
  int _livenessCheckPassed = 0;
  String? _verificationUuid;

  // Shows the pending banner when KycInitiateSuccess fires
  bool _isKycInitiated = false;

  // Selected document type (NIN, passport, etc.)
  String? _selectedIdType;

  // Personal detail controllers
  final _fullNameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _dobController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _idNumberController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>()
      ..add(const GetUserKYCStatusEvent())
      ..add(const KycInitiateEvent());
  }

  bool get _personalDetailsFilled =>
      _fullNameController.text.trim().isNotEmpty &&
      _idNumberController.text.trim().isNotEmpty &&
      _dobController.text.trim().isNotEmpty;

  void _onDocumentTap(BuildContext context) {
    // Check if KYC has been initiated (verificationUuid is available)
    if (_verificationUuid == null || _verificationUuid!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please wait for KYC to initialize. If this persists, please restart the process.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!_photoTaken) {
      _showPhotoFirstDialog(context);
    } else {
      context.push(
        MyAppRouteConstant.uploadkyc,
        extra: {
          'verificationUuid': _verificationUuid ?? '',
          'fullName': _fullNameController.text.trim(),
          'idNumber': _idNumberController.text.trim(),
          'dateOfBirth': _dobController.text.trim(),
          'idType': _selectedIdType ?? '',
        },
      ).then((result) {
        // When user comes back from UploadKycFile, mark document as uploaded
        // Also capture the idType if returned from UploadKyc
        if (result != null && result is String) {
          setState(() {
            _documentUploaded = true;
            _selectedIdType = result;
          });
        } else if (result == true) {
          setState(() => _documentUploaded = true);
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1976D2),
              onPrimary: Colors.white,
              surface: Color(0xFF1A1A1A),
              onSurface: Colors.white,
            ),
            dialogTheme:
                DialogThemeData(backgroundColor: const Color(0xFF1A1A1A)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _showPhotoFirstDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                child: const Center(
                  child: Text('!',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28)),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Photo Required First',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text(
                'Please upload your photo first before adding documents.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK, Got it',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmitKyc(BuildContext context) {
    if (_verificationUuid == null) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<WalletBloc>().add(
          KycUploadEvent(
            params: KycUploadParams(
              fullName: _fullNameController.text.trim(),
              idNumber: _idNumberController.text.trim(),
              dateOfBirth: _dobController.text.trim(),
              verificationUuid: _verificationUuid!,
              documentType: 'image',
              document: '',
              idType: _selectedIdType ?? '',
              livenessCheckPassed: _livenessCheckPassed,
            ),
          ),
        );
  }

  bool get _canSubmit =>
      _photoTaken &&
      _documentUploaded &&
      _personalDetailsFilled &&
      _selectedIdType != null;

  InputDecoration _fieldDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFF1A1A1A),
      suffixIcon: icon != null ? Icon(icon, color: Colors.white38) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade800),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade800),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF1976D2)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  /// Pending banner — matches the screenshot design exactly
  Widget _buildPendingBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1F00),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFB020).withOpacity(0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFFFFB020),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.access_time, size: 16, color: Colors.black),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pending',
                  style: TextStyle(
                    color: Color(0xFFFFB020),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'KYC initiated. Please upload your photo and documents.',
                  style: TextStyle(
                    color: Color(0xFFFFD699),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is WalletError) {
            final msg = state.message.toLowerCase();
            if (msg.contains('pending kyc') ||
                msg.contains('already have a pending')) {
              // When there's already a pending KYC, try to get verificationUuid from status
              setState(() => _isKycInitiated = true);
              // Re-fetch KYC status to get the verificationUuid
              context.read<WalletBloc>().add(const GetUserKYCStatusEvent());
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          }
          if (state is GetUserKYCStatusSuccessState) {
            final kycData = state.theGetUserKycStatusResponseEntity;
            if (kycData.isVerified == true) {
              setState(() => _photoTaken = true);
            }
            // If verificationUuid is available from the status response, use it
            if (kycData.verificationUuid != null &&
                kycData.verificationUuid!.isNotEmpty) {
              setState(() {
                _verificationUuid = kycData.verificationUuid;
                _isKycInitiated = true;
              });
            }
          }
          if (state is KycInitiateSuccess) {
            setState(() {
              _verificationUuid = state.data.verificationUuid;
              // Show the pending banner whenever initiate succeeds
              _isKycInitiated = true;
            });
          }
          if (state is KycUploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('KYC submitted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading =
              state is WalletLoading || state is GetUserKYCStatusLoadingState;

          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h),

                          // ── Pending banner (shows after KycInitiateSuccess) ──
                          if (_isKycInitiated) ...[
                            _buildPendingBanner(),
                            SizedBox(height: 20.h),
                          ],

                          Text(
                            "KYC Verification",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            "Complete your identity verification",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 14.sp),
                          ),
                          SizedBox(height: 12.h),

                          /// Upload Documents Info Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0F1C2E), Color(0xFF16273F)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E3A5F),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.upload_file,
                                      color: Color(0xFF5DA9FF), size: 28),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Upload Documents",
                                          style: TextStyle(
                                              color: Color(0xFF5DA9FF),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600)),
                                      SizedBox(height: 6),
                                      Text(
                                        "Please upload your documents and click submit to complete your KYC.",
                                        style: TextStyle(
                                            color: Color(0xFF8FB3E8),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // ── Personal Details Section ──────────────────────
                          Text(
                            "Personal Details",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 12.h),

                          /// Full Name
                          TextFormField(
                            controller: _fullNameController,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                            textCapitalization: TextCapitalization.words,
                            decoration: _fieldDecoration('Full Name'),
                            onChanged: (_) => setState(() {}),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Full name is required'
                                : null,
                          ),
                          SizedBox(height: 14.h),

                          /// ID Number
                          TextFormField(
                            controller: _idNumberController,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                            decoration: _fieldDecoration('ID Number').copyWith(
                              hintText:
                                  'Enter the idnumber on the document to add',
                              hintStyle: const TextStyle(
                                  color: Colors.white24, fontSize: 13),
                            ),
                            onChanged: (_) => setState(() {}),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'ID number is required'
                                : null,
                          ),
                          SizedBox(height: 14.h),

                          /// Date of Birth
                          TextFormField(
                            controller: _dobController,
                            readOnly: true,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                            decoration: _fieldDecoration(
                                'Date of Birth (YYYY-MM-DD)',
                                icon: Icons.calendar_today),
                            onTap: () => _selectDate(context),
                            onChanged: (_) => setState(() {}),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Date of birth is required'
                                : null,
                          ),

                          SizedBox(height: 24.h),

                          // ── Take Photo Section ────────────────────────────
                          Text(
                            "Selfie Verification",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 12.h),

                          /// Take Photo Card
                          GestureDetector(
                            onTap: () async {
                              // Validate personal details before allowing photo
                              if (!_personalDetailsFilled) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please fill in your personal details first.'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                                return;
                              }
                              final result = await context.push(
                                  MyAppRouteConstant.kycFaceProcessWidget);
                              if (result is KycFaceResult &&
                                  result.livenessCheckPassed) {
                                setState(() {
                                  _photoTaken = true;
                                  _livenessCheckPassed = 1;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 18),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _photoTaken
                                      ? Colors.green.withOpacity(0.5)
                                      : Colors.white.withOpacity(0.15),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 64,
                                    width: 64,
                                    decoration: BoxDecoration(
                                      color: _photoTaken
                                          ? const Color(0xFF0A3C1F)
                                          : const Color(0xFF0A1F3C),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      _photoTaken
                                          ? Icons.check_circle
                                          : Icons.camera_alt,
                                      color: _photoTaken
                                          ? Colors.green
                                          : const Color(0xFF2F80ED),
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _photoTaken
                                              ? "Photo Taken ✓"
                                              : "Take a Photo",
                                          style: TextStyle(
                                            color: _photoTaken
                                                ? Colors.green
                                                : Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          _photoTaken
                                              ? "Selfie captured successfully"
                                              : "Capture a selfie for verification",
                                          style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right,
                                      color: Colors.white70),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 24.h),

                          Text(
                            "NIN or International Passport",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 12.h),

                          /// Add Document Tile
                          GestureDetector(
                            onTap: () => _onDocumentTap(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 16.h),
                              decoration: BoxDecoration(
                                color: _documentUploaded
                                    ? const Color(0xFF0A3C1F)
                                    : const Color(0xFF1A1A1A),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: _documentUploaded
                                      ? Colors.green.withOpacity(0.5)
                                      : Colors.grey.shade800,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      if (_documentUploaded)
                                        const Padding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Icon(Icons.check_circle,
                                              color: Colors.green, size: 18),
                                        ),
                                      Text(
                                        _documentUploaded
                                            ? "Document Uploaded ✓"
                                            : "Add your document",
                                        style: TextStyle(
                                          color: _documentUploaded
                                              ? Colors.green
                                              : Colors.white,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.arrow_forward_ios,
                                      color: Colors.white, size: 16),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 30.h),

                          /// Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 55.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _canSubmit
                                    ? const Color(0xFF1976D2)
                                    : Colors.grey.shade800,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                              ),
                              onPressed: (isLoading || !_canSubmit)
                                  ? null
                                  : () => _onSubmitKyc(context),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
                                      'Submit KYC',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                            ),
                          ),

                          SizedBox(height: 30.h),
                          const Text(
                            textAlign: TextAlign.center,
                            'Your information is secure and will only be used for verification purposes.',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class KycDocumentTypeScreen extends StatelessWidget {
  const KycDocumentTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "KYC",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "Add your personal details below",
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 40.h),
            Center(
              child: Container(
                height: 160.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.credit_card_rounded,
                    color: Colors.white.withOpacity(0.7),
                    size: 64.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            _buildDocTile(context, "NINC", () {}),
            SizedBox(height: 16.h),
            _buildDocTile(context, "International Passport", () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildDocTile(BuildContext context, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 15.sp,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}
