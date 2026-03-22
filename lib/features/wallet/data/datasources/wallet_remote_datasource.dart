import 'package:clapmi/core/api/clapmi_network_client.dart';
import 'package:clapmi/core/constants/endpoint_constant.dart';
import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/features/wallet/data/models/bank_details_model.dart';
import 'package:clapmi/features/wallet/data/models/confirm_address_deposit_model.dart';
import 'package:clapmi/features/wallet/data/models/get_user_kyc_status_response_model.dart';
import 'package:clapmi/features/wallet/data/models/kyc_intiate_model.dart';
import 'package:clapmi/features/wallet/data/models/kyc_status_model.dart';
import 'package:clapmi/features/wallet/data/models/kyc_upload_model.dart';
import 'package:clapmi/features/wallet/data/models/paywith_transfer_enity.dart';
import 'package:clapmi/features/wallet/domain/entities/get_user_kyc_status_response_entity.dart';
import 'package:clapmi/features/wallet/domain/entities/paywith_transfer_model.dart';
import 'package:clapmi/features/wallet/data/models/recent_gifting_transaction.dart';
import 'package:clapmi/features/wallet/data/models/transaction.dart';
import 'package:clapmi/features/wallet/data/models/wallet_properties_model.dart';
import 'package:clapmi/features/wallet/domain/entities/asset_entity.dart';
import 'package:clapmi/features/wallet/domain/entities/bank_details.dart';
import 'package:clapmi/features/wallet/domain/entities/gift_user.dart';
import 'package:clapmi/features/wallet/domain/entities/swap_entity.dart';
import 'package:clapmi/screens/walletSystem/withdrawal/fiat_withdrawal.dart';
import '../models/asset_balance.dart';

abstract class WalletRemoteDatasource {
  Future<List<TransactionHistoryModel>> walletTransactionHistory({
    required TransactionHistoryModel transactionHistoryModel,
  });

  Future<List<AssetModel>> getWalletBalances();
  Future<String> giftClapPoint({
    required GiftUserEntity giftClapPointRequestEntity,
  });
  Future<TransactionHistoryModel> getTransactionsDetail(String transactionID);
  Future<List<TransactionHistoryModel>> getTransactionsListRecent();
  Future<List<RecentGiftingModel>> getRecentGifting();
  Future<Map> swapCoin({required SwapEntity swapCoinEntity});

  Future<List<WalletAddressModel>> getWalletAddresses();
  Future<List<WalletAddressUSDCModel>> getWalletUSDCAddresses();
  Future<String> twofaVerification();
  Future<String> verify2FACode({required String otpCode});
  Future<String> createWithdrawalPin(
      {required String pin, required String confirmPin});

  Future<String> getAvailableCoin();
  Future<GetUserKycStatusResponseEntity> getUserKYCStatus();
  Future<KycVerificationModel> kycInitiate();
  Future<KycUploadModel> kycUpload({required KycUploadParams params});

  Future<WalletPropertiesModel> getWalletProperties();

  Future<(String, String)> buyPointLocally({required BuyPointEntity buypoint});

  Future<String> initiateWithdrawal(
      {required InitiateWithdrawalRequest request});
  Future<List<BankDataModel>> getAvailableBanks();
  Future<BankDetailsModel> verifyBankAccountNumber(
      {required String accountNumber, required String bankCode});

  Future<AddBankRequestModel> addBankAccount(
      {required AddBankRequestModel bankAccount});

  Future<List<AddBankRequestModel>> getUserBankAccount();

  Future<GetQuoteRequestModel> getQuote({required GetQuoteRequest request});
  Future<ConfirmAddressDepositModel> addressDeposit(
      {required ConfirmAddressDepositModel request});
  Future<GetQuoteRequestModelDeposit> paywithTransfer(
      {required GetQuoteRequestFiat request});

  Future<String> createOrder(
      {required String orderId, required String idempotencykey});
  Future<String> resetWithdrawalPin(
      {required String pin, required String pinConfirmation});
  Future<String> verifyOrder({required String orderId});
  Future<String> verifyOtpForgotPin({required String otp});
  Future<String> generateOtpForForgetPin();
}

