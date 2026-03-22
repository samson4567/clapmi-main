// import 'package:blockchain_utils/bip/bip.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:web3dart/web3dart.dart';

// class CryptoWalletServices {
//   //Mnemonic to probably be sent to the backend or get it and write it down at the frontend...
//   //For Future purpose..
//   //If the person wants to enter the wallet address back he will have to manually do that...

//   //*GENERATE MNEMONIC WORDS */
//   static Future<String> generateMnemonic() async {
//     //**GENERATE MNEMONICS AND GET A 24 WORDS PASSPHRASE FOR YOUR WALLET */
//     final mnemonic = Bip39MnemonicGenerator(Bip39Languages.english)
//         .fromWordsNumber(Bip39WordsNum.wordsNum24);
//     final pref = await SharedPreferences.getInstance();
//     pref.setString('mnemonic', mnemonic.toStr());

//     // generatePrivateKey(mnemonic.toStr());

//     return mnemonic.toStr();
//   }

// //The idea of this is to test and generate
//   static String generatePrivateKey(String words) {
//     //GENERATE MNEMONIC FROM THE WORDS THAT WERE PASSED
//     final mnemonic = Bip39Mnemonic.fromString(words);

//     //CONVERT THE MNEMONIC TO SEED
//     final seed = Bip39SeedGenerator(mnemonic).generate("optional-passphrase");

//     //Derive the BIP44 Ethereum wallet
//     final wallet = Bip44.fromSeed(seed, Bip44Coins.ethereum);
//     final defaultPathWallet = wallet.deriveDefaultPath;

//     // Step 4: Get private key in hex for the sake of web3dart that is going to be used
//     final privateKey = defaultPathWallet.privateKey.privKey.toHex();
//     print(
//         'This is the private key in Bytes for recovery situation $privateKey');

//     return privateKey;
//   }

//   static Credentials generatePublicKey(String privateKey) {
//     //**THE PUBLIC KEY GENERATED HERE IS TO THE END THAT */
//     //** IT CAN NOW BE USEFUL ON ETHEREUM BASED ON WEB3DART SPECIFICATION */
//     Credentials credentials = EthPrivateKey.fromHex(privateKey);
//     return credentials;
//   }

//   static void addWallet(String words, String walletName) {
//     String privateKey = CryptoWalletServices.generatePrivateKey(words);
//     Credentials publicKey = CryptoWalletServices.generatePublicKey(privateKey);

//     var ethClient = Web3Client('', Client());
//     ethClient.getBalance(publicKey.address);
//   }

//   static void testingChainWorking() async {
//     // final wordsGenerated = await CryptoWalletServices.generateMnemonic();
//     // print('This is the word generated...... $wordsGenerated');
//     // final privateKey = CryptoWalletServices.generatePrivateKey(wordsGenerated);

//     // print('This is the generated private key............ $privateKey');

//     final publicKey = CryptoWalletServices.generatePublicKey(
//         "7ed1b5e99ba2b05a6cd390834706e5d637da648b3bfbf43b8fc35028c173d0db");
//     // Credentials credentials = EthPrivateKey.fromHex(privateKey); // Public Key Generated.....

//     print(
//         'This is the generated publickey from the EthPrivateKey----------- ${publicKey.address.toString()}');

//     //Generated private key
//     //7ed1b5e99ba2b05a6cd390834706e5d637da648b3bfbf43b8fc35028c173d0db

//     //This is the generated Public key....
//     //874feCe505B09A49F01792Eda5c833A647469fff

//     var ethClient = Web3Client('https://rpc.sepolia-api.lisk.com', Client());
//     var balance = await ethClient.getBalance(publicKey.address);
//     print(
//         "This is the balance gotten from the contract address or something ------ ${balance.getInWei}");

//     final abiString = await rootBundle.loadString('assets/contract.abi.json');

//     final contractAddress = CryptoWalletServices.generatePublicKey("");
//     //Let us get the token Balance
//     final contract = DeployedContract(
//         ContractAbi.fromJson(abiString, 'PaymentContract'),
//         EthPrivateKey.fromHex('').address);

//         final paywithUSDT = contract.function('payWithUSDT');
//   }
// }
