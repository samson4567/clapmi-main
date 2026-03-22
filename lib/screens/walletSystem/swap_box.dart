import 'package:clapmi/features/wallet/data/models/asset_balance.dart';
import 'package:clapmi/features/wallet/data/models/transaction.dart';
import 'package:clapmi/features/wallet/domain/entities/swap_entity.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/screens/walletSystem/transaction/single_transaction_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SwapBox extends StatefulWidget {
  final bool isWeb3;
  AssetModel payAssets;
  AssetModel receiveAsset;
  List<AssetModel> allAssets;

  SwapBox({
    super.key,
    required this.isWeb3,
    required this.payAssets,
    required this.receiveAsset,
    required this.allAssets,
  });

  @override
  State<SwapBox> createState() => _SwapBoxState();
}

class _SwapBoxState extends State<SwapBox> {
  final TextEditingController payController = TextEditingController();
  final TextEditingController receiveController = TextEditingController();
  List<TransactionHistoryModel> listOfTransactionHistoryModel = [];
  String? orderID;

  String payIconPath = 'assets/images/openmoji_coin 1.png';
  String receiveIconPath = 'assets/images/cryptocurrency-color_usdt.png';
  String payToken = 'CAPP';
  String receiveToken = 'USDT'; // default as USDT
  String payId = '';
  String receiveId = '';
  double payBalance = 12;
  double receiveBalance = 50;
  double payConversionRate = 0.0;
  double payConversionRate2 = 0.0;
  double receiveConversionRate = 0.0;
  AssetModel? recieiveAssetModel;
  AssetModel? sendAssetModel;

