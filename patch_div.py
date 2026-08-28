import re

with open('lib/features/reading/reading_screen.dart', 'r') as f:
    text = f.read()

# fix division by zero just in case
old_calc1 = """final newPercent = ((p / reading.totalPages) * 100).round().clamp(0, 100);"""
new_calc1 = """final totalParam = reading.totalPages > 0 ? reading.totalPages : 1;
                              final newPercent = ((p / totalParam) * 100).round().clamp(0, 100);"""
text = text.replace(old_calc1, new_calc1)

old_calc2 = """final newPage = ((p / 100) * reading.totalPages).round().clamp(0, reading.totalPages);"""
new_calc2 = """final newPage = ((p / 100) * reading.totalPages).round().clamp(0, reading.totalPages > 0 ? reading.totalPages : 1);"""
text = text.replace(old_calc2, new_calc2)

with open('lib/features/reading/reading_screen.dart', 'w') as f:
    f.write(text)

