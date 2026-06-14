import '../models/program_model.dart';

class ProgramUtils {
  static String getCategory(ProgramModel program) {
    final title = program.title.toLowerCase();
    if (title.contains('flutter') ||
        title.contains('android') ||
        title.contains('mobile')) {
      return 'Mobile';
    }
    if (title.contains('design') || title.contains('ux')) {
      return 'Design';
    }
    if (title.contains('data') ||
        title.contains('ai') ||
        title.contains('machine learning') ||
        title.contains('science')) {
      return 'Data & AI';
    }
    if (title.contains('security') || title.contains('cyber')) {
      return 'Security';
    }
    if (title.contains('full stack') || title.contains('web')) {
      return 'Web Dev';
    }
    return 'General';
  }

  static bool matchesCategory(ProgramModel program, String category) {
    if (category == 'All') return true;
    return getCategory(program) == category;
  }
}
