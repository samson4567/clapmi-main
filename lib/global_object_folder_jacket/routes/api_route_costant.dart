import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/app/data/models/user_model.dart';
import 'package:clapmi/features/brag/data/models/brag_challengers.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/features/post/data/models/create_post_model.dart';
import 'package:clapmi/features/wallet/data/models/paywith_transfer_enity.dart';
import 'package:clapmi/features/wallet/data/models/transaction.dart';
import 'package:clapmi/global_object_folder_jacket/global_variables/global_variables.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:clapmi/screens/Authentication/UserChoiceScreen.dart';
import 'package:clapmi/screens/Authentication/account_signup.dart';
import 'package:clapmi/screens/Authentication/build_your_feed_screen.dart';
import 'package:clapmi/screens/Authentication/connect_to_user.dart';
import 'package:clapmi/screens/Authentication/forget_passoword.dart';
import 'package:clapmi/screens/Authentication/googlesigin_webview.dart';
import 'package:clapmi/screens/Authentication/login_page.dart';
import 'package:clapmi/screens/Authentication/onboarding/onboarding_page.dart';
import 'package:clapmi/screens/Authentication/onboarding/splash_screen.dart';
import 'package:clapmi/screens/Authentication/passoword_link.dart';
import 'package:clapmi/screens/Authentication/reset_or_update_password.dart';
import 'package:clapmi/screens/Authentication/varify_mail.dart';
import 'package:clapmi/screens/Brag/brag_detail_screen.dart';

