import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';
import 'wallet_page.dart';
import 'profile_page.dart';
import 'room_theme.dart';

const int zegoAppID = 1215236018;
const String zegoAppSign = 'd0deabfd9623d2c75ef2dc3f2fd5a80bb46f979c9c9c73171b5e421a15eb102d';
const String supabaseUrl = 'https://yoicutbnblnrjytgcehs.supabase.co';
const String supabaseAnonKey = 'sb_publishable_EWLjhL6DbfFbooH8w6IEJg_eLlR0djP';

final supabase = Supabase.instance.client;

class OutfitFrame {
  final String id;
  final String name;
  final String emoji;
  final int price;
  final List<Color> colors;

  const OutfitFrame({
    required this.id,
    required this.name,
    required this.emoji,
    required this.price,
    required this.colors,
  });
}

const List<OutfitFrame> appFrames = [
  OutfitFrame(
    id: 'none',
    name: 'সাধারণ',
    emoji: '⚪',
    price: 0,
    colors: [Colors.white24, Colors.white24],
  ),
  OutfitFrame(
    id: 'gold',
    name: 'গোল্ডেন ক্রাউন',
    emoji: '👑',
    price: 200,
    colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
  ),
  OutfitFrame(
    id: 'fire',
    name: 'ফায়ার ড্রাগন',
    emoji: '🔥',
    price: 400,
    colors: [Color(0xFFFF1744), Color(0xFFFF9100)],
  ),
  OutfitFrame(
    id: 'rose',
    name: 'পিঙ্ক রোজ',
    emoji: '🌸',
    price: 300,
    colors: [Color(0xFFFF4081), Color(0xFFE040FB)],
  ),
  OutfitFrame(
    id: 'diamond',
    name: 'ডায়মন্ড কুইন',
    emoji: '💎',
    price: 700,
    colors: [Color(0xFF00E5FF), Color(0xFF2979FF)],
  ),
  OutfitFrame(
    id: 'cyber',
    name: 'নিয়ন সাইবার',
    emoji: '⚡',
    price: 500,
    colors: [Color(0xFF00E676), Color(0xFF651FFF)],
  ),
];

OutfitFrame getFrameById(String? id) {
  return appFrames.firstWhere(
    (f) => f.id == id,
    orElse: () => appFrames.first,
  );
}

class GiftItem {
  final String name;
  final String emoji;
  final int cost;
  const GiftItem(this.name, this.emoji, this.cost);
}

const List<GiftItem> appGifts = [
  GiftItem('গোলাপ', '🌹', 10),
  GiftItem('হার্ট', '❤️', 50),
  GiftItem('কেক', '🎂', 80),
  GiftItem('হীরা', '💎', 200),
  GiftItem('মুকুট', '👑', 300),
  GiftItem('গাড়ি', '🏎️', 1000),
  GiftItem('রকেট', '🚀', 2000),
];

class FramedAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final String? frameId;
  final double size;

  const FramedAvatar({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.frameId,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    final frame = getFrameById(frameId);
    final hasFrame = frame.id != 'none';
    final trimmed = name.trim();
    final letter = trimmed.isNotEmpty
        ? String.fromCharCode(trimmed.runes.first).toUpperCase()
        : 'A';

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(hasFrame ? 3.5 : 1.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: frame.colors),
            boxShadow: hasFrame
                ? [
                    BoxShadow(
                      color: frame.colors.first.withOpacity(0.55),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF331B5E),
            backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                ? NetworkImage(avatarUrl!)
                : null,
            child: (avatarUrl == null || avatarUrl!.isEmpty)
                ? Text(
                    letter,
                    style: TextStyle(
                      fontSize: size * 0.38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
        ),
        if (hasFrame)
          Positioned(
            top: -6,
            child: Text(
              frame.emoji,
              style: TextStyle(fontSize: size * 0.30),
            ),
          ),
      ],
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  final prefs = await SharedPreferences.getInstance();
  final savedUserId = prefs.getString('ador_user_id');
  runApp(AdorLiveApp(initialUserId: savedUserId));
}

class AdorLiveApp extends StatelessWidget {
  final String? initialUserId;
  const AdorLiveApp({super.key, this.initialUserId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'আদর লাইভ',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF130926),
        primaryColor: Colors.pinkAccent,
        colorScheme: const ColorScheme.dark(
          primary: Colors.pinkAccent,
          secondary: Colors.amber,
        ),
      ),
      home: initialUserId != null
          ? MainShell(myUserId: initialUserId!)
          : const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _usernameCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  bool isRegister = false;
  bool loading = false;

  Future<void> _submit() async {
    final username = _usernameCtrl.text.trim().toLowerCase().replaceAll(' ', '');
    final pin = _pinCtrl.text.trim();
    final name = _nameCtrl.text.trim();

    if (username.length < 3 || pin.length < 4) {
      _msg('ইউজারনেম কমপক্ষে ৩ অক্ষর এবং ৪ ডিজিটের পিন দিন');
      return;
    }

    setState(() => loading = true);
    try {
      Map<String, dynamic>? user;
      if (isRegister) {
        if (name.isEmpty) {
          _msg('আপনার নাম লিখুন');
          setState(() => loading = false);
          return;
        }
        final existing = await supabase
            .from('profiles')
            .select()
            .eq('username', username)
            .maybeSingle();
        if (existing != null) {
          _msg('এই ইউজারনেম আগেই নেওয়া হয়েছে, অন্যটি দিন');
          setState(() => loading = false);
          return;
        }
        final newId = (100000 + Random().nextInt(899999)).toString();
        user = await supabase.from('profiles').insert({
          'id': newId,
          'username': username,
          'pin': pin,
          'name': name,
          'coins': 1500,
          'level': 1,
          'frame_id': 'gold',
          'owned_frames': ['none', 'gold'],
        }).select().single();
      } else {
        user = await supabase
            .from('profiles')
            .select()
            .eq('username', username)
            .eq('pin', pin)
            .maybeSingle();
        if (user == null) {
          _msg('ইউজারনেম বা পিন ভুল হয়েছে! নতুন হলে "নতুন অ্যাকাউন্ট" চাপুন');
          setState(() => loading = false);
          return;
        }
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('ador_user_id', user['id']);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainShell(myUserId: user!['id'])),
      );
    } catch (e) {
      _msg('ত্রুটি হয়েছে: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _msg(String t) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.pinkAccent, Colors.deepPurple],
                    ),
                  ),
                  child: const Icon(Icons.mic, size: 54, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  'আদর লাইভ',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                  ),
                ),
                const Text(
                  'রিয়েল ভয়েস গ্রুপ চ্যাট ও আড্ডা',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 30),
                if (isRegister) ...[
                  TextField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      labelText: 'আপনার নাম (যেমন: রিমন)',
                      prefixIcon: const Icon(Icons.badge),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                TextField(
                  controller: _usernameCtrl,
                  decoration: InputDecoration(
                    labelText: 'ইউজারনেম বা মোবাইল নম্বর',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _pinCtrl,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '৪ ডিজিটের পিন (যেমন: 1234)',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: loading ? null : _submit,
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            isRegister ? 'অ্যাকাউন্ট তৈরি করুন' : 'লগইন করুন',
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => setState(() => isRegister = !isRegister),
                  child: Text(
                    isRegister
                        ? 'আগে থেকেই অ্যাকাউন্ট আছে? লগইন করুন'
                        : 'নতুন ইউজার? নতুন অ্যাকাউন্ট খুলুন',
                    style: const TextStyle(color: Colors.amber),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  final String myUserId;
  const MainShell({super.key, required this.myUserId});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;
  Map<String, dynamic>? myProfile;
  Set<String> followingIds = {};
  String selectedCategory = 'সব';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    await _refreshMyProfile();
    await _refreshFollows();
  }

  Future<void> _refreshMyProfile() async {
    final res = await supabase
        .from('profiles')
        .select()
        .eq('id', widget.myUserId)
        .maybeSingle();
    if (res != null && mounted) {
      setState(() => myProfile = res);
    } else if (res == null && mounted) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('ador_user_id');
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    }
  }

  Future<void> _refreshFollows() async {
    final rows = await supabase
        .from('follows')
        .select('following_id')
        .eq('follower_id', widget.myUserId);
    if (mounted) {
      setState(() {
        followingIds = rows.map((r) => r['following_id'].toString()).toSet();
      });
    }
  }

  Future<void> _toggleFollow(String targetId) async {
    if (targetId == widget.myUserId) return;
    if (followingIds.contains(targetId)) {
      await supabase
          .from('follows')
          .delete()
          .eq('follower_id', widget.myUserId)
          .eq('following_id', targetId);
      setState(() => followingIds.remove(targetId));
    } else {
      await supabase.from('follows').insert({
        'follower_id': widget.myUserId,
        'following_id': targetId,
      });
      setState(() => followingIds.add(targetId));
    }
  }

  Future<void> _joinRoom({
    required String roomId,
    required String roomTitle,
    required bool isHost,
  }) async {
    if (myProfile == null) return;
    await supabase.from('profiles').update({
      'current_room_id': roomId,
      'current_room_title': roomTitle,
    }).eq('id', widget.myUserId);

    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VoiceRoomPage(
          roomID: roomId,
          roomTitle: roomTitle,
          myProfile: myProfile!,
          isHost: isHost,
        ),
      ),
    );
    await _refreshMyProfile();
    await _refreshFollows();
  }

  void _showCreateRoomDialog() {
    final titleCtrl = TextEditingController();
    String category = 'আড্ডা';
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          backgroundColor: const Color(0xFF231147),
          title: const Text('🎙️ নতুন ভয়েস রুম খুলুন'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'রুমের নাম (যেমন: রাতের আড্ডা)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                dropdownColor: const Color(0xFF231147),
                decoration: const InputDecoration(
                  labelText: 'ক্যাটাগরি',
                  border: OutlineInputBorder(),
                ),
                items: ['আড্ডা', 'গানের আসর', 'কবিতা', 'গেম']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setD(() => category = v ?? 'আড্ডা'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('বাতিল'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
              onPressed: () async {
                final title = titleCtrl.text.trim().isEmpty
                    ? '${myProfile?['name'] ?? 'আদর'}-এর রুম'
                    : titleCtrl.text.trim();
                final roomId = 'ador_${widget.myUserId}_${Random().nextInt(999)}';
                await supabase.from('rooms').upsert({
                  'id': roomId,
                  'title': title,
                  'category': category,
                  'host_id': widget.myUserId,
                  'host_name': myProfile?['name'] ?? 'Host',
                  'is_live': true,
                });
                if (!ctx.mounted) return;
                Navigator.pop(ctx);
                _joinRoom(roomId: roomId, roomTitle: title, isHost: true);
              },
              child: const Text('লাইভ শুরু করুন'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (myProfile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF231147),
        title: const Row(
          children: [
            Icon(Icons.mic, color: Colors.pinkAccent),
            SizedBox(width: 8),
            Text('আদর লাইভ', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Text('🪙', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  '${myProfile!['coins'] ?? 0}',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _tab,
        children: [
          _buildLiveRoomsTab(),
          _buildFollowingTab(),
           ProfilePage(profile: myProfile),
        ],
         ),
      floatingActionButton: _tab == 0
          ? FloatingActionButton.extended(
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
              onPressed: _showCreateRoomDialog,
              icon: const Icon(Icons.add_call),
              label: const Text('রুম খুলুন'),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        backgroundColor: const Color(0xFF1C0D38),
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.white60,
        onTap: (i) {
          setState(() => _tab = i);
          _refreshMyProfile();
          _refreshFollows();
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'লাইভ রুম'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'ফলো ও বন্ধু'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'প্রোফাইল'),
        ],
      ),
    );
  }

  Widget _buildLiveRoomsTab() {
    final categories = ['সব', 'আড্ডা', 'গানের আসর', 'কবিতা', 'গেম'];
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: categories.length,
            itemBuilder: (_, i) {
              final cat = categories[i];
              final active = selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: active,
                  selectedColor: Colors.pinkAccent,
                  onSelected: (_) => setState(() => selectedCategory = cat),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: supabase
                .from('rooms')
                .stream(primaryKey: ['id'])
                .eq('is_live', true)
                .order('created_at', ascending: false),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              var rooms = snapshot.data!;
              if (selectedCategory != 'সব') {
                rooms = rooms
                    .where((r) => r['category'] == selectedCategory)
                    .toList();
              }
              if (rooms.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.mic_off, size: 64, color: Colors.white30),
                      const SizedBox(height: 12),
                      const Text('এখন কোনো রুম লাইভে নেই!',
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent),
                        onPressed: _showCreateRoomDialog,
                        icon: const Icon(Icons.mic),
                        label: const Text('প্রথম রুমটি আপনি খুলুন'),
                      ),
                    ],
                  ),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.all(14),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.05,
                ),
                itemCount: rooms.length,
                itemBuilder: (_, i) {
                  final r = rooms[i];
                  final isMyRoom = r['host_id'] == widget.myUserId;
                  return InkWell(
                    onTap: () => _joinRoom(
                      roomId: r['id'],
                      roomTitle: r['title'],
                      isHost: isMyRoom,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF33186B), Color(0xFF52185E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: Colors.pinkAccent.withOpacity(0.35)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.pinkAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '🔴 ${r['category'] ?? 'লাইভ'}',
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                              const Icon(Icons.graphic_eq,
                                  color: Colors.greenAccent, size: 18),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r['title'] ?? 'ভয়েস রুম',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '👑 হোস্ট: ${r['host_name'] ?? 'User'}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFollowingTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: (v) => setState(() => searchQuery = v.trim().toLowerCase()),
            decoration: InputDecoration(
              hintText: 'বন্ধুর নাম বা আইডি খুঁজুন...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFF231147),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: supabase
                .from('profiles')
                .stream(primaryKey: ['id'])
                .order('level', ascending: false),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              var users = snapshot.data!
                  .where((u) => u['id'] != widget.myUserId)
                  .toList();

              if (searchQuery.isNotEmpty) {
                users = users.where((u) {
                  final n = (u['name'] ?? '').toString().toLowerCase();
                  final un = (u['username'] ?? '').toString().toLowerCase();
                  final id = (u['id'] ?? '').toString();
                  return n.contains(searchQuery) ||
                      un.contains(searchQuery) ||
                      id.contains(searchQuery);
                }).toList();
              } else {
                users.sort((a, b) {
                  final aFol = followingIds.contains(a['id']) ? 1 : 0;
                  final bFol = followingIds.contains(b['id']) ? 1 : 0;
                  if (aFol != bFol) return bFol.compareTo(aFol);
                  final aLive = a['current_room_id'] != null ? 1 : 0;
                  final bLive = b['current_room_id'] != null ? 1 : 0;
                  return bLive.compareTo(aLive);
                });
              }

              if (users.isEmpty) {
                return const Center(child: Text('কোনো ইউজার পাওয়া যায়নি'));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: users.length,
                itemBuilder: (_, i) {
                  final u = users[i];
                  final isFol = followingIds.contains(u['id']);
                  final roomId = u['current_room_id'];
                  final roomTitle = u['current_room_title'] ?? 'লাইভ রুম';
                  final frame = getFrameById(u['frame_id']);

                  return Card(
                    color: const Color(0xFF231147),
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    child: ListTile(
                      onTap: () => showUserProfileSheet(
                        context: context,
                        targetUserId: u['id'],
                        myUserId: widget.myUserId,
                        isFollowing: isFol,
                        onToggleFollow: () => _toggleFollow(u['id']),
                        onJoinUserRoom: roomId != null
                            ? () => _joinRoom(
                                  roomId: roomId,
                                  roomTitle: roomTitle,
                                  isHost: false,
                                )
                            : null,
                      ),
                      leading: FramedAvatar(
                        avatarUrl: u['avatar_url'],
                        name: u['name'] ?? 'U',
                        frameId: u['frame_id'],
                        size: 48,
                      ),
                      title: Row(
                        children: [
                          Flexible(
                            child: Text(
                              u['name'] ?? 'User',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Lv.${u['level'] ?? 1} ${frame.emoji}',
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.amber),
                            ),
                          ),
                        ],
                      ),
                      subtitle: roomId != null
                          ? Text(
                              '🟢 এখন আছে: $roomTitle',
                              style: const TextStyle(
                                  color: Colors.greenAccent, fontSize: 12),
                            )
                          : Text(
                              'ID: ${u['id']}',
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 12),
                            ),
                      trailing: roomId != null
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onPressed: () => _joinRoom(
                                roomId: roomId,
                                roomTitle: roomTitle,
                                isHost: false,
                              ),
                              child: const Text('রুমে যান',
                                  style: TextStyle(fontSize: 12)),
                            )
                          : OutlinedButton(
                              onPressed: () => _toggleFollow(u['id']),
                              child: Text(isFol ? 'ফলোয়িং' : '+ ফলো',
                                  style: const TextStyle(fontSize: 12)),
                            ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTab() {
    final p = myProfile!;
    final List<String> owned = List<String>.from(p['owned_frames'] ?? ['none']);
    final currentFrame = p['frame_id'] ?? 'none';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              FramedAvatar(
                avatarUrl: p['avatar_url'],
                name: p['name'] ?? 'U',
                frameId: currentFrame,
                size: 96,
              ),
              InkWell(
                onTap: _pickAndUploadAvatar,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.pinkAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            p['name'] ?? 'User',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '🔥 Level ${p['level'] ?? 1} (XP: ${p['xp'] ?? 0})',
                  style: const TextStyle(color: Colors.amber, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: p['id']));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('আইডি কপি হয়েছে!')),
                  );
                },
                child: Text('ID: ${p['id']} 📋',
                    style: const TextStyle(color: Colors.white60, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(p['bio'] ?? '', style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _statBox('🪙 কয়েন', '${p['coins'] ?? 0}', Colors.amber),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statBox(
                    '💎 ডায়মন্ড', '${p['diamonds'] ?? 0}', Colors.cyanAccent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statBox('❤️ ফলোয়িং', '${followingIds.length}',
                    Colors.pinkAccent),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E175B)),
                  onPressed: _editProfileDialog,
                  icon: const Icon(Icons.edit),
                  label: const Text('নাম ও বায়ো এডিট'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade800),
                  onPressed: _claimFreeCoins,
                  icon: const Icon(Icons.card_giftcard),
                  label: const Text('+৫০০ ফ্রি কয়েন'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '👗 আমার জামা ও VIP ফ্রেম স্টোর',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.78,
            ),
            itemCount: appFrames.length,
            itemBuilder: (_, i) {
              final f = appFrames[i];
              final isOwned = owned.contains(f.id);
              final isEquipped = currentFrame == f.id;
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF231147),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isEquipped ? Colors.pinkAccent : Colors.white12,
                    width: isEquipped ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FramedAvatar(
                      avatarUrl: p['avatar_url'],
                      name: p['name'] ?? 'A',
                      frameId: f.id,
                      size: 44,
                    ),
                    Text(
                      f.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 28,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: isEquipped
                              ? Colors.green
                              : (isOwned ? Colors.deepPurple : Colors.amber.shade800),
                        ),
                        onPressed: isEquipped
                            ? null
                            : () => _handleFrameAction(f, isOwned, owned),
                        child: Text(
                          isEquipped
                              ? 'পরা আছে'
                              : (isOwned ? 'পরুন' : '🪙 ${f.price}'),
                          style: const TextStyle(fontSize: 11, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('ador_user_id');
                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                );
              },
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text('লগআউট করুন',
                  style: TextStyle(color: Colors.redAccent)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox(String label, String val, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF231147),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(val,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 600,
    );
    if (file == null) return;
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ছবি আপলোড হচ্ছে...')),
      );
      final bytes = await file.readAsBytes();
      final path = '${widget.myUserId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await supabase.storage.from('avatars').uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(upsert: true, contentType: 'image/jpeg'),
          );
      final url = supabase.storage.from('avatars').getPublicUrl(path);
      await supabase
          .from('profiles')
          .update({'avatar_url': url})
          .eq('id', widget.myUserId);
      await _refreshMyProfile();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('প্রোফাইল ছবি পরিবর্তন হয়েছে! ✅')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ছবি আপলোড ব্যর্থ: $e')),
      );
    }
  }

  void _editProfileDialog() {
    final nameCtrl = TextEditingController(text: myProfile?['name'] ?? '');
    final bioCtrl = TextEditingController(text: myProfile?['bio'] ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF231147),
        title: const Text('প্রোফাইল এডিট'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'নাম'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bioCtrl,
              decoration: const InputDecoration(labelText: 'বায়ো / স্ট্যাটাস'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('বাতিল')),
          ElevatedButton(
            onPressed: () async {
              await supabase.from('profiles').update({
                'name': nameCtrl.text.trim(),
                'bio': bioCtrl.text.trim(),
              }).eq('id', widget.myUserId);
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              _refreshMyProfile();
            },
            child: const Text('সেভ করুন'),
          ),
        ],
      ),
    );
  }

  Future<void> _claimFreeCoins() async {
    final current = (myProfile?['coins'] ?? 0) as int;
    await supabase
        .from('profiles')
        .update({'coins': current + 500})
        .eq('id', widget.myUserId);
    await _refreshMyProfile();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🎉 +৫০০ কয়েন যোগ হয়েছে!')),
    );
  }

  Future<void> _handleFrameAction(
      OutfitFrame f, bool isOwned, List<String> owned) async {
    if (isOwned) {
      await supabase
          .from('profiles')
          .update({'frame_id': f.id})
          .eq('id', widget.myUserId);
      await _refreshMyProfile();
    } else {
      final coins = (myProfile?['coins'] ?? 0) as int;
      if (coins < f.price) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('পর্যাপ্ত কয়েন নেই! +৫০০ ফ্রি কয়েন নিন।')),
        );
        return;
      }
      final newOwned = [...owned, f.id];
      await supabase.from('profiles').update({
        'coins': coins - f.price,
        'owned_frames': newOwned,
        'frame_id': f.id,
      }).eq('id', widget.myUserId);
      await _refreshMyProfile();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${f.emoji} ${f.name} পরা হয়ে গেছে!')),
      );
    }
  }
}

