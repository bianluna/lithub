import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:litapp/core/providers.dart';
import 'package:litapp/core/theme/lit_theme.dart';
import 'package:litapp/core/widgets/lit_widgets.dart';
import 'package:litapp/models/lit_models.dart';

class ChallengesScreen extends ConsumerWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(litRepositoryProvider);
    final active = repo.challenges
        .where((c) => c.status == ChallengeStatus.active)
        .toList();
    final completed = repo.challenges
        .where((c) => c.status == ChallengeStatus.completed)
        .toList();
    final upcoming = repo.challenges
        .where((c) => c.status == ChallengeStatus.upcoming)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
      children: [
        Text('Challenges',
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text(
            'Active, completed, and upcoming challenges all in one cozy board.',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: LitColors.mutedText)),
        const SizedBox(height: 18),
        _ChallengeSection(
            title: 'Active challenges',
            items: active,
            color: LitColors.softPeach),
        const SizedBox(height: 18),
        _ChallengeSection(
            title: 'Completed challenges',
            items: completed,
            color: LitColors.softPeriwinkle),
        const SizedBox(height: 18),
        _ChallengeSection(
            title: 'Upcoming challenges',
            items: upcoming,
            color: LitColors.warmSurface),
      ],
    );
  }
}

class _ChallengeSection extends StatelessWidget {
  const _ChallengeSection(
      {required this.title, required this.items, required this.color});

  final String title;
  final List<dynamic> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: color.withOpacity(.7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title),
          ...items.map(
            (challenge) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                color: Colors.white.withOpacity(.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(challenge.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w800))),
                        Text('+${challenge.rewardPoints} points',
                            style:
                                const TextStyle(fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(challenge.description,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: LitColors.mutedText)),
                    const SizedBox(height: 12),
                    ProgressBar(
                        progress: challenge.progress / challenge.goal,
                        color: LitColors.primaryPurple),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('${challenge.progress} / ${challenge.goal}',
                            style:
                                const TextStyle(fontWeight: FontWeight.w800)),
                        const Spacer(),
                        Text(DateFormat('d MMM').format(challenge.deadline),
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
