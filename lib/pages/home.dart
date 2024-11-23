import 'package:flutter/material.dart';
import '../src/leaderboard.dart';
import 'card_statistics.dart';
import '../services/api_service.dart';
import '../services/authentication_dialogue.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const CardStatisticsPage(),
    const MainPage(),
  ];

  void _selectPage(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Royale Insights'),
        actions: [
          IconButton(
            onPressed: () => _showAuthenticationDialog(context),
            icon: const Icon(Icons.login),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Global Leaderboard'),
              onTap: () => _selectPage(0),
            ),
            ListTile(
              title: const Text('Card Stats'),
              onTap: () => _selectPage(1),
            ),
            /*ListTile(
              title: const Text('Global Clan Leaderboard'),
              onTap: () => _selectPage(2),
            ),*/
          ],
        ),
      ),
      body: _currentIndex == 0
          ? Column(
              children: [
                // Title above the leaderboard
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                    'Current Season Global Leaderboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Global Leaderboard
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchLeaderboard('leaderboard'), // Fetch leaderboard data
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No data available.'));
                      } else {
                        return Leaderboard(
                          data: snapshot.data!, // Pass the fetched data
                          sqlCategories: const [
                            'rank',
                            'id',
                            'display_name',
                            'trophies',
                            'clan_name',
                            'clanid',
                            'role'
                          ],
                          displayCategories: const [
                            'Rank',
                            'Player Tag',
                            'Display Name',
                            'Trophies',
                            'Clan Name',
                            'Clan Tag',
                            'Role'
                          ],
                          detailPageBuilder: (row) => Scaffold(
                            appBar: AppBar(
                              title: Text('${row['display_name']} Details'),
                            ),
                            body: Center(
                              child: Text(
                                row.entries
                                    .map((entry) =>
                                        '${entry.key}: ${entry.value ?? 'N/A'}')
                                    .join('\n'),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            )
          : _pages[_currentIndex],
    );
  }
}

void _showAuthenticationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AuthenticationDialog();
    },
  );
}