import 'package:clapmi/screens/Brag/brag_screen_tu_tu.dart';
import 'package:clapmi/screens/Brag/challenge_brag.dart';
import 'package:clapmi/screens/NetworkAndRewards/clap_reward.dart';
import 'package:clapmi/screens/leaderboard/clapmiplus/clapmi_plus.dart';
import 'package:clapmi/screens/leaderboard/payment_checkout.dart';
import 'package:clapmi/screens/challenge/others/Single_livestream.dart';
import 'package:clapmi/screens/challenge/start_challeng_now_chalenger_page.dart';
import 'package:clapmi/screens/Brag_new/brag_new.dart';
import 'package:clapmi/screens/MainNavigationPage/MainNavigationPage.dart';
import 'package:clapmi/screens/NetworkAndRewards/network.dart';
import 'package:clapmi/screens/Notification/notification.dart';
import 'package:clapmi/screens/challenge/challenge_list.dart';
import 'package:clapmi/screens/challenge/others/Live_combo.dart';
import 'package:clapmi/screens/challenge/others/Live_combo_about_to_recieve.dart';
import 'package:clapmi/screens/challenge/others/Live_combo_three_image_present.dart';
import 'package:clapmi/screens/challenge/start_join_challenge_screen.dart';
import 'package:clapmi/screens/challenge/upcoming_challenge_detail_page.dart';
import 'package:clapmi/screens/challenge/single_livestream_detail_page.dart';
import 'package:clapmi/screens/chatsection/chat_page.dart';
import 'package:clapmi/screens/chatsection/chat_page_for_group.dart';
import 'package:clapmi/screens/chatsection/chats_list_page.dart';
import 'package:clapmi/screens/chatsection/create_new_group_page.dart';
import 'package:clapmi/screens/chatsection/group_info_page.dart';
import 'package:clapmi/screens/chatsection/my_network_page.dart';
import 'package:clapmi/screens/chatsection/user_info_page.dart';
import 'package:clapmi/screens/feed/feed_extraction_files/feed.dart';
import 'package:clapmi/screens/feed/feed_extraction_files/how_clapmi_work.dart';
import 'package:clapmi/screens/feed/feed_extraction_files/post_new.dart';
import 'package:clapmi/screens/generalSearchPage/general_search_page.dart';
import 'package:clapmi/screens/leaderboard/leader_dashbord.dart';
import 'package:clapmi/screens/leaderboard/payment_leader.dart';
import 'package:clapmi/screens/leaderboard/unlock_elite.dart';
import 'package:clapmi/screens/posts/post.dart';
import 'package:clapmi/screens/posts/post_%20report.dart';
import 'package:clapmi/screens/posts/your_report.dart';
import 'package:clapmi/screens/settings/account.dart';
import 'package:clapmi/screens/settings/deleteaccount.dart';
import 'package:clapmi/screens/settings/kyc/kyc.dart';
import 'package:clapmi/screens/settings/kyc/kyc_process.dart';
import 'package:clapmi/screens/settings/kyc/kyc_upload_details.dart';
import 'package:clapmi/screens/settings/kyc/kyc_upload_file.dart';
import 'package:clapmi/screens/settings/notification.dart';
import 'package:clapmi/screens/settings/privacy.dart';
import 'package:clapmi/screens/settings/security.dart';
import 'package:clapmi/screens/settings/settings.dart';
import 'package:clapmi/screens/society/society.dart';
import 'package:clapmi/screens/ui_experimentals/ui_display.dart';
import 'package:clapmi/screens/user_account_profile/edit_account_page.dart';
import 'package:clapmi/screens/user_account_profile/my_account.dart';
import 'package:clapmi/screens/user_account_profile/others_account.dart';
import 'package:clapmi/screens/walletSystem/buy_points/buy_points.dart';
import 'package:clapmi/screens/walletSystem/buy_points/change_payment_method.dart';
import 'package:clapmi/screens/walletSystem/buy_points/coin_added.dart';
import 'package:clapmi/screens/walletSystem/buy_points/order_summary.dart';
import 'package:clapmi/screens/walletSystem/gifting/all_recent_gifting.dart';
import 'package:clapmi/screens/walletSystem/gifting/gift_coins.dart';
import 'package:clapmi/screens/walletSystem/gifting/gifting_successful.dart';
import 'package:clapmi/screens/walletSystem/receive.dart';
import 'package:clapmi/screens/walletSystem/transaction/all_transaction_history.dart';
import 'package:clapmi/screens/walletSystem/transaction/single_transaction_detail.dart';
import 'package:clapmi/screens/walletSystem/transaction/transaction_history_args.dart';
import 'package:clapmi/screens/walletSystem/transaction/transaction_history_filter.dart';
import 'package:clapmi/screens/walletSystem/withdrawal/enter_setnewpin.dart';
import 'package:clapmi/screens/walletSystem/withdrawal/fiat_withdrawal.dart';
import 'package:clapmi/screens/walletSystem/withdrawal/search_bank.dart';
import 'package:clapmi/screens/walletSystem/withdrawal/two_factor_auth.dart';
import 'package:clapmi/screens/walletSystem/withdrawal/usdc_withdrawal.dart';
import 'package:clapmi/screens/walletSystem/withdrawal/wallet_email_verification.dart';
import 'package:clapmi/screens/walletSystem/withdrawal/withdraw_forgotpin.dart';
import 'package:clapmi/screens/walletSystem/withdrawal/withdrawal.dart';
import 'package:clapmi/screens/walletSystem/withdrawal/withdrawal_order_summary.dart';
import 'package:clapmi/screens/walletSystem/withdrawal/withdrawal_pin.dart';
import 'package:clapmi/screens/walletSystem/withdrawal/withdrawal_successful.dart';
import 'package:clapmi/core/di/injector.dart';
import 'package:clapmi/core/db/auth_preference_service.dart';
// import 'package:clapmi/screens/walletsection/buy_point_page.dart';
// import 'package:clapmi/screens/walletsection/convert_page.dart';
// import 'package:clapmi/screens/walletsection/deposit_via_crypto_screen.dart';
// import 'package:clapmi/screens/walletsection/payment_method_card_page.dart';
// import 'package:clapmi/screens/walletsection/payment_method_general_page.dart';
// import 'package:clapmi/screens/walletsection/payment_method_point_page.dart';
// import 'package:clapmi/screens/walletsection/transaction_detail.dart';
// import 'package:clapmi/screens/walletsection/transaction_history.dart';
// import 'package:clapmi/screens/walletsection/transfer_page.dart';
// import 'package:clapmi/screens/walletsection/wallet_clapmi.dart';
// import 'package:clapmi/screens/walletsection/wallet_web3.dart';
// import 'package:clapmi/screens/walletsection/withdraw_page.dart';
// import 'package:clapmi/screens/walletsection/buy_point_page.dart';
// import 'package:clapmi/screens/walletsection/buy_point_page_new.dart';
// import 'package:clapmi/screens/walletsection/convert_page.dart';
// import 'package:clapmi/screens/walletsection/deposit_screen.dart';
// import 'package:clapmi/screens/walletsection/deposit_via_crypto_screen.dart';
// import 'package:clapmi/screens/walletsection/order_summary_new.dart';
// import 'package:clapmi/screens/walletsection/payment_method_card_page.dart';
// import 'package:clapmi/screens/walletsection/payment_method_general_page.dart';
// import 'package:clapmi/screens/walletsection/payment_method_point_page.dart';
// import 'package:clapmi/screens/walletsection/transfer_page.dart';
// import 'package:clapmi/screens/walletsection/wallet_clapmi.dart';
// import 'package:clapmi/screens/walletsection/wallet_web3.dart';
// import 'package:clapmi/screens/walletsection/withdraw_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// import '../../screens/walletSystem/gift_coin.dart';
import '../../screens/walletSystem/wallet_page.dart';
// import '../../screens/walletsection/transaction_detail.dart';
// import '../../screens/walletsection/transaction_history.dart';

