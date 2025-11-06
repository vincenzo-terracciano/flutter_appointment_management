import 'package:flutter/material.dart';
import 'package:flutter_appointment_management/providers/appointments_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/other_providers.dart';
import '../login_screen.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(userEmailProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Email: ${email ?? 'Non disponibile'}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              // logout rimuove token e pulisce state
              await ref.read(authProvider.notifier).logout();
              // reset dello stato
              ref.read(userEmailProvider.notifier).state = null;
              // svuoto lista appuntamenti
              ref.read(appointmentsProvider.notifier).clear();
              // svuoto query di ricerca
              ref.read(searchQueryProvider.notifier).state = '';
              // torna alla schermata di login
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
