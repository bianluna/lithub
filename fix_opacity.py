import os, glob

for filepath in ['lib/core/widgets/app_shell.dart', 'lib/core/widgets/lit_widgets.dart']:
    with open(filepath, 'r') as f:
        content = f.read()
    
    # replace .withOpacity(x) with .withValues(alpha: x)
    import re
    content = re.sub(r'\.withOpacity\(([^)]+)\)', r'.withValues(alpha: \1)', content)
    
    with open(filepath, 'w') as f:
        f.write(content)
