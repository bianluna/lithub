import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:litapp/core/providers.dart';
import 'package:litapp/core/theme/lit_theme.dart';
import 'package:litapp/core/widgets/lit_widgets.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime(2026, 8, 21);
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(litRepositoryProvider);
    final events = repo.events;
    final selectedEvents = events
        .where((event) => event.dateTime.day == _selectedDay!.day)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
      children: [
        Text('Calendar',
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text(
            'Meetings, reading deadlines, milestones, and challenge reminders.',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: LitColors.mutedText)),
        const SizedBox(height: 18),
        Wrap(
          spacing: 18,
          runSpacing: 18,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            SizedBox(
              width: 620,
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                        title: 'August 2026',
                        subtitle: 'Tap a day with small palette indicators'),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 31,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8),
                      itemBuilder: (context, index) {
                        final day = index + 1;
                        final event =
                            events.where((e) => e.dateTime.day == day).toList();
                        final selected = _selectedDay?.day == day;
                        return InkWell(
                          onTap: () => setState(
                              () => _selectedDay = DateTime(2026, 8, day)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: selected
                                  ? LitColors.primaryPurple.withOpacity(.15)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: LitColors.border),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('$day',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800)),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: event
                                      .take(2)
                                      .map((e) => Container(
                                          width: 7,
                                          height: 7,
                                          decoration: BoxDecoration(
                                              color: e.color,
                                              shape: BoxShape.circle)))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 420,
              child: AppCard(
                color: LitColors.warmSurface.withOpacity(.75),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                        title: DateFormat('d MMMM').format(_selectedDay!),
                        subtitle: 'Selected day details'),
                    ...selectedEvents.map(
                      (event) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AppCard(
                          color: Colors.white.withOpacity(.82),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w800)),
                              const SizedBox(height: 4),
                              Text(event.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: LitColors.mutedText)),
                              const SizedBox(height: 8),
                              Text(DateFormat('HH:mm').format(event.dateTime),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
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
    );
  }
}
