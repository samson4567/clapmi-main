import 'package:clapmi/core/error/failure.dart';
import 'package:clapmi/features/wallet/data/models/asset_balance.dart';
import 'package:clapmi/features/wallet/data/models/bank_details_model.dart';
import 'package:clapmi/features/wallet/data/models/kyc_upload_model.dart';
import 'package:clapmi/features/wallet/data/models/paywith_transfer_enity.dart';
import 'package:clapmi/features/wallet/domain/entities/confirm_address_entity.dart';
import 'package:clapmi/features/wallet/domain/entities/get_user_kyc_status_response_entity.dart';
import 'package:clapmi/features/wallet/domain/entities/kyc_entityes.dart';
import 'package:clapmi/features/wallet/domain/entities/kyc_intiate_entiy.dart';
import 'package:clapmi/features/wallet/domain/entities/paywith_transfer_model.dart';
import 'package:clapmi/features/wallet/data/models/recent_gifting_transaction.dart';
import 'package:clapmi/features/wallet/data/models/transaction.dart';
import 'package:clapmi/features/wallet/domain/entities/bank_details.dart';
import 'package:clapmi/features/wallet/domain/entities/gift_user.dart';
import 'package:clapmi/features/wallet/domain/entities/swap_entity.dart';
import 'package:clapmi/features/wallet/domain/entities/wallet_properties.dart';
import 'package:clapmi/features/wallet/domain/entities/asset_entity.dart';
import 'package:dartz/dartz.dart';

abstract class WalletRepository {
  Future<Either<Failure, List<TransactionHistoryModel>>>
      walletTransactionHistory({
    required TransactionHistoryModel transactionHistoryModel,
  });

  Future<Either<Failure, List<AssetModel>>> getWalletBalances();
  Future<Either<Failure, String>> giftClapPoint({
    required GiftUserEntity giftClapPointRequestEntity,
  });
  Future<Either<Failure, TransactionHistoryModel>> getTransactionsDetail(
      String transactionID);
  Future<Either<Failure, List<TransactionHistoryModel>>>
      getTransactionsListRecent();
  Future<Either<Failure, List<RecentGiftingModel>>> getRecentGifting();
  Future<Either<Failure, Map>> swapCoin({
    required SwapEntity swapCoinEntity,
  });

  Future<Either<Failure, List<WalletAddress>>> getWalletAddresses();
  Future<Either<Failure, List<WalletUSDCAddress>>> getWalletUSDCAddresses();

  Future<Either<Failure, String>> twoFaverification();

  Future<Either<Failure, String>> verify2FACode({required String otpCode});
  Future<Either<Failure, String>> createWithdrawalPin(
      {required String pin, required String confirmPin});
  Future<Either<Failure, String>> getAvailableCoin();
  Future<Either<Failure, WalletPropertiesEntity>> getWalletProperties();
  Future<Either<Failure, (String, String)>> buyPointLocally(
      {required BuyPointEntity buypoint});

  Future<Either<Failure, String>> initiateWithdrawal(
      {required InitiateWithdrawalRequest request});

  Future<Either<Failure, List<BankDataEntity>>> getAvailableBanks();

  Future<Either<Failure, BankDetails>> verifyBankAccount(
      {required String accountNumber, required String bankCode});

  Future<Either<Failure, AddBankRequest>> addBankAccount(
      {required AddBankRequestModel bankAccount});

  Future<Either<Failure, KycVerificationEntity>> kycInitiate();

  Future<Either<Failure, List<AddBankRequest>>> getUserBankAccount();

  Future<Either<Failure, GetQuoteRequestModel>> getQuote(
      {required GetQuoteRequest request});

  Future<Either<Failure, String>> createOrder({
    required String orderId,
    required String idempotencykey,
  });

  Future<Either<Failure, String>> restWithDrawalEvent({
    required String pin,
    required String pinConfirmation,
  });

  Future<Either<Failure, GetQuoteRequestModelDeposit>> depositwithBankFiat(
      {required GetQuoteRequestFiat request});
  Future<Either<Failure, String>> verifyOrder({required String orderId});
  Future<Either<Failure, String>> verifyForgotPinOtp({required String otp});
  Future<Either<Failure, String>> otpGenneration();

  Future<Either<Failure, ConfirmAddressDepositEntity>> depoistConfirmation(
      {required ConfirmAddressDepositEntity request});
  Future<Either<Failure, GetUserKycStatusResponseEntity>> getUserKYCStatus();
  // Abstract
  Future<Either<Failure, KycUploadEntity>> kycUpload(
      {required KycUploadParams params});
}
