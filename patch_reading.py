import re

with open('lib/features/clubs/club_detail_screen.dart', 'r') as f:
    text = f.read()

old_reading = """                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CoverArt(seed: book!.coverSeed, title: book!.title, subtitle: book!.author, accentColor: book!.accentColor, width: 150, height: 220),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(book!.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                              const SizedBox(height: 4),
                              Text(book!.author, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: LitColors.mutedText)),
                              const SizedBox(height: 14),
                              ProgressBar(progress: reading!.progressPercent / 100, color: club.themeColor),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(child: StatCard(label: 'Start date', value: DateFormat('d MMM').format(reading!.startDate), color: LitColors.softPeriwinkle)),
                                  const SizedBox(width: 12),
                                  Expanded(child: StatCard(label: 'End date', value: DateFormat('d MMM').format(reading!.endDate), color: LitColors.softPeach)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(child: StatCard(label: 'Average progress', value: '${reading!.averageClubProgress}%', color: club.themeColor)),
                                  const SizedBox(width: 12),
                                  Expanded(child: StatCard(label: 'Finished', value: '${reading!.membersFinished}', color: LitColors.softPeriwinkle)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('Timeline', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    MilestoneTimeline(items: reading!.milestones.map((m) => (m.title, m.reached)).toList()),"""

new_reading = """                    Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        CoverArt(seed: book!.coverSeed, title: book!.title, subtitle: book!.author, accentColor: book!.accentColor, width: 150, height: 220),
                        SizedBox(
                          width: 480, // constrain width so it wraps on mobile
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(book!.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                              const SizedBox(height: 8),
                              Text(book!.author, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: LitColors.mutedText)),
                              const SizedBox(height: 24),
                              ProgressBar(progress: reading!.progressPercent / 100, color: club.themeColor),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(child: StatCard(label: 'Start date', value: DateFormat('d MMM').format(reading!.startDate), color: LitColors.softPeriwinkle)),
                                  const SizedBox(width: 16),
                                  Expanded(child: StatCard(label: 'End date', value: DateFormat('d MMM').format(reading!.endDate), color: LitColors.softPeach)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: StatCard(label: 'Average progress', value: '${reading!.averageClubProgress}%', color: club.themeColor)),
                                  const SizedBox(width: 16),
                                  Expanded(child: StatCard(label: 'Finished', value: '${reading!.membersFinished}', color: LitColors.softPeriwinkle)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text('Timeline', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 16),
                    MilestoneTimeline(items: reading!.milestones.map((m) => (m.title, m.reached)).toList()),
                    
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
                                  Text(challenge.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 12),
                                  ProgressBar(progress: challenge.progress / challenge.goal, color: club.themeColor),
                                  const SizedBox(height: 8),
                                  Text('${challenge.progress} / ${challenge.goal}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: LitColors.mutedText)),
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
                        SecondaryButton(label: 'Previous', icon: Icons.history_rounded, onPressed: () {}),
                        SecondaryButton(label: 'Upcoming', icon: Icons.upcoming_rounded, onPressed: () {}),
                      ],
                    ),"""

if old_reading in text:
    text = text.replace(old_reading, new_reading)
    with open('lib/features/clubs/club_detail_screen.dart', 'w') as f:
        f.write(text)
    print("Successfully replaced reading section")
else:
    print("Could not find reading section string")