Future<void> showUserProfileSheet({
  required BuildContext context,
  required String targetUserId,
  required String myUserId,
  bool? isFollowing,
  VoidCallback? onToggleFollow,
  VoidCallback? onJoinUserRoom,
  VoidCallback? onSendGiftTap,
  bool isCurrentUserHostInRoom = false,
}) async {
  final data = await supabase
      .from('profiles')
      .select()
      .eq('id', targetUserId)
      .maybeSingle();

  if (!context.mounted) return;
  if (data == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ইউজার তথ্য পাওয়া যায়নি')),
    );
    return;
  }

  bool fol = isFollowing ?? false;
  if (isFollowing == null && targetUserId != myUserId) {
    final fRow = await supabase
        .from('follows')
        .select()
        .eq('follower_id', myUserId)
        .eq('following_id', targetUserId)
        .maybeSingle();
    fol = fRow != null;
  }

  final frame = getFrameById(data['frame_id']);
  final level = (data['level'] ?? 1) as int;
  final xp = (data['xp'] ?? 0) as int;

  if (!context.mounted) return;
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1F0E3D),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setS) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FramedAvatar(
              avatarUrl: data['avatar_url'],
              name: data['name'] ?? 'U',
              frameId: data['frame_id'],
              size: 76,
            ),
            const SizedBox(height: 10),
            Text(
              data['name'] ?? 'User',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('ID: ${data['id']}  •  জামা: ${frame.emoji} ${frame.name}',
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                '🔥 Level $level  |  💎 ${data['diamonds'] ?? 0}  |  🪙 ${data['coins'] ?? 0}  |  XP: $xp',
                style: const TextStyle(color: Colors.amber, fontSize: 12),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data['bio'] ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            if (targetUserId != myUserId)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: fol ? Colors.grey.shade800 : Colors.pinkAccent,
                    ),
                    onPressed: () async {
                      if (onToggleFollow != null) {
                        onToggleFollow();
                      } else {
                        if (fol) {
                          await supabase
                              .from('follows')
                              .delete()
                              .eq('follower_id', myUserId)
                              .eq('following_id', targetUserId);
                        } else {
                          await supabase.from('follows').insert({
                            'follower_id': myUserId,
                            'following_id': targetUserId,
                          });
                        }
                      }
                      setS(() => fol = !fol);
                    },
                    icon: Icon(fol ? Icons.check : Icons.person_add),
                    label: Text(fol ? 'ফলোয়িং' : 'ফলো করুন'),
                  ),
                  if (onSendGiftTap != null)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade800),
                      onPressed: () {
                        Navigator.pop(ctx);
                        onSendGiftTap();
                      },
                      icon: const Icon(Icons.card_giftcard),
                      label: const Text('🎁 গিফট দিন'),
                    ),
                  if (onJoinUserRoom != null)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () {
                        Navigator.pop(ctx);
                        onJoinUserRoom();
                      },
                      icon: const Icon(Icons.meeting_room),
                      label: const Text('রুমে যান'),
                    ),
                  if (isCurrentUserHostInRoom)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await ZegoUIKitPrebuiltLiveAudioRoomController()
                            .seat
                            .host
                            .removeSpeaker(targetUserId, showDialogConfirm: false);
                      },
                      icon: const Icon(Icons.voice_over_off),
                      label: const Text('সিট থেকে নামান'),
                    ),
                ],
              ),
          ],
        ),
      ),
    ),
  );
}

