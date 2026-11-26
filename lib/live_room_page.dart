
import 'package:flutter/material.dart';

class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({super.key});

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  int seatCount = 15;
  int viewers = 128;
  int mySeat = 1;

  final int hostSeat = 1;

  final List<Map<String, dynamic>> users = [
    {
      'name': 'Host',
      'seat': 1,
      'admin': true,
      'muted': false,
    },
    {
      'name': 'Rahim',
      'seat': 2,
      'admin': false,
      'muted': false,
    },
    {
      'name': 'Karim',
      'seat': 3,
      'admin': false,
      'muted': false,
    },
  ];

  bool get isHost => mySeat == hostSeat;

  Map<String, dynamic>? userAt(int seat) {
    for (final user in users) {
      if (user['seat'] == seat) return user;
    }
    return null;
  }

  void showSeatOptions(int seat) {
    final user = userAt(seat);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF28133D),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'সিট $seat',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),

                if (user == null)
                  ListTile(
                    leading: const Icon(
                      Icons.event_seat,
                      color: Colors.green,
                    ),
                    title: const Text(
                      'এই সিটে বসুন',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        mySeat = seat;
                      });
                    },
                  ),

                if (user != null && isHost && seat != hostSeat) ...[
                  ListTile(
                    leading: const Icon(
                      Icons.volume_off,
                      color: Colors.orange,
                    ),
                    title: Text(
                      user['muted'] ? 'Unmute' : 'Mute',
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        user['muted'] = !user['muted'];
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.admin_panel_settings,
                      color: Colors.amber,
                    ),
                    title: Text(
                      user['admin'] ? 'Admin বাতিল করুন' : 'Admin বানান',
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        user['admin'] = !user['admin'];
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.person_remove,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Kick করুন',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        users.remove(user);
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void changeSeatCount(int count) {
    setState(() {
      seatCount = count;
      users.removeWhere((user) => user['seat'] > count);
      if (mySeat > count) mySeat = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF170B27),
      appBar: AppBar(
        backgroundColor: const Color(0xFF28133D),
        title: const Text(
          'Ador Live Room',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          const Icon(Icons.remove_red_eye, color: Colors.white),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: Text(
                '$viewers',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          const Text(
            'লাইভ রুম',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          if (isHost)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'সিট সংখ্যা: ',
                  style: TextStyle(color: Colors.white),
                ),
                DropdownButton<int>(
                  value: seatCount,
                  dropdownColor: const Color(0xFF28133D),
                  style: const TextStyle(color: Colors.white),
                  items: [10, 15, 20, 30]
                      .map(
                        (n) => DropdownMenuItem(
                          value: n,
                          child: Text('$n সিট'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) changeSeatCount(value);
                  },
                ),
              ],
            ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: seatCount,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 18,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final seat = index + 1;
                final user = userAt(seat);
                final occupied = user != null;

                return GestureDetector(
                  onTap: () => showSeatOptions(seat),
                  child: Column(
                    children: [
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: occupied
                              ? const Color(0xFF7136A0)
                              : const Color(0xFF332342),
                          border: Border.all(
                            color: seat == hostSeat
                                ? Colors.amber
                                : Colors.purpleAccent,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          occupied
                              ? Icons.person
                              : Icons.mic_off,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        occupied ? user['name'] : 'খালি',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'সিট $seat',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 12,
                        ),
                      ),
                      if (occupied && user['admin'] == true)
                        const Text(
                          'ADMIN',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 10,
                          ),
                        ),
                      if (occupied && user['muted'] == true)
                        const Icon(
                          Icons.mic_off,
                          color: Colors.red,
                          size: 15,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(18),
            color: const Color(0xFF28133D),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (mySeat != 0) {
                        mySeat = 0;
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.mic,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
