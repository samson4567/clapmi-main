// import 'package:clapmi/features/rewards/bloc/reward_event.dart';
// import 'package:clapmi/global_object_folder_jacket/global_object.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:skeletonizer/skeletonizer.dart';

// import '../../features/rewards/bloc/reward_bloc.dart';
// import '../../features/rewards/bloc/reward_state.dart';

// class Reward extends StatefulWidget {
//   const Reward({super.key});

//   @override
//   State<Reward> createState() => _RewardState();
// }

// String balance = '0 \$CAP';

// class _RewardState extends State<Reward> {
//   // Sample list of RewardItem objects
//   final List<RewardItem> rewardItems = [
//     RewardItem(
//       imageAsset: 'assets/images/people.png',
//       title: 'Invite a Friend',
//       subtitle: 'status: 4 invites',
//       showCopyIcon: true, // Special flag for "Invite a Friend"
//     ),
//     RewardItem(
//       imageAsset: 'assets/images/brag.png',
//       title: 'Host a Brag',
//       subtitle: 'status: 2 brags hosted.',
//       showCopyIcon:
//           false, // Special flag for "Host a Brag" to show "Go to Brags"
//     ),
//     RewardItem(
//       imageAsset: 'assets/images/people.png',
//       title: 'Join Our Telegram \n Community',
//       subtitle: 'status:Not yet join.',
//       showCopyIcon:
//           false, // Special flag for "Send 4 Invites" to show "Join Telegram"
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<RewardBloc>().add(ClaimDailyRewardEvent());
//       context.read<RewardBloc>().add(RewardHistoryEvent());
//       context.read<RewardBloc>().add(RewardBalanceEvent());
//       // context.read<RewardBloc>().add(WithdrawalEvent());
//       // context.read<RewardBloc>().add(ClaimReferralRewardEvent());
//       // context.read<RewardBloc>().add(LeaderboardEvent());
//       context.read<RewardBloc>().add(ReferrerQrCodeEvent());
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<RewardBloc, RewardState>(listener: (context, state) {
//       if (state is ClaimDailyRewardSuccessState) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(state.response.message)),
//         );
//         //* Once daily reward is successful, reload the balance
//         context.read<RewardBloc>().add(RewardBalanceEvent());
//       } else if (state is ClaimDailyRewardErrorState) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(state.errorMessage)),
//         );
//       }
//     }, builder: (context, state) {
//       return Scaffold(
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 10),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Icon(Icons.arrow_back_ios_new)),
//                     Text(
//                       ' Reward',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 35.h,
//                 ),
//                 Image.asset(
//                   'assets/images/hand.png',
//                 ),
//                 Image.asset('assets/images/airdrop.png'),
//                 const CustomText(
//                   text: '\$CAP',
//                   style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.blue,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Geist'),
//                 ),
//                 const CustomText(
//                   text: 'Clapcoin Airdrop is Live',
//                   style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Geist'),
//                 ),
//                 const CustomText(
//                   text: 'Connect Wallet to Claim Your \$cap',
//                   style: TextStyle(
//                       fontSize: 10, color: Colors.white, fontFamily: 'Geist'),
//                 ),
//                 SizedBox(
//                   height: 30.h,
//                 ),
//                 const CustomText(
//                   text: 'Airdrop Balance',
//                   style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Geist'),
//                 ),
//                 SizedBox(
//                   height: 20.h,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 100.w),
//                   child: BlocBuilder<RewardBloc, RewardState>(
//                     builder: (context, state) {
//                       if (state is RewardBalanceSuccessState) {
//                         balance = '${state.response.data.balance} \$CAP';
//                       }
//                       if (state is RewardBalanceErrorState) {
//                         balance = 'Unable to get balance.';
//                       }

