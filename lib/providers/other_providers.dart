import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final userEmailProvider = StateProvider<String?>((ref) => null);
