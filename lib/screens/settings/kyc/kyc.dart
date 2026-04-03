import 'package:clapmi/features/wallet/data/models/kyc_upload_model.dart';
import 'package:clapmi/features/wallet/domain/entities/get_user_kyc_status_response_entity.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:clapmi/screens/settings/kyc/kyc_process.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

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
  String? _documentPath;
  String? _documentType;
  String? _documentName;
  bool _isVerified = false;
  bool _hasAttemptedInitiate = false;
  String? _kycStatus;
  String? _kycReason;
  String? _kycLevel;
  int? _submissionAttempt;
  bool _isInitialStatusLoading = true;

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
    context.read<WalletBloc>().add(const GetUserKYCStatusEvent());
  }

  bool get _personalDetailsFilled =>
      _fullNameController.text.trim().isNotEmpty &&
      _idNumberController.text.trim().isNotEmpty &&
      _dobController.text.trim().isNotEmpty;

  void _maybeInitiateKyc({
    required bool exists,
    required bool hasVerificationUuid,
    required bool isVerified,
  }) {
    if (_hasAttemptedInitiate || isVerified || exists || hasVerificationUuid) {
      return;
    }
    _hasAttemptedInitiate = true;
    context.read<WalletBloc>().add(const KycInitiateEvent());
  }

  void _applyKycStatus(GetUserKycStatusResponseEntity kycData) {
    final hasVerificationUuid =
        kycData.verificationUuid != null && kycData.verificationUuid!.isNotEmpty;
    final exists = kycData.exists == true;
    final verified = kycData.isVerified == true;

    setState(() {
      _verificationUuid = hasVerificationUuid
          ? kycData.verificationUuid
          : _verificationUuid;
      _isVerified = verified;
      _isKycInitiated = verified || exists || hasVerificationUuid;
      _kycStatus = kycData.status;
      _kycReason = kycData.reason;
      _kycLevel = kycData.level;
      _submissionAttempt = kycData.submissionAttempt;
      if (verified) {
        _photoTaken = true;
        _documentUploaded = true;
        _livenessCheckPassed = 1;
      }
    });

    _maybeInitiateKyc(
      exists: exists,
      hasVerificationUuid: hasVerificationUuid,
      isVerified: verified,
    );
  }

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
        if (result is Map<String, dynamic>) {
          setState(() {
            _documentUploaded = true;
            _selectedIdType = result['idType']?.toString();
            _documentPath = result['documentPath']?.toString();
            _documentType = result['documentType']?.toString();
            _documentName = result['fileName']?.toString();
          });
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
    if (_verificationUuid == null || _verificationUuid!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('KYC session is not ready yet. Please try again.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_livenessCheckPassed != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete the face verification step first.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if ((_documentPath ?? '').isEmpty || (_documentType ?? '').isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload a valid ID document first.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context.read<WalletBloc>().add(
          KycUploadEvent(
            params: KycUploadParams(
              fullName: _fullNameController.text.trim(),
              idNumber: _idNumberController.text.trim(),
              dateOfBirth: _dobController.text.trim(),
              verificationUuid: _verificationUuid!,
              documentType: _documentType!,
              document: _documentPath!,
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
      _selectedIdType != null &&
      _livenessCheckPassed == 1 &&
      (_documentPath ?? '').isNotEmpty &&
      !_isVerified;

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

  Widget _buildStatusBanner() {
    final isRejected = (_kycStatus?.toLowerCase() ?? '') == 'rejected';
    final isVerifiedBanner = _isVerified;
    final backgroundColor = isVerifiedBanner
        ? const Color(0xFF0F291B)
        : isRejected
            ? const Color(0xFF2A1616)
            : const Color(0xFF2A1F00);
    final accentColor = isVerifiedBanner
        ? const Color(0xFF2ECC71)
        : isRejected
            ? const Color(0xFFFF6B6B)
            : const Color(0xFFFFB020);
    final icon = isVerifiedBanner
        ? Icons.check_circle
        : isRejected
            ? Icons.error
            : Icons.access_time;
    final title = isVerifiedBanner
        ? 'Verified'
        : isRejected
            ? 'Rejected'
            : 'Pending';
    final description = isVerifiedBanner
        ? (_kycLevel?.isNotEmpty == true
            ? 'Your KYC is verified at level $_kycLevel.'
            : 'Your KYC is verified and ready to use.')
        : isRejected
            ? (_kycReason?.isNotEmpty == true
                ? _kycReason!
                : 'Your previous KYC submission was rejected. Please review your details and upload again.')
            : (_documentUploaded
                ? 'Your details are ready. Submit KYC to send for review.'
                : 'KYC initiated. Please upload your photo and documents.');
    final metaText = _submissionAttempt != null && _submissionAttempt! > 0
        ? 'Attempt ${_submissionAttempt!}'
        : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(
                    color: accentColor.withOpacity(0.85),
                    fontSize: 13,
                  ),
                ),
                if (metaText != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    metaText,
                    style: TextStyle(
                      color: accentColor.withOpacity(0.72),
                      fontSize: 12,
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
            if (_isInitialStatusLoading) {
              setState(() => _isInitialStatusLoading = false);
            }
            final msg = state.message.toLowerCase();
            if (msg.contains('pending kyc') ||
                msg.contains('already have a pending')) {
              setState(() => _isKycInitiated = true);
              context.read<WalletBloc>().add(const GetUserKYCStatusEvent());
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          }
          if (state is GetUserKYCStatusSuccessState) {
            if (_isInitialStatusLoading) {
              setState(() => _isInitialStatusLoading = false);
            }
            _applyKycStatus(state.theGetUserKycStatusResponseEntity);
          }
          if (state is KycInitiateSuccess) {
            setState(() {
              _verificationUuid = state.data.verificationUuid;
              _isKycInitiated = true;
              _kycStatus = state.data.status;
              _submissionAttempt = state.data.submissionAttempt;
            });
          }
          if (state is KycUploadSuccess) {
            setState(() {
              _isKycInitiated = true;
              _kycStatus = state.data.status;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.data.status.toLowerCase() == 'verified'
                      ? 'KYC verified successfully!'
                      : 'KYC submitted successfully!',
                ),
                backgroundColor: Colors.green,
              ),
            );
            context.read<WalletBloc>().add(const GetUserKYCStatusEvent());
          }
        },
        builder: (context, state) {
          if (_isInitialStatusLoading &&
              state is GetUserKYCStatusLoadingState) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: _buildKycLoadingShimmer(),
                ),
              ),
            );
          }

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
                          if (_isVerified ||
                              (_kycStatus?.toLowerCase() == 'rejected') ||
                              _isKycInitiated) ...[
                            _buildStatusBanner(),
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
                                            ? (_documentName?.isNotEmpty == true
                                                ? _documentName!
                                                : "Document Uploaded ✓")
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

  Widget _buildKycLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1E1E1E),
      highlightColor: const Color(0xFF2A2A2A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          _shimmerBox(height: 24.h, width: 180.w, radius: 8),
          SizedBox(height: 18.h),
          _shimmerBox(height: 16.h, width: 220.w, radius: 8),
          SizedBox(height: 18.h),
          _shimmerCard(height: 108.h),
          SizedBox(height: 24.h),
          _shimmerBox(height: 16.h, width: 120.w, radius: 8),
          SizedBox(height: 12.h),
          _shimmerField(),
          SizedBox(height: 14.h),
          _shimmerField(),
          SizedBox(height: 14.h),
          _shimmerField(),
          SizedBox(height: 24.h),
          _shimmerBox(height: 16.h, width: 140.w, radius: 8),
          SizedBox(height: 12.h),
          _shimmerCard(height: 96.h),
          SizedBox(height: 24.h),
          _shimmerBox(height: 16.h, width: 190.w, radius: 8),
          SizedBox(height: 12.h),
          _shimmerCard(height: 56.h),
          SizedBox(height: 30.h),
          _shimmerBox(height: 55.h, width: double.infinity, radius: 40),
          SizedBox(height: 24.h),
          _shimmerBox(height: 10.h, width: 260.w, radius: 6),
          SizedBox(height: 6.h),
          _shimmerBox(height: 10.h, width: 220.w, radius: 6),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _shimmerField() {
    return _shimmerBox(
      height: 56.h,
      width: double.infinity,
      radius: 12,
    );
  }

  Widget _shimmerCard({required double height}) {
    return _shimmerBox(
      height: height,
      width: double.infinity,
      radius: 16,
    );
  }

  Widget _shimmerBox({
    required double height,
    required double width,
    required double radius,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
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
