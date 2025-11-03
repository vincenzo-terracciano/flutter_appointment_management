class Date {
  // definisco le proprietà del modello dell'appuntamento
  final DateTime day;
  final DateTime startTime;
  final DateTime endTime;
  final String title;
  final String? notes;

  // costruttore
  Date({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.title,
    this.notes,
  });

  // converto un appuntamento in Json
  Map<String, dynamic> toJson() => {
    'day': day.toIso8601String(),
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'title': title,
    'notes': notes,
  };

  // converto il Json in un appuntamento
  factory Date.fromJson(Map<String, dynamic> json) {
    return Date(
      day: DateTime.parse(json['day'] as String),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      title: json['title'] as String,
      notes: json['notes'] as String?,
    );
  }
}
