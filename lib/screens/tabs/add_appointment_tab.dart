import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/appointment.dart';
import '../../providers/appointments_provider.dart';

// dichiarazione tab 1 - Nuovo Appuntamento
class AddAppointmentTab extends ConsumerStatefulWidget {
  const AddAppointmentTab({super.key});

  @override
  ConsumerState<AddAppointmentTab> createState() => _AddAppointmentTabState();
}

// stato della tab 1
class _AddAppointmentTabState extends ConsumerState<AddAppointmentTab> {
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  // controller per gestire gli input di testo
  final titleController = TextEditingController();
  final notesController = TextEditingController();

  // variabile per il caricamento
  bool saving = false;

  // libera i controller quando il widget viene distrutto
  @override
  void dispose() {
    titleController.dispose();
    notesController.dispose();
    super.dispose();
  }

  // Picker per data
  Future<void> pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      // permetto di scegliere una data da 1 anno fa fino a 2 anni nel futuro
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 2)),
    );
    if (pickedDate != null) setState(() => selectedDate = pickedDate);
  }

  // Picker per ora inizio
  Future<void> pickStartTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
      builder: (context, child) {
        // forza il formato 24h
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (pickedTime != null) setState(() => startTime = pickedTime);
  }

  // Picker per ora fine
  Future<void> pickEndTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: endTime ?? TimeOfDay.now(),
      builder: (context, child) {
        // forza il formato 24h
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (pickedTime != null) setState(() => endTime = pickedTime);
  }

  // unisco la data e l'ora
  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  // Sumbit del form
  Future<void> onSubmit() async {
    // controllo che i campi siano selezionati
    if (selectedDate == null || startTime == null || endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleziona data, ora inizio e ora fine')),
      );
      return;
    }

    // oggetti DateTime con data e ora
    final start = _combineDateAndTime(selectedDate!, startTime!);
    final end = _combineDateAndTime(selectedDate!, endTime!);

    // controllo che l'ora di fine sia dopo quella di inizio
    if (!end.isAfter(start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('L\'ora di fine deve essere dopo l\'ora di inizio'),
        ),
      );
      return;
    }

    // controllo che il titolo non sia vuoto
    final title = titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Inserisci un titolo')));
      return;
    }

    // creo un oggetto Appointment con i dati inseriti
    final appointment = Appointment(
      day: selectedDate!,
      startTime: start,
      endTime: end,
      title: title,
      notes: notesController.text.trim(),
    );

    // mostro il caricamento e disabilito il pulsante
    setState(() => saving = true);

    try {
      // aggiungo l'appuntamento tramite provider
      await ref.read(appointmentsProvider.notifier).addAppointment(appointment);

      // se l'appuntamento è stato aggiunto correttamente mostro un messaggio
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Appuntamento aggiunto')));
      }

      // resetto i campi di input
      setState(() {
        selectedDate = null;
        startTime = null;
        endTime = null;
        titleController.clear();
        notesController.clear();
      });
    } catch (e) {
      // altrimenti mostro un messaggio di errore
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Errore: $e')));
      }
    } finally {
      // disabilita il caricamento e abilitato il pulsante
      if (mounted) setState(() => saving = false);
    }
  }

  // funzioni helper per formattare data e ora
  String _dateText() {
    if (selectedDate == null) return 'Seleziona data';
    return '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
  }

  String _timeText(TimeOfDay? t, String placeholder) {
    if (t == null) return placeholder;
    // mostra sempre in formato 24h
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  // interfaccia tab 1
  @override
  Widget build(BuildContext context) {
    // SingleChildScrollView per permettere lo scorrimento se la tastiera è aperta
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // pulsante per la selezione della data
          ElevatedButton.icon(
            icon: const Icon(Icons.calendar_today),
            label: Text(_dateText()),
            onPressed: pickDate,
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                // pulsante per la selezione dell'ora di inzio
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.access_time),
                  label: Text(_timeText(startTime, 'Ora inizio')),
                  onPressed: pickStartTime,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                // pulsante per la selezione dell'ora di fine
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.access_time),
                  label: Text(_timeText(endTime, 'Ora fine')),
                  onPressed: pickEndTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Titolo
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Titolo'),
          ),
          const SizedBox(height: 20),

          // Note
          TextField(
            controller: notesController,
            decoration: const InputDecoration(labelText: 'Note (opzionale)'),
            maxLines: 3,
          ),
          const SizedBox(height: 20),

          // Bottone conferma
          ElevatedButton(
            onPressed: saving ? null : onSubmit,
            child: saving
                // mostra lo spinner di caricamento
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                // altrimenti mostra il testo
                : const Text('Conferma'),
          ),
        ],
      ),
    );
  }
}
