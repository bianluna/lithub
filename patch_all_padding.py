import os
import glob

# Search all *_screen.dart files in lib/features
for dirpath, _, filenames in os.walk('lib/features'):
    for filename in filenames:
        if filename.endswith('_screen.dart'):
            filepath = os.path.join(dirpath, filename)
            with open(filepath, 'r') as f:
                content = f.read()
            
            new_content = content.replace(
                'padding: const EdgeInsets.fromLTRB(24, 24, 24, 32)', 
                'padding: const EdgeInsets.fromLTRB(24, 24, 24, 140)'
            )
            
            if new_content != content:
                with open(filepath, 'w') as f:
                    f.write(new_content)
                print(f"Patched padding in {filepath}")

