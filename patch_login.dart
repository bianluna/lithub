import 'dart:io';

void main() {
  final file = File('lib/features/auth/login_page.dart');
  var content = file.readAsStringSync();
  
  content = content.replaceAll(
'''
  Future<void> _handleLogin() async {
    final repo = ref.read(litRepositoryProvider);
    repo.signIn();
    context.go('/home');
  }'''
,
'''
  Future<void> _handleLogin() async {
    final repo = ref.read(litRepositoryProvider);
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an email and password')),
      );
      return;
    }
    
    final success = repo.signIn(email, password);
    if (success) {
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }'''
  );

  file.writeAsStringSync(content);
}
