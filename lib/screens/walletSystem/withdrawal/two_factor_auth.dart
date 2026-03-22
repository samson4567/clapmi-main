import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class TwoFactorAuth extends StatelessWidget {
  const TwoFactorAuth(
      {super.key, this.orderId, this.amount, this.address, this.network});
  final String? orderId;
  final String? amount;
  final String? network;
  final String? address;

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state is FAAuthCodeSent) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
          if (orderId != null && orderId?.isNotEmpty == true) {
            context.push(MyAppRouteConstant.walletEmailVerification, extra: {
              'isEnterOtp': false,
              'orderId ': orderId,
            });
          } else {
            context.push(MyAppRouteConstant.walletEmailVerification, extra: {
              'isEnterOtp': false,
              'amount ': amount,
              'network': network,
              'address': address,
            });
          }
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(MediaQuery.paddingOf(context).top + 16),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: Navigator.of(context).pop,
                  child: const Icon(Icons.arrow_back_ios),
                ),
              ),
              const Gap(8),
              Text(
                'Two Factor Authentication',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
              ),
              const Gap(16),
              Text(
                'Protect your account and transactions',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(.5),
                    ),
                textAlign: TextAlign.center,
              ),
              const Gap(32),
              Image.asset('assets/images/two-factor.png'),
              const Gap(16),
              Text(
                'A confirmation code will be sent to your email, Input the code and proceed with withdrawal',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: PillButton(
                      backgroundColor: AppColors.greyColor,
                      onTap: Navigator.of(context).pop,
                      child: Text(
                        'Back',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: PillButton(
                      onTap: () {
                        context.read<WalletBloc>().add(Send2FACodeEvent());
                      },
                      child: Text(
                        'Continue',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(MediaQuery.paddingOf(context).bottom + 16),
            ],
          ),
        ),
      ),
    );
  }
}