  Future showTransactionDetails() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {
            showModalButtom = false;
            setState(() {});
          },
          builder: (context) {
            return SingleTransactionDetail(
                transaction: listOfTransactionHistoryModel.first);
          },
        );
      },
    );
    showModalButtom = false;
  }

  final List<Map<String, String>> receiveTokens = [
    {
      'name': 'USDT',
      'icon': 'assets/images/cryptocurrency-color_usdt.png',
    },
    {
      'name': 'USDC',
      'icon': 'assets/images/usdc.png',
    },
  ];

  final List<Map<String, String>> receiveTokens2 = [
    {
      'name': 'CAPP',
      'icon': 'assets/images/openmoji_coin 1.png',
    },
  ];

  bool isDropdownOpen = false;

  bool showModalButtom = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      payToken = widget.payAssets.name;
      payBalance = double.parse(widget.payAssets.balance);
      sendAssetModel = widget.payAssets;
      recieiveAssetModel = widget.receiveAsset;
      payConversionRate = double.parse(widget.payAssets.conversionRate);
      payId = widget.payAssets.id;

      // Always make USDT first as default receive
      receiveToken = widget.receiveAsset.symbol;
      // 'USDT';
      receiveIconPath = _iconForToken(receiveToken);
      receiveBalance = double.parse(widget.receiveAsset.balance);
      receiveConversionRate = double.parse(widget.receiveAsset.conversionRate);
      receiveId = widget.receiveAsset.id;

      payIconPath = _iconForToken(payToken);
    });

    payController.addListener(() {
      double price = double.tryParse(payController.text) ?? 0.0;
      if (payController.text.isEmpty) {
        receiveController.text = '';
        return;
      }

      double result;
      payConversionRate2 = double.parse(recieiveAssetModel!.conversionRate) /
          double.parse(sendAssetModel!.conversionRate);
      result = price / payConversionRate2;

      // if (payToken == 'CAPP') {
      //   result = price * payConversionRate;
      // } else {
      //   result = price / payConversionRate;
      // }

      receiveController.text =
          result.toString(); // exact number, no trailing zeros
    });
  }

  String _iconForToken(String token) {
    switch (token) {
      case 'USDT':
        return 'assets/images/cryptocurrency-color_usdt.png';
      case 'USDC':
        return 'assets/images/usdc.png';
      default:
        return 'assets/images/openmoji_coin 1.png';
    }
  }

  @override
  void dispose() {
    payController.dispose();
    receiveController.dispose();
    super.dispose();
  }

  void _swapTiles() {
    setState(() {
      final tempToken = payToken;
      payToken = receiveToken;
      receiveToken = tempToken;
      recieiveAssetModel = widget.allAssets
          .where(
            (element) => element.name == receiveToken,
          )
          .firstOrNull;
      sendAssetModel = widget.allAssets
          .where(
            (element) => element.name == payToken,
          )
          .firstOrNull;

      final tempBalance = payBalance;
      payBalance = receiveBalance;
      receiveBalance = tempBalance;

      final tempId = payId;
      payId = receiveId;
      receiveId = tempId;

      final tempConversionRate = payConversionRate;
      payConversionRate = receiveConversionRate;
      receiveConversionRate = tempConversionRate;

      payIconPath = _iconForToken(payToken);
      receiveIconPath = _iconForToken(receiveToken);

      final tempText = payController.text;
      payController.text = receiveController.text;
      receiveController.text = tempText;
    });
  }

  void _performSwap() {
    final amount = double.tryParse(payController.text) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount')),
      );
      return;
    }

    final allowedPairs = [
      'CAPP-USDT',
      'CAPP-USDC',
      'USDT-CAPP',
      'USDC-CAPP',
    ];
    final pair = '$payToken-$receiveToken';
    if (!allowedPairs.contains(pair)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid swap pair')),
      );
      return;
    }
    print('nnjkjjjkjjkjjjjjkjk-performswap${[receiveToken, payToken]}');
    print('nnjkjjjkjjkjjjjjkjk-performswap2${[payId, receiveId]}');
    context.read<WalletBloc>().add(
          SwapEvent(
            swapCoinEntity: SwapEntity(
              from: payId,
              to: receiveId,
              amount: payController.text,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state is SwapErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        } else if (state is SwapSuccessState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(generalSnackBar('swap succesful')
                  // SnackBar(content: Text('${state.swapModels} ✅')),
                  );
          payController.clear();
          receiveController.clear();
          orderID = state.orderID;

          context.read<WalletBloc>().add(LoadWalletBalances());
          context.read<WalletBloc>().add(GetTransactionsListRecentEvent());
          showModalButtom = true;
          print("dskjgaisjdkjsadjbaskdj>>${[payBalance, receiveBalance]}");

          // ?sjgdjd
        }
        if (state is WalletLoaded) {
          setState(() {
            widget.allAssets = state.balances;

            payBalance = double.tryParse(state.balances
                        .where(
                          (element) => sendAssetModel?.id == element.id,
                        )
                        .firstOrNull
                        ?.balance ??
                    "0") ??
                payBalance;
            receiveBalance = double.tryParse(state.balances
                        .where(
                          (element) => recieiveAssetModel?.id == element.id,
                        )
                        .firstOrNull
                        ?.balance ??
                    "0") ??
                receiveBalance;
          });
          setState(() {});
        }
        if (state is GetTransactionsListRecentErrorState) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   generalSnackBar(state.errorMessage),
          // );
        }

        if (state is GetTransactionsListRecentSuccessState) {
          listOfTransactionHistoryModel = state.listOfTransactionHistoryModel;
          print('fghjfggffmfg${[
            // listOfTransactionHistoryModel.first,
            // listOfTransactionHistoryModel.last
            orderID
          ]}');
          if (showModalButtom) {
            showTransactionDetails();
          }
        }
      },
      builder: (context, state) {
        final isLoading = state is SwapLoadingState;
        return AbsorbPointer(
          absorbing: isLoading,
          child: Stack(
            children: [
              _buildMainCard(),
              if (isLoading) _buildLoader(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Swap',
            //  ${sendAssetModel?.name}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _swapTile(
            title: 'You Pay',
            token: payToken,
            controller: payController,
            usdValue: payConversionRate,
            balance: payBalance,
            iconPath: payIconPath,
            showDropdown: false,
          ),
          const SizedBox(height: 12),
          Center(
            child: GestureDetector(
              onTap: _swapTiles,
              child: Image.asset('assets/images/swap.png', width: 40),
            ),
          ),
          const SizedBox(height: 12),
          _swapTile(
            title: 'You Receive',
            token: receiveToken,
            controller: receiveController,
            usdValue: receiveConversionRate,
            balance: receiveBalance,
            iconPath: receiveIconPath,
            showDropdown: true,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _performSwap,
              child: const Text(
                'Swap',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _swapTile({
    required String title,
    required String token,
    required TextEditingController controller,
    required double usdValue,
    required double balance,
    required String iconPath,
    required bool showDropdown,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(color: Colors.blue, fontSize: 28),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              GestureDetector(
                onTap: showDropdown
                    ? () {
                        setState(() {
                          isDropdownOpen = !isDropdownOpen;
                        });
                      }
                    : null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D3D3D),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(iconPath, width: 24, height: 24),
                      const SizedBox(width: 6),
                      Text(
                        token,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                      if (showDropdown)
                        Icon(
                          isDropdownOpen
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          color: Colors.white70,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (isDropdownOpen && showDropdown)
            Container(
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                children: ((token == 'CAPP') ? receiveTokens2 : receiveTokens)
                    .map((t) {
                  return InkWell(
                    onTap: () {
                      recieiveAssetModel = widget.allAssets
                          .where(
                            (element) => element.name == receiveToken,
                          )
                          .firstOrNull;
                      setState(() {
                        receiveToken = t['name']!;
                        receiveId = widget.allAssets
                            .where(
                              (element) => element.name == receiveToken,
                            )
                            .first
                            .id;
                        receiveIconPath = t['icon']!;
                        isDropdownOpen = false;
                        _recalculate();
                      });
                      print('nnjkjjjkjjkjjjjjkjk${[receiveToken, payToken]}');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: Row(
                        children: [
                          Image.asset(t['icon']!, width: 22, height: 22),
                          const SizedBox(width: 8),
                          Text(
                            t['name']!,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '\$$usdValue',
                style: const TextStyle(color: Colors.white38, fontSize: 13),
              ),
              const Spacer(),
              Text(
                '$balance $token',
                style: const TextStyle(color: Colors.white38, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _recalculate() {
    final amount = double.tryParse(payController.text) ?? 0;
    if (payController.text.isEmpty) {
      receiveController.text = '';
      return;
    }
    double result;
    payConversionRate2 = double.parse(recieiveAssetModel!.conversionRate) /
        double.parse(sendAssetModel!.conversionRate);
    result = amount / payConversionRate2;
    // if (payToken == 'CAPP') {
    //   result = amount * payConversionRate;
    // } else {
    //   result = amount / payConversionRate;
    // }
    receiveController.text = result.toString(); // exact number
  }

  Widget _buildLoader() => Positioned.fill(
        child: Container(
          color: Colors.black45,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
}
