import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litapp/core/providers.dart';
import 'package:litapp/core/theme/lit_theme.dart';
import 'package:litapp/core/widgets/lit_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(litRepositoryProvider);
    final user = repo.currentUser;
    final achievements = repo.achievements.where((a) => a.unlocked).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      children: [
        AppCard(
          color: LitColors.warmSurface.withOpacity(.75),
          child: Row(
            children: [
              AvatarCircle(seed: user.avatarSeed, size: 84),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(user.handle, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: LitColors.mutedText)),
                    const SizedBox(height: 10),
                    Text(user.bio, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5)),
                  ],
                ),
              ),
              ColorPill(label: user.isAdmin ? 'Admin' : 'Reader', color: LitColors.primaryPurple),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 18,
          runSpacing: 18,
          children: [
            SizedBox(width: 240, child: StatCard(label: 'Level', value: '${user.level}', icon: Icons.stars_rounded, color: LitColors.softPeriwinkle)),
            SizedBox(width: 240, child: StatCard(label: 'XP', value: '${user.xp} / ${user.nextLevelXp}', icon: Icons.bolt_rounded, color: LitColors.softPeach)),
            SizedBox(width: 240, child: StatCard(label: 'Points', value: '${user.points}', icon: Icons.confirmation_num_rounded, color: LitColors.warmSurface)),
            SizedBox(width: 240, child: StatCard(label: 'Streak', value: '${user.streakDays} days', icon: Icons.local_fire_department_rounded, color: LitColors.primaryPurple)),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: AppCard(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(title: 'XP progression', subtitle: 'Level progress and elegant charting'),
                    Text('${user.xp} / ${user.nextLevelXp} XP', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    ProgressBar(progress: user.xp / user.nextLevelXp, color: LitColors.primaryPurple),
                    const SizedBox(height: 16),
                    const MiniBarChart(values: [3, 5, 6, 4, 8, 9, 7]),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: AppCard(
                color: LitColors.warmSurface.withOpacity(.7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(title: 'Reading stats', subtitle: 'Books, pages, and favorite genres'),
                    Text('${user.booksRead} books read', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    Text('${user.pagesRead} pages read', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: user.favoriteGenres.map((genre) => ColorPill(label: genre, color: LitColors.softPeach)).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        AppCard(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: 'Achievements', subtitle: 'Recently unlocked badges'),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: achievements.map((achievement) => ColorPill(label: '${achievement.icon} ${achievement.title}', color: LitColors.primaryPurple)).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
