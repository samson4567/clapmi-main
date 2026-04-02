import 'package:clapmi/features/wallet/data/models/asset_balance.dart';
import 'package:clapmi/features/wallet/data/models/transaction.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/error_widget.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:clapmi/screens/walletSystem/swap_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'asset_box.dart';
import 'balance_card.dart';

class WalletView extends StatefulWidget {
  // final Function() connectWalletCallback;
  const WalletView({
    super.key,
  });

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  bool isClapmiSelected = true;
  List<AssetModel> balances = [];
  bool isWalletLoaded = false;

  // ReownAppKitModal? _appKitModal;
  double totalBalance = 0.0;

  // void initializeModa() async {
  //   try {
  //     if (_appKitModal != null) {
  //       await _appKitModal?.init();
  //       // await _appKitModal?.connectSelectedWallet();
  //     }
  //   } catch (e) {
  //     print('appkitModal error is this ------- $e');
  //   }
  // }

  // void connectionUr() async {
  //   await _appKitModal?.buildConnectionUri();
  // }

  @override
  void initState() {
    super.initState();
    _hydrateFromWalletBlocCache();
    _loadWalletHomeData();
  }

  List<TransactionHistoryModel> listOfTransactionHistoryModel = [];

  void _hydrateFromWalletBlocCache() {
    final walletBloc = context.read<WalletBloc>();

    if (walletBloc.assetBalances.isNotEmpty) {
      final cachedBalances = walletBloc.assetBalances;
      final computedTotal = cachedBalances.fold<double>(0.0, (sum, coin) {
        final parsedBalance = double.tryParse(coin.balance) ?? 0.0;
        return sum +
            (coin.name == 'CAPP' ? parsedBalance / 100 : parsedBalance);
      });

      balances = cachedBalances;
      totalBalance = computedTotal;
      isWalletLoaded = true;
    }

    if (walletBloc.recentTransactions.isNotEmpty) {
      listOfTransactionHistoryModel = walletBloc.recentTransactions;
    }
  }

  void _loadWalletHomeData() {
    final walletBloc = context.read<WalletBloc>();
    if (walletBloc.recentTransactions.isEmpty) {
      walletBloc.add(GetTransactionsListRecentEvent());
    }
    if (walletBloc.assetBalances.isEmpty) {
      walletBloc.add(LoadWalletBalances());
    }
    if (walletBloc.recentGiftings.isEmpty) {
      walletBloc.add(const RecentGiftingEvent());
    }
  }

  Future<void> _refreshWalletHomeData() async {
    _loadWalletHomeData();
  }

