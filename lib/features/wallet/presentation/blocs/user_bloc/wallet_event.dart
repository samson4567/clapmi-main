import 'package:clapmi/features/wallet/data/models/bank_details_model.dart';
import 'package:clapmi/features/wallet/data/models/kyc_upload_model.dart';
import 'package:clapmi/features/wallet/data/models/paywith_transfer_enity.dart';
import 'package:clapmi/features/wallet/domain/entities/asset_entity.dart';
import 'package:clapmi/features/wallet/domain/entities/bank_details.dart';
import 'package:clapmi/features/wallet/domain/entities/confirm_address_entity.dart';
import 'package:clapmi/features/wallet/domain/entities/gift_user.dart';
import 'package:clapmi/features/wallet/domain/entities/swap_entity.dart';
import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

class WalletUpdateEvent extends WalletEvent {
  final bool recent;
  final int perPage;
  final String transaction;
  final String operation;
  final String currency;
  final String amount;
  final String date;
  final String status;

  const WalletUpdateEvent({
    required this.recent,
    required this.perPage,
    required this.transaction,
    required this.operation,
    required this.currency,
    required this.amount,
    required this.date,
    required this.status,
  });

  @override
  List<Object> get props => [
        recent,
        perPage,
        transaction,
        operation,
        currency,
        amount,
        date,
        status,
      ];
}

class LoadWalletBalances extends WalletEvent {}

// GetTransactionsDetail
final class GetTransactionsDetailEvent extends WalletEvent {
  final String transactionID;
  const GetTransactionsDetailEvent(this.transactionID);

  @override
  List<Object> get props => [transactionID];
}

final class GetTransactionsListRecentEvent extends WalletEvent {
  const GetTransactionsListRecentEvent();

  @override
  List<Object> get props => [];
}

//  RecentGifting

final class RecentGiftingEvent extends WalletEvent {
  const RecentGiftingEvent();

  @override
  List<Object> get props => [];
}

// Swap
class SwapEvent extends WalletEvent {
  final SwapEntity swapCoinEntity;

  const SwapEvent({required this.swapCoinEntity});
}
// gift

class GiftUserEvent extends WalletEvent {
  final GiftUserEntity giftClapPointRequestEntity;

  const GiftUserEvent({required this.giftClapPointRequestEntity});
}

class GetWalletAddressEvent extends WalletEvent {
  const GetWalletAddressEvent();
}

class GetWalletAddressUSDCEvent extends WalletEvent {
  const GetWalletAddressUSDCEvent();
}

class Send2FACodeEvent extends WalletEvent {
  const Send2FACodeEvent();
}

class Verify2FACodeEvent extends WalletEvent {
  const Verify2FACodeEvent(this.otpCode);
  final String otpCode;
}

class CreateWithdrawalPinEvent extends WalletEvent {
  final String pin;
  final String confirmPin;
  const CreateWithdrawalPinEvent({required this.pin, required this.confirmPin});

  @override
  List<Object> get props => [pin, confirmPin];
}

class GetAvailableCoinEvent extends WalletEvent {
  const GetAvailableCoinEvent();
}

class GetWalletPropertiesEvent extends WalletEvent {
  const GetWalletPropertiesEvent();
}

class InitiateWithDrawalEvent extends WalletEvent {
  final InitiateWithdrawalRequest request;
  const InitiateWithDrawalEvent({required this.request});
}

// class ConnectWalletEvent extends WalletEvent {
//   const ConnectWalletEvent();
// }

class BuyPointEvent extends WalletEvent {
  final BuyPointEntity buypoint;
  const BuyPointEvent({required this.buypoint});
  @override
  List<Object> get props => [buypoint];
}

class GetAvailableBanksEvent extends WalletEvent {
  const GetAvailableBanksEvent();
}

class VerifyBankAccountEvent extends WalletEvent {
  const VerifyBankAccountEvent(
      {required this.accountNumber, required this.bankCode});
  final String accountNumber;
  final String bankCode;

  @override
  List<Object> get props => [accountNumber, bankCode];
}

class AddUserBankAccountEvent extends WalletEvent {
  const AddUserBankAccountEvent({required this.addBank});
  final AddBankRequestModel addBank;

  @override
  List<Object> get props => [addBank];
}

class GetUserBankAccount extends WalletEvent {
  const GetUserBankAccount();
}

class GetQuoteEvent extends WalletEvent {
  const GetQuoteEvent({required this.request});
  final GetQuoteRequest request;

  @override
  List<Object> get props => [request];
}

class CreateOrderEvent extends WalletEvent {
  final String orderId;
  final String idempotencykey;
  const CreateOrderEvent({required this.orderId, required this.idempotencykey});

  @override
  List<Object> get props => [orderId];
}

class ResetPinWithDrawalEvent extends WalletEvent {
  final String pin;
  final String pinconfirmation;
  const ResetPinWithDrawalEvent(
      {required this.pin, required this.pinconfirmation});

  @override
  List<Object> get props => [pin, pinconfirmation];
}

class GetQuoteEventDposit extends WalletEvent {
  const GetQuoteEventDposit({required this.request});
  final GetQuoteRequestModelDeposit request;

  @override
  List<Object> get props => [request];
}

class VerifyOrderStutusEvent extends WalletEvent {
  final String orderId;
  const VerifyOrderStutusEvent({required this.orderId});

  @override
  List<Object> get props => [orderId];
}

class VerifiedCodeSentForgotPin extends WalletEvent {
  final String otp;
  const VerifiedCodeSentForgotPin({required this.otp});

  @override
  List<Object> get props => [otp];
}

class GenerateForgotPinEvent extends WalletEvent {
  const GenerateForgotPinEvent();

  @override
  List<Object> get props => [];
}

class ConfirmAddressDepositEvent extends WalletEvent {
  const ConfirmAddressDepositEvent({required this.request});
  final ConfirmAddressDepositEntity request;

  @override
  List<Object> get props => [request];
}

// GetUserKYCStatus
class GetUserKYCStatusEvent extends WalletEvent {
  const GetUserKYCStatusEvent();

  @override
  List<Object> get props => [];
}

class KycInitiateEvent extends WalletEvent {
  const KycInitiateEvent();

  @override
  List<Object> get props => [];
}

class KycUploadEvent extends WalletEvent {
  final KycUploadParams params;

  const KycUploadEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class StripeCheckoutEvent extends WalletEvent {
  final String amount;
  const StripeCheckoutEvent({required this.amount});

  @override
  List<Object> get props => [amount];
}

// getUserKYCStatus