//                       return ReusableContainer(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(13),
//                           color: const Color(0XFF181919),
//                         ),
//                         child: Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 balance,
//                                 style: const TextStyle(
//                                   color: Colors.blue,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20.h,
//                 ),
//                 const CustomText(
//                   text: 'Ways To Acquire More \$CAP',
//                   style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Geist'),
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 Column(
//                   children: [
//                     ...rewardItems.map((item) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: getFigmaColor("181919"),
//                             border: Border.all(
//                                 color: const Color(0xFF464747), width: 1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 0, vertical: 10),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Image.asset(
//                                   item.imageAsset,
//                                   width: 25, // Adjust image size
//                                   height: 25,
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       item.title,
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       item.subtitle,
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               // Check if showCopyIcon is true or false
//                               item.showCopyIcon
//                                   ? Padding(
//                                       padding:
//                                           const EdgeInsets.only(right: 16.0),
//                                       child: Row(
//                                         children: [
//                                           Image.asset(
//                                             'assets/images/document.png', // Path to copy icon image
//                                             width: 24,
//                                             height: 24,
//                                           ),
//                                           const SizedBox(
//                                               width:
//                                                   8), // Space between icon and text
//                                           const Text(
//                                             'Copy invite Link',
//                                             style: TextStyle(
//                                               fontSize: 10,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   : Padding(
//                                       padding:
//                                           const EdgeInsets.only(right: 16.0),
//                                       child: item.title == 'Host a Brag'
//                                           ? FancyContainer(
//                                               backgroundColor:
//                                                   AppColors.primaryColor,
//                                               radius: 40,
//                                               height: 40,
//                                               width: 120,
//                                               child: const Text(
//                                                 'Go to Brags',
//                                                 style: TextStyle(
//                                                   fontSize: 12,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             )
//                                           : item.title ==
//                                                   'Join Our Telegram \n Community'
//                                               ? FancyContainer(
//                                                   backgroundColor:
//                                                       AppColors.primaryColor,
//                                                   radius: 40,
//                                                   height: 40,
//                                                   width: 120,
//                                                   child: const Text(
//                                                     'Join Telegram',
//                                                     style: TextStyle(
//                                                       fontSize: 12,
//                                                       color: Colors.white,
//                                                     ),
//                                                   ),
//                                                 )
//                                               : Container(),
//                                     ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }),
//                     const SizedBox(height: 12),

//                     //* Reward Balance
//                     BlocBuilder<RewardBloc, RewardState>(
//                         builder: (context, state) {
//                       String balance = '\$CAP 0';

//                       if (state is RewardBalanceSuccessState) {
//                         balance = ' \$CAP ${state.response.data.balance}';
//                       }
//                       if (state is RewardBalanceErrorState) {
//                         balance = 'Unable to get balance.';
//                       }
//                       return FancyContainer(
//                         padding: const EdgeInsets.all(10),
//                         radius: 16,
//                         backgroundColor: getFigmaColor("181919"),
//                         hasBorder: true,
//                         borderColor: getFigmaColor("464747"),
//                         height: 190.h,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               "Reward Balance",
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.w500),
//                             ),
//                             Skeletonizer(
//                               enabled: state is RewardBalanceLoadingState,
//                               child: Text(
//                                 balance,
//                                 style: TextStyle(
//                                   fontSize: 25,
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.primaryColor,
//                                 ),
//                               ),
//                             ),
//                             Row(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 7,
//                                   child: Text(
//                                     "!",
//                                     style: TextStyle(
//                                       fontSize: 10.w,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 3),
//                                 Text(
//                                   "Get a total of 500 clap points to be able to withdraw your clap coin",
//                                   style: TextStyle(
//                                     fontSize: 9.w,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 20.h),
//                             GestureDetector(
//                               onTap: state is RewardBalanceLoadingState
//                                   ? null
//                                   : () {
//                                       // Add your onTap functionality here
//                                     },
//                               child: FancyContainer(
//                                 backgroundColor: getFigmaColor("485E8F", 30),
//                                 height: 33,
//                                 child: Center(
//                                   child: Text(
//                                     "Claim Clap coin",
//                                     style: TextStyle(
//                                       fontSize: 10.w,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white.withOpacity(.5),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }),
//                     const SizedBox(height: 12),
//                     //* QR Code
//                     BlocBuilder<RewardBloc, RewardState>(
//                         builder: (context, state) {
//                       return FancyContainer(
//                         padding: const EdgeInsets.all(10),
//                         radius: 16,
//                         backgroundColor: getFigmaColor("181919"),
//                         hasBorder: true,
//                         borderColor: getFigmaColor("464747"),
//                         child: Column(
//                           children: [
//                             const Text("Referral Link"),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Skeletonizer(
//                                   enabled: state is ReferrerQrCodeLoadingState,
//                                   child: Row(
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       const Text("Scan QR code"),
//                                       SizedBox(width: 10.w),
//                                       Image.asset(
//                                         "assets/icons/qcode.png",
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: 16.w),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: FancyContainer(
//                                         padding: const EdgeInsets.all(10),
//                                         alignment: Alignment.centerLeft,
//                                         backgroundColor:
//                                             getFigmaColor("485E8F", 30),
//                                         height: 40,
//                                         child: Skeletonizer(
//                                           enabled: state
//                                               is ReferrerQrCodeLoadingState,
//                                           child: Text(
//                                               "https://clapmi.com/register?ref=kmvnfjDjnnJDH",
//                                               style: TextStyle(
//                                                   fontSize: 10.w,
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Colors.white
//                                                       .withOpacity(.5))),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 16.w),
//                                     FancyContainer(
//                                       height: 30,
//                                       width: 30,
//                                       backgroundColor: AppColors.primaryColor,
//                                       child: GestureDetector(
//                                         onTap: () async {
//                                           await _copyToClipBoard(
//                                               "https://clapmi.com/register?ref=kmvnfjDjnnJDH");
//                                         },
//                                         child: const Icon(
//                                           Icons.copy,
//                                           size: 12,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 14.h),
//                                 Row(
//                                   children: [
//                                     const Text("Referrals: "),
//                                     Skeletonizer(
//                                         enabled:
//                                             state is ReferrerQrCodeLoadingState,
//                                         child: const Text("4 users")),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     }),

//                     const SizedBox(height: 12),

//                     //* Rewards History
//                     BlocBuilder<RewardBloc, RewardState>(
//                         builder: (context, state) {
//                       return FancyContainer(
//                         padding: const EdgeInsets.all(10),
//                         radius: 16,
//                         backgroundColor: getFigmaColor("181919"),
//                         hasBorder: true,
//                         borderColor: getFigmaColor("464747"),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               "Rewards History",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w500, fontSize: 16),
//                             ),
//                             SizedBox(height: 10),
//                             //* Reward Table
//                             Visibility(
//                               visible: state is RewardHistoryErrorState,
//                               replacement: Skeletonizer(
//                                 enabled: state is RewardHistoryLoadingState,
//                                 child: Table(
//                                   children: [
//                                     //* Table Head
//                                     TableRow(
//                                         decoration: BoxDecoration(
//                                             border: Border.all(
//                                                 color: Colors.transparent),
//                                             color:
//                                                 Colors.white.withOpacity(.15)),
//                                         children: [
//                                           FancyContainer(
//                                             hasBorder: true,
//                                             borderColor: Colors.white,
//                                             radius: 0,
//                                             child: const TableCell(
//                                               child: Text(""),
//                                             ),
//                                           ),
//                                           FancyContainer(
//                                             hasBorder: true,
//                                             borderColor: Colors.white,
//                                             radius: 0,
//                                             child: const TableCell(
//                                               child: Text("No."),
//                                             ),
//                                           ),
//                                           FancyContainer(
//                                             hasBorder: true,
//                                             borderColor: Colors.white,
//                                             radius: 0,
//                                             child: const TableCell(
//                                               child: Text("Points"),
//                                             ),
//                                           ),
//                                           FancyContainer(
//                                             hasBorder: true,
//                                             borderColor: Colors.white,
//                                             radius: 0,
//                                             child: const TableCell(
//                                               child: Text("Sub-Total"),
//                                             ),
//                                           ),
//                                         ]),
//                                     //* Table Body
//                                     if (state is RewardHistorySuccessState)
//                                       ...state.response.data.map(
//                                         (item) => TableRow(
//                                             decoration: BoxDecoration(
//                                                 border: Border.all(
//                                                     color: Colors.transparent),
//                                                 color: Colors.white
//                                                     .withOpacity(0)),
//                                             children: [
//                                               FancyContainer(
//                                                 hasBorder: true,
//                                                 borderColor: Colors.white,
//                                                 radius: 0,
//                                                 child: TableCell(
//                                                   child: Text(
//                                                       item.type.toUpperCase()),
//                                                 ),
//                                               ),
//                                               FancyContainer(
//                                                 hasBorder: true,
//                                                 borderColor: Colors.white,
//                                                 radius: 0,
//                                                 child: TableCell(
//                                                   child: Text(
//                                                       item.rewardId.toString()),
//                                                 ),
//                                               ),
//                                               FancyContainer(
//                                                 hasBorder: true,
//                                                 borderColor: Colors.white,
//                                                 radius: 0,
//                                                 child: TableCell(
//                                                   child: Text(
//                                                       "\$CAP ${item.clapPoints}"),
//                                                 ),
//                                               ),
//                                               FancyContainer(
//                                                 hasBorder: true,
//                                                 borderColor: Colors.white,
//                                                 radius: 0,
//                                                 child: TableCell(
//                                                   child: Text(
//                                                       "\$CAP ${item.clapPoints}"),
//                                                 ),
//                                               ),
//                                             ]),
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                               child: Center(child: Text(() {
//                                 if (state is RewardHistoryErrorState) {
//                                   return state.errorMessage;
//                                 }
//                                 return "";
//                               }())),
//                             )
//                           ],
//                         ),
//                       );
//                     }),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }

//   static Future<void> _copyToClipBoard(String value) async {
//     final data = ClipboardData(text: value);
//     await Clipboard.setData(data);
//   }

//   TableRow _buildGenericRow() {
//     return TableRow(
//         decoration: BoxDecoration(
//             border: Border.all(color: Colors.transparent),
//             color: Colors.white.withOpacity(.15)),
//         children: [
//           FancyContainer(
//             hasBorder: true,
//             borderColor: Colors.white,
//             radius: 0,
//             child: const TableCell(
//               child: Text(""),
//             ),
//           ),
//           FancyContainer(
//             hasBorder: true,
//             borderColor: Colors.white,
//             radius: 0,
//             child: const TableCell(
//               child: Text("No."),
//             ),
//           ),
//           FancyContainer(
//             hasBorder: true,
//             borderColor: Colors.white,
//             radius: 0,
//             child: const TableCell(
//               child: Text("Points"),
//             ),
//           ),
//           FancyContainer(
//             hasBorder: true,
//             borderColor: Colors.white,
//             radius: 0,
//             child: const TableCell(
//               child: Text("Sub-Total"),
//             ),
//           ),
//         ]);
//   }

//   TableRow _buildGenericRow2() {
//     return TableRow(
//         decoration: BoxDecoration(
//             border: Border.all(color: Colors.transparent),
//             color: Colors.white.withOpacity(0)),
//         children: [
//           FancyContainer(
//             hasBorder: true,
//             borderColor: Colors.white,
//             radius: 0,
//             child: const TableCell(
//               child: Text("Referrals"),
//             ),
//           ),
//           FancyContainer(
//             hasBorder: true,
//             borderColor: Colors.white,
//             radius: 0,
//             child: const TableCell(
//               child: Text("2"),
//             ),
//           ),
//           FancyContainer(
//             hasBorder: true,
//             borderColor: Colors.white,
//             radius: 0,
//             child: const TableCell(
//               child: Text("\$CAP 25"),
//             ),
//           ),
//           FancyContainer(
//             hasBorder: true,
//             borderColor: Colors.white,
//             radius: 0,
//             child: const TableCell(
//               child: Text("\$CAP 25"),
//             ),
//           ),
//         ]);
//   }

//   TableRow _buildGenericRow3() {
//     return TableRow(
//         decoration: BoxDecoration(
//             border: Border.all(color: Colors.transparent),
//             color: Colors.white.withOpacity(0)),
//         children: [
//           FancyContainer(
//             hasBorder: true,
//             borderColor: Colors.white,
//             radius: 0,
//             child: const TableCell(
//               child: Text(""),
//             ),
//           ),
//           FancyContainer(
//             hasBorder: true,
//             borderColor: Colors.white,
//             radius: 0,
//             child: const TableCell(
//               child: Text(""),
//             ),
//           ),
//           FancyContainer(
//             hasBorder: true,
//             borderColor: Colors.white,
//             radius: 0,
//             child: const TableCell(
//               child: Text("Total"),
//             ),
//           ),
//           FancyContainer(
//             hasBorder: true,
//             borderColor: Colors.white,
//             radius: 0,
//             child: const TableCell(
//               child: Text("\$CAP 25"),
//             ),
//           ),
//         ]);
//   }

//   FancyContainer _buildQrCodeSlab() {
//     return FancyContainer(
//       padding: const EdgeInsets.all(10),
//       radius: 16,
//       backgroundColor: getFigmaColor("181919"),
//       hasBorder: true,
//       borderColor: getFigmaColor("464747"),
//       child: Stack(
//         children: [
//           const Text("Referral Link"),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   const Text("Scan QR code"),
//                   SizedBox(width: 10.w),
//                   Image.asset("assets/icons/qcode.png")
//                 ],
//               ),
//               SizedBox(height: 16.w),
//               Row(
//                 children: [
//                   Expanded(
//                     child: FancyContainer(
//                       padding: const EdgeInsets.all(10),
//                       alignment: Alignment.centerLeft,
//                       backgroundColor: getFigmaColor("485E8F", 30),
//                       height: 40,
//                       child: Text(
//                           "https://clapmi.com/register?ref=kmvnfjDjnnJDH",
//                           style: TextStyle(
//                               fontSize: 10.w,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white.withOpacity(.5))),
//                     ),
//                   ),
//                   SizedBox(width: 16.w),
//                   FancyContainer(
//                     height: 30,
//                     width: 30,
//                     backgroundColor: AppColors.primaryColor,
//                     child: const Icon(
//                       Icons.copy,
//                       size: 12,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 14.h),
//               const Text("Referrals: 4 users"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   FancyContainer _buildRewardBalanceSlab() {
//     return FancyContainer(
//       padding: const EdgeInsets.all(10),
//       radius: 16,
//       backgroundColor: getFigmaColor("181919"),
//       hasBorder: true,
//       borderColor: getFigmaColor("464747"),
//       height: 190.h,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Reward Balance",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//           ),
//           const Text(
//             "\$CAP 300",
//             style: TextStyle(
//               fontSize: 25,
//               fontWeight: FontWeight.bold,
//               color: AppColors.primaryColor,
//             ),
//           ),
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 7,
//                 child: Text(
//                   "!",
//                   style: TextStyle(
//                     fontSize: 10.w,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 3),
//               Text(
//                 "Get a total of 500 clap points to be able to withdraw your clap coin",
//                 style: TextStyle(
//                   fontSize: 9.w,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 20.h),
//           GestureDetector(
//             onTap: () {
//               // Add your onTap functionality here
//             },
//             child: FancyContainer(
//               backgroundColor: getFigmaColor("485E8F", 30),
//               height: 33,
//               child: Center(
//                 child: Text(
//                   "Claim Clap coin",
//                   style: TextStyle(
//                     fontSize: 10.w,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white.withOpacity(.5),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Data Model for Reward Items
// class RewardItem {
//   final String imageAsset;
//   final String title;
//   final String subtitle;
//   final bool showCopyIcon;

//   RewardItem({
//     required this.imageAsset,
//     required this.title,
//     required this.subtitle,
//     this.showCopyIcon = false, // Default to false if not specified
//   });
// }
