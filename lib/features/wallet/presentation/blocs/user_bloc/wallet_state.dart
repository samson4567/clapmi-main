// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clapmi/features/wallet/data/models/paywith_transfer_enity.dart';
import 'package:clapmi/features/wallet/domain/entities/bank_details.dart';
import 'package:clapmi/features/wallet/domain/entities/confirm_address_entity.dart';
import 'package:clapmi/features/wallet/domain/entities/get_user_kyc_status_response_entity.dart';
import 'package:clapmi/features/wallet/domain/entities/kyc_entityes.dart';
import 'package:clapmi/features/wallet/domain/entities/kyc_intiate_entiy.dart';
import 'package:clapmi/features/wallet/domain/entities/wallet_properties.dart';
import 'package:equatable/equatable.dart';
import 'package:clapmi/features/wallet/data/models/recent_gifting_transaction.dart';
import 'package:clapmi/features/wallet/data/models/transaction.dart';
import 'package:clapmi/features/wallet/domain/entities/asset_entity.dart';
import 'package:reown_appkit/reown_appkit.dart';

import '../../../data/models/asset_balance.dart';

sealed class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

final class WalletInitial extends WalletState {
  const WalletInitial();
}

final class WalletUpdateLoadingState extends WalletState {
  const WalletUpdateLoadingState();
}

final class WalletUpdateSuccessState extends WalletState {
  final List<TransactionHistoryModel> transactionHistoryModel;

  const WalletUpdateSuccessState({required this.transactionHistoryModel});

  @override
  List<Object> get props => [transactionHistoryModel];
}

final class WalletUpdateErrorState extends WalletState {
  final String errorMessage;

  const WalletUpdateErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final List<AssetModel> balances;

  const WalletLoaded({required this.balances});

  @override
  List<Object> get props => [balances];
}

class WalletError extends WalletState {
  final String message;

  const WalletError({required this.message});

  @override
  List<Object> get props => [message];
}

// GetTransactionsDetail
final class GetTransactionsDetailLoadingState extends WalletState {
  const GetTransactionsDetailLoadingState();
}

final class GetTransactionsDetailSuccessState extends WalletState {
  final TransactionHistoryModel? transactionHistoryModel;

  const GetTransactionsDetailSuccessState(
      {required this.transactionHistoryModel});

  @override
  List<Object> get props => [transactionHistoryModel ?? ""]; // Updated props
}

final class GetTransactionsDetailErrorState extends WalletState {
  final String errorMessage;

  const GetTransactionsDetailErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// GetTransactionsListRecent
final class GetTransactionsListRecentLoadingState extends WalletState {
  const GetTransactionsListRecentLoadingState();
}

final class GetTransactionsListRecentSuccessState extends WalletState {
  final List<TransactionHistoryModel> listOfTransactionHistoryModel;

  const GetTransactionsListRecentSuccessState(
      {required this.listOfTransactionHistoryModel});

  @override
  List<Object> get props => [listOfTransactionHistoryModel]; // Updated props
}

final class GetTransactionsListRecentErrorState extends WalletState {
  final String errorMessage;

  const GetTransactionsListRecentErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

//recent gifiting

final class RecentGiftingLoadingState extends WalletState {
  const RecentGiftingLoadingState();
}

final class RecentGiftingSuccessState extends WalletState {
  final List<RecentGiftingModel> recentGiftings;

  const RecentGiftingSuccessState(this.recentGiftings);

  @override
  List<Object> get props => [recentGiftings];
}

final class RecentGiftingErrorState extends WalletState {
  final String errorMessage;

  const RecentGiftingErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

//  SwapModel

// ── Swap States ──
final class SwapLoadingState extends WalletState {
  const SwapLoadingState();

  @override
  List<Object> get props => [];
}

final class SwapSuccessState extends WalletState {
  final String swapModels;
  final String orderID;
  const SwapSuccessState(this.swapModels, this.orderID);

  @override
  List<Object> get props => [swapModels];
}

final class SwapErrorState extends WalletState {
  final String errorMessage;
  const SwapErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// Gift user
final class GiftUserLoadingState extends WalletState {
  const GiftUserLoadingState();

  @override
  List<Object> get props => [];
}

class GiftUserSuccessState extends WalletState {
  final String message;