class WalletRemoteDatasourceImpl implements WalletRemoteDatasource {
  WalletRemoteDatasourceImpl({
    required this.networkClient,
    required this.appPreferenceService,
  });

  final AppPreferenceService appPreferenceService;
  final ClapMiNetworkClient networkClient;

  @override
  Future<List<TransactionHistoryModel>> walletTransactionHistory({
    required TransactionHistoryModel transactionHistoryModel,
  }) async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.getTransactionsList,
      isAuthHeaderRequired: true,
      data: transactionHistoryModel.toJson(),
    );

    final Map<String, dynamic> data = response.data as Map<String, dynamic>;
    final List transactions = data["transactions"] ?? [];

    return transactions
        .map((e) => TransactionHistoryModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<AssetModel>> getWalletBalances() async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.getBalance,
      isAuthHeaderRequired: true,
    );
    final data = response.data;
    print("###################################### get wallet balances $data");
    if (data is Map<String, dynamic>) {
      final List balances = data["data"] ?? [];
      return balances
          .map((e) => AssetModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (data is List) {
      return data
          .map((e) => AssetModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
  }

  @override
  Future<String> giftClapPoint({
    required GiftUserEntity giftClapPointRequestEntity,
    //  required String type,
  }) async {
    print(
        'This%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% is the ${giftClapPointRequestEntity.type}');
    final response = await networkClient.post(
      endpoint: EndpointConstant.giftClapPoint,
      isAuthHeaderRequired: true,
      data: {
        "to": giftClapPointRequestEntity.to,
        "amount": giftClapPointRequestEntity.amount,
        // "password": giftClapPointRequestEntity.password,
        "type": giftClapPointRequestEntity.type,
      },
    );
    print("This is the response from the giftClapcoin ${response.message}");
    return response.message;
    // return GiftUserModel.fromJson(response.data);
  }

  @override
  Future<TransactionHistoryModel> getTransactionsDetail(
      String transactionID) async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.getTransactionsDetail,
      isAuthHeaderRequired: true,
    );

    return TransactionHistoryModel.fromJson(response.data);
  }

  @override
  Future<List<TransactionHistoryModel>> getTransactionsListRecent() async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.getTransactionsListRecent,
      isAuthHeaderRequired: true,
    );
    final result = (response.data['transactions'] as List?)
            ?.map(
              (e) => TransactionHistoryModel.fromJson(e),
            )
            .toList() ??
        [];
    return result;
  }

  @override
  Future<List<RecentGiftingModel>> getRecentGifting() async {
    try {
      final response = await networkClient.get(
        endpoint: EndpointConstant.getRecentgifiting,
        isAuthHeaderRequired: true,
      );
      if (response.data is List) {
        return [];
      } else {
        print("debug_print->getRecentGifting-${response.data['giftings']}");
        final giftingList = (response.data["giftings"] as List?)
                ?.map((e) => RecentGiftingModel.fromMap(e))
                .toList() ??
            [];
        return giftingList;
      }
    } catch (e) {
      print(e.toString());
      throw Exception('This is an error: ${e.toString()}');
    }
  }

  @override
  Future<Map> swapCoin({
    required SwapEntity swapCoinEntity,
  }) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.swapCoin,
      isAuthHeaderRequired: true,
      data: {
        "from": swapCoinEntity.from,
        "to": swapCoinEntity.to,
        "amount": swapCoinEntity.amount,
      },
    );
    final String data = response.message;
    print('----------------------------------SWAP COIN RESPONSE $data');
    return response.data;
    //data.map((json) => SwapModel.fromJson(json)).toList();
  }

  @override
  Future<List<WalletAddressModel>> getWalletAddresses() async {
    try {
      final response = await networkClient.get(
          endpoint: EndpointConstant.getWalletAddresses,
          isAuthHeaderRequired: true);
      final result = (response.data as List)
          .map((walletAddress) => WalletAddressModel.fromMap(walletAddress))
          .toList();
      return result;
    } catch (e) {
      throw Exception('This is the error: ${e.toString()}');
    }
  }

  @override
  Future<List<WalletAddressUSDCModel>> getWalletUSDCAddresses() async {
    try {
      final response = await networkClient.get(
          endpoint: EndpointConstant.getWalletUSDCAddresses,
          isAuthHeaderRequired: true);
      final result = (response.data as List)
          .map((walletUSDCAddress) =>
              WalletAddressUSDCModel.fromMap(walletUSDCAddress))
          .toList();
      return result;
    } catch (e) {
      throw Exception('This is the error: ${e.toString()}');
    }
  }

  @override
  Future<String> twofaVerification() async {
    try {
      final response = await networkClient.post(
        endpoint: EndpointConstant.twoFAverification,
        isAuthHeaderRequired: true,
      );
      return response.message;
    } catch (e) {
      throw Exception('This is an error: ${e.toString()}');
    }
  }

  @override
  Future<String> verify2FACode({required String otpCode}) async {
    try {
      final response = await networkClient.post(
          endpoint: EndpointConstant.verify2FAcode,
          isAuthHeaderRequired: true,
          data: {
            'otp': otpCode,
          });
      return response.message;
    } catch (e) {
      throw Exception('This is an error: ${e.toString()}');
    }
  }

  @override
  Future<String> createWithdrawalPin(
      {required String pin, required String confirmPin}) async {
    try {
      print('This is the pin and the confirm pin $pin, $confirmPin');
      final response = await networkClient.post(
          endpoint: EndpointConstant.createwithdrawalPin,
          isAuthHeaderRequired: true,
          data: {'pin': pin, 'pin_confirmation': confirmPin});

      print('This is the createWithdrawalPin response $response');
      return response.message;
    } catch (e) {
      throw Exception('This is an eror : ${e.toString()}');
    }
  }

  @override
  Future<String> getAvailableCoin() async {
    try {
      final response = await networkClient.get(
        endpoint: EndpointConstant.getAvailableCoin,
        isAuthHeaderRequired: true,
      );
      return response.data['balance'];
    } catch (e) {
      throw Exception("This is an error : ${e.toString()}");
    }
  }

  @override
  Future<WalletPropertiesModel> getWalletProperties() async {
    try {
      final response = await networkClient.get(
        endpoint: EndpointConstant.getWalletProperties,
        isAuthHeaderRequired: true,
      );
      print('${response.data}--------------------||||||||||||||||||||||');
      return WalletPropertiesModel.fromMap(response.data);
    } catch (e) {
      throw Exception("This is an error : ${e.toString()}");
    }
  }

  @override
  Future<String> initiateWithdrawal(
      {required InitiateWithdrawalRequest request}) async {
    try {
      final response = await networkClient.post(
          endpoint: EndpointConstant.initiateWithdrawal,
          data: request.toMap(),
          // {
          //   "pin": pin,
          //   "amount": amount,
          // },
          isAuthHeaderRequired: true);
      return response.message;
    } catch (e) {
      throw Exception("This is an error: ${e.toString()}");
    }
  }

  @override
  Future<(String, String)> buyPointLocally(
      {required BuyPointEntity buypoint}) async {
    print('Making buyPoint locally');
    final response = await networkClient.post(
        endpoint: EndpointConstant.buypoint,
        isAuthHeaderRequired: true,
        data: {
          'amount': buypoint.amount,
          'coins': buypoint.coin,
          'payment_method': buypoint.paymentMethod
        });

    return (response.data['url'] as String, response.data['order'] as String);
  }

  @override
  Future<List<BankDataModel>> getAvailableBanks() async {
    final response = await networkClient.get(
        endpoint: EndpointConstant.supportedBanks, isAuthHeaderRequired: true);
    return (response.data as List)
        .map((dataItem) => BankDataModel.fromMap(dataItem))
        .toList();
  }

  @override
  Future<BankDetailsModel> verifyBankAccountNumber(
      {required String accountNumber, required String bankCode}) async {
    final response = await networkClient.post(
        endpoint: EndpointConstant.verifyBankAccount,
        isAuthHeaderRequired: true,
        data: {
          'accountNumber': accountNumber,
          'bankCode': bankCode,
        });

    return BankDetailsModel.fromMap(response.data);
  }

  @override
  Future<AddBankRequestModel> addBankAccount(
      {required AddBankRequestModel bankAccount}) async {
    final response = await networkClient.post(
        endpoint: EndpointConstant.userAccount,
        isAuthHeaderRequired: true,
        data: bankAccount.toMap());
    return AddBankRequestModel.fromMap(response.data);
  }

  @override
  Future<List<AddBankRequestModel>> getUserBankAccount() async {
    final response = await networkClient.get(
        endpoint: EndpointConstant.userAccount, isAuthHeaderRequired: true);
    return (response.data as List)
        .map((account) => AddBankRequestModel.fromMap(account))
        .toList();
  }

  @override
  Future<GetQuoteRequestModel> getQuote(
      {required GetQuoteRequest request}) async {
    print('Calling getQuote=======');
    final response = await networkClient.post(
        endpoint: EndpointConstant.getQuote,
        isAuthHeaderRequired: true,
        data: request.toMap());
    print('This is the response ${response.data}');
    final result = GetQuoteRequestModel.fromMap(response.data);
    return result;
  }

  @override
  Future<String> createOrder(
      {required String orderId, required String idempotencykey}) async {
    final response = await networkClient.post(
        endpoint: EndpointConstant.createOrder,
        isAuthHeaderRequired: true,
        data: {'order_id': orderId, 'idempotency_key': idempotencykey});
    return response.message;
  }

  @override
  Future<GetQuoteRequestModelDeposit> paywithTransfer(
      {required GetQuoteRequestFiat request}) async {
    print('Calling Paymentwith=======');
    final response = await networkClient.post(
      endpoint: EndpointConstant.paywithTranferFiat,
      isAuthHeaderRequired: true,
      data: {'amount': request.amount},
    );
    print('This is the response ${response.data}');
    final result = GetQuoteRequestModelDeposit.fromMap(response.data);
    return result;
  }

  @override
  Future<String> verifyOrder({required String orderId}) async {
    final response = await networkClient.get(
      endpoint: "${EndpointConstant.verifyorderStatus}/$orderId",
      isAuthHeaderRequired: true,
    );
    return response.message;
  }

  @override
  Future<String> generateOtpForForgetPin() async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.otpForgetPin,
      isAuthHeaderRequired: true,
    );
    return response.message;
  }

  @override
  Future<ConfirmAddressDepositModel> addressDeposit(
      {required ConfirmAddressDepositModel request}) async {
    print('Calling getQuote=======');
    final response = await networkClient.post(
        endpoint: EndpointConstant.depositConfirmation,
        isAuthHeaderRequired: true,
        data: request.toJson());
    print('This is the response ${response.data}');
    final result = ConfirmAddressDepositModel.fromJson(response.data);
    return result;
  }

  @override
  Future<String> verifyOtpForgotPin({required String otp}) async {
    final response = await networkClient.post(
        endpoint: EndpointConstant.verifyForgotPin,
        isAuthHeaderRequired: true,
        data: {
          'otp': otp,
        });
    return response.message;
  }

  @override
  Future<String> resetWithdrawalPin(
      {required String pin, required String pinConfirmation}) async {
    final response = await networkClient.post(
        endpoint: EndpointConstant.updatePin,
        isAuthHeaderRequired: true,
        data: {'pin': pin, 'pin_confirmation': pinConfirmation});
    return response.message;
  }

  @override
  Future<GetUserKycStatusResponseEntity> getUserKYCStatus() async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.getUserKYCStatus,
      isAuthHeaderRequired: true,
    );
    return GetUserKycStatusResponseModel.fromJson(response.data);
  }

// Abstract

// Implementation
  @override
  Future<KycVerificationModel> kycInitiate() async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.kycInitaite,
      isAuthHeaderRequired: true,
    );
    return KycVerificationModel.fromJson(response.data);
  }

  // Abstract

// Implementation
  @override
  Future<KycUploadModel> kycUpload({required KycUploadParams params}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.kycupload, // '/user/kyc/upload'
      isAuthHeaderRequired: true,
      data: params.toJson(),
    );
    return KycUploadModel.fromJson(response.data);
  }
}
