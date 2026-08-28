import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:litapp/core/providers.dart';
import 'package:litapp/core/theme/lit_theme.dart';
import 'package:litapp/core/widgets/lit_widgets.dart';

class BookDetailScreen extends ConsumerStatefulWidget {
  const BookDetailScreen({super.key, required this.bookId});

  final String bookId;

  @override
  ConsumerState<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends ConsumerState<BookDetailScreen> {
  final Set<String> _revealed = {};

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(litRepositoryProvider);
    final book = repo.bookById(widget.bookId)!;
    final reading = repo.readingByBookId(widget.bookId);
    final comments = repo.commentsForBook(widget.bookId);
    final progress = reading?.progressPercent ?? 0;
    final allowed = repo.clubs
        .any((club) => club.isJoined && club.currentBookId == widget.bookId);

    if (!allowed) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
        children: [
          EmptyStateCard(
            title: 'Book hidden',
            message: 'This book is only visible inside clubs you belong to.',
            actionLabel: 'View clubs',
            onAction: () => context.go('/clubs'),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
      children: [
        Wrap(
          spacing: 22,
          runSpacing: 22,
          children: [
            CoverArt(
                seed: book.coverSeed,
                title: book.title,
                subtitle: book.author,
                accentColor: book.accentColor,
                width: 240,
                height: 340),
            SizedBox(
              width: 620,
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(book.title,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    Text(book.author,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: LitColors.mutedText)),
                    const SizedBox(height: 18),
                    Text(book.synopsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(height: 1.6)),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ColorPill(
                            label: '${book.pages} pages',
                            color: LitColors.softPeriwinkle),
                        ColorPill(
                            label: 'Avg rating ${book.averageRating}',
                            color: LitColors.softPeach),
                        if (reading != null)
                          ColorPill(
                              label:
                                  'Club reading ${repo.clubById(reading.clubId)?.name ?? ''}',
                              color: LitColors.primaryPurple),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                            child: StatCard(
                                label: 'Start date',
                                value: reading != null
                                    ? DateFormat('d MMM')
                                        .format(reading.startDate)
                                    : '—',
                                color: LitColors.softPeriwinkle)),
                        const SizedBox(width: 12),
                        Expanded(
                            child: StatCard(
                                label: 'End date',
                                value: reading != null
                                    ? DateFormat('d MMM')
                                        .format(reading.endDate)
                                    : '—',
                                color: LitColors.softPeach)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                  title: 'Your review',
                  subtitle: 'Rate the book and add a note for your club'),
              Row(
                children: List.generate(
                    5,
                    (index) => Icon(
                        index < 4
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: LitColors.primaryPurple)),
              ),
              const SizedBox(height: 12),
              const TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write a thoughtful review...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                  title: 'Comments',
                  subtitle:
                      'Spoilers are hidden until you reach the required progress'),
              ...comments.map(
                (comment) {
                  final blocked = comment.spoilerUpToPage != null &&
                      progress < comment.spoilerUpToPage!;
                  final revealed = _revealed.contains(comment.id);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppCard(
                      color: blocked && !revealed
                          ? LitColors.warmSurface.withOpacity(.8)
                          : Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AvatarCircle(seed: comment.userSeed, size: 36),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Text(comment.userName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800))),
                              if (comment.spoilerUpToPage != null)
                                const ColorPill(
                                    label: 'Spoiler',
                                    color: LitColors.softPeach),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (blocked && !revealed)
                            ClipRect(
                              child: ImageFiltered(
                                imageFilter:
                                    ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Text(comment.body,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ),
                            )
                          else
                            Text(comment.body,
                                style: Theme.of(context).textTheme.bodyMedium),
                          if (blocked && !revealed) ...[
                            const SizedBox(height: 10),
                            Text(
                                'This comment contains spoilers up to page ${comment.spoilerUpToPage}.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: LitColors.mutedText)),
                            const SizedBox(height: 8),
                            SecondaryButton(
                                label: 'Reveal spoiler',
                                icon: Icons.visibility_rounded,
                                onPressed: () =>
                                    setState(() => _revealed.add(comment.id))),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
