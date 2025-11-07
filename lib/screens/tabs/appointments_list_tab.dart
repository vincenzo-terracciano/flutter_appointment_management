import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
// ignore: unused_import
import '../../models/appointment.dart';
import '../../providers/appointments_provider.dart';
import '../../providers/other_providers.dart';

// dichiarazione tab 2 - Lista Appuntamenti
class AppointmentsListTab extends ConsumerStatefulWidget {
  const AppointmentsListTab({super.key});

  @override
  ConsumerState<AppointmentsListTab> createState() =>
      _AppointmentsListTabState();
}

// stato della tab 2
class _AppointmentsListTabState extends ConsumerState<AppointmentsListTab> {
  @override
  void initState() {
    super.initState();

    // carica gli appuntamenti all'avvio della tab
    Future.microtask(
      () => ref.read(appointmentsProvider.notifier).loadAppointments(),
    );
  }

  // interfaccia tab 2
  @override
  Widget build(BuildContext context) {
    // ottengo la lista degli appuntamenti dal Provider
    final appointments = ref.watch(appointmentsProvider);
    // ottengo la stringa di ricerca inserita dall'utente
    final query = ref.watch(searchQueryProvider);
    // ora corrente
    final now = DateTime.now();

    // filtro per scartare appuntamenti passati
    final filtered = appointments.where((appointment) {
      // scarto quelli già terminati o quelli uguali all'ora attuale
      if (appointment.endTime.isBefore(now) ||
          appointment.endTime.isAtSameMomentAs(now)) {
        return false;
      }
      // se c'è una stringa di ricerca controllo se il titolo la contiene
      if (query.isNotEmpty &&
          !appointment.title.toLowerCase().contains(query.toLowerCase())) {
        return false;
      }
      return true;
    }).toList(); // restituisce gli appuntamenti futuri

    // se la lista filtrata è vuota mostro un messaggio
    if (filtered.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            // campo di ricerca
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Cerca per titolo',
              ),
              onChanged: (searchText) =>
                  ref.read(searchQueryProvider.notifier).state = searchText,
            ),
          ),
          const Expanded(child: Center(child: Text('Nessun Appuntamento'))),
        ],
      );
    }

    // altrimenti mostro il layout
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          // campo di ricerca
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Cerca per titolo',
            ),
            onChanged: (searchText) =>
                ref.read(searchQueryProvider.notifier).state = searchText,
          ),
        ),
        Expanded(
          // lista appuntamenti
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              // prendo l'appuntamento in posizione index
              final appointment = filtered[index];

              // formattatori per data e ora
              final dateFormat = DateFormat('dd/MM/yyyy');
              final timeFormat = DateFormat('HH:mm');

              // costruisco il testo del sottotitolo con data e orari
              final dateTimeText =
                  '${dateFormat.format(appointment.startTime)} '
                  '${timeFormat.format(appointment.startTime)} - '
                  '${timeFormat.format(appointment.endTime)}';

              // se ci sono note, le aggiungo al sottotitolo
              final hasNotes =
                  appointment.notes != null && appointment.notes!.isNotEmpty;
              final subtitleText = hasNotes
                  ? '$dateTimeText\n${appointment.notes}'
                  : dateTimeText;

              // mostro gli appuntamenti con titolo, sottotitolo ed eventuali note
              return Card(
                margin: EdgeInsets.all(12),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    appointment.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(subtitleText),
                  isThreeLine: hasNotes,
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.event, color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
