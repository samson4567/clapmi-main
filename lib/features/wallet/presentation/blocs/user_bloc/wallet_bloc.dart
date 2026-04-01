import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_bloc.dart';
import 'package:clapmi/features/wallet/data/models/asset_balance.dart';
import 'package:clapmi/features/wallet/data/models/transaction.dart';
import 'package:clapmi/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository walletRepository;
  // final CryptoRepo cryptoRepo;
  final AppBloc appBloc;

  // Constructor to initialize the WalletBloc
  WalletBloc({
    required this.appBloc,
    required this.walletRepository,
    // required this.cryptoRepo
  }) : super(WalletInitial()) {
    on<WalletUpdateEvent>(_onWalletUpdate);
    on<LoadWalletBalances>(_onLoadWalletBalances);
    on<GetTransactionsDetailEvent>(_onGetTransactionsDetailEvent);
    on<GetTransactionsListRecentEvent>(_onGetTransactionsListRecentEvent);
    on<RecentGiftingEvent>(_onGetRecentGiftingEvent);
    on<SwapEvent>(_onSwap);
    on<GiftUserEvent>(_onGiftUserEvent);
    on<GetWalletAddressEvent>(_onGetWalletAddressesEventHandler);
    on<GetWalletAddressUSDCEvent>(_onGetWalletAddressesUSDCEventHandler);
    on<Send2FACodeEvent>(_send2faCodeEventHandler);
    on<Verify2FACodeEvent>(_verify2FaCodeEventHandler);
    on<CreateWithdrawalPinEvent>(_createWithdrawalPinEventHandler);
    on<GetAvailableCoinEvent>(_getAvailableCoinEventHandler);
    on<GetWalletPropertiesEvent>(_getWalletPropertiesEventHandler);
    on<InitiateWithDrawalEvent>(_initiateWithDrawalEventHandler);
    // on<ConnectWalletEvent>(_connectWalletEventHandler);
    on<BuyPointEvent>(_buyPointEventHandler);
    on<GetAvailableBanksEvent>(_getAvailableBanksEventHandler);
    on<VerifyBankAccountEvent>(_verifyBankAccountEventHandler);
    on<AddUserBankAccountEvent>(_addBankAccountEventHandler);
    on<GetUserBankAccount>(_getUserBankAccountEventHandler);
    on<GetQuoteEvent>(_getQuoteEventHandler);
    on<CreateOrderEvent>(_createOrderEventHandler);
    on<GetQuoteEventDposit>(_getPaywithEventHandler);
    on<VerifyOrderStutusEvent>(_verifyOrderStatusEventHandler);
    on<GenerateForgotPinEvent>(_generateForgotPinEventHandler);
    on<ConfirmAddressDepositEvent>(_confirmAddressDepositHandler);
    on<VerifiedCodeSentForgotPin>(_veriforgotPinEventHandler);
    on<ResetPinWithDrawalEvent>(_ressetPinEventHandler); //ressetPinEventHandler
    on<GetUserKYCStatusEvent>(_getUserKYCStatusEventHandler);
    on<KycInitiateEvent>(_kycInitiateHandler);
    on<KycUploadEvent>(_kycUploadHandler);
    on<StripeCheckoutEvent>(_stripeCheckoutHandler);

    //
  }

  // Event handler to update wallet transactions
  Future<void> _onWalletUpdate(
      WalletUpdateEvent event, Emitter<WalletState> emit) async {
    emit(WalletUpdateLoadingState());
    final result = await walletRepository.walletTransactionHistory(
      transactionHistoryModel: TransactionHistoryModel(
        transaction: event.transaction,
        operation: event.operation,
        currency: event.currency,
        amount: event.amount,
        date: event.date,
        status: event.status,
        recent: event.recent,
        perPage: event.perPage,
      ),
    );

    result.fold(
      (error) {
        emit(WalletUpdateErrorState(errorMessage: error.message));
      },
      (transactionHistoryModel) {
        emit(WalletUpdateSuccessState(
          transactionHistoryModel: transactionHistoryModel,
        ));
      },
    );
  }

  List<AssetModel> _assetBalances = [];
  List<AssetModel> get assetBalances => _assetBalances;
  Future<void> _onLoadWalletBalances(
    LoadWalletBalances event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());

    final result = await walletRepository.getWalletBalances();

    result.fold((failure) => emit(WalletError(message: failure.message)),
        (balances) {
      _assetBalances = balances;
      emit(WalletLoaded(balances: balances));
    });
  }