class VoiceRoomPage extends StatefulWidget {
  final String roomID;
  final String roomTitle;
  final Map<String, dynamic> myProfile;
  final bool isHost;

  const VoiceRoomPage({
    super.key,
    required this.roomID,
    required this.roomTitle,
    required this.myProfile,
    required this.isHost,
  });

  @override
  State<VoiceRoomPage> createState() => _VoiceRoomPageState();
}

class _VoiceRoomPageState extends State<VoiceRoomPage> {
  final Map<String, Map<String, dynamic>> _userCache = {};
  final Set<String> _fetchingIds = {};
  StreamSubscription? _giftSub;
  Map<String, dynamic>? _activeGiftBanner;
  int? _lastGiftId;
  Timer? _bannerTimer;
  late Map<String, dynamic> _myProfile;
  String? _selectedRoomTheme;
  
  @override
  void initState() {
    super.initState();
    _myProfile = Map<String, dynamic>.from(widget.myProfile);
    _userCache[_myProfile['id']] = _myProfile;
    _listenGifts();
  }

  void _listenGifts() {
    _giftSub = supabase
        .from('room_gifts')
        .stream(primaryKey: ['id'])
        .eq('room_id', widget.roomID)
        .order('created_at', ascending: false)
        .limit(1)
        .listen((rows) {
      if (rows.isEmpty) return;
      final g = rows.first;
      final gid = g['id'] as int?;
      if (gid != null && gid != _lastGiftId) {
        final createdAt = DateTime.tryParse(g['created_at'].toString());
        final isFresh = createdAt == null ||
            DateTime.now().toUtc().difference(createdAt.toUtc()).inSeconds < 12;
        _lastGiftId = gid;
        if (isFresh && mounted) {
          setState(() => _activeGiftBanner = g);
          _bannerTimer?.cancel();
          _bannerTimer = Timer(const Duration(seconds: 4), () {
            if (mounted) setState(() => _activeGiftBanner = null);
          });
        }
      }
    });
  }

