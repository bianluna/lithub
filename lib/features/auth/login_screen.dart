import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litapp/core/providers.dart';
import 'package:litapp/core/theme/lit_theme.dart';
import 'package:litapp/core/widgets/lit_widgets.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(litRepositoryProvider);

    return Scaffold(
      backgroundColor: LitColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 900;
                return Flex(
                  direction: wide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: AppCard(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const ColorPill(
                                label: 'READ • CONNECT • PROGRESS • EARN',
                                color: LitColors.primaryPurple),
                            const SizedBox(height: 20),
                            Text('LitApp',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(fontWeight: FontWeight.w800)),
                            const SizedBox(height: 10),
                            Text(
                                'A cozy social reading club with playful progress, elegant discussions, and beautifully organized community reading.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: LitColors.mutedText)),
                            const SizedBox(height: 28),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: const [
                                ColorPill(
                                    label: 'Book clubs',
                                    color: LitColors.softPeriwinkle),
                                ColorPill(
                                    label: 'Challenges',
                                    color: LitColors.softPeach),
                                ColorPill(
                                    label: 'Spoiler-safe comments',
                                    color: LitColors.warmSurface),
                                ColorPill(
                                    label: 'Rewards store',
                                    color: LitColors.primaryPurple),
                              ],
                            ),
                            const SizedBox(height: 28),
                            PrimaryButton(
                                label: 'Enter LitApp',
                                icon: Icons.auto_stories_rounded,
                                onPressed: () => context.go('/login')),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24, height: 24),
                    Expanded(
                      child: AppCard(
                        color: LitColors.warmSurface.withOpacity(.7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Welcome back',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w800)),
                            const SizedBox(height: 12),
                            Text(repo.currentUser.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.w800)),
                            const SizedBox(height: 8),
                            Text(
                                'A new chapter is waiting. Pick up where your club left off.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: LitColors.mutedText)),
                            const SizedBox(height: 20),
                            const SearchBarCard(
                                hintText: 'Search a club, book, or event'),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                    child: StatCard(
                                        label: 'Level',
                                        value: '${repo.currentUser.level}',
                                        icon: Icons.stars_rounded,
                                        color: LitColors.softPeriwinkle)),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: StatCard(
                                        label: 'Points',
                                        value: '${repo.currentUser.points}',
                                        icon: Icons.confirmation_num_rounded,
                                        color: LitColors.softPeach)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
