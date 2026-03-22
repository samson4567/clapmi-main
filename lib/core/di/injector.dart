import 'package:clapmi/core/api/clapmi_network_client.dart';
import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/core/db/auth_preference_service.dart';
import 'package:clapmi/core/db/database_service.dart';
import 'package:clapmi/features/app/data/datasources/app_local_datasource.dart';
import 'package:clapmi/features/app/data/datasources/app_remote_datasource.dart';
import 'package:clapmi/features/app/data/repositories/app_repository_impl.dart';
import 'package:clapmi/features/app/domain/repositories/app_repository.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_bloc.dart';
import 'package:clapmi/features/authentication/data/datasources/authentication_local_datasource.dart';
import 'package:clapmi/features/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:clapmi/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:clapmi/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:clapmi/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:clapmi/features/brag/data/datasources/brag_local_datasource.dart';
import 'package:clapmi/features/brag/data/datasources/brag_remote_datasource.dart';
import 'package:clapmi/features/brag/data/repositories/brag_repository_impl.dart';
import 'package:clapmi/features/brag/domain/repositories/brag_repository.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_bloc.dart';
import 'package:clapmi/features/chats_and_socials/data/datasources/chats_and_socials_local_datasource.dart';
import 'package:clapmi/features/chats_and_socials/data/datasources/chats_and_socials_remote_datasource.dart';
import 'package:clapmi/features/chats_and_socials/data/repositories/chats_and_socials_repository_impl.dart';
import 'package:clapmi/features/chats_and_socials/domain/repositories/chats_and_socials_repository.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
import 'package:clapmi/features/combo/data/datasources/combo_local_datasource.dart';
import 'package:clapmi/features/combo/data/datasources/combo_remote_datasource.dart';
import 'package:clapmi/features/combo/data/repositories/combo_repository_impl.dart';
import 'package:clapmi/features/combo/domain/repositories/combo_repository.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_bloc.dart';
import 'package:clapmi/features/notification/data/datasources/notification_local_datasource.dart';
import 'package:clapmi/features/notification/data/datasources/notification_remote_datasource.dart';
import 'package:clapmi/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:clapmi/features/notification/domain/repositories/notification_repository.dart';
import 'package:clapmi/features/notification/presentation/blocs/user_bloc/notification_bloc.dart';
import 'package:clapmi/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:clapmi/features/onboarding/data/datasources/onboarding_remote_datasource.dart';
import 'package:clapmi/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:clapmi/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:clapmi/features/onboarding/presentation/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:clapmi/features/post/data/datasources/post_local_datasource.dart';
import 'package:clapmi/features/post/data/datasources/post_remote_datasource.dart';
import 'package:clapmi/features/post/data/repositories/post_repository_impl.dart';
import 'package:clapmi/features/post/domain/repositories/post_repository.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_bloc.dart';
import 'package:clapmi/features/post/presentation/blocs/video_bloc/video_bloc.dart';
import 'package:clapmi/features/rewards/presentation/blocs/reward_bloc.dart';
import 'package:clapmi/features/rewards/data/datasources/rewards_remote_data_source.dart'; // Add import
import 'package:clapmi/features/rewards/data/repositories/rewards_repository_impl.dart'; // Add import
import 'package:clapmi/features/rewards/domain/repositories/rewards_repository.dart'; // Add import
import 'package:clapmi/features/search/data/datasources/search_remote_data_source.dart'; // Add import
import 'package:clapmi/features/search/data/repositories/search_repository_impl.dart'; // Add import
import 'package:clapmi/features/search/domain/repositories/search_repository.dart'; // Add import
import 'package:clapmi/features/search/presentation/blocs/search_bloc.dart'; // Add import
import 'package:clapmi/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:clapmi/features/settings/presentation/bloc/notification_settings_bloc.dart';
import 'package:clapmi/features/settings/presentation/bloc/privacy_settings_bloc.dart';
import 'package:clapmi/features/settings/repositories/settings_repository.dart';
import 'package:clapmi/features/user/data/datasources/user_local_datasource.dart';
import 'package:clapmi/features/user/data/datasources/user_remote_datasource.dart';
import 'package:clapmi/features/user/data/repositories/user_repository_impl.dart';
import 'package:clapmi/features/user/domain/repositories/user_repository.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:clapmi/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:clapmi/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/screens/Brag/brag_screen_tu_controller.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../features/wallet/data/repositories/wallet_repo.dart';