// Future<void> _onGetTransactionsDetailEvent(
//     GetTransactionsDetailEvent event,
//     Emitter<WalletState> emit,
//   ) async {
//     emit(GetTransactionsDetailLoadingState());

//     final result = await walletRepository.getTransactionsDetail(event.transactionID);

//     result.fold(
//       (errorMessage) => emit(GetTransactionsDetailErrorState(errorMessage: errorMessage)),
//       (balances) => emit(GetTransactionsDetailSuccessState(message: balances)),
//     );
//   }

  Future<void> _onGetTransactionsDetailEvent(
      GetTransactionsDetailEvent event, Emitter<WalletState> emit) async {
    emit(GetTransactionsDetailLoadingState());
    final result =
        await walletRepository.getTransactionsDetail(event.transactionID);

    result.fold(
        (error) =>
            emit(GetTransactionsDetailErrorState(errorMessage: error.message)),
        (message) {
      emit(
        GetTransactionsDetailSuccessState(transactionHistoryModel: message),
      );
    });
  }

  Future<void> _onGetTransactionsListRecentEvent(
      GetTransactionsListRecentEvent event, Emitter<WalletState> emit) async {
    emit(GetTransactionsListRecentLoadingState());
    final result = await walletRepository.getTransactionsListRecent();

    result.fold(
        (error) => emit(
            GetTransactionsListRecentErrorState(errorMessage: error.message)),
        (listOfTransactionHistoryModel) {
      emit(
        GetTransactionsListRecentSuccessState(
            listOfTransactionHistoryModel: listOfTransactionHistoryModel),
      );
    });
  }

  Future<void> _onGetRecentGiftingEvent(
    RecentGiftingEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(const RecentGiftingLoadingState());

    final result = await walletRepository.getRecentGifting();

    result.fold(
      (error) => emit(RecentGiftingErrorState(error.message)),
      (listOfRecentGifting) =>
          emit(RecentGiftingSuccessState(listOfRecentGifting)),
    );
  }

  Future<void> _onSwap(
    SwapEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(const SwapLoadingState());

    final result = await walletRepository.swapCoin(
      swapCoinEntity: event.swapCoinEntity,
    );

    result.fold(
      (failure) => emit(SwapErrorState(failure.message)),
      (swapModels) => emit(SwapSuccessState('', swapModels['order_id'])),
    );
  }

  Future<void> _onGiftUserEvent(
    GiftUserEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(const GiftUserLoadingState());

    final result = await walletRepository.giftClapPoint(
      giftClapPointRequestEntity: event.giftClapPointRequestEntity,
    );

    result.fold(
      (error) {
        final moreInfo = error.moreInformation;
        final errorMap =
            moreInfo is Map<String, dynamic> ? moreInfo : <String, dynamic>{};
        final passwordErrors = errorMap['password'];
        final message = passwordErrors is List && passwordErrors.isNotEmpty
            ? passwordErrors.first.toString()
            : error.message;
        emit(GiftUserErrorState(message));
      },
      // Also fix this state name
      (message) => emit(GiftUserSuccessState(message)),
    );
  }

  Future<void> _onGetWalletAddressesEventHandler(
      GetWalletAddressEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());

    final result = await walletRepository.getWalletAddresses();

    result.fold((error) => emit(WalletError(message: error.message)),
        (walletAddresses) => emit(WalletAddressLoaded(walletAddresses)));
  }

  Future<void> _onGetWalletAddressesUSDCEventHandler(
      GetWalletAddressUSDCEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());

    final result = await walletRepository.getWalletUSDCAddresses();

    result.fold((error) => emit(WalletError(message: error.message)),
        (walletAdrressesUSDC) => emit(WalletAddressUSDC(walletAdrressesUSDC)));
  }

  Future<void> _send2faCodeEventHandler(
      Send2FACodeEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());

    final result = await walletRepository.twoFaverification();

    result.fold((error) => emit(WalletError(message: error.message)),
        (message) => emit(FAAuthCodeSent(message: message)));
  }

  Future<void> _verify2FaCodeEventHandler(
      Verify2FACodeEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());

    final result = await walletRepository.verify2FACode(otpCode: event.otpCode);

    result.fold((error) => emit(WalletError(message: error.message)),
        (message) => emit(VerifiedCodeSent(message: message)));
  }

  Future<void> _createWithdrawalPinEventHandler(
      CreateWithdrawalPinEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());

    final result = await walletRepository.createWithdrawalPin(
        pin: event.pin, confirmPin: event.confirmPin);

    result.fold((error) => emit(WalletError(message: error.message)),
        (message) => emit(WithdrawalPinCreated(message)));
  }

  Future<void> _getAvailableCoinEventHandler(
      GetAvailableCoinEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    final result = await walletRepository.getAvailableCoin();

    result.fold((error) => emit(WalletError(message: error.message)),
        (amount) => emit(AvailableClappCoinLoaded(amount)));
  }

  Future<void> _getWalletPropertiesEventHandler(
      GetWalletPropertiesEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    final result = await walletRepository.getWalletProperties();

    result.fold(
        (error) => emit(WalletError(message: error.message)),
        (properties) =>
            emit(WalletPropertiesLoaded(walletProperties: properties)));
  }

  Future<void> _initiateWithDrawalEventHandler(
      InitiateWithDrawalEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    final result = await walletRepository.initiateWithdrawal(
      request: event.request,
    );

    result.fold((error) => emit(WalletError(message: error.message)),
        (message) => emit(WithdrawalSuccessful(message: message)));
  }

  // Future<void> _connectWalletEventHandler(
  //     ConnectWalletEvent event, Emitter<WalletState> emit) async {
  //   emit(WalletLoading());
  //   final result = await cryptoRepo.connectToMetamask();
  //   result.fold((error) => emit(WalletError(message: error.message)),
  //       (appkit) => emit(WalletConnected(appkit: appkit)));
  // }

  Future<void> _buyPointEventHandler(
      BuyPointEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    final result =
        await walletRepository.buyPointLocally(buypoint: event.buypoint);
    result.fold((error) => emit(WalletError(message: error.message)),
        (response) => emit(CheckOut(checkoutEntity: response)));
  }

  Future<void> _getAvailableBanksEventHandler(
      GetAvailableBanksEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    final result = await walletRepository.getAvailableBanks();
    result.fold((error) => emit(WalletError(message: error.message)),
        (response) => emit(BanksDataLoaded(banksData: response)));
  }

  Future<void> _verifyBankAccountEventHandler(
      VerifyBankAccountEvent event, Emitter<WalletState> emit) async {
    final result = await walletRepository.verifyBankAccount(
        accountNumber: event.accountNumber, bankCode: event.bankCode);
    result.fold((error) => emit(WalletError(message: error.message)),
        (bank) => emit(AccountVerified(bankDetails: bank)));
  }

  Future<void> _addBankAccountEventHandler(
      AddUserBankAccountEvent event, Emitter<WalletState> emit) async {
    final result =
        await walletRepository.addBankAccount(bankAccount: event.addBank);
    result.fold((error) => emit(WalletError(message: error.message)),
        (bank) => emit(BankAdded(addedBank: bank)));
  }

  Future<void> _getUserBankAccountEventHandler(
      GetUserBankAccount event, Emitter<WalletState> emit) async {
    final result = await walletRepository.getUserBankAccount();
    result.fold((error) => emit(WalletError(message: error.message)),
        (userBanks) => emit(UserBankAccounts(banks: userBanks)));
  }

  Future<void> _getQuoteEventHandler(
      GetQuoteEvent event, Emitter<WalletState> emit) async {
    final result = await walletRepository.getQuote(request: event.request);
    result.fold((error) => emit(WalletError(message: error.message)),
        (response) => emit(QuoteRetrieved(quoteInfo: response)));
  }

  Future<void> _createOrderEventHandler(
      CreateOrderEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    final result = await walletRepository.createOrder(
        orderId: event.orderId, idempotencykey: event.idempotencykey);
    result.fold((error) => emit(WalletError(message: error.message)),
        (response) => emit(OrderCreated(message: response)));
  }

  Future<void> _ressetPinEventHandler(
      ResetPinWithDrawalEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    final result = await walletRepository.restWithDrawalEvent(
        pin: event.pin, pinConfirmation: event.pinconfirmation);
    result.fold((error) => emit(WalletError(message: error.message)),
        (response) => emit(ResetPin(message: response)));
  }

  Future<void> _getUserKYCStatusEventHandler(
      GetUserKYCStatusEvent event, Emitter<WalletState> emit) async {
    emit(GetUserKYCStatusLoadingState());
    final result = await walletRepository.getUserKYCStatus();
    result.fold(
        (error) =>
            emit(GetUserKYCStatusErrorState(errorMessage: error.message)),
        (response) => emit(GetUserKYCStatusSuccessState(
            theGetUserKycStatusResponseEntity: response)));
  }

  Future<void> _getPaywithEventHandler(
      GetQuoteEventDposit event, Emitter<WalletState> emit) async {
    final result =
        await walletRepository.depositwithBankFiat(request: event.request);
    result.fold(
        (error) => emit(WalletError(message: error.message)),
        (response) => emit(QuoteRetrievedDeposit(
              quoteInfo: response,
            )));
  }

  Future<void> _verifyOrderStatusEventHandler(
      VerifyOrderStutusEvent event, Emitter<WalletState> emit) async {
    final result = await walletRepository.verifyOrder(orderId: event.orderId);
    result.fold((error) => emit(WalletError(message: error.message)),
        (response) => emit(VerifyOrderStstus(message: response)));
  }

  Future<void> _veriforgotPinEventHandler(
      VerifiedCodeSentForgotPin event, Emitter<WalletState> emit) async {
    final result = await walletRepository.verifyForgotPinOtp(otp: event.otp);
    result.fold((error) => emit(WalletError(message: error.message)),
        (response) => emit(VerifiedForgotPin(message: response)));
  }

  Future<void> _generateForgotPinEventHandler(
      GenerateForgotPinEvent event, Emitter<WalletState> emit) async {
    final result = await walletRepository.otpGenneration();
    result.fold((error) => emit(WalletError(message: error.message)),
        (response) => emit(GenerateForgotPinOTP(message: response)));
  }

  Future<void> _confirmAddressDepositHandler(
      ConfirmAddressDepositEvent event, Emitter<WalletState> emit) async {
    final result =
        await walletRepository.depoistConfirmation(request: event.request);
    result.fold(
        (error) => emit(WalletError(message: error.message)),
        (depositModel) =>
            emit(ConfirmAddressDeposit(depositModel: depositModel)));
  }

  Future<void> _kycInitiateHandler(
    KycInitiateEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    final result = await walletRepository.kycInitiate();
    result.fold(
      (error) => emit(WalletError(message: error.message)),
      (data) => emit(KycInitiateSuccess(data: data)),
    );
  }

  Future<void> _kycUploadHandler(
    KycUploadEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    final result = await walletRepository.kycUpload(params: event.params);
    result.fold(
      (error) => emit(WalletError(message: error.message)),
      (data) => emit(KycUploadSuccess(data: data)),
    );
  }

  Future<void> _stripeCheckoutHandler(
    StripeCheckoutEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    final result = await walletRepository.createStripeCheckout(
        amount: event.amount);
    result.fold(
      (error) => emit(WalletError(message: error.message)),
      (data) => emit(StripeCheckoutSuccess(checkoutData: data)),
    );
  }
}
