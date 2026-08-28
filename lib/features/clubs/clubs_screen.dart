import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:litapp/core/providers.dart';
import 'package:litapp/core/theme/lit_theme.dart';
import 'package:litapp/core/widgets/lit_widgets.dart';
import 'package:litapp/models/lit_models.dart';

class ClubsScreen extends ConsumerStatefulWidget {
  const ClubsScreen({super.key});

  @override
  ConsumerState<ClubsScreen> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends ConsumerState<ClubsScreen> {
  String _query = '';

  Widget _buildCarousel(List<dynamic> clubsList) {
    if (clubsList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text('No magic found in this dimension 🌌',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: LitColors.mutedText)),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: clubsList.map((club) {
            return Container(
              width: MediaQuery.of(context).size.width > 600
                  ? 400
                  : MediaQuery.of(context).size.width * 0.85,
              margin: const EdgeInsets.only(right: 18),
              child: _ClubCard(clubId: club.id),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(litRepositoryProvider);
    final clubs = repo.clubs.where((club) {
      final q = _query.toLowerCase();
      return q.isEmpty ||
          club.name.toLowerCase().contains(q) ||
          club.description.toLowerCase().contains(q);
    }).toList();

    final myClubs = clubs.where((c) => c.isJoined).toList();
    final discoverClubs = clubs.where((c) => !c.isJoined).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
      children: [
        Row(
          children: [
            Expanded(
                child: Text('Covens 🔮',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontWeight: FontWeight.w900))),
            PrimaryButton(
              label: 'Create coven',
              icon: Icons.add_rounded,
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Coven creation is ready for backend integration.')),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
            'Discover communities, join a magical circle, or request access to a private coven.',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: LitColors.mutedText)),
        const SizedBox(height: 18),
        SearchBarCard(
            hintText: 'Search covens',
            onChanged: (value) => setState(() => _query = value)),
        const SizedBox(height: 24),
        if (myClubs.isNotEmpty) ...[
          SectionHeader(
              title: 'Your Covens', subtitle: 'Bookclubs you belong to'),
          const SizedBox(height: 16),
          _buildCarousel(myClubs),
          const SizedBox(height: 32),
        ],
        SectionHeader(
            title: 'Discover new Covens',
            subtitle: 'Explore the mystical reads of other communities'),
        const SizedBox(height: 16),
        _buildCarousel(discoverClubs),
      ],
    );
  }
}

class _ClubCard extends ConsumerWidget {
  const _ClubCard({required this.clubId});
  final String clubId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(litRepositoryProvider);
    final club = repo.clubById(clubId)!;
    final book = repo.bookById(club.currentBookId)!;

    return AppCard(
      onTap: () => context.go('/clubs/$clubId'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          CoverArt(
              seed: club.coverSeed,
              title: club.name,
              subtitle: club.description,
              accentColor: LitColors.primaryBlue,
              width: double.infinity,
              height: 180),
          const SizedBox(height: 16),
          Row(
            children: [
              AvatarCircle(seed: club.profileSeed, size: 44),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(club.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800))),
              ColorPill(label: club.privacy.label, color: LitColors.brightCyan),
            ],
          ),
          const SizedBox(height: 12),
          Text(club.description,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: LitColors.mutedText)),
          const SizedBox(height: 14),
          if (club.isJoined) ...[
            Text('Current book',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: LitColors.mutedText, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(book.title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            ProgressBar(
                progress: club.progress / 100, color: LitColors.brightCyan),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('${club.memberCount} familiars',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const Spacer(),
                Text('${club.progress}%',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ] else ...[
            AppCard(
              color: LitColors.warmSurface,
              child: Text(
                  'Join this coven to see the current book and reading progress.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: LitColors.text)),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              if (club.isJoined)
                SecondaryButton(
                  label: 'Leave coven',
                  icon: Icons.logout_rounded,
                  onPressed: () =>
                      ref.read(litRepositoryProvider).toggleClubJoin(clubId),
                )
              else if (club.privacy == ClubPrivacy.public)
                SecondaryButton(
                  label: 'Join coven',
                  icon: Icons.group_add_rounded,
                  onPressed: () =>
                      ref.read(litRepositoryProvider).toggleClubJoin(clubId),
                )
              else
                SecondaryButton(
                  label: 'Request access',
                  icon: Icons.lock_open_rounded,
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Your request has been queued for the coven admin.')),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
