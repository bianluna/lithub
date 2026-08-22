import 'dart:io';

void main() {
  final file = File('lib/features/auth/signup_page.dart');
  var content = file.readAsStringSync();
  
  content = content.replaceAll(
'''
  Future<void> _handleSignup() async {
    final repo = ref.read(litRepositoryProvider);
    repo.signIn(); // Mocking signup with signIn for now
    context.go('/home');
  }'''
,
'''
  Future<void> _handleSignup() async {
    final repo = ref.read(litRepositoryProvider);
    // Mocking signup with signIn for now using a hardcoded default
    repo.signIn('bianca@example.com', 'password123'); 
    context.go('/home');
  }'''
  );

  file.writeAsStringSync(content);
}
