import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  // costruttore
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // variabile che tiene traccia della tab selezionata
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // operatore ternario per scegliere il titolo in base alla tab selezionata
          _currentIndex == 0
              ? 'Nuovo Appuntamento'
              : _currentIndex == 1
              ? 'Lista Appuntamenti'
              : 'Profilo',
        ),
      ),
      body: _currentIndex == 0
          ? const Center(child: Text('Tab 1 - Nuovo Appuntamento'))
          : _currentIndex == 1
          ? const Center(child: Text('Tab 2 - Lista Appuntamenti'))
          : const Center(child: Text('Tab 3 - Profilo')),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Nuovo'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Lista'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profilo'),
        ],
      ),
    );
  }
}
