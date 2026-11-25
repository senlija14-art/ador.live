
import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  final int coins;
  final int diamonds;

  const WalletPage({super.key, this.coins = 0, this.diamonds = 0});

  static const bg = Color(0xFF100026);
  static const panel = Color(0xFF260047);
  static const purple = Color(0xFF7500D9);
  static const pink = Color(0xFFFF159F);
  static const gold = Color(0xFFFFC629);

  void info(BuildContext context, String title, String message) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: panel,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ঠিক আছে', style: TextStyle(color: gold)),
          ),
        ],
      ),
    );
  }

  void form(BuildContext context, String title, String hint) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: panel,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('এটি ডেমো। সার্ভার সংযোগ না থাকায় অনুরোধ পাঠানো হয়নি।'),
                ),
              );
            },
            child: const Text('জমা দিন'),
          ),
        ],
      ),
    ).whenComplete(controller.dispose);
  }

  @override
  Widget build(BuildContext context) {
    final items = <_WalletAction>[
      _WalletAction('Add Coins', Icons.add_circle, gold,
          () => info(context, 'Add Coins', 'নিরাপদ পেমেন্ট গেটওয়ে এখনো যুক্ত হয়নি।')),
      _WalletAction('Withdraw', Icons.account_balance, pink,
          () => form(context, 'Withdraw Request', 'পরিমাণ ও পেমেন্ট নম্বর')),
      _WalletAction('Send Coins', Icons.send, Colors.cyanAccent,
          () => form(context, 'Send Coins', 'প্রাপকের User ID ও কয়েন')),
      _WalletAction('Gift Coins', Icons.card_giftcard, gold,
          () => form(context, 'Gift Coins', 'প্রাপকের User ID ও গিফট')),
      _WalletAction('History', Icons.receipt_long, Colors.lightBlueAccent,
          () => info(context, 'Transaction History', 'লেনদেনের ডেটাবেস যুক্ত হলে এখানে ইতিহাস দেখা যাবে।')),
      _WalletAction('Payment', Icons.credit_card, Colors.orangeAccent,
          () => info(context, 'Payment Methods', 'bKash, Nagad, Rocket ও Card gateway এখনো যুক্ত হয়নি।')),
      _WalletAction('Daily Bonus', Icons.redeem, pink,
          () => info(context, 'Daily Bonus', 'বোনাসের সার্ভার যাচাই এখনো যুক্ত হয়নি।')),
      _WalletAction('Coupons', Icons.confirmation_number, gold,
          () => form(context, 'Apply Coupon', 'কুপন কোড লিখুন')),
      _WalletAction('Referral', Icons.people, Colors.cyanAccent,
          () => info(context, 'Referral Bonus', 'রেফারেল ব্যবস্থা এখনো যুক্ত হয়নি।')),
      _WalletAction('Exchange', Icons.currency_exchange, Colors.greenAccent,
          () => info(context, 'Coin Exchange', 'এক্সচেঞ্জের নিয়ম ও সার্ভার ব্যবস্থা এখনো যুক্ত হয়নি।')),
      _WalletAction('Security', Icons.shield, Colors.lightBlueAccent,
          () => info(context, 'Wallet Security', 'Wallet PIN ও দুই-ধাপ যাচাইয়ের Backend প্রয়োজন।')),
      _WalletAction('Support', Icons.support_agent, pink,
          () => form(context, 'Help & Support', 'আপনার সমস্যা লিখুন')),
    ];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('আমার Wallet', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: panel,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8500E8), Color(0xFF35005F), Color(0xFF78005D)],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: gold.withOpacity(.55)),
              ),
              child: Column(
                children: [
                  const Text('MY TOTAL BALANCE',
                      style: TextStyle(color: Colors.white70, letterSpacing: 1.3)),
                  const SizedBox(height: 12),
                  const Icon(Icons.account_balance_wallet, color: gold, size: 38),
                  const SizedBox(height: 8),
                  Text('$coins', style: const TextStyle(
                    color: gold, fontSize: 38, fontWeight: FontWeight.bold)),
                  const Text('Available Coins', style: TextStyle(color: Colors.white)),
                  const Divider(color: Colors.white30, height: 30),
                  Text('💎  $diamonds Diamonds',
                      style: const TextStyle(color: Colors.white, fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Wallet Services', style: TextStyle(
              color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.builder(
              itemCount: items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10,
                childAspectRatio: .95,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return InkWell(
                  onTap: item.onTap,
                  borderRadius: BorderRadius.circular(17),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF35005F), Color(0xFF1D0640)],
                      ),
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(color: purple),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icon, color: item.color, size: 30),
                        const SizedBox(height: 9),
                        Text(item.title, textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white,
                                fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text('Coin Recharge Packages', style: TextStyle(
              color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _package(context, '1,000 Coins', '৳100', Icons.monetization_on),
            _package(context, '5,000 Coins', '৳450', Icons.monetization_on),
            _package(context, '10,000 Coins', '৳850', Icons.monetization_on),
            const SizedBox(height: 14),
            const Text('Diamond Packages', style: TextStyle(
              color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _package(context, '100 Diamonds', '৳100', Icons.diamond),
            _package(context, '500 Diamonds', '৳450', Icons.diamond),
            _package(context, '1,000 Diamonds', '৳850', Icons.diamond),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFF3A230D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'নিরাপত্তা নোট: এই সংস্করণে Wallet-এর ডিজাইন ও মেনু তৈরি হয়েছে। '
                'বাস্তব Add Coins, Withdraw, Send/Gift, Bonus ও Payment চালুর আগে '
                'Supabase-এর নিরাপদ Database Policy এবং server-side transaction '
                'function তৈরি করতে হবে। আপাতত কোনো টাকা পাঠাবেন না।',
                style: TextStyle(color: Color(0xFFFFE7A0), fontSize: 12, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _package(BuildContext context, String amount, String price, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: purple),
      ),
      child: Row(
        children: [
          Icon(icon, color: gold, size: 30),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(amount, style: const TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(price, style: const TextStyle(color: gold,
                  fontWeight: FontWeight.bold)),
            ],
          )),
          OutlinedButton(
            onPressed: () => info(context, 'পেমেন্ট চালু হয়নি',
                'নিরাপদ bKash/Nagad বা Card gateway যুক্ত হলে এখানে পেমেন্ট করা যাবে।'),
            child: const Text('কিনুন'),
          ),
        ],
      ),
    );
  }
}

class _WalletAction {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _WalletAction(this.title, this.icon, this.color, this.onTap);
}
