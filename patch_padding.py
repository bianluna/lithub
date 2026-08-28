import re

with open('lib/features/reading/reading_screen.dart', 'r') as f:
    text = f.read()

text = text.replace('padding: const EdgeInsets.fromLTRB(24, 24, 24, 32)', 'padding: const EdgeInsets.fromLTRB(24, 24, 24, 140)')

with open('lib/features/reading/reading_screen.dart', 'w') as f:
    f.write(text)

