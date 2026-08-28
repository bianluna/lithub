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
    final time = DateTime.now().hour < 12
        ? 'morning'
        : DateTime.now().hour < 18
            ? 'afternoon'
            : 'evening';

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
          children: [
            Row(
              children: [
                Expanded(
                    child: Text('Magical $time, ${user.name}',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(fontWeight: FontWeight.w900))),
                const Icon(Icons.auto_awesome,
                    color: LitColors.goldSparks, size: 32),
              ],
            ),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.star_rounded,
                  color: LitColors.goldSparks, size: 20),
              const SizedBox(width: 8),
              Expanded(
                  child: Text('Ready to read some cute dark tales? 🦇🔮',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: LitColors.mutedText))),
            ]),
            const SizedBox(height: 24),
            if (activeReadings.isNotEmpty) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: activeReadings.map((reading) {
                      final book = repo.bookById(reading.bookId)!;
                      final club = repo.clubById(reading.clubId)!;
                      return Container(
                        width: MediaQuery.of(context).size.width > 600
                            ? 500
                            : MediaQuery.of(context).size.width * 0.85,
                        margin: const EdgeInsets.only(right: 18),
                        child: _CurrentReadingCard(
                            repo: repo,
                            book: book,
                            reading: reading,
                            club: club),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            _UpcomingEventsCard(repo: repo),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 960;
                return Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: [
                    SizedBox(
                        width: wide
                            ? constraints.maxWidth * .38
                            : constraints.maxWidth,
                        child: _ClubProgressCard(repo: repo)),
                    SizedBox(
                        width: wide
                            ? constraints.maxWidth * .58
                            : constraints.maxWidth,
                        child: _ChallengeCard(repo: repo)),
                  ],
                );
              },
            ),
          ],
        ),
        Positioned(
          top: 24,
          right: 24,
          child: FloatingActionButton(
            backgroundColor: LitColors.primaryBlue,
            foregroundColor: LitColors.background,
            elevation: 4,
            mini: true,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: _NotificationsCard(repo: repo),
                  ),
                ),
              );
            },
            child: const Icon(Icons.notifications_rounded),
          ),
        ),
      ],
    );
  }
}

class _CurrentReadingCard extends StatelessWidget {
  const _CurrentReadingCard(
      {required this.repo,
      required this.book,
      required this.reading,
      required this.club});

  final LitRepository repo;
  final dynamic book;
  final dynamic reading;
  final dynamic club;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: LitColors.warmSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CoverArt(
                  seed: book.coverSeed,
                  title: book.title,
                  subtitle: book.author,
                  accentColor: book.accentColor,
                  width: 150,
                  height: 212),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome,
                            color: LitColors.goldSparks, size: 16),
                        const SizedBox(width: 6),
                        Text('Current reading',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: LitColors.goldSparks)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(book.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text(book.author,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: LitColors.mutedText)),
                    const SizedBox(height: 12),
                    ColorPill(
                        label: club.name,
                        color: LitColors.background.withOpacity(0.6)),
                    const SizedBox(height: 16),
                    Row(children: [
                      Text('${reading.progressPercent}%',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: LitColors.brightCyan)),
                      const SizedBox(width: 8),
                      if (reading.progressPercent > 50)
                        const Icon(Icons.star,
                            color: LitColors.goldSparks, size: 18),
                    ]),
                    const SizedBox(height: 4),
                    Text(
                        '${reading.currentPage} / ${reading.totalPages} pages \u2022 ${DateFormat('d MMM').format(reading.endDate)} deadline',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: LitColors.mutedText)),
                    const SizedBox(height: 16),
                    ProgressBar(
                        progress: reading.progressPercent / 100,
                        color: LitColors.brightCyan),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: PrimaryButton(
                      label: 'Update progress',
                      icon: Icons.edit_rounded,
                      onPressed: () => context.go('/reading'))),
              const SizedBox(width: 12),
              Expanded(
                  child: SecondaryButton(
                      label: 'Open book',
                      icon: Icons.menu_book_rounded,
                      onPressed: () => context.go('/books/${book.id}'))),
            ],
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
      color: LitColors.warmSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.nightlight_round,
                  color: LitColors.primaryBlue, size: 16),
              const SizedBox(width: 6),
              Text('Club spell-casting',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: LitColors.primaryBlue,
                      fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 10),
          Text(book.title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          ProgressBar(
              progress: club.progress / 100, color: LitColors.primaryBlue),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: StatCard(
                      label: 'Familiars',
                      value: '${club.memberCount}',
                      icon: Icons.people_alt_rounded,
                      color: LitColors.brightCyan)),
              const SizedBox(width: 12),
              Expanded(
                  child: StatCard(
                      label: 'Finished',
                      value:
                          '${repo.readingByClubId(club.id)?.membersFinished ?? 0}',
                      icon: Icons.check_circle_rounded,
                      color: LitColors.goldSparks)),
            ],
          ),
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
    final challenge = repo.challenges
        .firstWhere((item) => item.status == ChallengeStatus.active);
    return AppCard(
      color: LitColors.warmSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.star_rounded, color: LitColors.goldSparks),
            const SizedBox(width: 8),
            Expanded(
                child: SectionHeader(
                    title: 'Quest of the Moon 🌙',
                    subtitle: 'A little magical nudge for the month')),
          ]),
          const SizedBox(height: 12),
          Text(challenge.title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(challenge.description,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: LitColors.mutedText)),
          const SizedBox(height: 14),
          ProgressBar(
              progress: challenge.progress / challenge.goal,
              color: LitColors.goldSparks),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${challenge.progress} / ${challenge.goal}',
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              Text('+${challenge.rewardPoints} mana',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: LitColors.goldSparks)),
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
      color: LitColors.warmSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
              title: 'Upcoming seances 🔮',
              subtitle: 'Meetings, deadlines, and club moments'),
          ...repo.events.take(3).map(
                (event) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    color: event.color.withOpacity(.15),
                    child: Row(
                      children: [
                        Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                                color: event.color,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: event.color.withOpacity(0.6),
                                      blurRadius: 4)
                                ])),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 3),
                              Text(
                                  DateFormat('EEE, d MMM \u2022 HH:mm')
                                      .format(event.dateTime),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: LitColors.mutedText)),
                            ],
                          ),
                        ),
                        const Icon(Icons.auto_awesome,
                            color: LitColors.goldSparks, size: 14),
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

class _NotificationsCard extends StatelessWidget {
  const _NotificationsCard({required this.repo});
  final LitRepository repo;
  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: LitColors.background.withOpacity(0.95), // Dark enchanted glass
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionHeader(
              title: 'Owl Mails 🦉✨',
              subtitle: 'Recent updates from your covens'),
          ...repo.notifications.take(3).map(
                (n) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    color: LitColors.warmSurface,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                              child: Text(n.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800))),
                          const Icon(Icons.star,
                              color: LitColors.goldSparks, size: 14),
                        ]),
                        const SizedBox(height: 4),
                        Text(n.body,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: LitColors.mutedText)),
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
