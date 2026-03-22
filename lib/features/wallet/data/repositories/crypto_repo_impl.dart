// import 'package:clapmi/core/error/failure.dart';
// import 'package:clapmi/core/mapper/failure_mapper.dart';
// import 'package:clapmi/features/wallet/data/datasources/crypto_source/chain_repository.dart';
// import 'package:clapmi/features/wallet/domain/entities/chain_entity.dart';
// import 'package:clapmi/features/wallet/domain/repositories/crypto_repo.dart';
// import 'package:dartz/dartz.dart';
// import 'package:reown_appkit/base/appkit_base_impl.dart';

// class CryptoRepoImpl extends CryptoRepo {
//   final ChainDataSource cryptoRemoteSource;

//   CryptoRepoImpl({required this.cryptoRemoteSource});

//   @override
//   Future<Either<Failure, ReownAppKit?>> connectToMetamask() async {
//     try {
//       final result = await cryptoRemoteSource.fetchBalamceFromChain(
//           address: '', chain: ChainEntity(tokens: []));
//       return right(result);
//     } catch (e) {
//       return left(mapExceptionToFailure(e));
//     }
//   }
// }
