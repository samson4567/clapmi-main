import 'dart:convert';
import 'package:clapmi/features/wallet/data/models/crypto_wallet_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CryptoRepository {
  static Future<List<CryptoWalletModel>> fetchWallet() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    dynamic walletJsonString = pref.getString("walletAddress");
    if (walletJsonString == null) {
      return [];
    }
    print(walletJsonString);
    List<dynamic> walletMap = jsonDecode(walletJsonString);
    List<CryptoWalletModel> wallet =
        walletMap.map((e) => CryptoWalletModel.fromJson(e)).toList();
    return wallet;
  }

  static void saveWallet({
    name,
    publicAddress,
    mnemonic,
    privateKey,
  }) async {
    List<CryptoWalletModel> saveWallet = await CryptoRepository.fetchWallet();

    saveWallet.insert(
        0,
        CryptoWalletModel(
            name: name,
            publicAddress: publicAddress,
            mnemonic: mnemonic,
            privateKey: privateKey,
            chains: []));
    List<Map<String, dynamic>> savedWalletJson =
        saveWallet.map((e) => e.toMap()).toList();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('walletAddress', jsonEncode(savedWalletJson));
  }
}
