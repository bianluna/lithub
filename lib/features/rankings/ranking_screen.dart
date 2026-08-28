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
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Hall of Fame 🏆',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontWeight: FontWeight.w900)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Monthly, yearly, and all-time mystical leaderboards.',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: LitColors.mutedText)),
          const SizedBox(height: 18),
          AppCard(
            padding: EdgeInsets.zero,
            color: LitColors.warmSurface,
            child: const TabBar(
              dividerColor: Colors.transparent,
              labelColor: LitColors.goldSparks,
              unselectedLabelColor: LitColors.mutedText,
              indicatorColor: LitColors.goldSparks,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: LitColors.goldSparks, width: 3)),
              ),
              tabs: [
                Tab(text: 'MOON CYCLE'),
                Tab(text: 'SOLAR YEAR'),
                Tab(text: 'ALL TIME'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AppCard(
            color: LitColors.primaryBlue,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: LitColors.goldSparks.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome,
                      color: LitColors.goldSparks, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your position',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: LitColors.goldSparks)),
                      const SizedBox(height: 4),
                      Text('#3 this cycle',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
                ColorPill(
                    label: 'Lvl ${repo.currentUser.level}',
                    color: LitColors.brightCyan),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 650, // Expanded height so it frames nicely
            child: TabBarView(
              clipBehavior: Clip.none,
              children: [
                _RankingList(
                    entries: repo.rankingsMonth,
                    currentUserId: repo.currentUser.id),
                _RankingList(
                    entries: repo.rankingsYear,
                    currentUserId: repo.currentUser.id),
                _RankingList(
                    entries: repo.rankingsAllTime,
                    currentUserId: repo.currentUser.id),
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
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final current = entry.userId == currentUserId;

        final isFirst = entry.rank == 1;
        final isSecond = entry.rank == 2;
        final isThird = entry.rank == 3;
        final isTop = isFirst || isSecond || isThird;

        Color rankColor = LitColors.text;
        if (isFirst)
          rankColor = LitColors.goldSparks;
        else if (isSecond)
          rankColor = const Color(0xFFE2E8F0); // Mithril/Silver
        else if (isThird) rankColor = const Color(0xFFCD7F32); // Bronze

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: AppCard(
            color: isFirst
                ? LitColors.goldSparks.withOpacity(0.2)
                : current
                    ? LitColors.primaryBlue.withOpacity(0.2)
                    : null,
            padding: const EdgeInsets.fromLTRB(16, 20, 20, 20),
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                  child: Center(
                    child: isTop
                        ? Icon(
                            isFirst
                                ? Icons.emoji_events_rounded
                                : Icons.military_tech_rounded,
                            color: rankColor,
                            size: isFirst ? 36 : 30)
                        : Text('#${entry.rank}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: LitColors.mutedText)),
                  ),
                ),
                const SizedBox(width: 8),
                AvatarCircle(seed: entry.avatarSeed, size: isTop ? 56 : 46),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              entry.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      fontWeight: isTop
                                          ? FontWeight.w900
                                          : FontWeight.w700,
                                      color: isFirst
                                          ? LitColors.goldSparks
                                          : LitColors.text),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (current) ...[
                            const SizedBox(width: 8),
                            const ColorPill(
                                label: 'You', color: LitColors.brightCyan),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.star_rounded,
                            size: 14, color: LitColors.goldSparks),
                        const SizedBox(width: 4),
                        Text('Level ${entry.level}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: LitColors.mutedText,
                                    fontWeight: FontWeight.w700)),
                      ])
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${entry.points}',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 2),
                    Text('mana',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: LitColors.goldSparks,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