  void _ensureUserLoaded(String userId) {
    if (_userCache.containsKey(userId) || _fetchingIds.contains(userId)) return;
    _fetchingIds.add(userId);
    supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle()
        .then((res) {
      _fetchingIds.remove(userId);
      if (res != null && mounted) {
        setState(() => _userCache[userId] = res);
      }
    });
  }

  @override
  void dispose() {
    _giftSub?.cancel();
    _bannerTimer?.cancel();
    _cleanupRoom();
    super.dispose();
  }

  Future<void> _cleanupRoom() async {
    try {
      await supabase.from('profiles').update({
        'current_room_id': null,
        'current_room_title': null,
      }).eq('id', widget.myProfile['id']);
      if (widget.isHost) {
        await supabase
            .from('rooms')
            .update({'is_live': false})
            .eq('id', widget.roomID);
      }
    } catch (_) {}
  }

  void _openGiftSheet({String? preselectedUserId}) {
    final users = ZegoUIKit().getAllUsers();
    String? targetId = preselectedUserId ??
        (users.isNotEmpty ? users.first.id : widget.myProfile['id']);
    GiftItem selectedGift = appGifts.first;
    bool sending = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D0D3B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('🎁 গিফট পাঠান',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('🪙 কয়েন: ${_myProfile['coins'] ?? 0}',
                      style: const TextStyle(
                          color: Colors.amber, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: users.map((u) {
                    final selected = u.id == targetId;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(u.name),
                        selected: selected,
                        selectedColor: Colors.pinkAccent,
                        onSelected: (_) => setS(() => targetId = u.id),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.9,
                ),
                itemCount: appGifts.length,
                itemBuilder: (_, i) {
                  final g = appGifts[i];
                  final sel = selectedGift.name == g.name;
                  return InkWell(
                    onTap: () => setS(() => selectedGift = g),
                    child: Container(
                      decoration: BoxDecoration(
                        color: sel
                            ? Colors.pinkAccent.withOpacity(0.25)
                            : Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: sel ? Colors.pinkAccent : Colors.white12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(g.emoji, style: const TextStyle(fontSize: 26)),
                          Text(g.name, style: const TextStyle(fontSize: 11)),
                          Text('🪙 ${g.cost}',
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.amber)),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent),
                  onPressed: sending
                      ? null
                      : () async {
                          final myCoins = (_myProfile['coins'] ?? 0) as int;
                          if (myCoins < selectedGift.cost) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('পর্যাপ্ত কয়েন নেই! প্রোফাইল থেকে ফ্রি কয়েন নিন।')),
                            );
                            return;
                          }
                          setS(() => sending = true);
                          try {
                            final rec = users.firstWhere(
                              (u) => u.id == targetId,
                              orElse: () => ZegoUIKitUser(
                                id: _myProfile['id'],
                                name: _myProfile['name'],
                              ),
                            );
                            final newCoins = myCoins - selectedGift.cost;
                            await supabase.from('profiles').update({
                              'coins': newCoins,
                            }).eq('id', _myProfile['id']);
                            _myProfile['coins'] = newCoins;

                            final recData = await supabase
                                .from('profiles')
                                .select()
                                .eq('id', rec.id)
                                .maybeSingle();
                            if (recData != null) {
                              final newDiamonds =
                                  (recData['diamonds'] ?? 0) + selectedGift.cost;
                              final newXp =
                                  (recData['xp'] ?? 0) + selectedGift.cost;
                              final newLevel = 1 + (newXp ~/ 200);
                              await supabase.from('profiles').update({
                                'diamonds': newDiamonds,
                                'xp': newXp,
                                'level': newLevel,
                              }).eq('id', rec.id);
                              _userCache.remove(rec.id);
                            }

                            await supabase.from('room_gifts').insert({
                              'room_id': widget.roomID,
                              'sender_id': _myProfile['id'],
                              'sender_name': _myProfile['name'],
                              'receiver_id': rec.id,
                              'receiver_name': rec.name,
                              'gift_name': selectedGift.name,
                              'gift_emoji': selectedGift.emoji,
                              'cost': selectedGift.cost,
                            });

                            await ZegoUIKitPrebuiltLiveAudioRoomController()
                                .message
                                .send(
                                  '🎁 ${_myProfile['name']} -> ${rec.name}-কে ${selectedGift.emoji} ${selectedGift.name} পাঠিয়েছে!',
                                );

                            if (!ctx.mounted) return;
                            Navigator.pop(ctx);
                          } finally {
                            if (ctx.mounted) setS(() => sending = false);
                          }
                        },
                  child: Text(sending
                      ? 'পাঠানো হচ্ছে...'
                      : 'পাঠান (${selectedGift.emoji} ${selectedGift.cost} কয়েন)'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openRoomUsersSheet() {
    final users = ZegoUIKit().getAllUsers();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D0D3B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('👥 রুমে থাকা আইডিসমূহ (${users.length})',
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (_, i) {
                  final u = users[i];
                  _ensureUserLoaded(u.id);
                  final cached = _userCache[u.id];
                  final frame = getFrameById(cached?['frame_id']);
                  return ListTile(
                    leading: FramedAvatar(
                      avatarUrl: cached?['avatar_url'],
                      name: u.name,
                      frameId: cached?['frame_id'],
                      size: 42,
                    ),
                    title: Text(u.name),
                    subtitle: Text(
                      'Lv.${cached?['level'] ?? 1}  •  জামা: ${frame.emoji} ${frame.name}',
                      style: const TextStyle(color: Colors.amber, fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pop(ctx);
                      showUserProfileSheet(
                        context: context,
                        targetUserId: u.id,
                        myUserId: _myProfile['id'],
                        isCurrentUserHostInRoom: widget.isHost,
                        onSendGiftTap: () =>
                            _openGiftSheet(preselectedUserId: u.id),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.isHost
        ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
        : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience();

    config.turnOnMicrophoneWhenJoining = widget.isHost;
    config.useSpeakerWhenJoining = true;

    config.seat.layout = ZegoLiveAudioRoomLayoutConfig(
      rowSpacing: 12,
      rowConfigs: [
        ZegoLiveAudioRoomLayoutRowConfig(
          count: 1,
          alignment: ZegoLiveAudioRoomLayoutAlignment.center,
        ),
        ZegoLiveAudioRoomLayoutRowConfig(
          count: 4,
          alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround,
        ),
        ZegoLiveAudioRoomLayoutRowConfig(
          count: 4,
          alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround,
        ),
      ],
    );
    config.seat.showSoundWaveInAudioMode = true;
    config.seat.keepOriginalForeground = true;

    config.seat.avatarBuilder = (context, size, user, extraInfo) {
      if (user == null) return const SizedBox.shrink();
      _ensureUserLoaded(user.id);
      final cached = _userCache[user.id];
      return Center(
        child: FramedAvatar(
          avatarUrl: cached?['avatar_url'],
          name: user.name,
          frameId: cached?['frame_id'],
          size: size.width * 0.88,
        ),
      );
    };

    config.seat.foregroundBuilder = (context, size, user, extraInfo) {
      if (user == null) return const SizedBox.shrink();
      _ensureUserLoaded(user.id);
      final cached = _userCache[user.id];
      final lv = cached?['level'] ?? 1;
      return Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => showUserProfileSheet(
            context: context,
            targetUserId: user.id,
            myUserId: _myProfile['id'],
            isCurrentUserHostInRoom: widget.isHost,
            onSendGiftTap: () => _openGiftSheet(preselectedUserId: user.id),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Lv.$lv',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    };

    config.memberList = ZegoLiveAudioRoomMemberListConfig(
      itemBuilder: (context, size, user, extraInfo) {
        _ensureUserLoaded(user.id);
        final cached = _userCache[user.id];
        final frame = getFrameById(cached?['frame_id']);
        return ListTile(
          onTap: () {
            Navigator.pop(context);
            showUserProfileSheet(
              context: context,
              targetUserId: user.id,
              myUserId: _myProfile['id'],
              isCurrentUserHostInRoom: widget.isHost,
              onSendGiftTap: () => _openGiftSheet(preselectedUserId: user.id),
            );
          },
          leading: FramedAvatar(
            avatarUrl: cached?['avatar_url'],
            name: user.name,
            frameId: cached?['frame_id'],
            size: 40,
          ),
          title: Text(user.name),
          subtitle: Text(
            'Lv.${cached?['level'] ?? 1} ${frame.emoji}',
            style: const TextStyle(color: Colors.amber, fontSize: 12),
          ),
          trailing: const Text('দেখুন', style: TextStyle(color: Colors.pinkAccent)),
        );
      },
    );

    final giftBtn = IconButton(
      onPressed: () => _openGiftSheet(),
      icon: Container(
        padding: const EdgeInsets.all(7),
        decoration: const BoxDecoration(
          color: Colors.pinkAccent,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.card_giftcard, color: Colors.white, size: 20),
      ),
    );
    final usersBtn = IconButton(
      onPressed: _openRoomUsersSheet,
      icon: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Colors.amber.shade800,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.badge, color: Colors.white, size: 20),
      ),
    );

    config.bottomMenuBar.hostExtendButtons = [giftBtn, usersBtn];
    config.bottomMenuBar.speakerExtendButtons = [giftBtn, usersBtn];
    config.bottomMenuBar.audienceExtendButtons = [giftBtn, usersBtn];

    config.background = Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF311157), Color(0xFF140826)],
        ),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 12, left: 16),
          child: Text(
            '🏠 ${widget.roomTitle}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ZegoUIKitPrebuiltLiveAudioRoom(
              appID: zegoAppID,
              appSign: zegoAppSign,
              userID: _myProfile['id'],
              userName: _myProfile['name'],
              roomID: widget.roomID,
              config: config,
            ),
            if (_activeGiftBanner != null)
              Positioned(
                top: 56,
                left: 20,
                right: 20,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.pinkAccent, Colors.deepPurple],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(color: Colors.black54, blurRadius: 12)
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_activeGiftBanner!['gift_emoji']}',
                        style: const TextStyle(fontSize: 26),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '${_activeGiftBanner!['sender_name']} → ${_activeGiftBanner!['receiver_name']}-কে ${_activeGiftBanner!['gift_name']} পাঠিয়েছে!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
