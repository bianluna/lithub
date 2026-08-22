import 'dart:io';

void main() {
  final file = File('lib/services/lit_repository.dart');
  var content = file.readAsStringSync();
  
  content = content.replaceAll(
    'void signIn();',
    'bool signIn(String email, String password);'
  );
  
  content = content.replaceAll(
    '  final AppUser _currentUser = MockLitData.currentUser;',
    '  AppUser _currentUser = MockLitData.currentUser;'
  );

  content = content.replaceAll(
    '  void signIn() {\n    _signedIn = true;\n    notifyListeners();\n  }',
    '  bool signIn(String email, String password) {\n    for (var user in _users) {\n      if (user.email == email && user.password == password) {\n        _currentUser = user;\n        _signedIn = true;\n        notifyListeners();\n        return true;\n      }\n    }\n    return false;\n  }'
  );

  file.writeAsStringSync(content);
}
