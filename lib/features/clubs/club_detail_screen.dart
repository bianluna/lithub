import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:litapp/core/providers.dart';
import 'package:litapp/core/theme/lit_theme.dart';
import 'package:litapp/core/widgets/lit_widgets.dart';
import 'package:litapp/models/lit_models.dart';

class ClubDetailScreen extends ConsumerWidget {
  const ClubDetailScreen({super.key, required this.clubId});

  final String clubId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(litRepositoryProvider);
    final club = repo.clubById(clubId)!;
    final joined = club.isJoined;
    final reading = joined ? repo.readingByClubId(clubId) : null;
    final book = reading != null ? repo.bookById(reading.bookId) : null;
    final selection = repo.selectionForClub(clubId);
    final members = repo.users.take(club.memberCount).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
      children: [
        AppCard(
          color: LitColors.warmSurface.withOpacity(.82),
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(28)),
                  gradient: LinearGradient(colors: [
                    club.themeColor.withOpacity(.95),
                    LitColors.softPeriwinkle.withOpacity(.82)
                  ]),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(club.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900)),
                        ),
                        AvatarCircle(seed: club.profileSeed, size: 72),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(club.description,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white.withOpacity(.92))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ColorPill(
                        label: '${club.memberCount} members',
                        color: club.themeColor),
                    ColorPill(
                        label: club.privacy.label, color: LitColors.softPeach),
                    SecondaryButton(
                        label: 'Ranking',
                        icon: Icons.emoji_events_rounded,
                        onPressed: () {}),
                    SecondaryButton(
                        label: 'Members',
                        icon: Icons.people_alt_rounded,
                        onPressed: () {}),
                    SecondaryButton(
                        label: 'Challenges',
                        icon: Icons.flag_rounded,
                        onPressed: () {}),
                    SecondaryButton(
                        label: 'Settings',
                        icon: Icons.tune_rounded,
                        onPressed: () => context.go('/settings')),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (!joined) ...[
          AppCard(
            color: LitColors.warmSurface.withOpacity(.72),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Join this club to see its current book and reading dashboard.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    if (club.privacy == ClubPrivacy.public)
                      SecondaryButton(
                        label: 'Join club',
                        icon: Icons.group_add_rounded,
                        onPressed: () => ref
                            .read(litRepositoryProvider)
                            .toggleClubJoin(clubId),
                      )
                    else
                      SecondaryButton(
                        label: 'Request access',
                        icon: Icons.lock_open_rounded,
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Your request has been queued for the club admin.')),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ] else ...[
          Wrap(
            spacing: 18,
            runSpacing: 18,
            children: [
              SizedBox(
                width: 720,
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                          title: 'Current reading',
                          subtitle:
                              'The main visual element in the club dashboard'),
                      Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          CoverArt(
                              seed: book!.coverSeed,
                              title: book!.title,
                              subtitle: book!.author,
                              accentColor: book!.accentColor,
                              width: 150,
                              height: 220),
                          SizedBox(
                            width: 480, // constrain width so it wraps on mobile
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(book!.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w800)),
                                const SizedBox(height: 8),
                                Text(book!.author,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: LitColors.mutedText)),
                                const SizedBox(height: 24),
                                ProgressBar(
                                    progress: reading!.progressPercent / 100,
                                    color: club.themeColor),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                        child: StatCard(
                                            label: 'Start date',
                                            value: DateFormat('d MMM')
                                                .format(reading!.startDate),
                                            color: LitColors.softPeriwinkle)),
                                    const SizedBox(width: 16),
                                    Expanded(
                                        child: StatCard(
                                            label: 'End date',
                                            value: DateFormat('d MMM')
                                                .format(reading!.endDate),
                                            color: LitColors.softPeach)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                        child: StatCard(
                                            label: 'Average progress',
                                            value:
                                                '${reading!.averageClubProgress}%',
                                            color: club.themeColor)),
                                    const SizedBox(width: 16),
                                    Expanded(
                                        child: StatCard(
                                            label: 'Finished',
                                            value:
                                                '${reading!.membersFinished}',
                                            color: LitColors.softPeriwinkle)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text('Timeline',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 16),
                      MilestoneTimeline(
                          items: reading!.milestones
                              .map((m) => (m.title, m.reached))
                              .toList()),
                      const SizedBox(height: 32),
                      SectionHeader(
                        title: 'Active Challenges',
                        subtitle: 'Work together to complete these goals!',
                      ),
                      const SizedBox(height: 20),
                      ...repo.challenges.take(2).map(
                            (challenge) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: AppCard(
                                color: LitColors.warmSurface,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(challenge.title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 12),
                                    ProgressBar(
                                        progress:
                                            challenge.progress / challenge.goal,
                                        color: club.themeColor),
                                    const SizedBox(height: 8),
                                    Text(
                                        '${challenge.progress} / ${challenge.goal}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                color: LitColors.mutedText)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          SecondaryButton(
                              label: 'Previous',
                              icon: Icons.history_rounded,
                              onPressed: () {}),
                          SecondaryButton(
                              label: 'Upcoming',
                              icon: Icons.upcoming_rounded,
                              onPressed: () {}),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 320,
                child: Column(
                  children: [
                    AppCard(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(
                              title: 'Members',
                              subtitle: 'A cozy reading circle'),
                          ...members.take(5).map((user) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    AvatarCircle(
                                        seed: user.avatarSeed, size: 34),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: Text(user.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700))),
                                    Text('Lv ${user.level}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    AppCard(
                      color: LitColors.warmSurface.withOpacity(.72),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(
                              title: 'Ranking',
                              subtitle: 'Top readers in the club'),
                          Text('1. Luna — 820 pts',
                              style: Theme.of(context).textTheme.bodyLarge),
                          Text('2. Clara — 760 pts',
                              style: Theme.of(context).textTheme.bodyLarge),
                          Text('3. You — 720 pts',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(
                              title: 'Library',
                              subtitle: 'Voting or draw selection'),
                          if (selection != null &&
                              selection.mode == BookSelectionMode.voting)
                            ...selection.options.map(
                              (option) {
                                final bookOption =
                                    repo.bookById(option.bookId)!;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: AppCard(
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 42,
                                              height: 42,
                                              decoration: BoxDecoration(
                                                color: bookOption.accentColor
                                                    .withOpacity(.16),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              child: Icon(
                                                  Icons.menu_book_rounded,
                                                  color: bookOption.accentColor,
                                                  size: 20),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                                child: Text(bookOption.title,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800))),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text('${option.votes} votes',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                    color:
                                                        LitColors.mutedText)),
                                        const SizedBox(height: 10),
                                        PrimaryButton(
                                            label: 'Vote',
                                            onPressed: () => ref
                                                .read(litRepositoryProvider)
                                                .voteForBook(
                                                    clubId, bookOption.id)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          else if (selection != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Draw mode is ready.',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                                const SizedBox(height: 12),
                                PrimaryButton(
                                    label: 'Reveal draw',
                                    icon: Icons.auto_awesome_rounded,
                                    onPressed: () => ref
                                        .read(litRepositoryProvider)
                                        .executeDraw(clubId)),
                                if (selection.selectedBookId != null) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                      'Selected: ${repo.bookById(selection.selectedBookId!)!.title}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800)),
                                ],
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 18,
            runSpacing: 18,
            children: [
              SizedBox(
                width: 720,
                child: AppCard(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                          title: 'Events',
                          subtitle: 'Meetings, milestones, and club moments'),
                      ...repo.events
                          .where((event) => event.clubId == clubId)
                          .take(3)
                          .map(
                            (event) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AppCard(
                                color: event.color.withOpacity(.16),
                                child: Row(
                                  children: [
                                    Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                            color: event.color,
                                            shape: BoxShape.circle)),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(event.title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w800)),
                                          const SizedBox(height: 4),
                                          Text(event.description,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      color:
                                                          LitColors.mutedText)),
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
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
