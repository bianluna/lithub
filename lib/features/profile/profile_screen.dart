import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litapp/core/providers.dart';
import 'package:litapp/core/theme/lit_theme.dart';
import 'package:litapp/core/widgets/lit_widgets.dart';
import 'package:litapp/models/lit_models.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(litRepositoryProvider);
    final user = repo.currentUser;
    final achievements = repo.achievements.where((a) => a.unlocked).toList();
    final joinedClubs = repo.clubs.where((club) => club.isJoined).toList();
    final activeChallenges = repo.challenges
        .where((c) => c.status == ChallengeStatus.active)
        .toList();

    // History includes finished and abandoned readings
    final historyReadings = repo.readings
        .where((r) =>
            r.status == ReadingStatus.finished ||
            r.status == ReadingStatus.abandoned)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
      children: [
        // Character & Main Info
        AppCard(
          color: LitColors.warmSurface,
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Character Portrait Box
              Container(
                width: 120,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      LitColors.primaryBlue.withOpacity(0.8),
                      LitColors.brightCyan.withOpacity(0.3)
                    ],
                  ),
                  border: Border.all(
                      color: LitColors.goldSparks.withOpacity(0.6), width: 2),
                  boxShadow: [
                    BoxShadow(
                        color: LitColors.goldSparks.withOpacity(0.2),
                        blurRadius: 12,
                        spreadRadius: 0)
                  ],
                  // TODO: Sustituir la imagen abajo con tu recurso de imagen real:
                  // image: DecorationImage(image: AssetImage('assets/character.png'), fit: BoxFit.cover),
                ),
                child: const Center(
                  // Placeholder mágico
                  child:
                      Icon(Icons.face_4_rounded, size: 72, color: Colors.white),
                ),
              ),
              const SizedBox(width: 20),

              // Character Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 2),
                    Text(user.handle,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: LitColors.goldSparks,
                                fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),

                    // Level and Streak Row
                    Row(
                      children: [
                        ColorPill(
                            label: 'Lvl ${user.level} Mage',
                            color: LitColors.primaryBlue),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: LitColors.goldSparks.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: LitColors.goldSparks.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.local_fire_department_rounded,
                                  color: LitColors.goldSparks, size: 16),
                              const SizedBox(width: 4),
                              Text('${user.streakDays} days',
                                  style: const TextStyle(
                                      color: LitColors.goldSparks,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Covens (Clubs) joined
                    Text('Active Covens:',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: LitColors.mutedText)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: joinedClubs
                          .map((club) => Tooltip(
                                message: club.name,
                                child: AvatarCircle(
                                    seed: club.profileSeed, size: 32),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Books Read Stats
        Row(
          children: [
            // Calculo dummy para los libros anuales basados en los totales para la maqueta
            Expanded(
                child: StatCard(
                    label: 'Books this year',
                    value: '${(user.booksRead * 0.4).ceil()}',
                    icon: Icons.auto_stories_rounded,
                    color: LitColors.brightCyan)),
            const SizedBox(width: 16),
            Expanded(
                child: StatCard(
                    label: 'All-time books',
                    value: '${user.booksRead}',
                    icon: Icons.library_books_rounded,
                    color: LitColors.goldSparks)),
          ],
        ),

        const SizedBox(height: 32),

        // Active Challenges
        if (activeChallenges.isNotEmpty) ...[
          SectionHeader(
              title: 'Active Quests 🌙',
              subtitle: 'Magical challenges to complete'),
          const SizedBox(height: 16),
          ...activeChallenges.map(
            (challenge) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                color: LitColors.warmSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(challenge.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800)),
                        Text('+${challenge.rewardPoints} mana',
                            style: const TextStyle(
                                color: LitColors.goldSparks,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(challenge.description,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: LitColors.mutedText)),
                    const SizedBox(height: 14),
                    ProgressBar(
                        progress: challenge.progress / challenge.goal,
                        color: LitColors.brightCyan),
                    const SizedBox(height: 8),
                    Text('${challenge.progress} / ${challenge.goal} completed',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: LitColors.text)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Achievements by Coven
        SectionHeader(
            title: 'Grimoire Trophies 🏆',
            subtitle: 'Achievements sorted by your covens'),
        const SizedBox(height: 16),
        ...joinedClubs.map((club) {
          // Simulamos una asignación de logros a cada club para la UI (porque el modelo no trae `clubId` en los logros y usamos datos globales)
          final clubAchievements = achievements
              .where((a) => (a.id.hashCode + club.id.hashCode) % 2 == 0)
              .toList();

          if (clubAchievements.isEmpty) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              color: LitColors.warmSurface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    AvatarCircle(seed: club.profileSeed, size: 28),
                    const SizedBox(width: 8),
                    Text(club.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800)),
                  ]),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: clubAchievements
                        .map((ach) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: LitColors.primaryBlue.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.08)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(ach.icon,
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(width: 8),
                                  Text(ach.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: LitColors.text)),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 20),

        // Historical Reads
        SectionHeader(
            title: 'Historical Reads 📖',
            subtitle: 'A chronicle of past journeys and progress'),
        const SizedBox(height: 16),
        if (historyReadings.isEmpty)
          const EmptyStateCard(
              title: 'No past journeys',
              message: 'You have not finished or abandoned any books yet.')
        else
          ...historyReadings.map((reading) {
            final book = repo.bookById(reading.bookId)!;
            final club = repo.clubById(reading.clubId)!;
            final isFinished = reading.status == ReadingStatus.finished;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                color: LitColors.warmSurface,
                child: Row(
                  children: [
                    CoverArt(
                        seed: book.coverSeed,
                        title: book.title,
                        subtitle: book.author,
                        accentColor: book.accentColor,
                        width: 70,
                        height: 100),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(book.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text('Read with ${club.name}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: LitColors.mutedText)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                  isFinished
                                      ? Icons.check_circle_rounded
                                      : Icons.pause_circle_filled_rounded,
                                  color: isFinished
                                      ? LitColors.brightCyan
                                      : LitColors.mutedText,
                                  size: 16),
                              const SizedBox(width: 4),
                              Text('${reading.progressPercent}% progress',
                                  style: TextStyle(
                                      color: isFinished
                                          ? LitColors.brightCyan
                                          : LitColors.mutedText,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
