import 'package:flutter/material.dart';
import 'card_statistics.dart';
import 'global_leaderboard.dart'; 
import '../services/authentication_dialogue.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const GlobalLeaderboardPage(),
    const CardStatisticsPage(),
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