  const GiftUserSuccessState(this.message);
}

final class GiftUserErrorState extends WalletState {
  final String errorMessage;
  const GiftUserErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class WalletAddressLoaded extends WalletState {
  final List<WalletAddress> walletAdrresses;
  const WalletAddressLoaded(this.walletAdrresses);

  @override
  List<Object> get props => [walletAdrresses];
}

class WalletAddressUSDC extends WalletState {
  final List<WalletUSDCAddress> walletAdrressesUSDC;
  const WalletAddressUSDC(this.walletAdrressesUSDC);
  @override
  List<Object> get props => [walletAdrressesUSDC];
}

class FAAuthCodeSent extends WalletState {
  final String message;
  const FAAuthCodeSent({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class VerifiedCodeSent extends WalletState {
  final String message;
  const VerifiedCodeSent({required this.message});
  @override
  List<Object> get props => [message];
}

class VerifiedForgotPin extends WalletState {
  final String message;
  const VerifiedForgotPin({required this.message});
  @override
  List<Object> get props => [message];
}

class WithdrawalPinCreated extends WalletState {
  final String message;
  const WithdrawalPinCreated(this.message);

  @override
  List<Object> get props => [message];
}

class AvailableClappCoinLoaded extends WalletState {
  final String amount;
  const AvailableClappCoinLoaded(this.amount);
  @override
  List<Object> get props => [amount];
}

class WalletPropertiesLoaded extends WalletState {
  final WalletPropertiesEntity walletProperties;
  const WalletPropertiesLoaded({required this.walletProperties});

  @override
  List<Object> get props => [walletProperties];
}

class WithdrawalSuccessful extends WalletState {
  final String message;
  const WithdrawalSuccessful({required this.message});
  @override
  List<Object> get props => [message];
}

class WalletConnected extends WalletState {
  final ReownAppKit? appkit;
  const WalletConnected({required this.appkit});

  @override
  List<Object> get props => [appkit!];
}

class CheckOut extends WalletState {
  final (String, String) checkoutEntity;
  const CheckOut({required this.checkoutEntity});
  @override
  List<Object> get props => [checkoutEntity];
}

class BanksDataLoaded extends WalletState {
  final List<BankDataEntity> banksData;
  const BanksDataLoaded({required this.banksData});
  @override
  List<Object> get props => [banksData];
}

class AccountVerified extends WalletState {
  final BankDetails bankDetails;
  const AccountVerified({required this.bankDetails});

  @override
  List<Object> get props => [bankDetails];
}

class BankAdded extends WalletState {
  final AddBankRequest addedBank;
  const BankAdded({required this.addedBank});

  @override
  List<Object> get props => [addedBank];
}

class UserBankAccounts extends WalletState {
  final List<AddBankRequest> banks;
  const UserBankAccounts({required this.banks});

  @override
  List<Object> get props => [banks];
}
// PaystackPaymentgateway

class QuoteRetrieved extends WalletState {
  final GetQuoteRequest quoteInfo;
  const QuoteRetrieved({required this.quoteInfo});

  @override
  List<Object> get props => [quoteInfo];
}

class OrderCreated extends WalletState {
  final String message;
  const OrderCreated({required this.message});
  @override
  List<Object> get props => [message];
}

class ResetPin extends WalletState {
  final String message;
  const ResetPin({required this.message});
  @override
  List<Object> get props => [message];
}

class QuoteRetrievedDeposit extends WalletState {
  final GetQuoteRequestModelDeposit quoteInfo;
  const QuoteRetrievedDeposit({
    required this.quoteInfo,
  });

  @override
  List<Object> get props => [quoteInfo];
}

class VerifyOrderStstus extends WalletState {
  final String message;
  const VerifyOrderStstus({required this.message});
  @override
  List<Object> get props => [message];
}

class GenerateForgotPinOTP extends WalletState {
  final String message;
  const GenerateForgotPinOTP({required this.message});
  @override
  List<Object> get props => [message];
}

class ConfirmAddressDeposit extends WalletState {
  final ConfirmAddressDepositEntity depositModel;

  const ConfirmAddressDeposit({required this.depositModel});

  @override
  List<Object> get props => [depositModel];
}

class GetUserKYCStatusLoadingState extends WalletState {
  const GetUserKYCStatusLoadingState();

  // List<Object> get props => [errorMessage];
}

class GetUserKYCStatusSuccessState extends WalletState {
  final GetUserKycStatusResponseEntity theGetUserKycStatusResponseEntity;

  const GetUserKYCStatusSuccessState(
      {required this.theGetUserKycStatusResponseEntity});

  @override
  List<Object> get props => [theGetUserKycStatusResponseEntity];
}

class GetUserKYCStatusErrorState extends WalletState {
  final String errorMessage;

  const GetUserKYCStatusErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class KycInitiateSuccess extends WalletState {
  final KycVerificationEntity data;

  const KycInitiateSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class KycUploadSuccess extends WalletState {
  final KycUploadEntity data;

  const KycUploadSuccess({required this.data});

  @override
  List<Object> get props => [data];
}
// GetUserKYCStatus
