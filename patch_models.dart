import 'dart:io';

void main() {
  final file = File('lib/models/lit_models.dart');
  var content = file.readAsStringSync();

  content = content.replaceFirst(
    '  AppUser({',
    '  AppUser({\n    required this.email,\n    required this.password,'
  );

  content = content.replaceFirst(
    '  final String id;',
    '  final String id;\n  final String email;\n  final String password;'
  );

  file.writeAsStringSync(content);
}
