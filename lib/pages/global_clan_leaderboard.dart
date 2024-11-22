// global_clan_leaderboard.dart
import 'package:flutter/material.dart';
import 'clan_details.dart';
import '../services/api_service.dart';

class GlobalClanLeaderboardPage extends StatefulWidget {
  const GlobalClanLeaderboardPage({super.key});

  @override
  _GlobalClanLeaderboardPageState createState() => _GlobalClanLeaderboardPageState();
}

class _GlobalClanLeaderboardPageState extends State<GlobalClanLeaderboardPage> {
  List<dynamic> _clanLeaderboard = [];

  @override
  void initState() {
    super.initState();
    _fetchClanLeaderboard();
  }

  Future<void> _fetchClanLeaderboard() async {
    try {
      final data = await fetchClanLeaderboard(); // Use your API service to fetch clan data
      setState(() {
        _clanLeaderboard = List.generate(data.length, (index) {
          return {
            'rank': index + 1, // Rank each clan by index in the sorted list
            ...Map<String, dynamic>.from(data[index]),
          };
        });
      });
    } catch (e) {
      print('Error fetching clan leaderboard: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Clan Leaderboard'),
      ),
      body: _clanLeaderboard.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: Colors.blueAccent,
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                    'Global Clan Leaderboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(child: Text('Rank', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Clan Tag', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Clan Label', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Total Trophies', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _clanLeaderboard.length,
                    itemBuilder: (context, index) {
                      final clan = _clanLeaderboard[index];
                      final backgroundColor = index.isEven ? Colors.white : Colors.grey[200];
                      Color hoverColor = Colors.blue.withOpacity(0.1);
                      bool isHovered = false;

                      return StatefulBuilder(
                        builder: (context, setHoverState) {
                          return MouseRegion(
                            onEnter: (_) {
                              setHoverState(() => isHovered = true);
                            },
                            onExit: (_) {
                              setHoverState(() => isHovered = false);
                            },
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClanDetailsPage(
                                      clanId: clan['clanid'],
                                      clanLabel: clan['label'],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                color: isHovered ? hoverColor : backgroundColor,
                                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(child: Text(clan['rank']?.toString() ?? 'N/A')),
                                    Expanded(child: Text(clan['id']?.toString() ?? 'N/A')),
                                    Expanded(child: Text(clan['name'] ?? 'Unknown')),
                                    Expanded(child: Text(clan['totalTrophies']?.toString() ?? 'N/A')),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
