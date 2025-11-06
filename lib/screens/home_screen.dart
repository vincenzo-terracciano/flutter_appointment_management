import 'package:flutter/material.dart';
import 'package:flutter_appointment_management/screens/tabs/appointments_list_tab.dart';
import 'package:flutter_appointment_management/screens/tabs/profile_tab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tabs/add_appointment_tab.dart';

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
          ? const AddAppointmentTab()
          : _currentIndex == 1
          ? const AppointmentsListTab()
          : const ProfileTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Nuovo'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Lista'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profilo'),
        ],
      ),
    );
  }
}
