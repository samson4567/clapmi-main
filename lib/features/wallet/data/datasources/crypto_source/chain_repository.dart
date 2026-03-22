// import 'package:clapmi/features/wallet/domain/entities/chain_entity.dart';
// import 'package:http/http.dart';
// import "package:reown_appkit/reown_appkit.dart";

// abstract class ChainDataSource {
//   Future<ReownAppKit?> fetchBalamceFromChain(
//       {required String address, required ChainEntity chain});
// }

// class ChainDataSourceImpl extends ChainDataSource {
//   var httpClient = Client();
//   @override
//   Future<ReownAppKit?> fetchBalamceFromChain(
//       {required String address, required ChainEntity chain}) async {
//     print('This is testing the connection to metaMask on the application');
//     try {
//       final appKitModal = await ReownAppKit.createInstance(
//           projectId: '660f502fca34979802846878e403e25a',
//           metadata: const PairingMetadata(
//               name: 'Clapmi App',              
//               description: 'A social Media Application',
//               url: 'https://staging.clapmi.com',
//               icons: ['https://scontent.flos1-1.fna.fbcdn.net/v/t39.30808-6/304759900_384998397140035_7026570229034445650_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeEKKhPAlyu4tKIfyxbXBERCjN6xfB-evsKM3rF8H56-wqQDBbGd9s5hRZPg69VUwAzrslHL_fc13bwKDaJSJeCl&_nc_ohc=LDiiemtEiGQQ7kNvwERuHXU&_nc_oc=Adm8hpiMyBm1g8uwcVzXqFYCdBtGG5dd2Hci-hncp4SrGB9kPmKZE8dltu3oc-nwDck&_nc_zt=23&_nc_ht=scontent.flos1-1.fna&_nc_gid=xHzhY9zst9gMk9P0BrTyIA&oh=00_AfQe1GwepW59HdZfiM_33ykY6SB8wrln5DFHKf91PbRsrg&oe=68724B0C'],
//               redirect: Redirect(
//                 native: 'clapmi://app/onboardingPage"',
//                 // universal: ''
//                 linkMode: true | false,
//               )));
//       print({
//         'This is the response from the appkIT ... ${appKitModal.toString()}'
//       });
//       return appKitModal;
//     } catch (e) {
//       print('this is the error language ${e.toString()}');
//     }

//     return null;
//     // balance.toString();
//   }
// }
