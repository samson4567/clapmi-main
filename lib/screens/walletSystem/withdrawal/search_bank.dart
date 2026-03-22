import 'package:clapmi/features/wallet/data/models/bank_details_model.dart';
import 'package:clapmi/features/wallet/domain/entities/bank_details.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class BankSearchScreen extends StatefulWidget {
  const BankSearchScreen({super.key});

  @override
  State<BankSearchScreen> createState() => _BankSearchScreenState();
}

class _BankSearchScreenState extends State<BankSearchScreen> {
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController searchBankController = TextEditingController();

  List<BankDataEntity> banks = [];
  BankDataEntity? selectedBank;
  bool isLoading = false;
  bool showBankList = false;
  String showAccountName = '';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state is WalletError) {
          setState(() {
            isLoading = false;
            showBankList = false;
          });
        }
        if (state is BankAdded) {
          context.pop(state.addedBank);
        }
        if (state is WalletLoading) {
          setState(() {
            isLoading = true;
            showBankList = false;
          });
        }
        if (state is BanksDataLoaded) {
          setState(() {
            isLoading = false;
            showBankList = true;
          });
          banks = state.banksData;
        }
        if (state is AccountVerified) {
          setState(() {
            isLoading = false;
            showBankList = false;
          });
          print(
              '-----------------theuhuhuhsuhduhsuhs fhdhdsdysydsuhyahyda aydyadsydys');
          showAccountName = state.bankDetails.accountName ?? '';
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(MediaQuery.paddingOf(context).top + 16),
                //**This is the header */
                Row(
                  children: [
                    InkWell(
                      onTap: context.pop,
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                _customTextfield(
                  context,
                  title: 'Enter Account Number',
                  hintText: 'Account number',
                  controller: accountNumberController,
                  keyboardType: TextInputType.number,
                  onChanged: (p0) {
                    if (p0?.length == 10) {
                      print('the length is now 10');
                      FocusNode().unfocus();
                      context.read<WalletBloc>().add(GetAvailableBanksEvent());
                    }
                  },
                ),
                _customTextfield(context,
                    hintText: 'Search bank name',
                    controller: searchBankController),
                if (isLoading) CircularProgressIndicator.adaptive(),
                if (showAccountName.isNotEmpty)
                  Padding(
                      padding: EdgeInsetsGeometry.only(top: 8),
                      child: Text(showAccountName)),
                if (showBankList)
                  Expanded(
                    child: Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(3)),
                      child: ListView.builder(
                          itemCount: banks.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                //Where the selected bank code would be taking;
                                selectedBank = banks[index];
                                setState(() {
                                  searchBankController.text =
                                      banks[index].name ?? '';
                                });
                                context.read<WalletBloc>().add(
                                    VerifyBankAccountEvent(
                                        accountNumber:
                                            accountNumberController.text,
                                        bankCode: banks[index].code ?? ''));
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 4),
                                child: Row(
                                  children: [
                                    //  Image.network(),
                                    Text(
                                      banks[index].name ?? '',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                if (showBankList == false) Spacer(),
                //**Checkout button */
                GestureDetector(
                  onTap: () {
                    final addBank = AddBankRequestModel(
                        bankName: selectedBank?.name ?? '',
                        accountNumber: accountNumberController.text,
                        accountName: showAccountName,
                        bankCode: selectedBank?.code ?? '');
                    context
                        .read<WalletBloc>()
                        .add(AddUserBankAccountEvent(addBank: addBank));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        color: AppColors.primaryColor),
                    child: Center(
                      child: Text(
                        'Add Account',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _customTextfield(
  BuildContext context, {
  String? title,
  required String hintText,
  TextInputType? keyboardType,
  required TextEditingController controller,
  void Function(String?)? onChanged,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.greyTextColorVariant,
                ),
          ),
        const Gap(16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF121212),
            border: Border.all(
              color: const Color(0xFF3D3D3D),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
            onChanged: onChanged,
          ),
        )
      ],
    );
