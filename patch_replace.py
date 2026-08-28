import re

with open('lib/features/clubs/clubs_screen.dart', 'r') as f:
    text = f.read()

old_block = """              SecondaryButton(
                  label: club.isJoined ? 'Leave coven' : 'Join coven',
                  icon: club.isJoined
                      ? Icons.logout_rounded
                      : Icons.group_add_rounded,
                  onPressed: () =>
                      ref.read(litRepositoryProvider).toggleClubJoin(clubId)),
              if (!club.isJoined && club.privacy != ClubPrivacy.public)
                SecondaryButton(
                  label: 'Request access',
                  icon: Icons.lock_open_rounded,
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Your request has been queued for the coven admin.')),
                  ),
                ),"""

new_block = """              if (club.isJoined)
                SecondaryButton(
                  label: 'Leave coven',
                  icon: Icons.logout_rounded,
                  onPressed: () => ref.read(litRepositoryProvider).toggleClubJoin(clubId),
                )
              else if (club.privacy == ClubPrivacy.public)
                SecondaryButton(
                  label: 'Join coven',
                  icon: Icons.group_add_rounded,
                  onPressed: () => ref.read(litRepositoryProvider).toggleClubJoin(clubId),
                )
              else
                SecondaryButton(
                  label: 'Request access',
                  icon: Icons.lock_open_rounded,
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Your request has been queued for the coven admin.')),
                  ),
                ),"""

if old_block in text:
    text = text.replace(old_block, new_block)
    with open('lib/features/clubs/clubs_screen.dart', 'w') as f:
        f.write(text)
    print("Success")
else:
    print("Failed")
