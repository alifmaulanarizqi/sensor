import 'package:flutter/material.dart';

import 'a_page/a_page.dart';
import 'b_page/b_page.dart';
import 'c_page/c_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _widgetOptions = [
    APage(),
    BPage(),
    CPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Synapsis.id'),
      ),
      body: _widgetOptions[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Halaman A',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Halaman B',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Halaman C',
          ),
        ],
      ),
    );
  }

}