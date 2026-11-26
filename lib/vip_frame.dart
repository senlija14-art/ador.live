import 'package:flutter/material.dart';

class VipFrame extends StatefulWidget {
  final int level;
  final double size;
  final Widget child;

  const VipFrame({
    super.key,
    required this.level,
    required this.child,
    this.size = 108,
  });

  @override
  State<VipFrame> createState() => _VipFrameState();
}

class _VipFrameState extends State<VipFrame>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  static const List<List<Color>> colors = [
    [Color(0xFF00E5FF), Color(0xFF0066FF)],
    [Color(0xFF00FF88), Color(0xFF008844)],
    [Color(0xFFFFD700), Color(0xFFFF8800)],
    [Color(0xFFFF00CC), Color(0xFF8800FF)],
    [Color(0xFFFF3333), Color(0xFFFF8800)],
    [Color(0xFF00FFFF), Color(0xFFAA00FF)],
    [Color(0xFFFFE066), Color(0xFFFF00AA)],
  ];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = (widget.level.clamp(1, 7)) - 1;
    final frameColors = colors[index];

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: controller.value * 6.28318,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        frameColors[0],
                        frameColors[1],
                        Colors.white,
                        frameColors[0],
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: widget.size - 10,
                height: widget.size - 10,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: frameColors,
                  ),
                ),
                child: ClipOval(
                  child: widget.child,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: frameColors,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'VIP ${widget.level.clamp(1, 7)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
