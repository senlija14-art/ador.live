
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic>? profile;

  const ProfilePage({super.key, this.profile});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color bg = const Color(0xFF100026);
  final Color purple = const Color(0xFF7500D9);
  final Color pink = const Color(0xFFFF159F);
  final Color gold = const Color(0xFFFFC629);

  void showMessage(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name - Coming Soon'),
        backgroundColor: purple,
      ),
    );
  }

  String getValue(String key, String fallback) {
    final value = widget.profile?[key];
    if (value == null || value.toString().isEmpty) return fallback;
    return value.toString();
  }

  Widget actionItem(IconData icon, String title, Color color) {
    return InkWell(
      onTap: () => showMessage(title),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 112,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF35005F), Color(0xFF1D0640)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: purple, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 35),
            const SizedBox(height: 9),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuItem(IconData icon, String title, {String? badge}) {
    return InkWell(
      onTap: () {
  if (title == 'Wallet') {
    final coinsValue = widget.profile?['coins'];
    final diamondsValue = widget.profile?['diamonds'];

    final coins = coinsValue is num
        ? coinsValue.toInt()
        : int.tryParse('$coinsValue') ?? 0;

    final diamonds = diamondsValue is num
        ? diamondsValue.toInt()
        : int.tryParse('$diamondsValue') ?? 0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WalletPage(
          coins: coins,
          diamonds: diamonds,
        ),
      ),
    );
  } else {
    showMessage(title);
  }
},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFF382052)),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.pinkAccent, size: 25),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
            if (badge != null)
              Text(
                badge,
                style: TextStyle(
                  color: gold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.white70),
          ],
        ),
      ),
    );
  }

  Widget statItem(String number, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(Icons.people, color: color, size: 27),
          const SizedBox(height: 7),
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget balanceBox(IconData icon, String amount, String title, Color color) {
    return Expanded(
      child: InkWell(
        onTap: () => showMessage(title),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 38),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    amount,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(title, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = getValue('name', getValue('username', 'আদর'));
    final id = getValue('id', '136433');
    final coins = getValue('coins', '500');
    final diamonds = getValue('diamonds', '0');
    final level = getValue('level', '1');
    final avatar = getValue('avatar_url', '');

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 25),
          child: Column(
            children: [
              // Profile header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF35006B),
                      Color(0xFF17002F),
                      Color(0xFF100026),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () => showMessage('Notifications'),
                          icon: const Icon(Icons.notifications_none,
                              color: Colors.white, size: 28),
                        ),
                        IconButton(
                          onPressed: () => showMessage('Setting'),
                          icon: const Icon(Icons.settings,
                              color: Colors.white, size: 27),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 17),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: gold, width: 3),
                              ),
                              child: CircleAvatar(
                                radius: 54,
                                backgroundColor: const Color(0xFF46206C),
                                backgroundImage: avatar.isNotEmpty
                                    ? NetworkImage(avatar)
                                    : null,
                                child: avatar.isEmpty
                                    ? const Icon(Icons.person,
                                        size: 60, color: Colors.white)
                                    : null,
                              ),
                            ),
                            Icon(Icons.workspace_premium,
                                color: gold, size: 38),
                          ],
                        ),
                        const SizedBox(width: 17),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'ID: $id',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  _tag('👑 VIP', purple),
                                  const SizedBox(width: 8),
                                  _tag('⭐ Lv.$level', Colors.blue),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Live • Chat • Make Friends ❤️',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 22),

                    // Coins and diamonds
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 19),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6800B5), Color(0xFF310064)],
                        ),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: purple),
                      ),
                      child: Row(
                        children: [
                          balanceBox(Icons.monetization_on, coins,
                              'Coins', gold),
                          Container(width: 1, height: 48, color: Colors.white30),
                          balanceBox(Icons.diamond, diamonds,
                              'Diamonds', Colors.cyanAccent),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    Row(
                      children: [
                        statItem('54', 'Visitors', pink),
                        statItem('25', 'Following', Colors.cyan),
                        statItem('18', 'Followers', gold),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 22),

                    // VIP cards
                    Row(
                      children: [
                        Expanded(
                          child: _vipCard(
                            'My VIP',
                            Icons.workspace_premium,
                            const Color(0xFF8B00DD),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _vipCard(
                            'My SVIP',
                            Icons.diamond,
                            const Color(0xFFCF4A00),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // Four shortcuts
                    GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.82,
                      children: [
                        actionItem(Icons.account_balance_wallet,
                            'Wallet', Colors.pinkAccent),
                        actionItem(Icons.store, 'Store', Colors.orange),
                        actionItem(Icons.backpack,
                            'Bag', Colors.amber),
                        actionItem(Icons.card_giftcard,
                            'Reward', Colors.yellow),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Host and Family
                    Row(
                      children: [
                        Expanded(
                          child: _featureCard(
                            'Host Center',
                            'Become a Host',
                            Icons.mic,
                            const Color(0xFF7300FF),
                            () => showMessage('Host Center'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _featureCard(
                            'Family',
                            'Join Family',
                            Icons.groups,
                            const Color(0xFFE00091),
                            () => showMessage('Family'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Settings menu
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF260047), Color(0xFF18002D)],
                        ),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        children: [
                          menuItem(Icons.workspace_premium, 'My VIP',
                              badge: 'VIP'),
                          menuItem(Icons.security, 'Account Security'),
                          menuItem(Icons.card_giftcard, 'Invite Friends',
                              badge: '+100 Coins'),
                          menuItem(Icons.headset_mic, 'Help & Support'),
                          menuItem(Icons.info, 'About Us'),
                          menuItem(Icons.logout, 'Logout'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _vipCard(String title, IconData icon, Color color) {
    return InkWell(
      onTap: () => showMessage(title),
      child: Container(
        height: 85,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, const Color(0xFF320052)],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Icon(icon, color: Colors.amber, size: 32),
          ],
        ),
      ),
    );
  }

  Widget _featureCard(String title, String subtitle, IconData icon,
      Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 112,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, const Color(0xFF30004E)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 35),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      )),
                  const SizedBox(height: 5),
                  Text(subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
