import 'dart:convert';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/core/services/notification_handler_classes/notificationWorkers/local_notification.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_bloc.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_event.dart';
import 'package:clapmi/features/notification/domain/entities/notification_entity.dart';
import 'package:clapmi/features/notification/presentation/blocs/user_bloc/notification_bloc.dart';
import 'package:clapmi/features/notification/presentation/blocs/user_bloc/notification_state.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_bloc.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/global_classes.dart';
import 'package:clapmi/global_object_folder_jacket/global_variables/global_variables.dart';
import 'package:clapmi/screens/Brag/brag_screen_tu_controller.dart';

import 'package:clapmi/screens/ui_experimentals/ui_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatefulWidget {
  const MainPage(this.navigationShell, {super.key});
  final StatefulNavigationShell navigationShell;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool checkIfCurrentIndexIsTheSameAsItem(int index) {
    return (widget.navigationShell.currentIndex == index);
  }

  int? previousIndex;

  void _refreshWalletSnapshot() {
    final walletBloc = context.read<WalletBloc>();
    walletBloc.add(
      LoadWalletBalances(
        refreshInBackground: walletBloc.assetBalances.isNotEmpty,
      ),
    );
    walletBloc.add(
      GetTransactionsListRecentEvent(
        refreshInBackground: walletBloc.recentTransactions.isNotEmpty,
      ),
    );
    walletBloc.add(
      RecentGiftingEvent(
        refreshInBackground: walletBloc.recentGiftings.isNotEmpty,
      ),
    );
    walletBloc.add(
      GetWalletPropertiesEvent(
        refreshInBackground: walletBloc.walletProperties != null,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //* Only start pusher when user is logged in
      _refreshWalletSnapshot();
    });
  }

  void onTap(int index) {
    try {
      context.read<PostBloc>().add(GetCurrentTabIndexEvent(index: index));
      // if (index != 1) {
      //   BragPageVideoIitialisationController().pauseAll();
      // } else {
      //   try {
      //     BragPageVideoIitialisationController()
      //         .theDisplayedListOfBragAndVideoModel[
      //             BragPageVideoIitialisationController().currentIndex]
      //         .theVideoPlayerController
      //         ?.controller
      //         .play();
      //   } catch (e) {}
      // }

      if (index == 2) {
        context.read<ComboBloc>().add(GetLiveCombosEvent());
        context.read<ComboBloc>().add(GetUpcomingCombosEvent());
      }

      widget.navigationShell.goBranch(
        index,
        // Fix: Set to false to prevent re-initialization when tapping same tab
        // This prevents the chat navbar from always reloading
        initialLocation: false,
      );

      if (index == 4) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _refreshWalletSnapshot();
          }
        });
      }
      print(
          "jbfdksjfkjdsbfkjdbfbsf-before>>${videoPlayerControllerG?.dataSource}");
      bool isFeedTab = (index == 1);
      context.read<VideoFeedProvider>().setFeedVisibility(isFeedTab);
    } catch (e, stackTrace) {
      print("Error in onTap: $e");
      print("StackTrace: $stackTrace");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalScaffoldKey,
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is GetNotificationListErrorState) {
            // Error handling - uncomment if needed
            // ScaffoldMessenger.of(context).showSnackBar(
            //   generalSnackBar(state.errorMessage),
            // );
          }

          if (state is GetNotificationListSuccessState) {
            try {
              List<NotificationEntity> orderedNotification =
                  List.from(state.listOfNotificationEntity);

              orderedNotification.sort((a, b) {
                final aDate = a.createDate;
                final bDate = b.createDate;

                if (aDate == null || bDate == null) return 0;

                try {
                  return DateTime.parse(aDate).compareTo(DateTime.parse(bDate));
                } catch (e) {
                  print("Error parsing dates: $e");
                  return 0;
                }
              });

              List<NotificationEntity> listOfNotificationToShow =
                  orderedNotification.where((element) {
                if (element.readAt != null) return false;
                if (lastNotificationEntity == null) return true;

                final elementDate = element.createDate;
                final lastDate = lastNotificationEntity!.createDate;

                if (elementDate == null || lastDate == null) return false;

                try {
                  return DateTime.parse(lastDate)
                      .isAfter(DateTime.parse(elementDate));
                } catch (e) {
                  print("Error comparing dates: $e");
                  return false;
                }
              }).toList();

              for (var element in listOfNotificationToShow) {
                try {
                  LocalNotificationService.showInstantNotificationWithPayload(
                    title: element.title ?? "no title",
                    body: element.body ?? "no body",
                    payload:
                        element.data != null ? jsonEncode(element.data) : '',
                  );
                } catch (e) {
                  print("Error showing notification: $e");
                }
              }

              if (state.listOfNotificationEntity.isNotEmpty) {
                lastNotificationEntity = state.listOfNotificationEntity.first;
              }
            } catch (e) {}
          }
        },
        builder: (context, state) {
          return SafeArea(
            top: true,
            bottom: false,
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: widget.navigationShell,
                    ),
                    CustomBottomNavBar(
                      currentIndex: widget.navigationShell.currentIndex,
                      items: const <Map<String, String>>[
                        {
                          'icon': 'assets/icons/navButtonHome.png',
                          'label': 'Feeds',
                        },
                        {
                          'icon': 'assets/icons/navButtonbrag.png',
                          'label': 'Brags',
                        },
                        {
                          'icon': 'assets/icons/Live Combo.png',
                          'label': 'Combo Grounds'
                        },
                        {
                          'icon': 'assets/icons/messages.png',
                          'label': 'Chats',
                        },
                        {
                          'icon': 'assets/icons/navbuttonwallet.png',
                          'label': 'Wallet'
                        },
                      ],
                      onTap: onTap,
                    ),
                  ],
                ),
                SurfaceAnimationPanel(),
                // FancyContainer(
                //   height: 45,
                //   child: Text("${[videoPlayerControllerG?.dataSource]}"),
                //   backgroundColor: Colors.deepPurple,
                // )
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final List<Map<String, String>> items;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            currentIndex: currentIndex,
            elevation: 0.0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: Colors.grey[400],
            showSelectedLabels: true,
            showUnselectedLabels: true,
            enableFeedback: true,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            iconSize: 24,
            onTap: (index) => onTap(index),
            items: _buildNavItems(),
          ),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavItems() {
    return List.generate(items.length, (index) {
      final Map<String, String> item = items[index];
      final bool isSelected = currentIndex == index;

      final String iconPath = item['icon'] ?? '';
      final String label = item['label'] ?? '';
      final bool isLiveCombo =
          iconPath.isNotEmpty && iconPath.contains("Live Combo.png");

      return BottomNavigationBarItem(
        icon: _buildNavIcon(iconPath, false, isLiveCombo),
        activeIcon: _buildNavIcon(iconPath, true, isLiveCombo),
        label: label,
        tooltip: label,
      );
    });
  }

  Widget _buildNavIcon(String iconPath, bool isSelected, bool isLiveCombo) {
    if (iconPath.isEmpty) {
      return const Icon(
        Icons.circle,
        size: 24,
      );
    }

    return Image.asset(
      iconPath,
      height: isSelected ? 28.0 : 24.0,
      width: isSelected ? 28.0 : 24.0,
      fit: BoxFit.contain,
      color: isLiveCombo ? null : null, // Let selectedItemColor handle this
      colorBlendMode: isLiveCombo ? null : BlendMode.srcIn,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.error_outline,
          size: 24,
        );
      },
    );
  }
}
