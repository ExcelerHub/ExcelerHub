import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/program_model.dart';

/// Loads the program catalog from assets/data/programs.json.
/// Week 3: real data from a sample JSON file instead of hardcoded list.
Future<List<ProgramModel>> getDummyPrograms() async {
  final jsonString = await rootBundle.loadString('assets/data/programs.json');
  final Map<String, dynamic> jsonMap = json.decode(jsonString);
  final List<dynamic> programsJson = jsonMap['programs'];

  return programsJson
      .map((item) => ProgramModel.fromMap(item as Map<String, dynamic>))
      .toList();
}