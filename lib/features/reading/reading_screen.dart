import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:litapp/core/providers.dart';
import 'package:litapp/core/theme/lit_theme.dart';
import 'package:litapp/core/widgets/lit_widgets.dart';
import 'package:litapp/models/lit_models.dart';

enum ProgressInputMode { pages, percentage }

class ReadingScreen extends ConsumerStatefulWidget {
  const ReadingScreen({super.key});

  @override
  ConsumerState<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends ConsumerState<ReadingScreen> {
  late TextEditingController _pageController;
  late TextEditingController _percentController;
  ProgressInputMode _inputMode = ProgressInputMode.pages;

  @override
  void initState() {
    super.initState();
    final repo = ref.read(litRepositoryProvider);
    final reading = repo.readings.isNotEmpty ? repo.readings.first : null;
    _pageController =
        TextEditingController(text: reading?.currentPage.toString() ?? '0');
    _percentController =
        TextEditingController(text: reading?.progressPercent.toString() ?? '0');
  }

  @override
  void dispose() {
    _pageController.dispose();
    _percentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(litRepositoryProvider);
    if (repo.readings.isEmpty)
      return const Scaffold(body: Center(child: Text("No reading active")));
    final reading = repo.readings.first;
    final book = repo.bookById(reading.bookId)!;
    final club = repo.clubById(reading.clubId)!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
      children: [
        Text('Reading',
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text(
            'Update progress, switch reading status, and enjoy a subtle celebration when you finish a book.',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: LitColors.mutedText)),
        const SizedBox(height: 18),
        Wrap(
          spacing: 18,
          runSpacing: 18,
          children: [
            SizedBox(
              width: 560,
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(title: 'Current book', subtitle: club.name),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CoverArt(
                            seed: book.coverSeed,
                            title: book.title,
                            subtitle: book.author,
                            accentColor: book.accentColor,
                            width: 160,
                            height: 220),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(book.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.w800)),
                              const SizedBox(height: 4),
                              Text(book.author,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: LitColors.mutedText)),
                              const SizedBox(height: 12),
                              ColorPill(
                                  label: club.name, color: club.themeColor),
                              const SizedBox(height: 12),
                              Text('${reading.progressPercent}%',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(fontWeight: FontWeight.w900)),
                              Text(
                                  '${reading.currentPage} / ${reading.totalPages} pages',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: LitColors.mutedText)),
                              const SizedBox(height: 12),
                              ProgressBar(
                                  progress: reading.progressPercent / 100,
                                  color: club.themeColor),
                              const SizedBox(height: 14),
                              Text('Reading status',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: LitColors.mutedText)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10,
                                children: ReadingStatus.values
                                    .map((status) => SelectableChip(
                                        label: status.label,
                                        selected: reading.status == status))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        SelectableChip(
                          label: 'Pages',
                          selected: _inputMode == ProgressInputMode.pages,
                          onTap: () => setState(
                              () => _inputMode = ProgressInputMode.pages),
                        ),
                        const SizedBox(width: 8),
                        SelectableChip(
                          label: 'Percentage',
                          selected: _inputMode == ProgressInputMode.percentage,
                          onTap: () => setState(
                              () => _inputMode = ProgressInputMode.percentage),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_inputMode == ProgressInputMode.pages)
                      TextField(
                        controller: _pageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Pages read',
                          suffixText: ' / ${reading.totalPages}',
                          hintText: '0',
                        ),
                        onChanged: (val) {
                          final p = int.tryParse(val) ?? 0;
                          final newPercent = ((p / reading.totalPages) * 100)
                              .round()
                              .clamp(0, 100);
                          if (_percentController.text !=
                              newPercent.toString()) {
                            _percentController.text = newPercent.toString();
                          }
                        },
                      )
                    else
                      TextField(
                        controller: _percentController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Percentage',
                          suffixText: ' / 100%',
                          hintText: '0',
                        ),
                        onChanged: (val) {
                          final p = int.tryParse(val) ?? 0;
                          final newPage = ((p / 100) * reading.totalPages)
                              .round()
                              .clamp(0, reading.totalPages);
                          if (_pageController.text != newPage.toString()) {
                            _pageController.text = newPage.toString();
                          }
                        },
                      ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            label: 'Update progress',
                            icon: Icons.refresh_rounded,
                            onPressed: () {
                              final page = int.tryParse(_pageController.text) ??
                                  reading.currentPage;
                              final pcent =
                                  int.tryParse(_percentController.text) ??
                                      reading.progressPercent;
                              ref
                                  .read(litRepositoryProvider)
                                  .updateReadingProgress(reading.id,
                                      page: page, percent: pcent);
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SecondaryButton(
                            label: 'Mark finished',
                            icon: Icons.check_circle_rounded,
                            onPressed: () {
                              ref
                                  .read(litRepositoryProvider)
                                  .completeReading(reading.id);
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 360,
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                            title: 'Club progress', subtitle: club.name),
                        Text('${club.progress}%',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 10),
                        ProgressBar(
                            progress: club.progress / 100,
                            color: club.themeColor),
                        const SizedBox(height: 12),
                        Text('${reading.membersReading} members reading',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text('${reading.membersFinished} finished',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text(
                            'Deadline ${DateFormat('d MMM').format(reading.endDate)}',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
