import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_event.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountUpdatePage extends StatefulWidget {
  const AccountUpdatePage({super.key});

  @override
  AccountUpdatePageState createState() => AccountUpdatePageState();
}

class AccountUpdatePageState extends State<AccountUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _religionController = TextEditingController();

  String? _country;
  String _countryCode = '+234';

  final List<String> _countries = [
    'Nigeria',
    'United States',
    'India',
    'United Kingdom'
  ];
  final List<String> _countryCodes = ['+234', '+1', '+91', '+44'];

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  bool _isValidNumber(String number) {
    if (number.length > 10) {
      number = number.replaceRange(0, 1, "");
    }
    if (number.length != 10) return false;
    if (number.length == 10) {
      number = _countryCode + number;
    }
    _phoneController.text = number;
    return true;
  }

  setControllersInitials() {
    _usernameController.text = profileModelG?.username ?? '';
    _cityController.text = profileModelG?.state ?? '';
    _emailController.text = profileModelG?.email ?? '';
    _phoneController.text = profileModelG?.mobile ?? '';
    if (_countries.contains(profileModelG?.country)) {
      _country = profileModelG?.country ?? '';
    } else {
      _country = null;
    }
  }

  @override
  initState() {
    setControllersInitials();
    super.initState();
  }

  updateUser() {
    Map? otherUserDetail = {
      'username': _usernameController.text.trim(),
      'email': _emailController.text.trim(),
      "mobile": _phoneController.text.trim(),
      "religion": _religionController.text.trim(),
      "city": _cityController.text.trim(),
      "country": _country,
    };
    if (otherUserDetail.values
        .fold<String>("", (previousValue, element) => previousValue + element)
        .isEmpty) {
      otherUserDetail = null;
      return;
    }

    context
        .read<UserBloc>()
        .add(UserDetailUpdateEvent(userDetail: otherUserDetail));
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
        title: const Text('Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Update your personal details like name, bio, and contact info',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: Color(0xFF8C8C8C),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tell us about you',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    color: Colors.white),
              ),
              SizedBox(height: 10.h),

              /// Username
              const Text(
                'Username',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: Color(0xFF8C8C8C),
                ),
              ),
              SizedBox(height: 10.h),
              CustomTextField(
                backgroundColor: AppColors.secondaryColor,
                hintText: 'Username',
                controller: _usernameController,
                boxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF3D3D3D)),
                ),
              ),
              const SizedBox(height: 16),

              /// Country & State
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Country',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            color: Color(0xFF8C8C8C),
                          ),
                        ),
                        const SizedBox(height: 5),
                        CustomTextField<String>(
                          backgroundColor: AppColors.secondaryColor,
                          hintText: "Select Country",
                          isDropdown: true,
                          dropdownValue: _country,
                          dropdownItems: _countries,
                          onDropdownChanged: (value) =>
                              setState(() => _country = value!),
                          boxDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF3D3D3D),
                            ),
                          ),
                          hintTextColor: Colors.white,
                          textStyle: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'State',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            color: Color(0xFF8C8C8C),
                          ),
                        ),
                        const SizedBox(height: 5),
                        CustomTextField(
                          backgroundColor: AppColors.secondaryColor,
                          hintText: 'City',
                          controller: _cityController,
                          boxDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF3D3D3D)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14.h),

              /// Religion
              const Text(
                'Religion',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: Color(0xFF8C8C8C),
                ),
              ),
              SizedBox(height: 14.h),
              CustomTextField(
                backgroundColor: AppColors.secondaryColor,
                hintText: 'Religion',
                controller: _religionController,
                onChanged: (value) {},
                boxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF3D3D3D)),
                ),
              ),

              SizedBox(height: 14.h),

              /// Email
              const Text(
                'Email',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: Color(0xFF8C8C8C),
                ),
              ),
              SizedBox(height: 14.h),
              CustomTextField(
                backgroundColor: AppColors.secondaryColor,
                hintText: 'Email',
                controller: _emailController,
                validator: (value) =>
                    _isValidEmail(value ?? '') ? null : "Enter a valid email",
                onChanged: (value) {},
                boxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF3D3D3D)),
                ),
              ),

              SizedBox(height: 14.h),

              /// Phone Number
              const Text(
                'Phone Number',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: Color(0xFF8C8C8C),
                ),
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  /// FIX: Wrap dropdown in Expanded to prevent overflow
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF3D3D3D)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _countryCode,
                          items: _countryCodes
                              .map((code) => DropdownMenuItem(
                                  value: code,
                                  child: Text(
                                    code,
                                    style: const TextStyle(color: Colors.white),
                                  )))
                              .toList(),
                          dropdownColor: AppColors.secondaryColor,
                          onChanged: (value) =>
                              setState(() => _countryCode = value!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 7,
                    child: CustomTextField(
                      backgroundColor: AppColors.secondaryColor,
                      hintText: 'Phone Number',
                      controller: _phoneController,
                      onChanged: (value) {},
                      boxDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF3D3D3D)),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 70.h),

              BlocConsumer<UserBloc, UserState>(
                listener: (context, state) {
                  if (state is UserDetailUpdateSuccessState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      generalSnackBar("User updated successfully"),
                    );
                  }
                  if (state is UserDetailUpdateErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      generalSnackBar(state.errorMessage),
                    );
                  }
                },
                builder: (context, state) {
                  return PillButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _isValidNumber(_phoneController.text)) {
                        updateUser();
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(generalErrorSnackBar("Form error"));
                      }
                    },
                    height: 50,
                    child: (state is UserDetailUpdateLoadingState)
                        ? const Center(
                            child: AspectRatio(
                                aspectRatio: 1,
                                child: CircularProgressIndicator.adaptive(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )),
                          )
                        : const Text('Update Details'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
