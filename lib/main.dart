import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() {
  runApp(const RoyaleInsights());
}

class RoyaleInsights extends StatefulWidget {
  const RoyaleInsights({super.key});

  @override
  _RoyaleInsightsState createState() => _RoyaleInsightsState();
}

class _RoyaleInsightsState extends State<RoyaleInsights>{

  bool isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),      
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MainPage(
        isDarkMode: isDarkMode,
        toggleTheme: _toggleTheme,
      )
    );
  }
}

 
