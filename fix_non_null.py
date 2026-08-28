import re

with open('lib/features/clubs/club_detail_screen.dart', 'r') as f:
    text = f.read()

# Just remove book!. and reading!. where it says it's unnecessary
text = text.replace('book!.', 'book.')
text = text.replace('reading!.', 'reading.')

with open('lib/features/clubs/club_detail_screen.dart', 'w') as f:
    f.write(text)

