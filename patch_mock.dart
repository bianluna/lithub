import 'dart:io';

void main() {
  final file = File('lib/services/mock_lit_data.dart');
  var content = file.readAsStringSync();
  
  content = content.replaceAll(
    "id: 'u1',",
    "id: 'u1',\n    email: 'bianca@example.com',\n    password: 'password123',"
  );
  content = content.replaceAll(
    "id: 'u2',",
    "id: 'u2',\n      email: 'luna@example.com',\n      password: 'password123',"
  );
  content = content.replaceAll(
    "id: 'u3',",
    "id: 'u3',\n      email: 'clara@example.com',\n      password: 'password123',"
  );
  content = content.replaceAll(
    "id: 'u4',",
    "id: 'u4',\n      email: 'milo@example.com',\n      password: 'password123',"
  );
  content = content.replaceAll(
    "id: 'u5',",
    "id: 'u5',\n      email: 'sofia@example.com',\n      password: 'password123',"
  );

  file.writeAsStringSync(content);
}