final getItInstance = GetIt.I;

Future init() async {
  getItInstance.registerSingletonAsync<AppPreferenceService>(() async {
    final service = AppPreferenceService();
    await service.init();
    return service;
  });

  getItInstance.registerSingletonAsync<DatabaseService>(() async {
    final database = DatabaseService();
    await database.createDatabase();
    return database;
  });

  getItInstance.registerLazySingleton(
      () => AuthPreferenceService(preferenceService: getItInstance()));

  getItInstance.registerLazySingleton(() => Dio());

  getItInstance.registerLazySingleton(() => GoogleSignIn.instance);
  getItInstance.registerLazySingleton(() => ClapMiNetworkClient(
      dio: getItInstance(), appPreferenceService: getItInstance()));

  // AppBloc
  getItInstance.registerLazySingleton<AppRemoteDatasource>(() =>
      AppRemoteDatasourceImpl(
          networkClient: getItInstance<ClapMiNetworkClient>(),
          appPreferenceService: getItInstance<AppPreferenceService>()));

  getItInstance.registerLazySingleton<AppLocalDatasource>(() =>
      AppLocalDatasourceImpl(
          appPreferenceService: getItInstance<AppPreferenceService>()));

  getItInstance.registerLazySingleton<AppRepository>(() => AppRepositoryImpl(
      appRemoteDatasource: getItInstance<AppRemoteDatasource>(),
      appLocalDatasource: getItInstance<AppLocalDatasource>()));

  getItInstance.registerLazySingleton<AppBloc>(
      () => AppBloc(appRepository: getItInstance<AppRepository>()));
  // AppBloc Ended......

// Authentication
  getItInstance.registerLazySingleton<AuthenticationRemoteDatasource>(() =>
      AuthenticationRemoteDatasourceImpl(
          networkClient: getItInstance(), googleSignIn: getItInstance()));
  getItInstance.registerLazySingleton<AuthenticationLocalDatasource>(() =>
      AuthenticationLocalDatasourceImpl(
          appPreferenceService: getItInstance(),
          authPreferenceService: getItInstance()));
  getItInstance.registerLazySingleton<AuthenticationRepository>(() =>
      AuthenticationRepositoryImpl(
          authenticationRemoteDatasource: getItInstance(),
          authenticationLocalDatasource: getItInstance()));

  getItInstance.registerLazySingleton(() => AuthBloc(
      authenticationRepository: getItInstance(),
      appBloc: getItInstance<AppBloc>()));

// Authentication ended ......

// Onboarding
  getItInstance.registerLazySingleton<OnboardingRemoteDatasource>(
      () => OnboardingRemoteDatasourceImpl(networkClient: getItInstance()));
  getItInstance.registerLazySingleton<OnboardingLocalDatasource>(() =>
      OnboardingLocalDatasourceImpl(appPreferenceService: getItInstance()));
  getItInstance.registerLazySingleton<OnboardingRepository>(() =>
      OnboardingRepositoryImpl(
          onboardingRemoteDatasource: getItInstance(),
          onboardingLocalDatasource: getItInstance()));

  getItInstance.registerLazySingleton(
      () => OnboardingBloc(onboardingRepository: getItInstance()));

// Onboarding ended ......

// UserBloc
  getItInstance.registerLazySingleton<UserRemoteDatasource>(() =>
      UserRemoteDatasourceImpl(
          networkClient: getItInstance(),
          appPreferenceService: getItInstance<AppPreferenceService>()));
  getItInstance.registerLazySingleton<UserLocalDatasource>(
      () => UserLocalDatasourceImpl(appPreferenceService: getItInstance()));
  getItInstance.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
      userLocalDatasource: getItInstance<UserLocalDatasource>(),
      userRemoteDatasource: getItInstance<UserRemoteDatasource>()));

  getItInstance.registerLazySingleton(() => UserBloc(
        appBloc: getItInstance<AppBloc>(),
        userRepository: getItInstance<UserRepository>(),
      ));

