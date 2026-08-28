import re

with open('lib/features/reading/reading_screen.dart', 'r') as f:
    text = f.read()

# fix unused complete and interpolation
text = text.replace("final complete = reading.progressPercent >= 100;", "")
text = text.replace("subtitle: '${club.name}'", "subtitle: club.name")

with open('lib/features/reading/reading_screen.dart', 'w') as f:
    f.write(text)

