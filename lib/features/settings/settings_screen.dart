import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litapp/core/providers.dart';
import 'package:litapp/core/theme/lit_theme.dart';
import 'package:litapp/core/widgets/lit_widgets.dart';
import 'package:litapp/models/lit_models.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(litRepositoryProvider);
    final user = repo.currentUser;
    final votingSelection = repo.selectionForClub('c1');
    final drawSelection = repo.selectionForClub('c3');

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      children: [
        Text('Settings & Admin', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text('Club settings, member management, rewards, events, polls, and draws.', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: LitColors.mutedText)),
        const SizedBox(height: 18),
        if (!user.isAdmin)
          const EmptyStateCard(title: 'Admin tools unavailable', message: 'This area is visible to club administrators only.')
        else ...[
          Wrap(
            spacing: 18,
            runSpacing: 18,
            children: [
              _AdminCard(title: 'Club settings', icon: Icons.settings_rounded),
              _AdminCard(title: 'Member management', icon: Icons.group_rounded),
              _AdminCard(title: 'Roles', icon: Icons.badge_rounded),
              _AdminCard(title: 'Reading management', icon: Icons.menu_book_rounded),
              _AdminCard(title: 'Points', icon: Icons.confirmation_num_rounded),
              _AdminCard(title: 'Rewards', icon: Icons.card_giftcard_rounded),
              _AdminCard(title: 'Challenges', icon: Icons.flag_rounded),
              _AdminCard(title: 'Events', icon: Icons.event_rounded),
            ],
          ),
          const SizedBox(height: 18),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: 'Polls and draws', subtitle: 'VOTING or DRAW mode for book selection'),
                if (votingSelection != null && votingSelection.mode == BookSelectionMode.voting)
                  ...votingSelection.options.map((option) {
                    final book = repo.bookById(option.bookId)!;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        color: Colors.white,
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: book.accentColor.withOpacity(.16),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Icon(Icons.menu_book_rounded, color: book.accentColor),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(book.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                                  Text('${option.votes} votes', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: LitColors.mutedText)),
                                ],
                              ),
                            ),
                            PrimaryButton(label: 'Vote', onPressed: () => ref.read(litRepositoryProvider).voteForBook(votingSelection.clubId, book.id)),
                          ],
                        ),
                      ),
                    );
                  })
                else if (votingSelection != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Voting mode is active for Lithappened.', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 12),
                      PrimaryButton(label: 'Execute draw', icon: Icons.auto_awesome_rounded, onPressed: () => ref.read(litRepositoryProvider).executeDraw(votingSelection.clubId)),
                      if (votingSelection.selectedBookId != null) ...[
                        const SizedBox(height: 12),
                        Text('Selected book: ${repo.bookById(votingSelection.selectedBookId!)!.title}', style: const TextStyle(fontWeight: FontWeight.w800)),
                      ],
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: 'Draw showcase', subtitle: 'Elegant reveal for invite-only clubs'),
                if (drawSelection != null && drawSelection.mode == BookSelectionMode.draw) ...[
                  Text('Paper Moon Society draw', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  PrimaryButton(label: 'Execute draw', icon: Icons.auto_awesome_rounded, onPressed: () => ref.read(litRepositoryProvider).executeDraw(drawSelection.clubId)),
                  if (drawSelection.selectedBookId != null) ...[
                    const SizedBox(height: 12),
                    Text('Selected book: ${repo.bookById(drawSelection.selectedBookId!)!.title}', style: const TextStyle(fontWeight: FontWeight.w800)),
                  ],
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          SecondaryButton(label: 'Sign out', icon: Icons.logout_rounded, onPressed: repo.signOut),
        ],
      ],
    );
  }
}

class _AdminCard extends StatelessWidget {
  const _AdminCard({required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: AppCard(
        color: LitColors.warmSurface.withOpacity(.72),
        child: Row(
          children: [
            Icon(icon, color: LitColors.primaryPurple),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800))),
          ],
        ),
      ),
    );
  }
}
