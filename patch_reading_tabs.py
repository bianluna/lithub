import re

with open('lib/features/reading/reading_screen.dart', 'r') as f:
    text = f.read()

# 1. Add the enum outside the class
old_class_start = """class ReadingScreen extends ConsumerStatefulWidget {"""
new_class_start = """enum ProgressInputMode { pages, percentage }

class ReadingScreen extends ConsumerStatefulWidget {"""
text = text.replace(old_class_start, new_class_start)


# 2. Add _inputMode state variable
old_state_vars = """class _ReadingScreenState extends ConsumerState<ReadingScreen> {
  late TextEditingController _pageController;
  late TextEditingController _percentController;"""
new_state_vars = """class _ReadingScreenState extends ConsumerState<ReadingScreen> {
  late TextEditingController _pageController;
  late TextEditingController _percentController;
  ProgressInputMode _inputMode = ProgressInputMode.pages;"""
text = text.replace(old_state_vars, new_state_vars)


# 3. Replace the Row of TextFields
old_textfields = """                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _pageController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Pages read',
                              suffixText: ' / ${reading.totalPages}',
                              hintText: '0',
                            ),
                            onChanged: (val) {
                              final p = int.tryParse(val) ?? 0;
                              final newPercent = ((p / reading.totalPages) * 100).round().clamp(0, 100);
                              if (_percentController.text != newPercent.toString()) {
                                _percentController.text = newPercent.toString();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _percentController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Percentage',
                              suffixText: ' / 100%',
                              hintText: '0',
                            ),
                            onChanged: (val) {
                              final p = int.tryParse(val) ?? 0;
                              final newPage = ((p / 100) * reading.totalPages).round().clamp(0, reading.totalPages);
                              if (_pageController.text != newPage.toString()) {
                                _pageController.text = newPage.toString();
                              }
                            },
                          ),
                        ),
                      ],
                    ),"""

new_textfields = """                    Row(
                      children: [
                        SelectableChip(
                          label: 'Pages',
                          selected: _inputMode == ProgressInputMode.pages,
                          onTap: () => setState(() => _inputMode = ProgressInputMode.pages),
                        ),
                        const SizedBox(width: 8),
                        SelectableChip(
                          label: 'Percentage',
                          selected: _inputMode == ProgressInputMode.percentage,
                          onTap: () => setState(() => _inputMode = ProgressInputMode.percentage),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_inputMode == ProgressInputMode.pages)
                      TextField(
                        controller: _pageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Pages read',
                          suffixText: ' / ${reading.totalPages}',
                          hintText: '0',
                        ),
                        onChanged: (val) {
                          final p = int.tryParse(val) ?? 0;
                          final newPercent = ((p / reading.totalPages) * 100).round().clamp(0, 100);
                          if (_percentController.text != newPercent.toString()) {
                            _percentController.text = newPercent.toString();
                          }
                        },
                      )
                    else
                      TextField(
                        controller: _percentController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Percentage',
                          suffixText: ' / 100%',
                          hintText: '0',
                        ),
                        onChanged: (val) {
                          final p = int.tryParse(val) ?? 0;
                          final newPage = ((p / 100) * reading.totalPages).round().clamp(0, reading.totalPages);
                          if (_pageController.text != newPage.toString()) {
                            _pageController.text = newPage.toString();
                          }
                        },
                      ),"""

if old_textfields in text:
    text = text.replace(old_textfields, new_textfields)
    with open('lib/features/reading/reading_screen.dart', 'w') as f:
        f.write(text)
    print("Successfully replaced with tabs")
else:
    print("Could not find the row of text fields")

