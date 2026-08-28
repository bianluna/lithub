import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:litapp/core/providers.dart';
import 'package:litapp/core/theme/lit_theme.dart';
import 'package:litapp/core/widgets/lit_widgets.dart';
import 'package:litapp/models/lit_models.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(litRepositoryProvider);
    final notifications = repo.notifications;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
      children: [
        Row(
          children: [
            Expanded(
                child: Text('Notifications',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontWeight: FontWeight.w900))),
            SecondaryButton(
                label: 'Mark all read',
                icon: Icons.done_all_rounded,
                onPressed: repo.markAllNotificationsRead),
          ],
        ),
        const SizedBox(height: 8),
        Text('Compact updates from clubs, reading, rewards, and achievements.',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: LitColors.mutedText)),
        const SizedBox(height: 18),
        if (notifications.isEmpty)
          const EmptyStateCard(
              title: 'No notifications yet',
              message: 'You have not received any updates.',
              actionLabel: 'Refresh',
              onAction: null)
        else
          ...notifications.map(
            (n) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                color: n.unread
                    ? LitColors.primaryPurple.withOpacity(.07)
                    : Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          color: LitColors.softPeriwinkle.withOpacity(.25),
                          borderRadius: BorderRadius.circular(16)),
                      child: Icon(_iconForType(n.type),
                          color: LitColors.primaryPurple),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(n.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w800))),
                              if (n.unread)
                                const ColorPill(
                                    label: 'New', color: LitColors.softPeach),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(n.body,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: LitColors.mutedText)),
                          const SizedBox(height: 8),
                          Text(DateFormat('d MMM • HH:mm').format(n.dateTime),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: LitColors.mutedText)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  IconData _iconForType(NotificationType type) => switch (type) {
        NotificationType.meeting => Icons.groups_rounded,
        NotificationType.book => Icons.book_rounded,
        NotificationType.deadline => Icons.timer_rounded,
        NotificationType.challenge => Icons.flag_rounded,
        NotificationType.levelUp => Icons.stars_rounded,
        NotificationType.achievement => Icons.emoji_events_rounded,
        NotificationType.invite => Icons.mail_rounded,
        NotificationType.request => Icons.how_to_reg_rounded,
        NotificationType.event => Icons.event_rounded,
      };
}
