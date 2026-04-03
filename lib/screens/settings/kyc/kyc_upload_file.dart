import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadKycFile extends StatefulWidget {
  final String idType;
  final String verificationUuid;
  final String fullName;
  final String idNumber;
  final String dateOfBirth;

  const UploadKycFile({
    super.key,
    required this.idType,
    required this.verificationUuid,
    required this.fullName,
    required this.idNumber,
    required this.dateOfBirth,
  });

  @override
  State<UploadKycFile> createState() => _UploadKycFileState();
}

class _UploadKycFileState extends State<UploadKycFile> {
  PlatformFile? _selectedFile;

  /// Map file extension to a valid document_type accepted by the API.
  /// The API only accepts: image (jpg/jpeg/png) or pdf.
  String _resolveDocumentType(String? extension) {
    final ext = (extension ?? '').toLowerCase();
    if (ext == 'pdf') return 'pdf';
    return 'image'; // jpg, jpeg, png all map to "image"
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _selectedFile = result.files.first);
    }
  }

  void _onSave() {
    // Validate verificationUuid
    if (widget.verificationUuid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Verification UUID is missing. Please start KYC process again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedFile == null) return;

    final filePath = _selectedFile!.path ?? '';
    if (filePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not read file path. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate file extension
    final extension = (_selectedFile!.extension ?? '').toLowerCase();
    if (!['jpg', 'jpeg', 'png', 'pdf'].contains(extension)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid file format. Please select JPG, PNG or PDF.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pop(context, {
      'idType': widget.idType,
      'documentPath': filePath,
      'documentType': _resolveDocumentType(_selectedFile!.extension),
      'fileName': _selectedFile!.name,
    });
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'KYC',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10.h),
            const Text(
              'Upload your document',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Attach Document',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 10),
            _UploadBox(
              file: _selectedFile,
              onTap: _pickFile,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedFile != null
                      ? const Color(0xFF1463F3)
                      : Colors.grey.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _selectedFile != null ? _onSave : null,
                child: const Text(
                  'Use this document',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  final PlatformFile? file;
  final VoidCallback onTap;

  const _UploadBox({required this.file, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasFile = file != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF3D3D3D),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade700,
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasFile
                        ? file!.name
                        : 'Attach a file, image or PDF for evidence',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: hasFile ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Accepted files: JPEG, PNG and PDF\nFile limit: 3mb',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            hasFile
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1463F3),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: onTap,
                    child: const Text(
                      'Change file',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
          ],
        ),
      ),
    );
  }
}