  void _updateWalletBalances(List<AssetModel> nextBalances) {
    final computedTotal = nextBalances.fold<double>(0.0, (sum, coin) {
      final parsedBalance = double.tryParse(coin.balance) ?? 0.0;
      return sum + (coin.name == 'CAPP' ? parsedBalance / 100 : parsedBalance);
    });

    setState(() {
      isWalletLoaded = true;
      balances = nextBalances;
      totalBalance = computedTotal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            _tabItem(
                title: 'Clapmi Wallet',
                selected: isClapmiSelected,
                onTap: () {
                  setState(() => isClapmiSelected = true);
                }),
            const SizedBox(width: 16),
            _tabItem(
                title: '',
                selected: !isClapmiSelected,
                onTap: () {
                  // setState(() => isClapmiSelected = false);
                }),
          ],
        ),
      ),
      body: Builder(
        builder: (context) {
          // WalletModel? walletData;
          // if (walletState is WalletLoaded) walletData = walletState.walletData;
          return RefreshIndicator(
            onRefresh: _refreshWalletHomeData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: BlocConsumer<WalletBloc, WalletState>(
                  listener: (context, state) {
                if (state is GetTransactionsListRecentErrorState) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: errorWidget(state.errorMessage)));
                }

                if (state is GetTransactionsListRecentSuccessState) {
                  listOfTransactionHistoryModel =
                      state.listOfTransactionHistoryModel;
                }

                if (state is WalletLoaded) {
                  _updateWalletBalances(state.balances);
                }
                // if (state is WalletConnected) {
                //   _appKitModal = ReownAppKitModal(
                //     context: context,
                //     appKit: state.appkit,
                //   );
                //   initializeModa();
                // }
              }, builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.all(8),
                    //   margin: const EdgeInsets.only(bottom: 16),
                    //   decoration: BoxDecoration(
                    //     color: Colors.red.withOpacity(0.1),
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    // ),
                    // if (_appKitModal != null)
                    //   AppKitModalConnectButton(appKit: _appKitModal!),
                    BalanceCard(
                      isWeb3: isClapmiSelected,
                      usdtAmount: balances.length >= 2
                          ? '${double.tryParse(balances.last.balance)?.toStringAsFixed(3)}'
                          : '0.00',
                      displayBalance: totalBalance.toStringAsFixed(2),

                      // '\$ ${double.tryParse((isClapmiSelected ? balances.first : balances.last).balance)?.toStringAsFixed(3)}'

                      connectWalletCallBack: () {
                        // _appKitModal
                        //     ?.openModalView(ReownAppKitModalAllWalletsPage());
                        // context.read<WalletBloc>().add(ConnectWalletEvent());
                      },
                      testingCallBack: () {
                        //  connectionUr();
                      },
                    ),
                    const SizedBox(height: 20),
                    if (isWalletLoaded)
                      SwapBox(
                        isWeb3: !isClapmiSelected,
                        payAssets: balances.where(
                          (element) {
                            // CAPP
                            return element.name == "CAPP";
                          },
                        ).first,
                        receiveAsset: balances.where(
                          (element) {
                            // CAPP
                            return element.name != "CAPP";
                          },
                        ).first,
                        //  balances.elementAt(balances.length - 2),
                        allAssets: balances,
                      ),
                    const SizedBox(height: 20),
                    AssetBox(balances: balances),
                    const SizedBox(height: 20),
                    _section(
                      'Transaction history',
                      route: MyAppRouteConstant.transactionHistory,
                      seeAllIsVisible: listOfTransactionHistoryModel.isNotEmpty,
                    ),
                    const SizedBox(height: 12),
                    _buildTransactionList(),
                    SizedBox(height: 20.h),
                    _section(
                      'Recent Giftings',
                      route: MyAppRouteConstant.allRecentGifting,
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<WalletBloc, WalletState>(
                      builder: (context, state) {
                        if (state is RecentGiftingLoadingState) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[800]!,
                            highlightColor: Colors.grey[700]!,
                            child: Column(
                              children: List.generate(
                                3,
                                (index) => Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 120,
                                              height: 14,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(height: 6),
                                            Container(
                                              width: 80,
                                              height: 12,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else if (state is RecentGiftingSuccessState) {
                          print(
                              "This is the gifting @@@@@@@@@@@@@@ ${state.recentGiftings}");
                          final giftings = state.recentGiftings;
                          print('let ${giftings.length}');
                          if (giftings.isEmpty) {
                            return const Center(
                                child: Text('No recent giftings found.'));
                          }
                          return Column(
                            children: List.generate(giftings.length, (index) {
                              final gifting = giftings[index];
                              return _singleGiftingWidget(
                                context,
                                outgoing: gifting.gifter == null,
                                dollarAmount:
                                    int.tryParse(gifting.amount ?? '0') ?? 0,
                                coinAmount:
                                    int.tryParse(gifting.amount ?? '0') ?? 0,
                                account: gifting.gifter == null
                                    ? gifting.receiver?.username ?? ''
                                    : gifting.gifter?.username ?? '',
                                date: gifting.metaData?.date ?? '',
                              );
                            }),
                          );
                        } else if (state is RecentGiftingErrorState) {
                          return Center(
                              child: Row(
                            children: [
                              Icon(
                                Icons.wifi,
                                size: 23.w,
                                color: Colors.white,
                              ),
                              Text("Unable to Load data"),
                            ],
                          ));
                        } else {
                          // Trigger fetching event when the screen loads or state is not yet handled
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }

  Widget _tabItem(
      {required String title,
      required bool selected,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 22),
        decoration: BoxDecoration(
            // border: Border(
            //   bottom: BorderSide(
            //       color: selected ? Colors.blue : Colors.transparent, width: 2),
            // ),
            ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _section(
    String title, {
    required String route,
    bool seeAllIsVisible = true,
  }) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        Spacer(),
        if (seeAllIsVisible)
          InkWell(
              onTap: () {
                context.push(route);
              },
              child: const Text('See all',
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ))),
      ],
    );
  }

  Widget _buildTransactionList() {
    return (listOfTransactionHistoryModel.isEmpty)
        ? Center(
            child: SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(
                'assets/images/ode.png',
                height: 200,
              ),
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row - FIXED ALIGNMENT
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text('Operation',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('Status',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          textAlign: TextAlign.center),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('Currency',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          textAlign: TextAlign.center),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('Amount',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          textAlign: TextAlign.center),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('Date',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          textAlign: TextAlign.end),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.grey, height: 1),
              const SizedBox(height: 6),

              // Transaction Items
              ...listOfTransactionHistoryModel.map(
                (tx) => InkWell(
                  onTap: () {
                    context.push(
                      MyAppRouteConstant.transactionDetail,
                      extra: tx,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // 1️⃣ OPERATION
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.grey[900],
                                child: Text(
                                  tx.operation == "swap" ? "🔁" : "💸",
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _capitalizeFirst(tx.operation),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 2️⃣ STATUS
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                tx.status == 'completed'
                                    ? Icons.check_circle
                                    : Icons.hourglass_bottom,
                                color: tx.status == 'completed'
                                    ? Colors.green
                                    : Colors.orange,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  _capitalizeFirst(tx.status),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 10),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 3️⃣ CURRENCY - FIXED ALIGNMENT
                        Expanded(
                          flex: 2,
                          child: Text(
                            tx.currency,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        // 4️⃣ AMOUNT
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  "assets/images/openmoji_coin 1.png",
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                tx.amount.split(".").first,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 10),
                              ),
                            ],
                          ),
                        ),

                        // 5️⃣ DATE
                        Expanded(
                          flex: 2,
                          child: Text(
                            tx.date,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 10),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }

// Helper method for capitalization
  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Widget _singleGiftingWidget(
    BuildContext context, {
    bool outgoing = false,
    required int dollarAmount,
    required int coinAmount,
    required String account,
    required String date,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          border: const Border(
              bottom: BorderSide(
            color: Color(0xFF3D3D3D),
            width: .5,
          )),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: outgoing
                          ? const Color(0xFF4E0703)
                          : const Color(0xFF032F07),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/${outgoing ? 'outgoing' : 'incoming'}.svg',
                      height: 32,
                      width: 32,
                    ),
                  ),
                  const Gap(16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '-\$  ${dollarAmount / 100}',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const Gap(8),
                      Row(
                        children: [
                          Text.rich(
                            overflow: TextOverflow.ellipsis,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Gifted',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.greyTextColorVariant,
                                      ),
                                ),
                                TextSpan(
                                  text: ' @$account',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.primaryColor,
                                      ),
                                ),
                                TextSpan(
                                  text: ' $coinAmount',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.greyTextColorVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          ClipOval(
                            child: Image.asset(
                              "assets/images/coin_big.png",
                              width: 20,
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              date,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 10, color: AppColors.greyTextColorVariant),
            )
          ],
        ),
      );
}
