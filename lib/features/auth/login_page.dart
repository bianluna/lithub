import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:litapp/services/lit_repository.dart'; // Corrected import path
import 'package:litapp/core/theme/lit_theme.dart';
import 'package:litapp/core/widgets/lit_widgets.dart';

import '../../core/providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    final repo = ref.read(litRepositoryProvider);
    repo.signIn();
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LitColors.background,
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: AppCard(
                color: Colors.white,
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                        child: ColorPill(
                            label: 'LITAPP', color: LitColors.primaryPurple)),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome Back',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Log in to continue your reading journey.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: LitColors.mutedText),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    _InputField(
                      hintText: 'Email address',
                      icon: Icons.email_outlined,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 16),
                    _InputField(
                      hintText: 'Password',
                      icon: Icons.lock_outline_rounded,
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      label: 'Log In',
                      icon: Icons.login_rounded,
                      onPressed: _handleLogin,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?",
                            style: TextStyle(color: LitColors.mutedText)),
                        TextButton(
                          onPressed: () => context.go('/signup'),
                          child: const Text('Sign up',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: LitColors.primaryPurple)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.hintText,
    required this.icon,
    this.controller,
    this.obscureText = false,
  });

  final String hintText;
  final IconData icon;
  final TextEditingController? controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: LitColors.mutedText, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: LitColors.mutedText),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}