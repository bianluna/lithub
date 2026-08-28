with open('lib/features/clubs/club_detail_screen.dart', 'r') as f:
    lines = f.readlines()

# line 139 has the extra `),`
# Let's remove line 139
del lines[138] # 0-indexed

with open('lib/features/clubs/club_detail_screen.dart', 'w') as f:
    f.writelines(lines)
