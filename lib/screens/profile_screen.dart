import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'আদর';
  final String _userId = '136433';
  String _userEmoji = '👑';
  String _frameType = 'vip'; // 'none', 'classic', 'vip', 'neon'
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _userName = prefs.getString('user_name') ?? 'আদর';
      _userEmoji = prefs.getString('user_emoji') ?? '👑';
      _frameType = prefs.getString('frame_type') ?? 'vip';
      _avatarPath = prefs.getString('avatar_path');
    });
  }

  Future<void> _pickAvatar() async {
    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('avatar_path', picked.path);
        if (!mounted) return;
        setState(() {
          _avatarPath = picked.path;
        });
      }
    } catch (e) {
      _showSnack('ছবি সিলেক্ট করা যায়নি');
    }
  }

  Future<void> _editNameDialog() async {
    final controller = TextEditingController(text: _userName);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0C2D28),
        title: const Text('নাম পরিবর্তন করুন', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'আপনার নাম লিখুন',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('বাতিল', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1DE99B)),
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('সেভ', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', result);
      if (!mounted) return;
      setState(() => _userName = result);
    }
  }

  Future<void> _setFrame(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('frame_type', type);
    if (!mounted) return;
    setState(() => _frameType = type);
  }

  Future<void> _setEmoji(String emoji) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_emoji', emoji);
    if (!mounted) return;
    setState(() => _userEmoji = emoji);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF061E1B),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 10),

            // নাম, ইমোজি ও এডিট বাটন
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_userName $_userEmoji',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _editNameDialog,
                  child: const Icon(
                    Icons.edit_rounded,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),
            Text(
              'ID:$_userId',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            // Visitors, Following, Followers
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatColumn(count: '54', label: 'Visitors'),
                  _StatColumn(count: '25', label: 'Following'),
                  _StatColumn(count: '18', label: 'Followers'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // VIP & SVIP কার্ড
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildVipCard(
                      title: 'VIP',
                      colors: const [Color(0xFF6B38FB), Color(0xFFA770EF)],
                      icon: Icons.shield_rounded,
                      iconColor: Colors.lightBlueAccent,
                      onTap: () => _showSnack('VIP পেজ (পরের ধাপে যুক্ত হবে)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildVipCard(
                      title: 'SVIP',
                      colors: const [Color(0xFFFF4E50), Color(0xFFF9D423)],
                      icon: Icons.diamond_rounded,
                      iconColor: Colors.cyanAccent,
                      onTap: () => _showSnack('SVIP পেজ (পরের ধাপে যুক্ত হবে)'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Wallet, Store, Bag, Reward
            _buildGlassCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _QuickActionItem(
                    icon: Icons.account_balance_wallet_rounded,
                    label: 'Wallet',
                    color: Colors.amberAccent,
                    onTap: () => _showSnack('Wallet'),
                  ),
                  _QuickActionItem(
                    icon: Icons.storefront_rounded,
                    label: 'Store',
                    color: Colors.pinkAccent,
                    onTap: () => _showSnack('Store'),
                  ),
                  _QuickActionItem(
                    icon: Icons.backpack_rounded,
                    label: 'Bag',
                    color: Colors.orangeAccent,
                    onTap: () => _showSnack('Bag'),
                  ),
                  _QuickActionItem(
                    icon: Icons.card_giftcard_rounded,
                    label: 'Reward',
                    color: Colors.lightBlueAccent,
                    onTap: () => _showSnack('Reward'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // মূল গ্রিড মেনু + Frame, VIP Frame, Emoji
            _buildGlassCard(
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 8,
                childAspectRatio: 0.95,
                children: [
                  _MenuGridItem(
                    icon: Icons.person_pin_rounded,
                    label: 'Host Center',
                    color: Colors.tealAccent,
                    onTap: () => _showSnack('Host Center'),
                  ),
                  _MenuGridItem(
                    icon: Icons.groups_rounded,
                    label: 'Family',
                    color: Colors.tealAccent,
                    onTap: () => _showSnack('Family'),
                  ),
                  _MenuGridItem(
                    icon: Icons.favorite_rounded,
                    label: 'CP',
                    color: Colors.cyanAccent,
                    onTap: () => _showSnack('CP'),
                  ),
                  _MenuGridItem(
                    icon: Icons.people_rounded,
                    label: 'Brotherhood',
                    color: Colors.lightBlueAccent,
                    onTap: () => _showSnack('Brotherhood'),
                  ),
                  _MenuGridItem(
                    icon: Icons.person_add_rounded,
                    label: 'Invite Friend',
                    color: Colors.tealAccent,
                    onTap: () => _showSnack('Invite Friend'),
                  ),
                  _MenuGridItem(
                    icon: Icons.support_agent_rounded,
                    label: 'Contact us',
                    color: Colors.tealAccent,
                    onTap: () => _showSnack('Contact us'),
                  ),
                  _MenuGridItem(
                    icon: Icons.military_tech_rounded,
                    label: 'Level',
                    color: Colors.tealAccent,
                    onTap: () => _showSnack('Level'),
                  ),
                  _MenuGridItem(
                    icon: Icons.settings_rounded,
                    label: 'Setting',
                    color: Colors.tealAccent,
                    onTap: () => _showSnack('Setting'),
                  ),
                  _MenuGridItem(
                    icon: Icons.filter_frames_rounded,
                    label: 'Frame',
                    color: Colors.amberAccent,
                    onTap: _showFramePicker,
                  ),
                  _MenuGridItem(
                    icon: Icons.auto_awesome_rounded,
                    label: 'VIP Frame',
                    color: Colors.orangeAccent,
                    onTap: () {
                      final next = _frameType == 'vip' ? 'none' : 'vip';
                      _setFrame(next);
                      _showSnack(
                        next == 'vip' ? 'VIP Frame চালু হয়েছে' : 'VIP Frame বন্ধ হয়েছে',
                      );
                    },
                  ),
                  _MenuGridItem(
                    icon: Icons.emoji_emotions_rounded,
                    label: 'Emoji',
                    color: Colors.yellowAccent,
                    onTap: _showEmojiPicker,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    final bool hasFile = _avatarPath != null && File(_avatarPath!).existsSync();

    List<Color>? frameGradient;
    Color? glowColor;
    if (_frameType == 'vip') {
      frameGradient = const [Color(0xFFFFD700), Color(0xFFFF8C00), Color(0xFFFFF099)];
      glowColor = const Color(0x66FFD700);
    } else if (_frameType == 'classic') {
      frameGradient = const [Color(0xFF00F5D4), Color(0xFF00BBF9)];
      glowColor = const Color(0x5500F5D4);
    } else if (_frameType == 'neon') {
      frameGradient = const [Color(0xFFFF007F), Color(0xFF7928CA)];
      glowColor = const Color(0x55FF007F);
    }

    return SizedBox(
      height: 195,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
            bottom: 35,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0E4D3B),
                    Color(0xFF082E26),
                    Color(0xFF061E1B),
                  ],
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 44, left: 22, right: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.star_rounded, color: Color(0x44FFD700), size: 32),
                    Icon(Icons.nights_stay_rounded, color: Color(0x44FFD700), size: 42),
                  ],
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: _pickAvatar,
            child: Container(
              padding: const EdgeInsets.all(4.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: frameGradient != null ? LinearGradient(colors: frameGradient) : null,
                border: frameGradient == null ? Border.all(color: Colors.white54, width: 2) : null,
                boxShadow: glowColor != null
                    ? [BoxShadow(color: glowColor, blurRadius: 14, spreadRadius: 2)]
                    : null,
              ),
              child: CircleAvatar(
                radius: 44,
                backgroundColor: const Color(0xFF103B34),
                backgroundImage: hasFile ? FileImage(File(_avatarPath!)) : null,
                child: hasFile
                    ? null
                    : const Icon(Icons.person, size: 48, color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVipCard({
    required String title,
    required List<Color> colors,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 66,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Icon(icon, color: iconColor, size: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0x14FFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1AFFFFFF)),
      ),
      child: child,
    );
  }

  void _showFramePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0C2D28),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('প্রোফাইল ফ্রেম বেছে নিন', style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              children: [
                ChoiceChip(
                  label: const Text('VIP Gold'),
                  selected: _frameType == 'vip',
                  onSelected: (_) {
                    _setFrame('vip');
                    Navigator.pop(ctx);
                  },
                ),
                ChoiceChip(
                  label: const Text('Ocean'),
                  selected: _frameType == 'classic',
                  onSelected: (_) {
                    _setFrame('classic');
                    Navigator.pop(ctx);
                  },
                ),
                ChoiceChip(
                  label: const Text('Neon'),
                  selected: _frameType == 'neon',
                  onSelected: (_) {
                    _setFrame('neon');
                    Navigator.pop(ctx);
                  },
                ),
                ChoiceChip(
                  label: const Text('None'),
                  selected: _frameType == 'none',
                  onSelected: (_) {
                    _setFrame('none');
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEmojiPicker() {
    final emojis = ['👑', '🔥', '💎', '🦅', '❤️', '🌙', '⚡', '🦁'];
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0C2D28),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('ইমোজি সিলেক্ট করুন', style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              children: emojis.map((e) {
                return GestureDetector(
                  onTap: () {
                    _setEmoji(e);
                    Navigator.pop(ctx);
                  },
                  child: Text(e, style: const TextStyle(fontSize: 30)),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String count;
  final String label;
  const _StatColumn({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class _MenuGridItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MenuGridItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
