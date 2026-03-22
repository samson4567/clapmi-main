import 'package:clapmi/features/wallet/data/models/transaction.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class TransactionHistory extends StatefulWidget {
  final bool recent;
  final int perPage;

  const TransactionHistory(
      {super.key, required this.recent, required this.perPage});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(WalletUpdateEvent(
          recent: widget.recent,
          perPage: widget.perPage,
          transaction: '',
          operation: '',
          currency: '',
          amount: '',
          date: '',
          status: '',
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(MediaQuery.of(context).padding.top + 16),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: const Icon(Icons.arrow_back_ios)),
                Text(
                  'Transaction History',
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ],
            ),
            const Gap(10),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    context.push(MyAppRouteConstant.transactionFilter);
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/filter.svg',
                          width: 20, height: 20),
                      const Gap(8),
                      Text(
                        'Filter',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.greyTextColor,
                            ),
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.textfieldBg,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search transaction history',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(.5),
                                  ),
                            ),
                          ),
                        ),
                        Icon(Icons.search, color: Colors.white.withOpacity(.5))
                      ],
                    ),
                  ),
                )
              ],
            ),
            const Gap(18),
            Expanded(
              child: BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  if (state is WalletUpdateLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WalletUpdateErrorState) {
                    return Center(child: Text('Error: ${state.errorMessage}'));
                  } else if (state is WalletUpdateSuccessState) {
                    final transactions = state.transactionHistoryModel;

                    if (transactions.isEmpty) {
                      return SizedBox(
                        height: 200,
                        width: 200,
                        child: Image.asset(
                          'assets/images/ode.png',
                          height: 200,
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final tx = transactions[index];
                        return _transactionWidget(context, tx: tx);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _transactionWidget(BuildContext context,
    {required TransactionHistoryModel tx}) {
  return InkWell(
    onTap: () {
      context.push(MyAppRouteConstant.transactionDetail,
          extra: {"transactionID": tx.transaction});
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.grey[900],
                  child: Text('🔁', style: const TextStyle(fontSize: 10)),
                ),
                const Gap(6),
                Expanded(
                  child: Text(
                    tx.transaction,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
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
                  tx.amount,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              tx.currency,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              tx.date,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(
                  tx.status == 'completed'
                      ? Icons.check_circle
                      : Icons.hourglass_bottom,
                  color:
                      tx.status == 'completed' ? Colors.green : Colors.orange,
                  size: 10,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    tx.status,
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
