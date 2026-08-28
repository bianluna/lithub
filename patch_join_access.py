import re

with open('lib/features/clubs/club_detail_screen.dart', 'r') as f:
    text = f.read()

old_buttons = """                    SecondaryButton(label: 'Join club', icon: Icons.group_add_rounded, onPressed: () => ref.read(litRepositoryProvider).toggleClubJoin(clubId)),
                    if (club.privacy != ClubPrivacy.public)
                      SecondaryButton(
                        label: 'Request access',
                        icon: Icons.lock_open_rounded,
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Your request has been queued for the club admin.')),
                        ),
                      ),"""

new_buttons = """                    if (club.privacy == ClubPrivacy.public)
                      SecondaryButton(
                        label: 'Join club', 
                        icon: Icons.group_add_rounded, 
                        onPressed: () => ref.read(litRepositoryProvider).toggleClubJoin(clubId),
                      )
                    else
                      SecondaryButton(
                        label: 'Request access',
                        icon: Icons.lock_open_rounded,
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Your request has been queued for the club admin.')),
                        ),
                      ),"""

if old_buttons in text:
    text = text.replace(old_buttons, new_buttons)
    with open('lib/features/clubs/club_detail_screen.dart', 'w') as f:
        f.write(text)
    print("Successfully patched club join button")
else:
    print("Could not find the button block")

