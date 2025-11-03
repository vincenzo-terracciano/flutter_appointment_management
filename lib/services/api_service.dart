import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/date.dart';

class ApiService {
  // definisco gli URL base per gli endpoint
  final String authBaseUrl = 'https://reqres.in/api';
  final String datesBaseUrl = 'https://jsonplaceholder.typicode.com';

  // Client http per fare le richieste
  final http.Client _client;

  // costruttore
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // metodo per il login
  Future<String> login(String email, String password) async {
    try {
      // invio una richiesta http POST
      final response = await _client.post(
        Uri.parse('$authBaseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      // controllo se la richiesta ha avuto successo
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'] as String;
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // metodo per creare un nuovo appuntamento
  Future<Map<String, dynamic>> createDate(Date date) async {
    try {
      // invio una richiesta http POST
      final response = await _client.post(
        Uri.parse('$datesBaseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
        // converto il modello in un Map
        // poi converto il Map in un Json
        body: jsonEncode(date.toJson()),
      );

      // controllo se è stato creato l'appuntamento
      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        final body = response.body;
        throw Exception(
          'Failed to create date (${response.statusCode}): $body',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // metodo per ottenere tutti gli appuntamenti
  Future<List<Date>> getDates() async {
    try {
      // invio una richiesta http GET
      final response = await _client.get(Uri.parse('$datesBaseUrl/posts'));
      // controllo se la richiesta ha avuto successo
      if (response.statusCode == 200) {
        // converto il Json in una List
        final List<dynamic> data = jsonDecode(response.body);
        // restituisco ogni elemento della lista trasformato
        return data.map((json) {
          // prendo la data e l'ora corrente
          final now = DateTime.now();
          // restituisco un appuntamento per ogni elemento della lista
          return Date(
            day: now,
            startTime: now,
            endTime: now.add(Duration(hours: 1)),
            title: json['title'] ?? 'Appuntamento',
            notes: json['body'],
          );
          // converto il risultato in una List
        }).toList();
      } else {
        throw Exception('Error loading dates');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }
}
