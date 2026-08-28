import re

with open('lib/features/clubs/club_detail_screen.dart', 'r') as f:
    text = f.read()

# Using regex to find the block
pattern = r"SecondaryButton\(\s*label:\s*'Join club'[\s\S]*?toggleClubJoin\(clubId\)\),\s*if\s*\(club\.privacy\s*!=\s*ClubPrivacy\.public\)[\s\S]*?Your request has been queued for the club admin\.'\)\),\s*\),"

new_buttons = """if (club.privacy == ClubPrivacy.public)
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
                      ),
"""

new_text = re.sub(pattern, new_buttons, text)

if text != new_text:
    with open('lib/features/clubs/club_detail_screen.dart', 'w') as f:
        f.write(new_text)
    print("Success")
else:
    print("Failed")
