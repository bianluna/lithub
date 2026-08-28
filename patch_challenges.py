import re

with open('lib/features/clubs/club_detail_screen.dart', 'r') as f:
    text = f.read()

old_challenges = """            SizedBox(
              width: 320,
              child: AppCard(
                color: LitColors.warmSurface.withOpacity(.72),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(title: 'Challenges', subtitle: 'Club-wide goals'),
                    ...repo.challenges.take(3).map(
                          (challenge) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AppCard(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(challenge.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 6),
                                  ProgressBar(progress: challenge.progress / challenge.goal, color: club.themeColor),
                                  const SizedBox(height: 6),
                                  Text('${challenge.progress} / ${challenge.goal}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: LitColors.mutedText)),
                                ],
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ),"""

if old_challenges in text:
    text = text.replace(old_challenges, "")
    with open('lib/features/clubs/club_detail_screen.dart', 'w') as f:
        f.write(text)
    print("Successfully removed old challenges section")
else:
    print("Could not find old challenges string")

