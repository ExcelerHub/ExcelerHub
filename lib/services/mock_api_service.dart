import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import '../models/program_model.dart';

class MockApiService {
  MockApiService._internal();
  static final MockApiService instance = MockApiService._internal();
  factory MockApiService() => instance;

  static const _networkDelay = Duration(milliseconds: 800);

  Future<List<ProgramModel>> fetchPrograms() async {
    await Future.delayed(_networkDelay);
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/programs.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> programsJson = jsonMap['programs'];
      return programsJson
          .map((item) => ProgramModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load programs from API: $e');
    }
  }
}