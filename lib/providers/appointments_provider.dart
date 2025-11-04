import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/appointment.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

// Provider che gestisce la lista degli appuntamenti
final appointmentsProvider =
    StateNotifierProvider<AppointmentsNotifier, List<Appointment>>((ref) {
      final api = ref.read(apiServiceProvider);
      return AppointmentsNotifier(api);
    });

class AppointmentsNotifier extends StateNotifier<List<Appointment>> {
  final ApiService _api;

  // costruttore e inizializza lo stato a lista vuota
  AppointmentsNotifier(this._api) : super([]);

  // carico gli appuntamenti dal backend e aggiorno lo stato
  Future<void> loadAppointments() async {
    try {
      final items = await _api.getAppointments();
      state = items;
    } catch (e) {
      rethrow;
    }
  }

  // aggiungo un appuntamento nel backend e aggiorno lo stato locale
  Future<void> addAppointment(Appointment appointment) async {
    try {
      await _api.createAppointment(appointment);
      state = [appointment, ...state];
    } catch (e) {
      rethrow;
    }
  }

  // resetto la lista
  void clear() => state = [];
}
