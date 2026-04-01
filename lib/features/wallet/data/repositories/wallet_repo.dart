import 'package:clapmi/core/error/failure.dart';
import 'package:clapmi/core/mapper/failure_mapper.dart';
import 'package:clapmi/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:clapmi/features/wallet/data/models/bank_details_model.dart';
import 'package:clapmi/features/wallet/data/models/confirm_address_deposit_model.dart';
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

import '../../domain/repositories/wallet_repository.dart';
import '../models/asset_balance.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDatasource walletRemoteDatasource;

  WalletRepositoryImpl({
    required this.walletRemoteDatasource,
  });

  @override
  Future<Either<Failure, List<TransactionHistoryModel>>>
      walletTransactionHistory({
    required TransactionHistoryModel transactionHistoryModel,
  }) async {
    try {
      final result = await walletRemoteDatasource.walletTransactionHistory(
        transactionHistoryModel: transactionHistoryModel,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<AssetModel>>> getWalletBalances() async {
    try {
      final result = await walletRemoteDatasource.getWalletBalances();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> giftClapPoint({
    required GiftUserEntity giftClapPointRequestEntity,
  }) async {
    try {
      final result = await walletRemoteDatasource.giftClapPoint(
        giftClapPointRequestEntity: giftClapPointRequestEntity,
      );
      return Right(result);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, TransactionHistoryModel>> getTransactionsDetail(
      String transactionID) async {
    try {
      final result =
          await walletRemoteDatasource.getTransactionsDetail(transactionID);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<TransactionHistoryModel>>>
      getTransactionsListRecent() async {
    try {
      final result = await walletRemoteDatasource.getTransactionsListRecent();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<RecentGiftingModel>>> getRecentGifting() async {
    try {
      final result = await walletRemoteDatasource.getRecentGifting();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map>> swapCoin({
    required SwapEntity swapCoinEntity,
  }) async {
    try {
      final result = await walletRemoteDatasource.swapCoin(
        swapCoinEntity: swapCoinEntity,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<WalletAddress>>> getWalletAddresses() async {
    try {
      final result = await walletRemoteDatasource.getWalletAddresses();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<WalletUSDCAddress>>>
      getWalletUSDCAddresses() async {
    try {
      final result = await walletRemoteDatasource.getWalletUSDCAddresses();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> twoFaverification() async {
    try {
      final result = await walletRemoteDatasource.twofaVerification();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> verify2FACode(
      {required String otpCode}) async {
    try {
      final result =
          await walletRemoteDatasource.verify2FACode(otpCode: otpCode);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> createWithdrawalPin(
      {required String pin, required String confirmPin}) async {
    try {
      final result = await walletRemoteDatasource.createWithdrawalPin(
          pin: pin, confirmPin: confirmPin);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> getAvailableCoin() async {
    try {
      final result = await walletRemoteDatasource.getAvailableCoin();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, WalletPropertiesEntity>> getWalletProperties() async {
    try {
      final result = await walletRemoteDatasource.getWalletProperties();
      print(
          ".............................................................$result");
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> initiateWithdrawal(
      {required InitiateWithdrawalRequest request}) async {
    try {
      final result =
          await walletRemoteDatasource.initiateWithdrawal(request: request);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, (String, String)>> buyPointLocally(
      {required BuyPointEntity buypoint}) async {
    try {
      final result =
          await walletRemoteDatasource.buyPointLocally(buypoint: buypoint);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<BankDataEntity>>> getAvailableBanks() async {
    try {
      final result = await walletRemoteDatasource.getAvailableBanks();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BankDetails>> verifyBankAccount(
      {required String accountNumber, required String bankCode}) async {
    try {
      final result = await walletRemoteDatasource.verifyBankAccountNumber(
          accountNumber: accountNumber, bankCode: bankCode);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AddBankRequest>> addBankAccount(
      {required AddBankRequestModel bankAccount}) async {
    try {
      final result =
          await walletRemoteDatasource.addBankAccount(bankAccount: bankAccount);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<AddBankRequest>>> getUserBankAccount() async {
    try {
      final result = await walletRemoteDatasource.getUserBankAccount();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, GetQuoteRequestModel>> getQuote(
      {required GetQuoteRequest request}) async {
    try {
      final result = await walletRemoteDatasource.getQuote(request: request);
      print("This is the result at the domain layer $result");
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> createOrder(
      {required String orderId, required String idempotencykey}) async {
    try {
      final result = await walletRemoteDatasource.createOrder(
        idempotencykey: idempotencykey,
        orderId: orderId,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, GetQuoteRequestModelDeposit>> depositwithBankFiat(
      {required GetQuoteRequestFiat request}) async {
    try {
      final result =
          await walletRemoteDatasource.paywithTransfer(request: request);
      print("This is the result at the domain layer $result");
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOrder({required String orderId}) async {
    try {
      final result = await walletRemoteDatasource.verifyOrder(orderId: orderId);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> otpGenneration() async {
    try {
      final result = await walletRemoteDatasource.generateOtpForForgetPin();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ConfirmAddressDepositEntity>> depoistConfirmation({
    required ConfirmAddressDepositEntity request,
  }) async {
    try {
      final model = ConfirmAddressDepositModel(address: request.address);

      final result =
          await walletRemoteDatasource.addressDeposit(request: model);

      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> verifyForgotPinOtp(
      {required String otp}) async {
    try {
      final result = await walletRemoteDatasource.verifyOtpForgotPin(otp: otp);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> restWithDrawalEvent(
      {required String pin, required String pinConfirmation}) async {
    try {
      final result = await walletRemoteDatasource.resetWithdrawalPin(
        pin: pin,
        pinConfirmation: pinConfirmation,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, GetUserKycStatusResponseEntity>>
      getUserKYCStatus() async {
    try {
      final result = await walletRemoteDatasource.getUserKYCStatus();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, KycVerificationEntity>> kycInitiate() async {
    try {
      final result = await walletRemoteDatasource.kycInitiate();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  // Implementation
  @override
  Future<Either<Failure, KycUploadEntity>> kycUpload(
      {required KycUploadParams params}) async {
    try {
      final result = await walletRemoteDatasource.kycUpload(params: params);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createStripeCheckout(
      {required String amount}) async {
    try {
      final result = await walletRemoteDatasource.createStripeCheckout(
          amount: amount);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }
}
