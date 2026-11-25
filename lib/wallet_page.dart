

import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  final int coins;
  final int diamonds;

  const WalletPage({
    super.key,
    this.coins = 500,
    this.diamonds = 0,
  });

  static const Color bg = Color(0xFF100026);
  static const Color purple = Color(0xFF6500B8);
  static const Color gold = Color(0xFFFFC629);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('My Wallet'),
        backgroundColor: const Color(0xFF260047),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [purple, Color(0xFF260047)],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  const Text(
                    'TOTAL BALANCE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$coins',
                    style: const TextStyle(
                      color: gold,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    '🪙 Coins',
                    style: TextStyle(color: Colors.white),
                  ),
                  const Divider(color: Colors.white30, height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.diamond,
                          color: Colors.cyanAccent, size: 32),
                      const SizedBox(width: 10),
                      Text(
                        '$diamonds Diamonds',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              '🪙 Coin Packages',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            packageCard(context, '1,000 Coins', '৳100', Icons.monetization_on),
            packageCard(context, '5,000 Coins', '৳450', Icons.monetization_on),
            packageCard(context, '10,000 Coins', '৳850', Icons.monetization_on),
            const SizedBox(height: 25),
            const Text(
              '💎 Diamond Packages',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            packageCard(context, '100 Diamonds', '৳100', Icons.diamond),
            packageCard(context, '500 Diamonds', '৳450', Icons.diamond),
            packageCard(context, '1,000 Diamonds', '৳850', Icons.diamond),
            const SizedBox(height: 25),
            const Text(
              'Transaction History',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF260047),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'No transactions yet',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget packageCard(
    BuildContext context,
    String amount,
    String price,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF260047),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: purple),
      ),
      child: Row(
        children: [
          Icon(icon, color: gold, size: 34),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              color: gold,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Payment system is not connected yet.',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: gold,
              foregroundColor: Colors.black,
            ),
            child: const Text('Buy'),
          ),
        ],
      ),
    );
  }
}
