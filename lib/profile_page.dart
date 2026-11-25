
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedTab = 3;

  final Color bg = const Color(0xFF001F19);
  final Color cyan = const Color(0xFF00D6CE);

  void showMessage(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name Coming Soon')),
    );
  }

  Widget menuItem(IconData icon, String name) {
    return InkWell(
      onTap: () => showMessage(name),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: cyan, size: 37),
          const SizedBox(height: 9),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget menuCard(List<Widget> children) {
    return Container(
      height: 125,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF193D36),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white70,
          width: 1.3,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: children.map((item) {
          return Expanded(child: item);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        top: 35,
                        bottom: 25,
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF064B2A),
                            Color(0xFF001F19),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '✨  🏮  👑  🏮  ✨',
                            style: TextStyle(fontSize: 27),
                          ),
                          const SizedBox(height: 20),

                          const CircleAvatar(
                            radius: 57,
                            backgroundColor: Colors.amber,
                            child: CircleAvatar(
                              radius: 53,
                              backgroundColor: Color(0xFF31534A),
                              child: Icon(
                                Icons.person,
                                size: 65,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'আদর',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    showMessage('Edit Profile'),
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),

                          const Text(
                            'ID:136433',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 35),

                          const Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                            children: [
                              _Stat(number: '54', label: 'Visitors'),
                              _Stat(number: '25', label: 'Following'),
                              _Stat(number: '18', label: 'Followers'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: _VipCard(
                                  title: 'VIP',
                                  color: Colors.deepPurple,
                                  icon: Icons.shield,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _VipCard(
                                  title: 'SVIP',
                                  color: Colors.deepOrange,
                                  icon: Icons.diamond,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          menuCard([
                            menuItem(Icons.account_balance_wallet, 'Wallet'),
                            menuItem(Icons.store, 'Store'),
                            menuItem(Icons.backpack, 'Bag'),
                            menuItem(Icons.card_giftcard, 'Reward'),
                          ]),

                          menuCard([
                            menuItem(Icons.account_circle, 'Host Center'),
                            menuItem(Icons.people, 'Family'),
                            menuItem(Icons.favorite, 'CP'),
                            menuItem(Icons.groups, 'Brother and'),
                          ]),

                          menuCard([
                            menuItem(Icons.person_add, 'Invite Friend'),
                            menuItem(Icons.call, 'Contact us'),
                            menuItem(Icons.workspace_premium, 'Level'),
                            menuItem(Icons.settings, 'Setting'),
                          ]),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              height: 82,
              decoration: const BoxDecoration(
                color: Color(0xFF063A2C),
                border: Border(
                  top: BorderSide(
                    color: Colors.amber,
                    width: 1.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _BottomItem(
                    icon: Icons.home,
                    title: 'Room',
                    selected: selectedTab == 0,
                    onTap: () => setState(() => selectedTab = 0),
                  ),
                  _BottomItem(
                    icon: Icons.stars,
                    title: 'Moment',
                    selected: selectedTab == 1,
                    onTap: () => setState(() => selectedTab = 1),
                  ),
                  _BottomItem(
                    icon: Icons.message,
                    title: 'Message',
                    selected: selectedTab == 2,
                    onTap: () => setState(() => selectedTab = 2),
                  ),
                  _BottomItem(
                    icon: Icons.person,
                    title: 'Me',
                    selected: selectedTab == 3,
                    onTap: () => setState(() => selectedTab = 3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String number;
  final String label;

  const _Stat({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
        const SizedBox(height: 7),
        Text(label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            )),
      ],
    );
  }
}

class _VipCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;

  const _VipCard({
    required this.title,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, Colors.amber.shade300],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          Icon(icon, size: 42, color: Colors.white),
        ],
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _BottomItem({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: selected ? Colors.amber : Colors.white70,
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              color: selected ? Colors.amber : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
