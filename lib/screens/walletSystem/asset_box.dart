import 'package:clapmi/features/wallet/data/models/asset_balance.dart';
import 'package:flutter/material.dart';

class AssetBox extends StatelessWidget {
  const AssetBox({required this.balances, super.key});
  final List<AssetModel> balances;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...balances.map(_assetCard),
        ],
      ),
    );
  }

  /// Builds an individual asset card from the [AssetModel].
  Widget _assetCard(AssetModel asset) {
    final iconPath = _iconForSymbol(asset.symbol);

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: const Color(0xFF1E1E1E), width: 1.5),
                ),
                child: ClipOval(
                  child: Image.asset(iconPath, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                asset.symbol,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            asset.name,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Text(
            '${double.tryParse(asset.balance)?.toStringAsFixed(3)}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            '1 ${asset.symbol} = \$${double.tryParse(asset.conversionRate)?.toStringAsFixed(3)} USD',
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Utility: map the asset symbol to its icon path.
  /// You can expand or replace this mapping as needed.
  String _iconForSymbol(String symbol) {
    switch (symbol) {
      case 'CAPP':
        return 'assets/images/openmoji_coin 1.png';
      case 'USDT':
        return 'assets/images/cryptocurrency-color_usdt.png';
      default:
        return 'assets/images/usdc.png';
    }
  }
}