// UserBloc ended ......

// ChatsAndSocialsBloc
  getItInstance.registerLazySingleton<ChatsAndSocialsRemoteDatasource>(() =>
      ChatsAndSocialsRemoteDatasourceImpl(
          localSource: getItInstance<ChatsAndSocialsLocalDatasource>(),
          dio: getItInstance<Dio>(),
          networkClient: getItInstance<ClapMiNetworkClient>(),
          appPreferenceService: getItInstance<AppPreferenceService>()));
  getItInstance.registerLazySingleton<ChatsAndSocialsLocalDatasource>(() =>
      ChatsAndSocialsLocalDatasourceImpl(databaseService: getItInstance()));
  getItInstance.registerLazySingleton<ChatsAndSocialsRepository>(() =>
      ChatsAndSocialsRepositoryImpl(
          chatsAndSocialsLocalDatasource:
              getItInstance<ChatsAndSocialsLocalDatasource>(),
          chatsAndSocialsRemoteDatasource:
              getItInstance<ChatsAndSocialsRemoteDatasource>()));

  getItInstance.registerLazySingleton(() => ChatsAndSocialsBloc(
      chatsAndSocialsRepository: getItInstance<ChatsAndSocialsRepository>()));

// ChatsAndSocialsBloc ended ......

//* Settings

  getItInstance.registerLazySingleton<SettingsDataSource>(() =>
      SettingsDataSourceImpl(
          networkClient: getItInstance(),
          appPreferenceService: getItInstance<AppPreferenceService>()));

  getItInstance.registerLazySingleton<SettingsRepository>(() =>
      SettingsRepositoryImpl(SettingsDataSourceImpl(
          networkClient: getItInstance(),
          appPreferenceService: getItInstance<AppPreferenceService>())));

  getItInstance.registerLazySingleton(
    () => NotificationSettingsBloc(
      getItInstance<SettingsRepository>(),
    ),
  );

  getItInstance.registerLazySingleton(
    () => PrivacySettingsBloc(
      getItInstance<SettingsRepository>(),
    ),
  );

// PostBloc
  getItInstance.registerLazySingleton<PostRemoteDatasource>(() =>
      PostRemoteDatasourceImpl(
          networkClient: getItInstance(),
          appPreferenceService: getItInstance<AppPreferenceService>()));
  getItInstance.registerLazySingleton<PostLocalDatasource>(
      () => PostLocalDatasourceImpl(appPreferenceService: getItInstance()));
  getItInstance.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      postLocalDatasource: getItInstance<PostLocalDatasource>(),
      postRemoteDatasource: getItInstance<PostRemoteDatasource>(),
    ),
  );
  getItInstance.registerLazySingleton(
      () => VideoBloc(postRepository: getItInstance<PostRepository>()));
  getItInstance.registerLazySingleton(
    () => PostBloc(
      postRepository: getItInstance<PostRepository>(),
      appBloc: getItInstance<AppBloc>(),
    ),
  );
// ComboBloc
  getItInstance.registerLazySingleton<ComboRemoteDatasource>(() =>
      ComboRemoteDatasourceImpl(
          networkClient: getItInstance(),
          appPreferenceService: getItInstance<AppPreferenceService>()));
  getItInstance.registerLazySingleton<ComboLocalDatasource>(
      () => ComboLocalDatasourceImpl(appPreferenceService: getItInstance()));
  getItInstance.registerLazySingleton<ComboRepository>(
    () => ComboRepositoryImpl(
      comboLocalDatasource: getItInstance<ComboLocalDatasource>(),
      comboRemoteDatasource: getItInstance<ComboRemoteDatasource>(),
    ),
  );

  getItInstance.registerLazySingleton(
    () => ComboBloc(
      comboRepository: getItInstance<ComboRepository>(),
      appBloc: getItInstance<AppBloc>(),
    ),
  );

