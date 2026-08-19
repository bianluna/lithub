import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litapp/core/providers.dart';
import 'package:litapp/core/theme/lit_theme.dart';
import 'package:litapp/core/widgets/lit_widgets.dart';

class RankingScreen extends ConsumerWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(litRepositoryProvider);

    return DefaultTabController(
      length: 3,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        children: [
          Text('Rankings', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text('Monthly, yearly, and all-time leaderboards with a soft purple edge.', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: LitColors.mutedText)),
          const SizedBox(height: 18),
          const TabBar(
            labelColor: LitColors.primaryPurple,
            unselectedLabelColor: LitColors.mutedText,
            indicatorColor: LitColors.primaryPurple,
            tabs: [
              Tab(text: 'MONTH'),
              Tab(text: 'YEAR'),
              Tab(text: 'ALL TIME'),
            ],
          ),
          const SizedBox(height: 18),
          AppCard(
            color: LitColors.warmSurface.withOpacity(.7),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your position', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Text('#3 this month', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ColorPill(label: '${repo.currentUser.level} level', color: LitColors.primaryPurple),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 460,
            child: TabBarView(
              children: [
                _RankingList(entries: repo.rankingsMonth, currentUserId: repo.currentUser.id),
                _RankingList(entries: repo.rankingsYear, currentUserId: repo.currentUser.id),
                _RankingList(entries: repo.rankingsAllTime, currentUserId: repo.currentUser.id),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RankingList extends StatelessWidget {
  const _RankingList({required this.entries, required this.currentUserId});

  final List<dynamic> entries;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: entries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final entry = entries[index];
        final current = entry.userId == currentUserId;
        final top = entry.rank <= 3;
        return AppCard(
          color: top ? LitColors.primaryPurple.withOpacity(.08) : Colors.white,
          child: Row(
            children: [
              Text('#${entry.rank}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, color: top ? LitColors.primaryPurple : LitColors.text)),
              const SizedBox(width: 14),
              AvatarCircle(seed: entry.avatarSeed, size: top ? 52 : 42),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(entry.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                        if (current) ...[
                          const SizedBox(width: 8),
                          const ColorPill(label: 'You', color: LitColors.softPeach),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text('Level ${entry.level}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: LitColors.mutedText)),
                  ],
                ),
              ),
              Text('${entry.points} pts', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            ],
          ),
        );
      },
    );
  }
}