final GoRouter router = GoRouter(
  initialLocation: MyAppRouteConstant.splashScreen,
  // initialLocation: MyAppRouteConstant.testScreen,
  // initialLocation: MyAppRouteConstant.userChoiceScreen +
  // "/" +
  //     MyAppRouteConstant.emailVerificationScreen,

  navigatorKey: rootNavigatorKey,
  observers: [routeObserver],
  routes: [
    GoRoute(
        name: MyAppRouteConstant.testScreen,
        path: MyAppRouteConstant.testScreen,
        builder: (context, state) {
          return SurfaceAnimationPanel();
        }),
    GoRoute(
        path: MyAppRouteConstant.googleWebview,
        name: MyAppRouteConstant.googleWebview,
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>;
          return GooglesiginWebview(
            googleSignInUrl: params['webview_link'] as String,
            coinAmount: params['coins'],
          );
        }),
    GoRoute(
        name: MyAppRouteConstant.upcomingChallengeDetailPage,
        path: MyAppRouteConstant.upcomingChallengeDetailPage,
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>;
          return UpcomingChallengeDetailPage(
            host: params["host"] as ProfileModel,
            challenge: params["challenge"] as BragChallengersModel,
            postId: params["postId"] as String,
          );
        }),
    GoRoute(
        path: MyAppRouteConstant.sharedPostPath,
        builder: (context, state) {
          return PostScreen(
            postId: state.pathParameters['postId'],
          );
        }),
    GoRoute(
        path: MyAppRouteConstant.sharedLivestreamPath,
        builder: (context, state) {
          return SingleLivestreamDetailPage(
            comboId: state.pathParameters['comboId'],
          );
        }),
    GoRoute(
        path: MyAppRouteConstant.sharedComboGroundPath,
        builder: (context, state) {
          return SingleLivestreamDetailPage(
            comboId: state.pathParameters['comboId'],
          );
        }),
    GoRoute(
        name: MyAppRouteConstant.singleLivestreamDetailPage,
        path: MyAppRouteConstant.singleLivestreamDetailPage,
        builder: (context, state) {
          return SingleLivestreamDetailPage(
            comboEntity: state.extra as ComboEntity,
          );
        }),
