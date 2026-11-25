import 'wallet_page.dart';
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
  static const Color darkPurple = Color(0xFF260047);
  static const Color gold = Color(0xFFFFC629);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text(
          'My Wallet',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: darkPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [purple, darkPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: gold.withOpacity(0.5),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'MY TOTAL BALANCE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Icon(
                    Icons.account_balance_wallet,
                    color: gold,
                    size: 38,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$coins',
                    style: const TextStyle(
                      color: gold,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Available Coins',
                    style: TextStyle(color: Colors.white),
                  ),
                  const Divider(
                    color: Colors.white30,
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.diamond,
                        color: Colors.cyanAccent,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '$diamonds Diamonds',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Coin Packages
            sectionTitle('🪙 Coin Recharge Packages'),

            packageCard(
              context,
              '1,000 Coins',
              '৳100',
              Icons.monetization_on,
            ),
            packageCard(
              context,
              '5,000 Coins',
              '৳450',
              Icons.monetization_on,
            ),
            packageCard(
              context,
              '10,000 Coins',
              '৳850',
              Icons.monetization_on,
            ),

            const SizedBox(height: 25),

            // Diamond Packages
            sectionTitle('💎 Diamond Packages'),

            packageCard(
              context,
              '100 Diamonds',
              '৳100',
              Icons.diamond,
            ),
            packageCard(
              context,
              '500 Diamonds',
              '৳450',
              Icons.diamond,
            ),
            packageCard(
              context,
              '1,000 Diamonds',
              '৳850',
              Icons.diamond,
            ),

            const SizedBox(height: 25),

            // Payment Methods
            sectionTitle('Payment Methods'),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: darkPurple,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: purple),
              ),
              child: const Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance,
                        color: gold,
                        size: 25,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'bKash',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Coming Soon',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.payment,
                        color: Colors.greenAccent,
                        size: 25,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Nagad',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Coming Soon',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Transaction History
            sectionTitle('Transaction History'),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: darkPurple,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: purple),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.receipt_long,
                    color: gold,
                    size: 38,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No transactions yet',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
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
        color: darkPurple,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: purple),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: gold,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  amount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  price,
                  style: const TextStyle(
                    color: gold,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 11,
              ),
            ),
            child: const Text(
              'Buy',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
