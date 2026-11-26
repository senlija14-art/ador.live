

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomThemePage extends StatefulWidget {
  final String userId;
  final ValueChanged<String>? onThemeSelected;

  const RoomThemePage({
    super.key,
    required this.userId,
    this.onThemeSelected,
  });

  static Future<String?> getSavedTheme(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('room_theme_$userId');
  }

  @override
  State<RoomThemePage> createState() => _RoomThemePageState();
}

class _RoomThemePageState extends State<RoomThemePage> {
  List<String> themes = [];
  String? selectedTheme;
  bool loading = true;

  final List<String> themeNames = [
    'Pink Love Lounge',
    'Neon Music Studio',
    'Cozy Fireplace',
    'Rose Garden',
    'Galaxy World',
    'Bamboo Nature',
    'Golden Autumn',
    'Underwater Ocean',
  ];

  @override
  void initState() {
    super.initState();
    loadThemes();
  }

  Future<void> loadThemes() async {
    try {
      final manifest =
          await AssetManifest.loadFromAssetBundle(rootBundle);

      final files = manifest.listAssets().where((path) {
        final p = path.toLowerCase();

        return p.startsWith('assets/room_themes/') &&
            (p.endsWith('.png') ||
                p.endsWith('.jpg') ||
                p.endsWith('.jpeg') ||
                p.endsWith('.webp'));
      }).toList()
        ..sort();

      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('room_theme_${widget.userId}');

      if (!mounted) return;

      setState(() {
        themes = files;
        selectedTheme = files.contains(saved) ? saved : null;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> chooseTheme(String path) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'room_theme_${widget.userId}',
      path,
    );

    if (!mounted) return;

    setState(() {
      selectedTheme = path;
    });

    widget.onThemeSelected?.call(path);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Room theme saved successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171326),
      appBar: AppBar(
        title: const Text(
          'Room Themes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF251A3D),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.pinkAccent,
              ),
            )
          : themes.isEmpty
              ? const Center(
                  child: Text(
                    'No room theme images found.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: themes.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final path = themes[index];
                    final isSelected = selectedTheme == path;

                    final name = index < themeNames.length
                        ? themeNames[index]
                        : 'Theme ${index + 1}';

                    return GestureDetector(
                      onTap: () => chooseTheme(path),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? Colors.pinkAccent
                                : Colors.white24,
                            width: isSelected ? 3 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                path,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) {
                                  return const ColoredBox(
                                    color: Colors.black26,
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  );
                                },
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  color: Colors.black54,
                                  child: Text(
                                    name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.greenAccent,
                                    size: 28,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
