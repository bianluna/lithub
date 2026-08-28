import re

with open('lib/features/clubs/club_detail_screen.dart', 'r') as f:
    text = f.read()

# 1. Update the header to be responsive and add new buttons
old_header = """              Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  gradient: LinearGradient(colors: [club.themeColor.withOpacity(.95), LitColors.softPeriwinkle.withOpacity(.82)]),
                ),
                child: Stack(
                  children: [
                    Positioned(right: 24, top: 24, child: AvatarCircle(seed: club.profileSeed, size: 72)),
                    Positioned(
                      left: 24,
                      bottom: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(club.name, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 6),
                          SizedBox(width: 620, child: Text(club.description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withOpacity(.92)))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ColorPill(label: '${club.memberCount} members', color: club.themeColor),
                    ColorPill(label: club.privacy.label, color: LitColors.softPeach),
                    SecondaryButton(label: 'Settings', icon: Icons.tune_rounded, onPressed: () => context.go('/settings')),
                  ],
                ),
              ),"""

new_header = """              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  gradient: LinearGradient(colors: [club.themeColor.withOpacity(.95), LitColors.softPeriwinkle.withOpacity(.82)]),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(club.name, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                        ),
                        AvatarCircle(seed: club.profileSeed, size: 72),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(club.description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withOpacity(.92))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ColorPill(label: '${club.memberCount} members', color: club.themeColor),
                    ColorPill(label: club.privacy.label, color: LitColors.softPeach),
                    SecondaryButton(label: 'Ranking', icon: Icons.emoji_events_rounded, onPressed: () {}),
                    SecondaryButton(label: 'Members', icon: Icons.people_alt_rounded, onPressed: () {}),
                    SecondaryButton(label: 'Challenges', icon: Icons.flag_rounded, onPressed: () {}),
                    SecondaryButton(label: 'Settings', icon: Icons.tune_rounded, onPressed: () => context.go('/settings')),
                  ],
                ),
              ),"""

text = text.replace(old_header, new_header)

with open('lib/features/clubs/club_detail_screen.dart', 'w') as f:
    f.write(text)
    
print("Successfully replaced header")