// BragBloc
  getItInstance.registerLazySingleton<BragRemoteDatasource>(() =>
      BragRemoteDatasourceImpl(
          networkClient: getItInstance(),
          appPreferenceService: getItInstance<AppPreferenceService>()));
  getItInstance.registerLazySingleton<BragLocalDatasource>(
      () => BragLocalDatasourceImpl(appPreferenceService: getItInstance()));
  getItInstance.registerLazySingleton<BragRepository>(
    () => BragRepositoryImpl(
      bragLocalDatasource: getItInstance<BragLocalDatasource>(),
      bragRemoteDatasource: getItInstance<BragRemoteDatasource>(),
    ),
  );

  getItInstance.registerLazySingleton(
    () => BragBloc(
      bragRepository: getItInstance<BragRepository>(),
      appBloc: getItInstance<AppBloc>(),
    ),
  );

// BragBloc ended ......

// RewardsBloc
  getItInstance.registerLazySingleton<RewardsRemoteDataSource>(
      () => RewardsRemoteDataSourceImpl(
            networkClient: getItInstance(),
          ));

  getItInstance.registerLazySingleton<RewardsRepository>(() =>
      RewardsRepositoryImpl(
          remoteDataSource: getItInstance<RewardsRemoteDataSource>()));

  getItInstance.registerLazySingleton(
      () => RewardBloc(rewardRepository: getItInstance<RewardsRepository>()));
// RewardsBloc ended ......

// NotificationBloc
  getItInstance.registerLazySingleton<NotificationRemoteDatasource>(() =>
      NotificationRemoteDatasourceImpl(
          networkClient: getItInstance(),
          appPreferenceService: getItInstance<AppPreferenceService>()));
  getItInstance.registerLazySingleton<NotificationLocalDatasource>(() =>
      NotificationLocalDatasourceImpl(appPreferenceService: getItInstance()));
  getItInstance.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      notificationLocalDatasource: getItInstance<NotificationLocalDatasource>(),
      notificationRemoteDatasource:
          getItInstance<NotificationRemoteDatasource>(),
    ),
  );

  getItInstance.registerLazySingleton(
    () => NotificationBloc(
      notificationRepository: getItInstance<NotificationRepository>(),
      appBloc: getItInstance<AppBloc>(),
    ),
  );

// NotificationBloc ended ......

// NotificationBloc

  //* Profile
  // getItInstance.registerLazySingleton<ProfileRemoteDataSource>(
  //     () => ProfileRemoteDataSourceImpl(networkClient: getItInstance()));

  // getItInstance.registerLazySingleton<ProfileRepository>(
  //     () => ProfileRepositoryImpl(remoteDataSource: getItInstance()));

  // // Register factory means a new instance is created each time it's requested
  // getItInstance.registerFactory(
  //   () => ProfileBloc(
  //     getItInstance<ProfileRepository>(),
  //   ),
  // );

  // Search Feature // Add Search Feature registrations
  getItInstance.registerLazySingleton<SearchRemoteDataSource>(() =>
      SearchRemoteDataSourceImpl(
          networkClient:
              getItInstance())); // Assuming DioClient is registered as ClapMiNetworkClient or similar

  getItInstance
      .registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(
            remoteDataSource: getItInstance<SearchRemoteDataSource>(),
          ));

  getItInstance.registerFactory(
    () => SearchBloc(searchRepository: getItInstance<SearchRepository>()),
  );

  // walletFeatures
  getItInstance.registerLazySingleton<WalletRemoteDatasource>(
      () => WalletRemoteDatasourceImpl(
            networkClient: getItInstance(),
            appPreferenceService: getItInstance<AppPreferenceService>(),
          ));

  getItInstance
      .registerLazySingleton<WalletRepository>(() => WalletRepositoryImpl(
            walletRemoteDatasource: getItInstance<WalletRemoteDatasource>(),
          ));

  // getItInstance.registerLazySingleton<CryptoRepo>(() => CryptoRepoImpl(
  //      // cryptoRemoteSource: ChainDataSourceImpl(),
  //       //  getItInstance<ChainDataSourceImpl>()
  //     ));

  getItInstance.registerFactory<WalletBloc>(() => WalletBloc(
        walletRepository: getItInstance<WalletRepository>(),
        //    cryptoRepo: getItInstance<CryptoRepo>(),
        appBloc: getItInstance<AppBloc>(),
      ));
  getItInstance.registerLazySingleton(() => VideoFeedProvider());
  await getItInstance.allReady();
}

//  WalletRepository
