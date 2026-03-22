// import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
// import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
// import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
// import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
// import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
// import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gap/gap.dart';
// import 'package:go_router/go_router.dart';
// import 'package:pinput/pinput.dart';

// class WalletEmailVerification extends StatefulWidget {
//   const WalletEmailVerification({
//     super.key,
//     required this.isEnterOtp,
//     required this.isFiatWithdrawal,
//     this.orderId,
//     this.amount,
//     this.address,
//     this.network,
//   });
//   final bool isEnterOtp;
//   final bool isFiatWithdrawal;
//   final String? orderId;
//   final String? amount;
//   final String? address;
//   final String? network;

//   @override
//   State<WalletEmailVerification> createState() =>
//       _WalletEmailVerificationState();
// }

// class _WalletEmailVerificationState extends State<WalletEmailVerification> {
//   @override
//   void initState() {
//     if (widget.isEnterOtp) {
//       context.read<WalletBloc>().add(Send2FACodeEvent());
//     }
//     super.initState();
//   }

//   bool isLoading = false;
//   String otpCode = '';

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<WalletBloc, WalletState>(
//       listener: (context, state) {
//         if (state is WalletError) {
//           setState(() {
//             isLoading = false;
//           });
//         }
//         if (state is WalletLoading) {
//           setState(() {
//             isLoading = true;
//           });
//         }
//         if (state is FAAuthCodeSent) {
//           setState(() {
//             isLoading = false;
//           });
//         }
//         if (state is VerifiedCodeSent) {
//           ScaffoldMessenger.of(context)
//               .showSnackBar(SnackBar(content: Text(state.message)));
//           if (widget.isEnterOtp) {
//             if (widget.isFiatWithdrawal) {
//               context.push(MyAppRouteConstant.fiatWithdrawal);
//             } else {
//               context.push(MyAppRouteConstant.withdrawal);
//               context.push(MyAppRouteConstant.usdcWithdrawal);
//             }
//           } else {
//             //FOR FIAT WITHDRAWAL
//             if (widget.orderId != null && widget.orderId?.isNotEmpty == true) {
//               context.push(MyAppRouteConstant.withdrawalPin, extra: {
//                 "isEnterPin": false,
//                 "orderId": widget.orderId,
//               });
//             } else {
//               //THIS WILL BE FOR CRYPTO WITHDRAWAL
//               context.push(MyAppRouteConstant.withdrawalPin, extra: {
//                 "isEnterPin": false,
//                 "amount": widget.amount,
//                 "network": widget.network,
//                 "address": widget.address,
//               });
//             }
//           }
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           resizeToAvoidBottomInset: true,
//           body: LayoutBuilder(builder: (context, layout) {
//             if (isLoading) {
//               return Center(child: CircularProgressIndicator.adaptive());
//             }
//             return SingleChildScrollView(
//               child: IntrinsicHeight(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(minHeight: layout.maxHeight),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 32.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Gap(MediaQuery.paddingOf(context).top + 16),
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: InkWell(
//                             onTap: Navigator.of(context).pop,
//                             child: const Icon(Icons.arrow_back_ios),
//                           ),
//                         ),
//                         const Gap(8),
//                         widget.isEnterOtp
//                             ? Text(
//                                 'Enter OTP',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .displayLarge
//                                     ?.copyWith(
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 20,
//                                     ),
//                               )
//                             : Text(
//                                 'Email Verification',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .displayLarge
//                                     ?.copyWith(
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 20,
//                                     ),
//                               ),
//                         const Gap(16),
//                         widget.isEnterOtp
//                             ? Text(
//                                 'An OTP has been sent to your email address',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyLarge
//                                     ?.copyWith(
//                                       color: Colors.white.withOpacity(.5),
//                                     ),
//                                 textAlign: TextAlign.center,
//                               )
//                             : Text(
//                                 'A confirmation code has been sent to your email',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyLarge
//                                     ?.copyWith(
//                                       color: Colors.white.withOpacity(.5),
//                                     ),
//                                 textAlign: TextAlign.center,
//                               ),
//                         const Gap(32),
//                         Image.asset(
//                           'assets/images/message.png',
//                           height: 200,
//                           width: 200,
//                         ),
//                         const Gap(16),
//                         Text(
//                           'Input 6-digits code we sent to your email',
//                           style: Theme.of(context).textTheme.bodyLarge,
//                           textAlign: TextAlign.center,
//                         ),
//                         const Gap(16),
//                         Pinput(
//                           length: 6,
//                           onChanged: (value) {
//                             setState(() {
//                               otpCode = value;
//                             });
//                           },
//                         ),
//                         const Gap(20),
//                         const Spacer(),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: PillButton(
//                                 backgroundColor: AppColors.greyColor,
//                                 onTap: Navigator.of(context).pop,
//                                 child: Text(
//                                   'Back',
//                                   style: Theme.of(context).textTheme.bodyLarge,
//                                 ),
//                               ),
//                             ),
//                             const Gap(16),
//                             Expanded(
//                               child: PillButton(
//                                 onTap: () {
//                                   print(
//                                       "This is the code about to be sent $otpCode");
//                                   context
//                                       .read<WalletBloc>()
//                                       .add(Verify2FACodeEvent(otpCode));
//                                 },
//                                 child: Text(
//                                   'Continue',
//                                   style: Theme.of(context).textTheme.bodyLarge,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Gap(MediaQuery.paddingOf(context).bottom + 16),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }),
//         );
//       },
//     );
//   }
// }