// UpcomingChallengeDetailPage
    // GoRoute(
    //     name: MyAppRouteConstant.buyPointPageNew,
    //     path: MyAppRouteConstant.buyPointPageNew,
    //     builder: (context, state) {
    //       return const BuyPointPageNew();
    //     }),
    // GoRoute(
    //     name: MyAppRouteConstant.orderSummaryNew,
    //     path: MyAppRouteConstant.orderSummaryNew,
    //     builder: (context, state) {
    //       return const OrderSummaryNew();
    //     }),
    GoRoute(
        name: MyAppRouteConstant.startChallengNowChalengerPage,
        path: MyAppRouteConstant.startChallengNowChalengerPage,
        builder: (context, state) {
          return StartChallengNowChalengerPage(
            challengeRequestEntity:
                (state.extra as Map)["challengeRequestEntity"],
            challengeId: (state.extra as Map)["challengeId"],
          );
        }),
    // GoRoute(
    //     name: MyAppRouteConstant.scheduleChallengeChalengerPage,
    //     path: MyAppRouteConstant.scheduleChallengeChalengerPage,
    //     builder: (context, state) {
    //       return ScheduleChallengeChalengerPage(
    //         challengeRequestEntity:
    //             (state.extra as Map)["challengeRequestEntity"],
    //       );
    //     }),

    // ScheduleChallengeChalengerPage
    GoRoute(
        name: MyAppRouteConstant.delete,
        path: MyAppRouteConstant.delete,
        builder: (context, state) {
          return const DeleteAccountScreen();
        }),
    GoRoute(
        name: MyAppRouteConstant.hwclapmiworks,
        path: MyAppRouteConstant.hwclapmiworks,
        builder: (context, state) {
          return const HowToClapmiScreen();
        }),
    GoRoute(
        name: MyAppRouteConstant.societyPage,
        path: MyAppRouteConstant.societyPage,
        builder: (context, state) {
          return const Society();
        }),

    GoRoute(
        name: MyAppRouteConstant.postReportPage,
        path: MyAppRouteConstant.postReportPage,
        builder: (context, state) {
          return const PostReportPage();
        }),
    GoRoute(
        name: MyAppRouteConstant.challengeBragPage,
        path: MyAppRouteConstant.challengeBragPage,
        builder: (context, state) {
          Map? extras = state.extra as Map?;
          return ChallengeBragPage(
            bragModel: extras?["bragModel"],
            postModel: extras?["postModel"],
          );
        }),

    GoRoute(
        name: MyAppRouteConstant.privacy,
        path: MyAppRouteConstant.privacy,
        builder: (context, state) {
          return const PrivacySettingsScreen();
        }),
    GoRoute(
        name: MyAppRouteConstant.kyc,
        path: MyAppRouteConstant.kyc,
        builder: (context, state) {
          return const KycInputScreen();
        }),
    GoRoute(
        name: MyAppRouteConstant.kycFaceProcessWidget,
        path: MyAppRouteConstant.kycFaceProcessWidget,
        builder: (context, state) {
          return const KycFaceProcessWidget();
        }),
    GoRoute(
      path: MyAppRouteConstant.uploadkyc, // e.g. '/upload-kyc'
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return UploadKyc(
          verificationUuid: extra['verificationUuid'] as String? ?? '',
          fullName: extra['fullName'] as String? ?? '',
          idNumber: extra['idNumber'] as String? ?? '',
          dateOfBirth: extra['dateOfBirth'] as String? ?? '',
        );
      },
    ),
    GoRoute(
      path: MyAppRouteConstant.uploadkycfile, // e.g. '/upload-kyc-file'
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return UploadKycFile(
          idType: extra['idType'] as String? ?? '',
          verificationUuid: extra['verificationUuid'] as String? ?? '',
          fullName: extra['fullName'] as String? ?? '',
          idNumber: extra['idNumber'] as String? ?? '',
          dateOfBirth: extra['dateOfBirth'] as String? ?? '',
        );
      },
    ),
    GoRoute(
        name: MyAppRouteConstant.notification,
        path: MyAppRouteConstant.notification,
        builder: (context, state) {
          return const NotificationSettings();
        }),

    GoRoute(
        name: MyAppRouteConstant.notificationPage,
        path: MyAppRouteConstant.notificationPage,
        builder: (context, state) {
          return const NotificationPage();
        }),

    GoRoute(
        name: MyAppRouteConstant.settings,
        path: MyAppRouteConstant.settings,
        builder: (context, state) {
          return const Setting();
        }),
    GoRoute(
        name: MyAppRouteConstant.security,
        path: MyAppRouteConstant.security,
        builder: (context, state) {
          return const SecurityPage();
        }),
    GoRoute(
        name: MyAppRouteConstant.account,
        path: MyAppRouteConstant.account,
        builder: (context, state) {
          return const AccountUpdatePage();
        }),
    GoRoute(
        name: MyAppRouteConstant.editProfile,
        path: MyAppRouteConstant.editProfile,
        builder: (context, state) {
          return EditAccountPage(
            fromSignUpFlow: (state.extra as Map?)?["fromSignUpFlow"] ?? false,
          );
        }),
    GoRoute(
        name: MyAppRouteConstant.postEmpty,
        path: MyAppRouteConstant.postEmpty,
        builder: (context, state) {
          return const PostEmpty();
        }),
    GoRoute(
        name: MyAppRouteConstant.generalSearch,
        path: MyAppRouteConstant.generalSearch,
        builder: (context, state) {
          return const SocialGeeralSearch();
        }),

    GoRoute(
      name: MyAppRouteConstant.reportSentPage,
      path: MyAppRouteConstant.reportSentPage,
      builder: (context, state) {
        return const ReportSentPage();
      },
    ),

    GoRoute(
      name: MyAppRouteConstant.resetOrUpdatePasswordPassword,
      path: MyAppRouteConstant.resetOrUpdatePasswordPassword,
      builder: (context, state) {
        final errorData = state.extra is Map ? state.extra as Map : {};
        final extraData = state.extra is Map ? state.extra as Map : {};

        final token = errorData["token"]?.toString() ?? "";
        final email = extraData["email"]?.toString() ?? "";
        final isReset =
            extraData["isReset"] is bool ? extraData["isReset"] : false;

        return ResetOrUpdatePassword(
          token: token,
          email: email,
          isReset: isReset,
        );
      },
    ),

    GoRoute(
        name: MyAppRouteConstant.newBrag,
        path: MyAppRouteConstant.newBrag,
        builder: (context, state) {
          return const NewBrag();
        }),
    GoRoute(
        name: MyAppRouteConstant.myAccountPage,
        path: MyAppRouteConstant.myAccountPage,
        builder: (context, state) {
          return const MyAccountPage();
        }),
    GoRoute(
        name: MyAppRouteConstant.othersAccountPage,
        path: MyAppRouteConstant.othersAccountPage,
        builder: (context, state) {
          return OthersAccountPage(
            userId: (state.extra as Map)["userId"]
                as String, // Extract userId as String
          );
        }),
    GoRoute(
        name: MyAppRouteConstant.onboardingPage,
        path: MyAppRouteConstant.onboardingPage,
        builder: (context, state) {
          return const OnboardingPage();
        }),
    GoRoute(
      name: MyAppRouteConstant.splashScreen,
      path: MyAppRouteConstant.splashScreen,
      builder: (context, state) {
        return const SplashScreen();
      },
      redirect: (context, state) {
        try {
          final authPreference = getItInstance<AuthPreferenceService>();
          final status = authPreference.getInitialLoginStatus();
          print('$status hhhhhhhhhhhhhhhhh');
          if (status == null) return MyAppRouteConstant.splashScreen;
          if (status) return MyAppRouteConstant.splashScreen;
          // getItInstance<AppBloc>().add(GetMyProfileEvent());

          return MyAppRouteConstant.feedScreen;
        } catch (e) {
          // If service not ready, stay on splash
          print('AuthPreferenceService not ready: $e');
          return null;
        }
      },
    ),
    GoRoute(
        name: MyAppRouteConstant.userChoiceScreen,
        path: MyAppRouteConstant.userChoiceScreen,
        builder: (context, state) {
          return const UserChoiceScreen();
        },
        routes: [
          GoRoute(
              name: MyAppRouteConstant.accountsignup,
              path: MyAppRouteConstant.accountsignup,
              builder: (context, state) {
                return const SignupAccount();
              }),
          GoRoute(
              name: MyAppRouteConstant.emailVerificationScreen,
              path: MyAppRouteConstant.emailVerificationScreen,
              builder: (context, state) {
                return EmailVerificationScreen(
                  email: (state.extra as Map?)?["email"] ?? "",
                  flow: (state.extra as Map?)?["flow"] ?? "",
                );
              }),
          GoRoute(
              name: MyAppRouteConstant.buildYourFeedScreen,
              path: MyAppRouteConstant.buildYourFeedScreen,
              builder: (context, state) {
                return const BuildYourFeedScreen();
              }),
          GoRoute(
              name: MyAppRouteConstant.connectWithUserScreen,
              path: MyAppRouteConstant.connectWithUserScreen,
              builder: (context, state) {
                return const ConnectWithUserScreen();
              }),
          GoRoute(
              name: MyAppRouteConstant.forgetPassowrd,
              path: MyAppRouteConstant.forgetPassowrd,
              builder: (context, state) {
                return const ForgetPassword();
              }),
          GoRoute(
              name: MyAppRouteConstant.passwordlink,
              path: MyAppRouteConstant.passwordlink,
              builder: (context, state) {
                return const passwordLink();
              }),
          GoRoute(
              name: MyAppRouteConstant.networkConnect,
              path: MyAppRouteConstant.networkConnect,
              builder: (context, state) {
                return const NetworkConnect();
              }),
        ]),
    GoRoute(
        name: MyAppRouteConstant.liveComboAboutToRecieveScreen,
        path: MyAppRouteConstant.liveComboAboutToRecieveScreen,
        builder: (context, state) {
          return const LiveComboAboutToRecieveScreen();
        }),
    GoRoute(
        name: MyAppRouteConstant.liveComboScreen,
        path: MyAppRouteConstant.liveComboScreen,
        builder: (context, state) {
          return const LiveComboScreen();
        }),
    GoRoute(
        name: MyAppRouteConstant.liveComboThreeImageScreen,
        path: MyAppRouteConstant.liveComboThreeImageScreen,
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>;
          return LiveComboThreeImageScreen(
              comboInfo: params['liveCombo'] as LiveComboEntity,
              comboId: params['comboId'] as String,
              bragID: params['brag'] as String);
        }),
    GoRoute(
        name: MyAppRouteConstant.singleLiveStream,
        path: MyAppRouteConstant.singleLiveStream,
        builder: (context, state) {
          return const SingleLiveStreaming();
        }),
    GoRoute(
      name: MyAppRouteConstant.paywithTransfer,
      path: MyAppRouteConstant.paywithTransfer,
      builder: (context, state) {
        final request = state.extra as GetQuoteRequestModelDeposit;
        return PaymentWithTransfer(request: request);
      },
    ),

    GoRoute(
        path: MyAppRouteConstant.startOrjoin,
        name: MyAppRouteConstant.startOrjoin,
        builder: (context, state) {
          return StartOrJoinChallengeScreen(
            model: state.extra as ComboEntity,
          );
        }),
    GoRoute(
        name: MyAppRouteConstant.bragDetailScreen,
        path: MyAppRouteConstant.bragDetailScreen,
        builder: (context, state) {
          return BragDetailScreen(
            model: (state.extra as Map?)?["model"],
          );
        }),
    // BragDetailScreen
    GoRoute(
        name: MyAppRouteConstant.login,
        path: MyAppRouteConstant.login,
        builder: (context, state) {
          return LoginPage(
            toFeed: (state.extra as Map?)?["toFeed"] ?? true,
          );
        }),
    StatefulShellRoute.indexedStack(
      redirect: (context, state) {
        return null;
      },
      builder: (context, state, navigationShell) {
        return MainPage(navigationShell);
      },
      branches: [
        StatefulShellBranch(
            navigatorKey: sectionNavigatorKey,
            initialLocation: MyAppRouteConstant.feedScreen,
            // Add this branch routes

            routes: <RouteBase>[
              GoRoute(
                name: MyAppRouteConstant.feedScreen,
                path: MyAppRouteConstant.feedScreen,
                // onExit: (context, state) {
                //   bool result = toPop;
                //   if (!result) {
                //     Fluttertoast.showToast(
                //         msg: "Tap again to exist",
                //         toastLength: Toast.LENGTH_SHORT,
                //         gravity: ToastGravity.BOTTOM,
                //         timeInSecForIosWeb: 1,
                //         backgroundColor: Colors.black.withAlpha(100),
                //         textColor: Colors.white,
                //         fontSize: 16.0);
                //   }
                //   toPop = true;
                //   Future.delayed(const Duration(seconds: 2), () {
                //     toPop = false;
                //   });

                //   return result;
                // },
                builder: (context, state) => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child:
                      // FeedBackup()
                      FeedScreen(),
                ),
                routes: [
                  GoRoute(
                    name: MyAppRouteConstant.postScreen,
                    path: MyAppRouteConstant.postScreen,
                    builder: (context, state) {
                      final extra = state.extra;
                      final postId = switch (extra) {
                        String value => value,
                        CreatePostModel model => model.uuid ?? '',
                        Map map when map['model'] is CreatePostModel =>
                          (map['model'] as CreatePostModel).uuid ?? '',
                        Map map when map['post'] is String =>
                          map['post'] as String,
                        Map map when map['postId'] is String =>
                          map['postId'] as String,
                        _ => '',
                      };

                      return PostScreen(
                        postId: postId,
                      );
                    },
                    routes:  [
                      
                    ],
                  ),
                ],
              )
            ]),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
                name: MyAppRouteConstant.bragScreen,
                path: MyAppRouteConstant.bragScreen,
                onExit: (context, state) {
                  return true;
                },
                builder: (context, state) {
                  return BragScreenTuTu();
                  // BragScreen(
                  //   key: ValueKey('video_player_screen'),
                  // );
                }),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
                name: MyAppRouteConstant.challenge,
                path: MyAppRouteConstant.challenge,
                builder: (context, state) {
                  return ChallengeListScreen(
                    isComingFromCommboSet: state.extra as bool?,
                  );
                },
                routes: []),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
                name: MyAppRouteConstant.chatListPage,
                path: MyAppRouteConstant.chatListPage,
                builder: (context, state) {
                  return const ChatListPage();
                },
                routes: [
                  GoRoute(
                    name: MyAppRouteConstant.chatPageForGroup,
                    path: MyAppRouteConstant.chatPageForGroup,
                    builder: (context, state) {
                      return const ChatPageForGroup();
                    },
                  ),
                  GoRoute(
                    name: MyAppRouteConstant.createNewGroupPage,
                    path: MyAppRouteConstant.createNewGroupPage,
                    builder: (context, state) {
                      return const CreateNewGroupPage();
                    },
                  ),
                  GoRoute(
                    name: MyAppRouteConstant.myNetworkPage,
                    path: MyAppRouteConstant.myNetworkPage,
                    builder: (context, state) {
                      return const MyNetworkPage();
                    },
                  ),
                  GoRoute(
                    name: MyAppRouteConstant.userInfoPage,
                    path: MyAppRouteConstant.userInfoPage,
                    builder: (context, state) {
                      return const UserInfoPage();
                    },
                  ),
                  GoRoute(
                    name: MyAppRouteConstant.groupInfoPage,
                    path: MyAppRouteConstant.groupInfoPage,
                    builder: (context, state) {
                      return const GroupInfoPage();
                    },
                  ),
                ]),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
                name: MyAppRouteConstant.walletGeneralPage,
                path: MyAppRouteConstant.walletGeneralPage,
                builder: (context, state) {
                  // return const WalletGeneral();
                  return const WalletView();
                }),

            GoRoute(
                name: MyAppRouteConstant.transactionHistory,
                path: MyAppRouteConstant.transactionHistory,
                builder: (context, state) {
                  return const TransactionHistory(
                    recent: false,
                    perPage: 0,
                  );
                }),
            GoRoute(
                name: MyAppRouteConstant.transactionDetail,
                path: MyAppRouteConstant.transactionDetail,
                builder: (context, state) {
                  final extra = state.extra;
                  final transaction = extra is TransactionHistoryModel
                      ? extra
                      : TransactionHistoryModel(
                          transaction:
                              extra is Map && extra['transactionID'] != null
                                  ? extra['transactionID'].toString()
                                  : '',
                          operation:
                              extra is Map && extra['operation'] != null
                                  ? extra['operation'].toString()
                                  : '',
                          currency: extra is Map && extra['currency'] != null
                              ? extra['currency'].toString()
                              : '',
                          amount: extra is Map && extra['amount'] != null
                              ? extra['amount'].toString()
                              : '',
                          date: extra is Map && extra['date'] != null
                              ? extra['date'].toString()
                              : '',
                          status: extra is Map && extra['status'] != null
                              ? extra['status'].toString()
                              : '',
                          recent: false,
                          perPage: 0,
                          orderId: extra is Map && extra['orderId'] != null
                              ? extra['orderId'].toString()
                              : '',
                          time: extra is Map && extra['time'] != null
                              ? extra['time'].toString()
                              : '',
                          from: extra is Map && extra['from'] != null
                              ? extra['from'].toString()
                              : '',
                          to: extra is Map && extra['to'] != null
                              ? extra['to'].toString()
                              : '',
                        );
                  return SingleTransactionDetail(
                    transaction: transaction,
                  );
                  // return const TransactionDetail();
                }),
            GoRoute(
                name: MyAppRouteConstant.transactionFilter,
                path: MyAppRouteConstant.transactionFilter,
                builder: (context, state) {
                  return TransactionHistoryFilter(
                    initialFilters:
                        state.extra is TransactionHistoryFilterArgs
                            ? state.extra as TransactionHistoryFilterArgs
                            : const TransactionHistoryFilterArgs(),
                  );
                }),
            // GoRoute(
            //     name: MyAppRouteConstant.giftCoin,
            //     path: MyAppRouteConstant.giftCoin,
            //     builder: (context, state) {
            //       return const GiftCoinPage();
            //     }),
            GoRoute(
                name: MyAppRouteConstant.allRecentGifting,
                path: MyAppRouteConstant.allRecentGifting,
                builder: (context, state) {
                  return const AllRecentGifting();
                }),
            GoRoute(
                name: MyAppRouteConstant.giftingSuccessful,
                path: MyAppRouteConstant.giftingSuccessful,
                builder: (context, state) {
                  final params = state.extra as Map<String, dynamic>;
                  return GiftingSuccessful(
                    name: params['name'] as String,
                    selectedPoint: params['coin'] as int,
                  );
                }),
            GoRoute(
                name: MyAppRouteConstant.giftCoin,
                path: MyAppRouteConstant.giftCoin,
                builder: (context, state) {
                  return const GiftCoins();
                }),
            GoRoute(
                name: MyAppRouteConstant.receive,
                path: MyAppRouteConstant.receive,
                builder: (context, state) {
                  return Receive(
                    onPress: () {},
                  );
                }),
            GoRoute(
                name: MyAppRouteConstant.buyPointsPage,
                path: MyAppRouteConstant.buyPointsPage,
                builder: (context, state) {
                  return BuyPoints(
                    onPress: () {},
                  );
                }),

            GoRoute(
                name: MyAppRouteConstant.orderSummary,
                path: MyAppRouteConstant.orderSummary,
                builder: (context, state) {
                  final params = state.extra as Map<String, dynamic>;
                  return OrderSummary(
                    amount: params['amount'] as double,
                    coin: params['coin'] as int,
                    paymentMethod: params['paymentMethod'] as String,
                    // payAssets: params['payAssets']
                  );
                }),
            GoRoute(
                name: MyAppRouteConstant.withdrawal,
                path: MyAppRouteConstant.withdrawal,
                builder: (context, state) {
                  return Withdrawal();
                }),
            // VerifyForgotPin
            GoRoute(
                name: MyAppRouteConstant.verifyForgotPin,
                path: MyAppRouteConstant.verifyForgotPin,
                builder: (context, state) {
                  return VerifyForgotPin(email: (state.extra as Map)["email"]);
                }),
            GoRoute(
                name: MyAppRouteConstant.createNewPinForgetPin,
                path: MyAppRouteConstant.createNewPinForgetPin,
                builder: (context, state) {
                  return CreateNewPin();
                }),
            GoRoute(
                name: MyAppRouteConstant.withdrawalSuccessful,
                path: MyAppRouteConstant.withdrawalSuccessful,
                builder: (context, state) {
                  return const WithdrawalSuccessful();
                }),
            GoRoute(
              name: MyAppRouteConstant.withdrawalPin,
              path: MyAppRouteConstant.withdrawalPin,
              builder: (context, state) {
                final extra = (state.extra as Map<String, dynamic>?) ?? {};

                return WithdrawalPin(
                  isEnterPin: (extra['isEnterPin'] as bool?) ?? false,
                  orderId: extra['orderId'] as String? ?? '',
                  amount: extra['amount'] as String? ?? '',
                  address: extra['address'] as String? ?? '',
                  assets: extra['assets'] as String? ?? '',
                  network: extra['network'] as String? ?? '',
                );
              },
            ),
            GoRoute(
                name: MyAppRouteConstant.twoFactorAuth,
                path: MyAppRouteConstant.twoFactorAuth,
                builder: (context, state) {
                  final params = state.extra as Map<String, dynamic>;
                  return TwoFactorAuth(
                    orderId: params['orderId'],
                    amount: params['amount'],
                    network: params['network'],
                    address: params['address'],
                  );
                }),
            GoRoute(
                name: MyAppRouteConstant.walletEmailVerification,
                path: MyAppRouteConstant.walletEmailVerification,
                builder: (context, state) {
                  final params = state.extra as Map<String, dynamic>;
                  return WalletEmailVerification(
                    isEnterOtp: params['isEnterOtp'] as bool,
                    //isUsdcEnterOtp: params['isUsdcEnterOtp'] as bool,
                    isFiatWithdrawal: params['isFiatWithdrawal'] as bool,
                    orderId: params['orderId'],
                    amount: params['amount'],
                    address: params['address'],
                    network: params['network'],
                  );
                }),
            GoRoute(
                name: MyAppRouteConstant.searchBank,
                path: MyAppRouteConstant.searchBank,
                builder: (context, state) {
                  return BankSearchScreen();
                }),
            GoRoute(
                name: MyAppRouteConstant.usdcWithdrawal,
                path: MyAppRouteConstant.usdcWithdrawal,
                builder: (context, state) {
                  return WithdrawalUsdcSolana();
                }),

            // usdcWithdrawal
            GoRoute(
                name: MyAppRouteConstant.fiatWithdrawal,
                path: MyAppRouteConstant.fiatWithdrawal,
                builder: (context, state) {
                  return FiatWithdrawalScreen();
                }),
            GoRoute(
                name: MyAppRouteConstant.fiatWithdrawalOrderSummary,
                path: MyAppRouteConstant.fiatWithdrawalOrderSummary,
                builder: (context, state) {
                  final params = state.extra as Map<String, dynamic>;
                  return WithdrawalOrderSummary(
                      amount: params['amount'], orderInfo: params['orderInfo']);
                }),
            GoRoute(
                name: MyAppRouteConstant.leaderboard,
                path: MyAppRouteConstant.leaderboard,
                builder: (context, state) {
                  return const LeaderboardScreen();
                }),
            GoRoute(
                name: MyAppRouteConstant.clapmiplus,
                path: MyAppRouteConstant.clapmiplus,
                builder: (context, state) {
                  return const LevelOnboardingScreen();
                }),
            GoRoute(
                name: MyAppRouteConstant.subscriptionScreen,
                path: MyAppRouteConstant.subscriptionScreen,
                builder: (context, state) {
                  return const SubscriptionScreen();
                }),
            GoRoute(
                name: MyAppRouteConstant.paymentLeader,
                path: MyAppRouteConstant.paymentLeader,
                builder: (context, state) {
                  return const SubscriptionScreen();
                }),
            GoRoute(
                name: MyAppRouteConstant.unlockElite,
                path: MyAppRouteConstant.unlockElite,
                builder: (context, state) {
                  return const UnlockEliteScreen();
                }),
            //subscriptionScreen
            GoRoute(
                name: MyAppRouteConstant.clapReward,
                path: MyAppRouteConstant.clapReward,
                builder: (context, state) {
                  return const ClapReward();
                }),
            GoRoute(
                name: MyAppRouteConstant.paymentCheckout,
                path: MyAppRouteConstant.paymentCheckout,
                builder: (context, state) {
                  // Extract the tier info from the extra parameter
                  final extra = state.extra as Map<String, dynamic>?;
                  final tierUuid = extra?['tierUuid'] as String?;
                  final tierName = extra?['tierName'] as String?;
                  final tierPrice = extra?['tierPrice'] as int?;

                  return LeaderboardPayemtUpgrade(
                    tierUuid: tierUuid,
                    tierName: tierName,
                    tierPrice: tierPrice,
                  );
                }),
          ],
        ),
      ],
    ),
    GoRoute(
      name: MyAppRouteConstant.chatPage,
      path: MyAppRouteConstant.chatPage,
      builder: (context, state) {
        return ChatPage(
          user: (state.extra as Map?)?["user"],
          newUser: (state.extra as Map?)?["newUser"],
          newPartner: (state.extra as Map?)?["newUserPid"],
        );
      },
    ),
    GoRoute(
        name: MyAppRouteConstant.coinAdded,
        path: MyAppRouteConstant.coinAdded,
        builder: (context, state) {
          return CoinAdded(
            addedCoin: state.extra as String,
          );
        }),
  ],
);
