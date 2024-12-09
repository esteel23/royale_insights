import 'package:flutter/material.dart';
import 'package:leaderboard/pages/clans_leaderboard.dart';
import 'matchmaking.dart';
import 'global_leaderboard.dart';
import '../services/authentication_dialogue.dart';

class MainPage extends StatefulWidget {
  final bool isDarkMode; 
  final VoidCallback toggleTheme; 

  const MainPage({
    required this.isDarkMode,
    required this.toggleTheme,
    super.key,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const GlobalLeaderboardPage(),
    const ClansLeaderboardPage(),
    const MatchmakingPage(),
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
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: widget.toggleTheme,
            icon: Icon(
              widget.isDarkMode ? Icons.dark_mode : Icons.dark_mode_outlined,
            ),
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
              title: const Text('Clans Leaderboard'),
              onTap: () => _selectPage(1),
            ),
            ListTile(
              title: const Text('Matchmaking'),
              onTap: () => _selectPage(2),
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
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
