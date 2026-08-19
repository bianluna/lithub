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

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(litRepositoryProvider);
    final clubs = repo.clubs.where((club) {
      final q = _query.toLowerCase();
      return q.isEmpty || club.name.toLowerCase().contains(q) || club.description.toLowerCase().contains(q);
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      children: [
        Row(
          children: [
            Expanded(child: Text('Clubs', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900))),
            PrimaryButton(
              label: 'Create club',
              icon: Icons.add_rounded,
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Club creation is ready for backend integration.')),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('Discover communities, join a reading circle, or request access to a private club.', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: LitColors.mutedText)),
        const SizedBox(height: 18),
        SearchBarCard(hintText: 'Search clubs', onChanged: (value) => setState(() => _query = value)),
        const SizedBox(height: 18),
        Wrap(
          spacing: 18,
          runSpacing: 18,
          children: clubs.map((club) => SizedBox(width: 380, child: _ClubCard(clubId: club.id))).toList(),
        ),
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
        children: [
          CoverArt(seed: club.coverSeed, title: club.name, subtitle: club.description, accentColor: club.themeColor, width: double.infinity, height: 180),
          const SizedBox(height: 16),
          Row(
            children: [
              AvatarCircle(seed: club.profileSeed, size: 44),
              const SizedBox(width: 12),
              Expanded(child: Text(club.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800))),
              ColorPill(label: club.privacy.label, color: club.themeColor),
            ],
          ),
          const SizedBox(height: 12),
          Text(club.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: LitColors.mutedText)),
          const SizedBox(height: 14),
          if (club.isJoined) ...[
            Text('Current book', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: LitColors.mutedText, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(book.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            ProgressBar(progress: club.progress / 100, color: club.themeColor),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('${club.memberCount} members', style: const TextStyle(fontWeight: FontWeight.w700)),
                const Spacer(),
                Text('${club.progress}%', style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ] else ...[
            AppCard(
              color: LitColors.warmSurface.withOpacity(.72),
              child: Text('Join this club to see the current book and reading progress.', style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            children: [
              SecondaryButton(label: club.isJoined ? 'Leave club' : 'Join club', icon: club.isJoined ? Icons.logout_rounded : Icons.group_add_rounded, onPressed: () => ref.read(litRepositoryProvider).toggleClubJoin(clubId)),
              if (club.privacy != ClubPrivacy.public)
                SecondaryButton(
                  label: 'Request access',
                  icon: Icons.lock_open_rounded,
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Your request has been queued for the club admin.')),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
