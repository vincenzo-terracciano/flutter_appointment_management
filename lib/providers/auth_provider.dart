import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

// creo il Provider per ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// creo il provider per gestire il token
final authProvider = StateNotifierProvider<AuthNotifier, String?>((ref) {
  return AuthNotifier(ref);
});

// classe che gestisce lo stato dell'autenticazione
class AuthNotifier extends StateNotifier<String?> {
  final Ref ref;

  // stato null (non autenticato)
  AuthNotifier(this.ref) : super(null);

  // Login
  Future<void> login(String email, String password) async {
    try {
      // token
      final api = ref.read(apiServiceProvider);
      final token = await api.login(email, password);

      // salvo il token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // aggiorno lo stato
      state = token;
    } catch (e) {
      state = null;
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    // rimuovo il token
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    // imposto lo stato a null
    state = null;
  }
}
