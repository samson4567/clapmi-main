import 'package:clapmi/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(UpdatePasswordEvent(
            currentPassword: _currentPasswordController.text,
            newPassword: _newPasswordController.text,
            passwordConfirmation: _confirmPasswordController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Security'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Keep your data safe by controlling what users see',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: const Color(0xFF8C8C8C),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Change Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                  "Enter Current Password", _currentPasswordController),
              const SizedBox(height: 16),
              _buildPasswordField("Enter New Password", _newPasswordController),
              const SizedBox(height: 16),
              _buildPasswordField(
                  "Confirm New Password", _confirmPasswordController),
              const Spacer(),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is UpdatePasswordSuccessState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is UpdatePasswordErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is UpdatePasswordLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return PillButton(
                    onPressed: _updatePassword,
                    height: 50,
                    child: const Text('Update Password'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            fontSize: 15,
            color: const Color(0xFF8C8C8C),
          ),
        ),
        SizedBox(height: 10.h),
        CustomTextField(
          backgroundColor: AppColors.secondaryColor,
          hintText: label,
          hintStyle: const TextStyle(color: Colors.white),
          controller: controller,
          obscureText: true,
          boxDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF3D3D3D)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "This field is required";
            }
            if (controller == _newPasswordController && value.length < 6) {
              return "Password must be at least 6 characters";
            }
            if (controller == _confirmPasswordController &&
                value != _newPasswordController.text) {
              return "Passwords do not match";
            }
            return null;
          },
        ),
      ],
    );
  }
}
