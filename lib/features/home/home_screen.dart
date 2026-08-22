import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:litapp/core/providers.dart';
import 'package:litapp/core/theme/lit_theme.dart';
import 'package:litapp/core/widgets/lit_widgets.dart';
import 'package:litapp/models/lit_models.dart';
import 'package:litapp/services/lit_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(litRepositoryProvider);
    final user = repo.currentUser;
    final activeReadings = repo.readings.where((r) {
      final c = repo.clubById(r.clubId);
      return c != null && c.isJoined && r.status == ReadingStatus.reading;
    }).toList();
    final time = DateTime.now().hour < 12 ? 'morning' : DateTime.now().hour < 18 ? 'afternoon' : 'evening';

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      children: [
        Text('Good $time, ${user.name}', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text('Ready to read something new?', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: LitColors.mutedText)),
        const SizedBox(height: 18),
        const SearchBarCard(hintText: 'Search clubs, books, challenges, or events'),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 960;
            return Wrap(
              spacing: 18,
              runSpacing: 18,
              children: [
                ...activeReadings.map((reading) {
                   final book = repo.bookById(reading.bookId)!;
                   final club = repo.clubById(reading.clubId)!;
                   return SizedBox(width: wide ? constraints.maxWidth * .58 : constraints.maxWidth, child: _CurrentReadingCard(repo: repo, book: book, reading: reading, club: club));
                }),
                SizedBox(width: wide ? constraints.maxWidth * .38 : constraints.maxWidth, child: _ClubProgressCard(repo: repo)),
                SizedBox(width: wide ? constraints.maxWidth * .38 : constraints.maxWidth, child: _RankingCard(repo: repo)),
                SizedBox(width: wide ? constraints.maxWidth * .58 : constraints.maxWidth, child: _ChallengeCard(repo: repo)),
                SizedBox(width: wide ? constraints.maxWidth * .58 : constraints.maxWidth, child: _UpcomingEventsCard(repo: repo)),
                SizedBox(width: wide ? constraints.maxWidth * .38 : constraints.maxWidth, child: _AchievementsCard(repo: repo)),
                SizedBox(width: wide ? constraints.maxWidth * .38 : constraints.maxWidth, child: _NotificationsCard(repo: repo)),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CurrentReadingCard extends StatelessWidget {
  const _CurrentReadingCard({required this.repo, required this.book, required this.reading, required this.club});

  final LitRepository repo;
  final dynamic book;
  final dynamic reading;
  final dynamic club;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CoverArt(seed: book.coverSeed, title: book.title, subtitle: book.author, accentColor: book.accentColor, width: 150, height: 212),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current reading', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800, color: LitColors.mutedText)),
                const SizedBox(height: 10),
                Text(book.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(book.author, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: LitColors.mutedText)),
                const SizedBox(height: 12),
                ColorPill(label: club.name, color: LitColors.warmSurface),
                const SizedBox(height: 16),
                Text('${reading.progressPercent}%', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('${reading.currentPage} / ${reading.totalPages} pages • ${DateFormat('d MMM').format(reading.endDate)} deadline', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: LitColors.mutedText)),
                const SizedBox(height: 16),
                ProgressBar(progress: reading.progressPercent / 100, color: LitColors.primaryPurple),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    PrimaryButton(label: 'Update progress', icon: Icons.edit_rounded, onPressed: () => context.go('/reading')),
                    SecondaryButton(label: 'Open book', icon: Icons.menu_book_rounded, onPressed: () => context.go('/books/${book.id}')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClubProgressCard extends StatelessWidget {
  const _ClubProgressCard({required this.repo});
  final LitRepository repo;
  @override
  Widget build(BuildContext context) {
    final club = repo.clubById('c1')!;
    final book = repo.bookById(club.currentBookId)!;
    return AppCard(
      color: LitColors.warmSurface.withOpacity(.8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: club.name, subtitle: 'Club progress and shared reading rhythm'),
          const SizedBox(height: 6),
          Text('Current reading', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: LitColors.mutedText, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text(book.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          ProgressBar(progress: club.progress / 100, color: LitColors.primaryPurple),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: StatCard(label: 'Members', value: '${club.memberCount}', icon: Icons.people_alt_rounded, color: LitColors.softPeriwinkle)),
              const SizedBox(width: 12),
              Expanded(child: StatCard(label: 'Finished', value: '${repo.readingByClubId(club.id)?.membersFinished ?? 0}', icon: Icons.check_circle_rounded, color: LitColors.softPeach)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RankingCard extends StatelessWidget {
  const _RankingCard({required this.repo});
  final LitRepository repo;
  @override
  Widget build(BuildContext context) {
    final ranking = repo.rankingsMonth;
    final current = ranking.firstWhere((entry) => entry.userId == repo.currentUser.id);
    return AppCard(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Ranking', subtitle: 'Your current position this month'),
          Text('#${current.rank} this month', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 14),
          ...ranking.take(3).map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Text('${entry.rank}.', style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(width: 10),
                    AvatarCircle(seed: entry.avatarSeed, size: 36),
                    const SizedBox(width: 10),
                    Expanded(child: Text(entry.name, style: const TextStyle(fontWeight: FontWeight.w700))),
                    Text('${entry.points} pts', style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              )),
          const SizedBox(height: 6),
          PrimaryButton(label: 'View ranking', icon: Icons.emoji_events_rounded, onPressed: () => context.go('/ranking')),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({required this.repo});
  final LitRepository repo;
  @override
  Widget build(BuildContext context) {
    final challenge = repo.challenges.firstWhere((item) => item.status == ChallengeStatus.active);
    return AppCard(
      color: const Color(0x66FFD8BE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Current challenge', subtitle: 'A light gamification nudge for the month'),
          Text(challenge.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(challenge.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: LitColors.mutedText)),
          const SizedBox(height: 14),
          ProgressBar(progress: challenge.progress / challenge.goal, color: LitColors.primaryPurple),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${challenge.progress} / ${challenge.goal}', style: const TextStyle(fontWeight: FontWeight.w800)),
              Text('+${challenge.rewardPoints} points', style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

class _UpcomingEventsCard extends StatelessWidget {
  const _UpcomingEventsCard({required this.repo});
  final LitRepository repo;
  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Upcoming events', subtitle: 'Meetings, deadlines, and club moments'),
          ...repo.events.take(3).map(
                (event) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    color: event.color.withOpacity(.18),
                    child: Row(
                      children: [
                        Container(width: 12, height: 12, decoration: BoxDecoration(color: event.color, shape: BoxShape.circle)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                              const SizedBox(height: 3),
                              Text(DateFormat('EEE, d MMM • HH:mm').format(event.dateTime), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: LitColors.mutedText)),
                            ],
                          ),
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

class _AchievementsCard extends StatelessWidget {
  const _AchievementsCard({required this.repo});
  final LitRepository repo;
  @override
  Widget build(BuildContext context) {
    final unlocked = repo.achievements.where((a) => a.unlocked).take(4).toList();
    return AppCard(
      color: LitColors.warmSurface.withOpacity(.8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Achievements', subtitle: 'Recently unlocked badges'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: unlocked.map((a) => ColorPill(label: '${a.icon} ${a.title}', color: LitColors.primaryPurple)).toList(),
          ),
        ],
      ),
    );
  }
}

class _NotificationsCard extends StatelessWidget {
  const _NotificationsCard({required this.repo});
  final LitRepository repo;
  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: const Color(0x66B8B8FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Notifications', subtitle: 'Recent updates from your clubs'),
          ...repo.notifications.take(3).map(
                (n) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    color: Colors.white.withOpacity(.72),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(n.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(n.body, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: LitColors.mutedText)),
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
